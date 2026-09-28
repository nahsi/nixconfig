/**
 * Send context usage from each main interactive omp instance to the LED monitor.
 * Updates run on events and every second, regardless of terminal focus.
 * The Unix socket is $XDG_RUNTIME_DIR/led-matrix/omp.sock, or OMP_LED_SOCKET.
 *
 * Terminal titles show the assigned instance number. Waiting instances have no prefix.
 * Saved session names remain unchanged. The title override replaces the spinner.
 * Attention marks pending ask calls or completed runs awaiting input.
 * Automatic continuations and general approval dialogs do not trigger attention.
 *
 * Resume, branch, and tree changes show unknown usage until the next agent turn.
 * A message during a delayed resume can briefly publish the previous usage.
 */
import { randomUUID } from "node:crypto";
import { Socket } from "node:net";
import { join } from "node:path";
import { z, type ExtensionAPI, type ExtensionContext } from "@oh-my-pi/pi-coding-agent";

const assignmentSchema = z.object({ v: z.literal(1), slot: z.number().int().min(1).max(4).nullable() }).strict();
type Snapshot = { v: 1; id: string; attention: boolean } & (
	| { kind: "unknown" }
	| { kind: "usage"; tokens: number; contextWindow: number }
);
type Connection = {
	client: Socket;
	output: { kind: "connecting" } | { kind: "ready" } | { kind: "writing"; pending: boolean };
	input: string;
	slot: number | null | undefined;
	lastReply: number;
};
type Attention = { kind: "none" } | { kind: "waiting" } | { kind: "asking"; calls: Set<string> };

export default function (omp: ExtensionAPI): void {
	const instanceId = randomUUID();
	const runtimeDir = process.env.XDG_RUNTIME_DIR;
	const path = process.env.OMP_LED_SOCKET ?? (runtimeDir ? join(runtimeDir, "led-matrix", "omp.sock") : undefined);
	let measurement: { kind: "ready" | "transition"; context: ExtensionContext } | undefined;
	let connection: Connection | undefined;
	let heartbeat: { context: ExtensionContext; timer: Timer } | undefined;
	let attention: Attention = { kind: "none" };
	let titleOwned = false;

	function updateTitle(): void {
		const ctx = measurement?.context;
		if (!ctx) return;
		const slot = connection?.slot;
		if (slot === undefined || slot === null) {
			if (titleOwned) ctx.ui.setTitle("");
			titleOwned = false;
			return;
		}
		// Native title updates clear overrides, even when the name stays the same.
		ctx.ui.setTitle(`[${slot}] ${omp.getSessionName() || "Untitled"}`);
		titleOwned = true;
	}

	function snapshot(): Snapshot {
		const base = { v: 1, id: instanceId, attention: attention.kind !== "none" } satisfies Pick<Snapshot, "v" | "id" | "attention">;
		const usage = measurement?.kind === "ready" ? measurement.context.getContextUsage() : undefined;
		if (!usage || !Number.isFinite(usage.tokens) || usage.tokens < 0 ||
			!Number.isFinite(usage.contextWindow) || usage.contextWindow <= 0) {
			return { ...base, kind: "unknown" };
		}
		return { ...base, kind: "usage", tokens: usage.tokens, contextWindow: usage.contextWindow };
	}

	function disconnect(): void {
		const previous = connection;
		connection = undefined;
		previous?.client.destroy();
		updateTitle();
	}

	function send(): void {
		const current = connection;
		if (!current || current.output.kind === "connecting" || current.client.destroyed) return;
		if (current.output.kind === "writing") {
			current.output.pending = true;
			return;
		}
		const output: Connection["output"] = { kind: "writing", pending: false };
		current.output = output;
		current.client.write(`${JSON.stringify(snapshot())}\n`, error => {
			if (connection !== current) return;
			if (error) {
				disconnect();
				return;
			}
			current.output = { kind: "ready" };
			if (output.pending) send();
		});
	}

	function connect(): void {
		if (connection || !path) return;
		const client = new Socket();
		const current: Connection = {
			client, output: { kind: "connecting" }, input: "", slot: undefined, lastReply: performance.now(),
		};
		connection = current;
		client.setEncoding("utf8");
		client.on("error", () => {
			if (connection !== current) return;
			disconnect();
		});
		client.on("close", () => {
			if (connection === current) disconnect();
		});
		client.on("connect", () => {
			if (connection !== current) return;
			current.output = { kind: "ready" };
			send();
		});
		client.on("data", (chunk: string) => {
			if (connection !== current) return;
			current.input += chunk;
			if (current.input.length > 4096) {
				disconnect();
				return;
			}
			try {
				let end = current.input.indexOf("\n");
				while (end >= 0) {
					const reply = assignmentSchema.parse(JSON.parse(current.input.slice(0, end)));
					current.input = current.input.slice(end + 1);
					current.slot = reply.slot;
					current.lastReply = performance.now();
					end = current.input.indexOf("\n");
				}
				updateTitle();
			} catch {
				disconnect();
			}
		});
		client.connect(path);
	}

	function refresh(): void {
		if (!heartbeat) return;
		if (connection && performance.now() - connection.lastReply >= 3000) {
			disconnect();
		}
		if (connection) send();
		else connect();
		updateTitle();
	}

	function cleanup(): void {
		if (heartbeat) heartbeat.context.clearTimer(heartbeat.timer);
		heartbeat = undefined;
		disconnect();
		measurement = undefined;
		attention = { kind: "none" };
		process.removeListener("exit", cleanup);
	}

	omp.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui" || !ctx.hasUI || ctx.agent.kind !== "main" ||
			!process.stdin.isTTY || !process.stdout.isTTY) return;
		if (heartbeat) heartbeat.context.clearTimer(heartbeat.timer);
		else process.on("exit", cleanup);
		measurement = { kind: "ready", context: ctx };
		heartbeat = { context: ctx, timer: ctx.setInterval(refresh, 1000) };
		refresh();
	});

	function transition(_event: unknown, ctx: ExtensionContext): void {
		if (!heartbeat) return;
		measurement = { kind: "transition", context: ctx };
		attention = { kind: "none" };
		// Drop blocked old snapshots before publishing the new session's state.
		disconnect();
		refresh();
	}

	function update(_event: unknown, ctx: ExtensionContext): void {
		if (!heartbeat) return;
		if (measurement) measurement.context = ctx;
		refresh();
	}

	omp.on("session_switch", (event, ctx) => {
		if (!heartbeat) return;
		if (event.reason !== "new") {
			transition(event, ctx);
			return;
		}
		measurement = { kind: "ready", context: ctx };
		attention = { kind: "none" };
		refresh();
	});
	omp.on("session_branch", transition);
	omp.on("session_tree", transition);
	omp.on("before_agent_start", (_event, ctx) => {
		if (!heartbeat) return;
		measurement = { kind: "ready", context: ctx };
		attention = { kind: "none" };
		refresh();
	});
	omp.on("agent_start", (event, ctx) => {
		if (attention.kind === "waiting") attention = { kind: "none" };
		update(event, ctx);
	});
	omp.on("tool_execution_start", (event, ctx) => {
		if (!heartbeat || event.toolName !== "ask") return;
		if (attention.kind !== "asking") attention = { kind: "asking", calls: new Set() };
		attention.calls.add(event.toolCallId);
		update(event, ctx);
	});
	omp.on("tool_execution_end", (event, ctx) => {
		if (!heartbeat || attention.kind !== "asking") return;
		attention.calls.delete(event.toolCallId);
		if (attention.calls.size === 0) attention = { kind: "none" };
		update(event, ctx);
	});
	omp.on("agent_end", (event, ctx) => {
		if (!heartbeat || event.willContinue) return;
		attention = { kind: "waiting" };
		update(event, ctx);
	});
	omp.on("context", update);
	omp.on("turn_end", update);
	omp.on("message_end", update);
	omp.on("session_compact", update);
	omp.on("session_shutdown", cleanup);
}
