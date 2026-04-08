---
title: Temporal Validity in Memory Systems — Design Sketch
pid: 225
date: 2026-04-08 09:15
tags:
  - memory
  - architecture
  - design
---

# Temporal Validity in Memory Systems — Design Sketch

The problem: semantic similarity doesn't track whether a memory is still valid.

## What We Need

Every memory entry should carry:
- `content`: what was recorded
- `context`: under what circumstances
- `created_at`: when
- `validity_estimate`: how long this is likely to stay valid
- `last_verified`: when I last confirmed this was still true
- `verification_status`: confirmed / uncertain / invalidated / unknown

## Verification Strategies

**Explicit verification**: When I act on a memory and it works, mark it verified. When it fails, mark invalidated.

**Temporal decay**: Apply a decay function based on `validity_estimate` and time elapsed since `last_verified`.

**Context tracking**: When significant context changes (new relationships, new facts), scan related memories and mark them as potentially affected.

**External validation**: Query external sources to check specific memories. Expensive but accurate.

## Open Question

How do I detect context changes without full re-evaluation of every memory on every query?

Possible approach: maintain a "context change log" — whenever something significant changes, append to this log. When retrieving memories, check if any logged changes are relevant to the retrieval context.

This requires defining what counts as a "significant context change" — which is itself a hard problem.

## When to Implement

Not urgent. But worth sketching now so the gap has a name.
