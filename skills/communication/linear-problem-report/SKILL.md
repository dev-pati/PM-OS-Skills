---
name: Linear-Problem-Report
description: Use when the user pastes a Linear issue, ticket, spec, or bug prompt and wants it explained back as a short Vietnamese problem report — what was broken, which holes it opened, how it is fixed, what is still undecided
---

# Linear Problem Report

## Overview

A pasted Linear issue is written for a tracker, not for a person: acceptance
checkboxes, policy references, blocked-by ids, hedging about approval. Reading
it out loud does not tell anyone what was actually wrong.

The failure mode this skill prevents is a **technical restatement** — "thiếu
kiểm tra membership" — instead of a consequence — "người rời công ty vẫn dùng
key được". The first is the issue text reworded. The second is the reason the
issue exists.

**Core principle:** every hole listed must name a consequence someone outside
the code would recognise. If you cannot say what goes wrong for a person or for
money, it is not a hole, it is a detail.

## Format

```
Vấn đề [ID], ngắn gọn:

**Trước đây:** [hiện trạng + cái gì đang hỏng, 1–2 câu]

**N lỗ hổng chính:**
1. **[Tên lỗ hổng].** [Hậu quả cụ thể]
2. ...

**Cách sửa:**
- [Thay đổi] → [ràng buộc mới]
- ...

**Điểm cần anh quyết:** [unknown, giá trị chưa duyệt, thứ đang chờ issue khác]
```

## Rules

- **Consequence, not mechanism.** Each hole says what breaks for a person, an
  account, or a budget. Mechanism belongs in the fix line, if anywhere.
- **Count the holes.** Naming "3 lỗ hổng chính" forces a decision about what is
  central. A list of nine is a restatement, not an analysis.
- **Fix lines are constraints.** "Grant không có trần = không cho tiêu" — the
  new rule, not the new file.
- **Verbatim identifiers.** File paths, symbol names, error strings, scope
  names, issue ids stay in their original form inside Vietnamese prose.
- **Unknowns stay unknown.** Missing owners, dates, default values, and anything
  waiting on another issue go in the last section, marked as not decided. Never
  invent a date or an owner.
- **Drop the last section when nothing is open.** An empty "cần anh quyết" is
  noise.
- **No verification theatre.** Test counts and build output belong in the Linear
  comment, not in the explanation — unless a result *is* the problem.

## When the prompt is an unfixed issue

Same shape, past tense dropped: **Vấn đề hiện tại** instead of **Trước đây**,
and **Cách sửa** becomes **Hướng sửa** with the approach rather than the diff.
Do not describe unwritten code as done.

## Language

Mirror the user's language. These examples are Vietnamese because that is what
the user writes; the structure is language-independent. Code identifiers never
translate.
