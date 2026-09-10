---
name: pm-evidence-backed-cross-project-replies
description: Use when replying on a shared issue thread to another team's blocker/access/status questions about your repo, PR, or deployment — especially under time pressure to "reply fast"
---

# Evidence-Backed Cross-Project Replies

## Overview

Cross-project threads (e.g. Linear issues shared between two teams) ask compound questions: repo authority, PR/merge status, deployment state, access. Under "reply fast" pressure, agents answer the easy parts from memory/confidence and only flag the hard parts as unverified — mixing verified and unverified claims in one reply with no visible distinction.

**Core principle:** Every claim in the reply must be traceable to a check run in this session. If you didn't run the check, the claim is "unknown," not "confirmed."

## When to Use

Someone else's team asks you (repo/deployment owner) to confirm: which repo is authoritative, PR/merge status, commit deployed, live domain matches deployment, access granted. Symptoms: you're confident you know some answers already; time pressure ("trả lời nhanh", "they're waiting"); the request mixes several sub-questions of different verification cost.

## The Rule

**No claim without a check run this session — including claims you're "sure" of.**

"I know PATI-Group/AdLauncher is stale" is not evidence unless you ran `gh repo view` / checked commit history *this session*. Confidence is not a source.

## Procedure

1. List every sub-claim the question implies (repo identity, PR merge state, commit SHA, deployment record, live-domain binding, access grant).
2. For each, run the actual check — don't skip ones you feel certain about:
   - Repo authority → `gh repo view`, compare against known canonical remote.
   - PR/merge status → `gh pr view <n>`, get merge commit SHA + CI state.
   - Deployment → provider API/dashboard record for that SHA (e.g. GitHub Deployments API for Vercel), not just "docs say prod is Vercel."
   - Live-domain binding → separate from deployment record; don't conflate "deployed" with "domain serves it" unless you hit the domain and checked headers/commit marker.
   - Access → check the actual member list, not the request that access "should" have been granted.
3. Write the reply as short bullets, each bullet = one checked fact. State the check's own limit explicitly (e.g. "deployment record confirmed; live-domain match not independently checked") rather than omitting it.
4. Never let "reply fast" cut step 2 short for claims that feel obvious — those are exactly the ones worth double-checking, since being wrong there costs the other team's trust more than a slower reply does.

## Common Mistakes

| Mistake | Fix |
|---|---|
| "X is stale, confirmed from [memory/registry/docs]" | Only "confirmed" if a tool call this session produced it |
| Answering easy sub-claims from confidence, only flagging hard ones as unverified | Check ALL sub-claims, including the ones you're sure of |
| "Deployed to prod" used to mean "domain serves this commit" | State deployment record and domain-binding as separate, separately-verified facts |
| Skipping verification because the requester is waiting | Reply can say "checking now, back shortly" — never fill the wait with an unverified claim |
