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






# 🏦 Banking Production Support Workflow with P1, P2, P3 Examples

## 🚨 P1 - Priority 1 (Critical - Business Down)

### 🔁 Workflow:
- Immediate alert to support team via monitoring or user escalation.
- Incident ticket created in **ServiceNow/Jira** and assigned to L2/L3 immediately.
- **Bridge call initiated** involving stakeholders (Support, Dev, Infra, DBA).
- Communication sent to users and leadership (email/SMS/Teams).
- Root cause analysis begins simultaneously with temporary fix.
- Permanent fix planned and tracked under Problem Management.

### 🧾 5 Example Issues:
1. **NetBanking down** for all users across the country.
2. **ATM network outage** in multiple cities due to server crash.
3. **Payment gateway integration failed**, affecting real-time payments (UPI/IMPS/NEFT).
4. **Core Banking System (CBS) failure** — customers can't access balance, transfer funds.
5. **Loan disbursement batch job failed**, affecting daily loan releases.

---

## ⚠️ P2 - Priority 2 (High - Partial Impact)

### 🔁 Workflow:
- Logged and assigned via ServiceNow.
- SLA usually 4–8 hours.
- Issue does not stop critical operations but impacts performance or a large user group.
- Investigated by L2 team, RCA sent to L3 if needed.

### 🧾 5 Example Issues:
1. **Cheque deposit system delay** — delayed reflection in accounts for some customers.
2. **High response time in Internet Banking** during peak hours.
3. **Batch job for SMS alerts failed**, notifications not sent to users.
4. **Branch printing system not working** for loan documents in a specific region.
5. **Currency rate updates not reflected** due to file ingestion delay from upstream systems.

---

## ⚙️ P3 - Priority 3 (Medium - Minor Impact)

### 🔁 Workflow:
- Logged through ticketing system.
- Investigated and resolved within 1–2 business days.
- Typically involves individual users or low-impact components.

### 🧾 5 Example Issues:
1. **User unable to download bank statement** via mobile app.
2. **UI glitch** in dashboard showing incorrect currency symbol.
3. **One branch’s user role misconfigured**, restricting access to internal tools.
4. **Error in report generation job** — specific filters not applied correctly.
5. **Email notifications not sent** to 10 users due to invalid email domain.

---

## ✅ Summary Table

| Priority | Impact                       | Response Time     | Examples Count | Owner     |
|----------|------------------------------|-------------------|----------------|-----------|
| P1       | System-wide outage            | Immediate         | 5              | L2 + L3   |
| P2       | Partial service disruption    | Within 4–8 hours  | 5              | L2        |
| P3       | Minor issues / UI / Reports  | 1–2 business days | 5              | L2        |









