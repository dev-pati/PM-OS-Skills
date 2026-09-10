---
title: PM Operating System
status: current
updated: 2026-09-10
tags:
  - framework
  - gates
  - linear
  - evidence
aliases:
  - PM OS
  - pm-operating-system
---

# PM Operating System

> **Job.** Một vòng vận hành duy nhất cho vai Product Manager: từ request tới **adopted evidence**, không mất dấu bằng chứng ở bất kỳ khâu nào.
> **Ghép từ hai nguồn.** [[product-development-framework]] (discovery, hai gate) + Linear issue feedback loop (delivery, 7 stage + 3 gate).
> **Không phải** SDLC tổng quát. Đây là control system của AdLauncher, mở rộng sang repo khác cần nguồn riêng.

Sơ đồ: `Second Brain/Outputs/shared/playbooks/pm-operating-system.html`

---

## Ba phase

| Phase | Nguồn | Việc |
|---|---|---|
| **A · Discovery** | [[product-development-framework]] §1–§6 | Intake → Gate 1 (B1–B9) → Gate 2 (8 plane) → smallest spec → tickets → triage |
| **B · Delivery** | `Outputs/shared/linear-feedback-loop.html` (thiết kế 08/09/2026) | 7 stage, 3 gate, checkpoint Linear MCP mỗi stage |
| **C · Adoption** | [[product-development-framework]] §9–§10 | Adoption check → adopted evidence, hoặc incident → prevention |

Điểm nối A→B là **triage label** `ready-for-agent`, và nhãn đó **yêu cầu Gate 1 đã pass** ([[System/agents/triage-labels]]).

---

## Phase B — 7 stage của Linear loop

| Stage | Việc | MCP ghi gì |
|---|---|---|
| **01** Take one eligible issue | Xác nhận scope, owner, blocker, trạng thái hiện tại | `save_issue` + `save_comment` → In Progress, owner, run ID |
| **02** Pass issue prompt to an agent | Issue ID + title/description + target repo. **Không bulk read** | `save_comment` → Delegated, task scope |
| **03** Agent understands the actual problem | Chỉ bằng chứng có đích; trả diagnosis + blocker | `save_comment` → diagnosis, criteria, code evidence |
| **04** Design the smallest implementation | Reuse trước; file bị ảnh hưởng; test; rollback nếu cần | `save_comment` → plan, tradeoff, verification commands |
| **GATE** Plan approved? | **Người** duyệt scope; không thì pause hoặc revise | `save_comment` → Waiting for approval, plan version |
| **05** Implement the approved change | Minimal diff + regression test; giữ nguyên việc của người khác | `save_comment` → changed files, next test run |
| **06A** Local testing | Regression + acceptance; đủ mọi check bắt buộc | `save_comment` → **exact commands**, pass/fail/skipped, attempt ID |
| **GATE** Review + deploy authorized? | Đã review, rollback sẵn sàng | `save_issue` + `save_comment` → approval, commit, deploy ID |
| **06B** Production testing | Smoke an toàn + critical path + log trên revision đang serve | `save_comment` (+ `save_issue` nếu fail) |
| **GATE** Observe + accept | Thời lượng, signal, threshold, owner chịu trách nhiệm — thoả thuận trước | `save_comment` → window start/end, health evidence |
| **07** Complete the issue | Local + production pass; observation accepted | `save_comment` `save_issue` `get_issue` verify |

Ba luật vận hành của loop:

1. **7 stage không phải 7 status Linear.** Giữ workflow status sẵn có của team; stage là checkpoint, không phải state machine mới.
2. **Một thread, bằng chứng thật.** Tạo một root comment, lưu ID, rồi `save_comment(parentId, body)` cho mọi update. Refresh comment trước khi implement / review / close / resume.
3. **Loop có biên.** Mặc định đề xuất: pause sau **3 lần fix không thành**, hoặc hết thời gian đã thoả thuận.

---

## Bộ skills theo phase

Nạp **tập tối thiểu đủ dùng**. Hai skill là thường, bốn là nhiều, sáu là đèn đỏ ([[Skills/meta/task-routing]]).

### Phase A — Discovery

| Khi nào | Skill | Ghi chú |
|---|---|---|
| Mở đầu mọi build | `/build-connected` | Orchestrator. Tự gọi grilling, domain-modeling, vault-system-thinking, to-spec, to-tickets |
| Trước khi hỏi bất cứ gì | `/vault-knowledge-retrieval` | Câu trả lời thường đã có trong vault, có trích dẫn, cờ stale |
| Gate 1 (B1–B9) | `/grilling` hoặc `/grill-with-docs` | Bản `-with-docs` để lại ADR + glossary |
| Ngôn ngữ domain còn mờ | `/domain-modeling` | Ubiquitous language → `CONTEXT.md` |
| **Gate 2** | `/vault-system-thinking` | 8 plane, reverse trace, mỗi seam hoãn phải có `TD-`/`BL-` |
| Ý tưởng chưa định hình | `/brainstorming` | Trước cả Gate 1 |
| Viết spec | `/to-spec` | Không phỏng vấn, chỉ tổng hợp |
| Chia ticket | `/to-tickets` | Ticket đầu là tracer, có blocking edge |
| Quá lớn cho một session | `/wayfinder` | Chia thành decision ticket |
| Cần bằng chứng ngoài | `/user-research` `/market-research` `/research` | B2, B4, B9 |
| Câu hỏi kỹ thuật chưa rõ | `/technical-spike` | Time-boxed, có exit criteria |
| Cần thử UI trước khi cam kết | `/prototype` | Throwaway, trả lời một câu hỏi |
| Quyết định cần người khác trả lời | `/to-questionnaire` | Biến deadlock thành form |

### Phase B — Delivery

| Khi nào | Skill | Ghi chú |
|---|---|---|
| Stage 01 | `/triage` | 5 label; `ready-for-agent` cần Gate 1 đã pass |
| Issue người khác dán vào | `/linear-problem-report` | Giải thích lại: cái gì vỡ, lỗ nào mở ra, fix gì, còn gì chưa quyết |
| Stage 03 chẩn đoán | `/bug-reproduction-brief` → `/systematic-debugging` | Repro tối thiểu trước khi sửa; 4 phase root cause |
| Stage 04 thiết kế | `/codebase-design` | Deep module, design-it-twice |
| Stage 05 | `/tdd` → `/implement` | Strict: `/test-driven-development` |
| Gate deploy | `/code-review` + `/differential-review` | Hai trục: Standards vs Spec; diff review có blast radius |
| Stage 06A | `/verification-before-completion` | Bằng chứng trước khi nói "done" |
| Đường browser | `/e2e-testing` | Playwright POM, flaky strategy |
| Trước deploy | `/rollout-plan` | Preflight, verification signal, rollback, comms |
| Chạm DB | `/supabase` `/supabase-postgres-best-practices` | Đọc luật migration của repo trước |
| Chạm UI | `/react-best-practices` `/frontend-design` `/web-design-guidelines` `/accessibility` | `/ui-ux-pro-max` khi cần bảng màu/font |
| Bề mặt có quyền | `/threat-model` `/security-best-practices` | Trust boundary, abuse path |
| Việc AI | `/prompt-review` `/agentic-eval` `/llm-cost-optimization` | |
| Nhiều task song song | `/dispatching-parallel-agents` `/subagent-driven-development` | Một subagent tươi mỗi task |
| Nhánh riêng | `/using-git-worktrees` → `/finishing-a-development-branch` | |
| Hết session | `/handoff` | Nén hội thoại cho agent kế |

### Phase C — Adoption + learning

| Khi nào | Skill | Ghi chú |
|---|---|---|
| Sau ship | `/vault-note-update` | Một fact → mọi doc phụ thuộc, hai chiều, **cùng change** |
| Doc mới | `/vault-note-creation` | PRD/API/DATAFLOW/BPMN theo `AGENTS.md` §2 |
| Production vỡ | `/incident-postmortem` | Đo trước, sửa sau |
| Báo cáo | `/internal-comms` `/daily-app-status` | |
| Trả lời team khác | `/evidence-backed-cross-project-replies` | Chỉ fact kiểm trong session này, không lấy từ ký ức |
| Cadence | `/update-action-plan` | Quét worktree/branch vào Action Plan |
| Visual | `/architecture-diagram` `/html-canvas` `/json-canvas` `/bpmn` | Sơ đồ này dựng bằng `/architecture-diagram` |
| Đo lường | `/experimentation` `/analytics-instrumentation` | B4 KPI, B7 unused signal |
| Sửa skill / AGENTS.md | `/writing-for-agents` `/writing-skills` | |

---

## Bằng chứng — thứ tự không được trộn

```text
runtime  >  commit  >  chat  >  none
```

- Code thắng docs. Runtime thắng code. Bất đồng là **finding**, không im lặng sửa theo doc cũ.
- Verification đầy đủ chạy **một lần, ở cuối**. Test có đích chạy trong lúc làm.
- Một lần test xanh **không phải** một lần deploy.
- Test bắt buộc bị skip = **không pass**.
- Meta write bị ngắt để `unknown`, không phải `failed` hay `0 created`.

## Điều kiện dừng

- 3 lần fix không thành → pause, escalate.
- Không có `BL-`/`TD-` nào trống mà không đụng collision → **không** mint next-free.
- Cây làm việc bẩn không phải của mình → để nguyên.
- Có ảnh hưởng production → contain hoặc rollback theo runbook đã cấp quyền.
- **Không bao giờ** redeploy khi chưa hiểu.

---

## Canvas và doc đã map

| Dùng ở | Nguồn trong vault |
|---|---|
| Toàn bộ Phase A | [[product-development-framework]] + canvas cùng thư mục |
| Định nghĩa hai gate | [[Projects/AdLauncher/architecture/decisions/0002-business-and-connection-gates-before-build]] |
| Plane 1 · process | `Projects/AdLauncher/architecture/bpmn.canvas` |
| Plane 3 · API | `Projects/AdLauncher/architecture/api-map.canvas` |
| Plane 4 · data | `Projects/AdLauncher/architecture/data-flow.canvas` |
| Sổ nợ | [[Projects/AdLauncher/architecture/tech-debt]] · [[Projects/AdLauncher/product/backlog]] |
| Incident mẫu | [[Projects/AdLauncher/postmortems/2026-08-25-ghost-ads-27-thanh-42]] |
| 5 triage label | [[System/agents/triage-labels]] |
| Tracker | [[System/agents/issue-tracker]] |
| Thiết kế Linear loop | `Outputs/shared/linear-feedback-loop.html` |
| Routing skill | [[Skills/meta/task-routing]] |
| Registry skill | `Skills/INDEX.md` |

---

## Phát hiện

1. **Linear loop chưa có note nguồn.** Nó chỉ tồn tại dưới dạng HTML render trong `Outputs/`, trái quy ước "Outputs là artefact tái tạo được". Note này là chỗ neo tạm; nếu loop thành chuẩn vận hành thì cần note riêng trong `Knowledge/playbooks/`.
2. HTML đó tự ghi **"Design only. No live issue data, status changes, running automation"** và **"Proposed operating design 8 September 2026"** — nên đây là **đề xuất**, chưa phải quy trình đã nghiệm thu. Đừng trích như đã chốt.
3. Tên tool MCP (`save_issue`, `save_comment`, `get_issue`, `list_issues`) khớp interface Linear đang kết nối tại thời điểm 08/09/2026. Kiểm lại trước khi tự động hoá.
4. Framework Phase A là của **AdLauncher**. AI Portal và Creative Portal chưa dùng sổ `BL-`/`TD-`, nên Gate 2 plane 2–4 chưa có canonical source cho hai repo đó.

## Liên quan

- [[product-development-framework]] — nguồn Phase A
- [[second-brain-playbook]] — bốn trụ triết lý
- [[Skills/meta/task-routing]] — chọn skill
- [[System/agents/triage-labels]] — điểm nối A→B

