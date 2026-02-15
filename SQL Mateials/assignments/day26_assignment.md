# Day 26 Assignment: Transactions

Use a **copy** of hr.employees (e.g. hr_emp_backup) for updates so you do not change production data.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Write a **transaction** that simulates "moving" several employees from one department to another: **UPDATE** their department_id from (e.g.) 50 to 60. Use a single transaction (multiple UPDATEs, then one COMMIT). If any step fails, the whole change should roll back.

**Answer:**

```sql
BEGIN
  UPDATE hr_emp_backup SET department_id = 60 WHERE department_id = 50 AND employee_id IN (101, 102, 103);
  -- Optional: more updates
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/
```

**Explanation:** All UPDATEs run in one transaction. COMMIT makes them permanent. If an exception occurs, ROLLBACK undoes all changes in the block, then RAISE propagates the error. This keeps the move all-or-nothing.

---

### Question 2
Use **SAVEPOINT**: after the first UPDATE, create a savepoint; after a second UPDATE, **ROLLBACK TO SAVEPOINT**; then **COMMIT**. Confirm that only the first UPDATE is committed.

**Answer:**

```sql
UPDATE hr_emp_backup SET salary = salary * 1.05 WHERE employee_id = 100;
SAVEPOINT after_first;
UPDATE hr_emp_backup SET salary = salary * 1.10 WHERE employee_id = 101;
ROLLBACK TO SAVEPOINT after_first;
COMMIT;
```

**Explanation:** After the first update we set a savepoint. The second update is then undone by ROLLBACK TO SAVEPOINT, so only the first update remains when we COMMIT.

---

### Question 3
In your own words, explain **isolation** between two sessions: Session A updates a row and has not yet committed. What does Session B see when it selects that row? After Session A commits?

**Answer (conceptual):** Until Session A commits, Session B typically does **not** see Session A's uncommitted change (read committed isolation). Session B may see the old value or may wait if it tries to update the same row (row-level lock). After Session A commits, Session B's **subsequent** queries will see the new value. Session B's current query may already be using a read-consistent snapshot from before the commit, depending on when the query started.

---

## Part 2: Self-Practice (No Answers)

1. Write a **procedure** that performs an UPDATE on your backup table and **commits** only if a condition is met (e.g. SQL%ROWCOUNT > 0); otherwise **roll back**.
2. Use **nested savepoints**: SAVEPOINT a, then SAVEPOINT b, then ROLLBACK TO a. What happens to work done after savepoint a?

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

Use **hr_emp_backup** or copy tables for DML so production hr.employees is not changed.

### 20 Medium Questions

1. **M1.** Run two UPDATEs then COMMIT in one block. **Hint:** UPDATE ... ; UPDATE ... ; COMMIT;
2. **M2.** Run UPDATE then ROLLBACK; verify row unchanged. **Hint:** UPDATE ... ; ROLLBACK; SELECT to verify.
3. **M3.** SAVEPOINT sp1; UPDATE; ROLLBACK TO sp1; COMMIT. **Hint:** Only work before sp1 is kept after COMMIT.
4. **M4.** In PL/SQL: UPDATE; IF SQL%ROWCOUNT = 0 THEN ROLLBACK; ELSE COMMIT; **Hint:** Commit only when rows updated.
5. **M5.** Procedure that UPDATEs backup table and COMMITs at end. **Hint:** UPDATE hr_emp_backup SET ... ; COMMIT;
6. **M6.** Block with EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE; **Hint:** Ensures no partial commit on error.
7. **M7.** Two SAVEPOINTs: after_first, after_second; ROLLBACK TO after_first. **Hint:** Second update is undone.
8. **M8.** UPDATE one row; SAVEPOINT; DELETE another row; ROLLBACK TO SAVEPOINT; COMMIT. **Hint:** DELETE undone, UPDATE committed.
9. **M9.** Explain: Session A updates row, no COMMIT; Session B SELECTs that row. **Hint:** Read committed: B sees old value (or may wait if B also updates).
10. **M10.** SET TRANSACTION READ ONLY; then SELECT; COMMIT to end. **Hint:** Read-only transaction; no DML allowed.
11. **M11.** Update 3 rows in one UPDATE; COMMIT; check SQL%ROWCOUNT. **Hint:** SQL%ROWCOUNT after UPDATE, before COMMIT.
12. **M12.** Nested block: inner COMMIT; outer ROLLBACK. **Hint:** Inner COMMIT ends transaction; outer ROLLBACK has nothing to roll back.
13. **M13.** Procedure with two UPDATEs; COMMIT only if both SQL%ROWCOUNT > 0. **Hint:** v1 := SQL%ROWCOUNT after first; v2 after second; IF v1>0 AND v2>0 THEN COMMIT; ELSE ROLLBACK;
14. **M14.** SAVEPOINT before loop that UPDATEs; on error ROLLBACK TO SAVEPOINT. **Hint:** Loop with EXCEPTION; ROLLBACK TO SAVEPOINT in handler.
15. **M15.** Explain atomicity in one transaction with 2 UPDATEs. **Hint:** Both commit or both roll back.
16. **M16.** UPDATE then SELECT in same transaction (same session). **Hint:** Session sees its own uncommitted changes.
17. **M17.** Use ROLLBACK without a savepoint to undo entire transaction. **Hint:** ROLLBACK; (no TO SAVEPOINT)
18. **M18.** After ROLLBACK TO SAVEPOINT, can you still use the savepoint name again? **Hint:** Yes; later SAVEPOINT same_name moves the point.
19. **M19.** Procedure that opens cursor, updates rows in loop, COMMIT every 10 rows. **Hint:** Counter; IF mod(counter,10)=0 THEN COMMIT; END IF;
20. **M20.** Block: UPDATE; SAVEPOINT; UPDATE; COMMIT. How many updates committed? **Hint:** Both (savepoint does not commit).

### 20 Hard Questions

1. **H1.** Transaction that "moves" all employees from dept 50 to 60 (UPDATE department_id); single COMMIT. **Hint:** UPDATE hr_emp_backup SET department_id = 60 WHERE department_id = 50; COMMIT;
2. **H2.** Nested savepoints: a, b, c; ROLLBACK TO b. What is state of work after c? **Hint:** Work after b (including c) is undone.
3. **H3.** SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; run two SELECTs; then UPDATE; COMMIT. **Hint:** Serializable snapshot for the transaction.
4. **H4.** Procedure that updates salary for one employee; COMMIT inside; caller expects to roll back. **Hint:** Procedure COMMIT breaks caller's transaction; document or avoid COMMIT in procedure.
5. **H5.** Two sessions: A updates row and holds; B updates same row. **Hint:** B waits for A to COMMIT or ROLLBACK (row lock).
6. **H6.** Block that inserts into audit table, then updates backup; on any exception ROLLBACK both. **Hint:** EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
7. **H7.** Use autonomous transaction in procedure to log "transaction started" without affecting main transaction commit/rollback. **Hint:** PRAGMA AUTONOMOUS_TRANSACTION; INSERT INTO log_table ...; COMMIT;
8. **H8.** SAVEPOINT in loop: each iteration SAVEPOINT; on error ROLLBACK TO that savepoint and continue. **Hint:** SAVEPOINT sp_loop; BEGIN ... EXCEPTION WHEN OTHERS THEN ROLLBACK TO sp_loop; END;
9. **H9.** Explain durability: after COMMIT, server crashes; after restart. **Hint:** Committed data is in redo log and is recovered.
10. **H10.** Transaction with 3 UPDATEs; second UPDATE raises error (e.g. constraint). **Hint:** EXCEPTION handler ROLLBACK; all three undone.
11. **H11.** Procedure with OUT parameter p_updated NUMBER; set to SQL%ROWCOUNT after UPDATE; caller decides COMMIT or ROLLBACK. **Hint:** p_updated := SQL%ROWCOUNT; no COMMIT in procedure.
12. **H12.** Batch update: loop 1 to 100, UPDATE one row each, COMMIT every 20. **Hint:** FOR i IN 1..100 LOOP UPDATE ... WHERE employee_id = ids(i); IF MOD(i,20)=0 THEN COMMIT; END IF; END LOOP;
13. **H13.** Read committed: Session A commits; Session B started SELECT before A's commit. **Hint:** B's query may not see A's committed row (snapshot at query start).
14. **H14.** ROLLBACK TO SAVEPOINT releases locks on rows updated after that savepoint? **Hint:** Yes; those changes are undone and locks released.
15. **H15.** Design: one big transaction (all employees) vs batch COMMIT every N. Trade-offs? **Hint:** Big: simple, all-or-nothing; batch: less lock time, can resume, but partial commit.
16. **H16.** Block: UPDATE; SAVEPOINT a; UPDATE; SAVEPOINT a; (same name). Then ROLLBACK TO a. **Hint:** Second SAVEPOINT a moves point; ROLLBACK TO a undoes only work after second a.
17. **H17.** Procedure that does INSERT then UPDATE in same table; exception on UPDATE; ensure INSERT also rolled back. **Hint:** No COMMIT until end; EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
18. **H18.** Two procedures: one COMMITs, one does not. Call both from same block; then ROLLBACK. **Hint:** Only uncommitted work from second procedure is rolled back.
19. **H19.** Lock timeout: Session A holds row; Session B waits. How to make B not wait (fail fast)? **Hint:** Use NOWAIT in SELECT ... FOR UPDATE or set timeout (Oracle has limited support; application can retry).
20. **H20.** Document "this procedure commits" vs "caller must commit" in procedure header. **Hint:** Comment or doc: -- Commits on success. Or: -- Caller must commit.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day26_transactions.md)
