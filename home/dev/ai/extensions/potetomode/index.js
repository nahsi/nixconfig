const ENTRY = "poteto-mode";

const REMINDER =
  "poteto-mode is PINNED for this session.\n" +
  "Before acting on a new task: read `skill://poteto-mode` in full (including its Principles index), " +
  "then read `skill://omp-mechanics` for the omp-specific levers every pstack skill assumes.\n" +
  "Match exactly one primary playbook before editing.\n" +
  "Playbook steps, principles, and skill reads govern how you work and never appear as todos.\n" +
  "Route delegation through `skill://pstack-omp` using the live tool schema and available roster. " +
  "Casual turns, or an explicit opt-out, do not need the playbook.";

export default function potetomode(pi) {
  let pinned = false;

  const syncBadge = (ctx) => {
    ctx.ui.setModeBadge(ENTRY, pinned ? "🥔" : undefined);
  };

  const restore = (entries) => {
    for (let i = entries.length - 1; i >= 0; i--) {
      const e = entries[i];
      if (e?.type === "custom" && e?.customType === ENTRY) return e.data?.pinned === true;
    }
    return undefined;
  };
  const setPinned = (next, ctx) => {
    pinned = next;
    pi.appendEntry(ENTRY, { pinned });
    syncBadge(ctx);
    ctx?.ui?.notify?.(
      pinned ? "poteto-mode pinned for this session." : "poteto-mode unpinned.",
      "info"
    );
  };

  pi.registerCommand("poteto-mode", {
    description: "Pin pstack's poteto-mode router for this session (on|off|status; default: toggle on)",
    handler: async (args, ctx) => {
      const arg = args.trim().toLowerCase();
      if (arg === "status") {
        syncBadge(ctx);
        ctx?.ui?.notify?.(`poteto-mode: ${pinned ? "pinned" : "not pinned"}`, "info");
        return;
      }
      if (arg === "off" || arg === "unpin") return setPinned(false, ctx);
      setPinned(true, ctx);
      const rest = args.trim();
      if (rest && !["on", "off", "pin", "unpin", "status"].includes(rest.toLowerCase())) {
        pi.sendUserMessage(rest, ctx?.isIdle?.() === false ? { deliverAs: "followUp" } : undefined);
      }
    },
  });

  pi.registerFlag("poteto", {
    description: "Pin pstack's poteto-mode for this run (works in -p print mode)",
    type: "boolean",
  });

  pi.registerShortcut("alt+shift+t", {
    description: "Toggle poteto-mode pin",
    handler: (ctx) => setPinned(!pinned, ctx),
  });

  pi.on("session_start", async (_event, ctx) => {
    const entries = ctx.sessionManager.getBranch();
    pinned = restore(entries) ?? pi.getFlag?.("poteto") === true;
    syncBadge(ctx);
  });

  pi.on("before_agent_start", async (event) => {
    if (!pinned) return;
    // systemPrompt is an ordered block list; interpolating it comma-joins the
    // blocks and collapses the provider's cache segmentation.
    return { systemPrompt: [...event.systemPrompt, REMINDER] };
  });
}
