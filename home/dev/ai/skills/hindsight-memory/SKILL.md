---
name: hindsight-memory
description: Store and retrieve long-term project memory via the Hindsight MCP tools (retain, recall, reflect). Use when asked to remember/store/save something, to recall / "what do we know" / "what did we decide", or before starting a non-trivial task that likely has prior context. Shared bank: agents.
---

# Hindsight Memory

You have persistent long-term memory via the **Hindsight** MCP server — tools `recall`, `retain`, and `reflect` — backed by the shared **`agents`** bank. Use them when the user asks, or when past project context would clearly help.

## How Hindsight works (read this first)

When you call **retain**, Hindsight does **NOT** store your text as-is. The server runs an LLM pipeline that:

1. Extracts structured facts from the content
2. Identifies entities (people, tools, concepts) and links related facts
3. Builds temporal and causal relationships between facts
4. Generates embeddings for semantic search

**The single most important rule: pass the richest, fullest content you have, and NEVER pre-summarize.** Your job is to decide **when** to store, not **what** to extract — the server does the extraction. A raw observation, a full description, or even a verbatim transcript beats a tidy summary, because summarizing destroys the entities, relationships, temporal detail, and causal context the extractor needs.

## Retaining (`retain`)

- **Pass full context**, not a summary: what happened, *why*, the outcome, and the surrounding detail. Do not condense or bullet-point it down.
- **Set the `context` field** (if the tool exposes one) to a short description of the source/type of the content, e.g. "coding session on the auth service", or a label like `procedures` / `learnings` / `preferences`. This meaningfully improves extraction quality — but it *labels* the content, it does **not** replace passing full content.
- **Include outcomes**: store what happened *and why*, including failures and workarounds — not just the happy path.
- **Attribute individual preferences to the person** ("Anatolios prefers explicit type annotations"), and distinguish **project conventions** (apply to everyone) from **personal preferences** (per person).
- **Store immediately** when something durable is discovered — don't batch it into a summary later.
- **Never retain** secrets, API keys, tokens, passwords, or credentials — and skip transient noise (raw log dumps, full file contents, one-off chatter).

Good retain content (note: full context, no summarizing):

- "The project uses ESLint with the Airbnb rule set and Prettier for formatting. Auto-fix on save is enabled in the editor config."
- "Build failed on Node 18 with 'ERR_UNSUPPORTED_ESM_URL_SCHEME'. Switched to Node 20 and the build succeeded." (context: `learnings`)
- "Ran the test suite with NODE_ENV=test — passes. Without NODE_ENV=test it fails with a missing-config error." (context: `procedures`)
- A full conversation transcript with timestamps, pasted verbatim.

### What is worth retaining

- **Project / team conventions**: code style, required tools and versions, lint/format rules, testing conventions, branch naming and PR conventions.
- **Decisions**: architectural or product decisions and their rationale / trade-offs.
- **Learnings**: bugs and their fixes, performance optimizations, gotchas, workarounds.
- **Procedure outcomes**: commands that worked or failed, and why.
- **Preferences**: attributed to a person.

## Recalling (`recall`)

Call **recall** before non-trivial work — starting a task, making an implementation decision, suggesting a tool/library/approach, or working in an unfamiliar area of the codebase. Use focused natural-language queries:

- "project conventions and coding standards"
- "what issues have we hit before in the auth module"
- "decisions and rationale for the database layer"

## Reflecting (`reflect`)

Use **reflect** for synthesis questions that require reasoning across many memories, e.g. "How should I approach this task based on past experience?" — it returns a synthesized answer rather than raw facts.

## Notes

- The `agents` bank is **shared** across tools and sessions — store knowledge that helps future work, not throwaway session state.
- Retain is **asynchronous**: a memory you just stored may not be recallable for a few seconds.
