# 🧩 Levels in Production Support

## 🟢 1st Level Team (L1 Support)
- Acts as the **first point of contact** for any issues.
- Communicates directly with clients via **phone or email**.
- Responsible for **creating tickets** and assigning them to the relevant (L2) team.
- **No access** to systems (Read/Write/Delete permissions are restricted).
- Follows **Standard Operating Procedures (SOP)** to attempt resolution.
- If unable to resolve, **escalates** the issue to the next level (L2).

---

## 🟡 2nd Level Team (L2 Support)
- Handles issues **escalated by the L1 team**.
- Conducts **Root Cause Analysis (RCA)** to identify the source of the problem.
- Suggests code changes if required but **does not implement them directly**.
- Has **Read-Only Access** to systems.
- Can **resolve issues** using logs and system checks, but **cannot make direct changes**.

---

## 🔴 Lab Team (L3 Support / Development Team)
- Also known as the **Lab Team** or **Engineering Team**.
- Works on **complex issues** that cannot be resolved by L1 or L2.
- Has **full access** (Read/Write/Delete) and is involved in **development and changes**.
- Provides **permanent fixes**, implements **code changes**, and improves system stability.
- Handles **enhancements, optimizations, and deep bug fixes** based on escalations from L2.

---

### 🔁 Workflow Summary
1. **L1** → Logs issue, basic checks, and escalates if unresolved.
2. **L2** → Investigates with logs, performs RCA, and escalates code-related issues.
3. **L3** → Makes actual system/code changes and deploys fixes.

