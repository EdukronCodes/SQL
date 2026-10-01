# Oracle SQL Analytic Functions

## Topics Covered

1. `ROW_NUMBER()`
2. `RANK()`
3. `DENSE_RANK()`
4. `FIRST_VALUE()`
5. `LAST_VALUE()`

---

ORACLE SQL ANALYTIC FUNCTIONS

1. ROW_NUMBER()

2. RANK()

3. DENSE_RANK()

4. FIRST_VALUE()

5. LAST_VALUE()

## CREATE DUMMY RETAIL TABLE

```sql
CREATE TABLE retail_sales (

    sale_id       NUMBER,

    product_name  VARCHAR2(30),

    category      VARCHAR2(30),

    sales_amount  NUMBER

);
```

```sql
INSERT INTO retail_sales VALUES (1, 'Laptop', 'Electronics', 50000);
```

```sql
INSERT INTO retail_sales VALUES (2, 'Mobile', 'Electronics', 40000);
```

```sql
INSERT INTO retail_sales VALUES (3, 'TV', 'Electronics', 40000);
```

```sql
INSERT INTO retail_sales VALUES (4, 'Tablet', 'Electronics', 30000);
```

```sql
INSERT INTO retail_sales VALUES (5, 'Jacket', 'Clothing', 10000);
```

```sql
INSERT INTO retail_sales VALUES (6, 'Jeans', 'Clothing', 8000);
```

```sql
INSERT INTO retail_sales VALUES (7, 'Shirt', 'Clothing', 5000);
```

```sql
INSERT INTO retail_sales VALUES (8, 'Rice', 'Grocery', 5000);
```

```sql
INSERT INTO retail_sales VALUES (9, 'Oil', 'Grocery', 5000);
```

```sql
INSERT INTO retail_sales VALUES (10, 'Sugar', 'Grocery', 4000);
```

```sql
COMMIT;
```

## 1. ROW_NUMBER()

ROW_NUMBER gives a UNIQUE sequential number to every row.

Even if two employees/products have the same value,

they receive different row numbers.

```sql
SELECT

    product_name,

    sales_amount,

    ROW_NUMBER() OVER (

        ORDER BY sales_amount DESC, sale_id

    ) AS row_num

FROM retail_sales;
```

### EXPECTED OUTPUT

PRODUCT       SALES       ROW_NUM

Laptop        50000          1

Mobile        40000          2

TV            40000          3

Tablet        30000          4

Jacket        10000          5

Jeans          8000          6

Shirt          5000          7

Rice           5000          8

Oil            5000          9

Sugar          4000         10

### EXPLANATION

Mobile = 40000

TV     = 40000

### Even though both values are equal

Mobile → 2

TV     → 3

ROW_NUMBER never gives the same number to two rows.

### Pattern

1

2

3

4

5

6

...

No duplicates.

No gaps.

## 2. RANK()

RANK gives the SAME rank to duplicate values.

But it SKIPS the next rank.

```sql
SELECT

    product_name,

    sales_amount,

    RANK() OVER (

        ORDER BY sales_amount DESC

    ) AS sales_rank

FROM retail_sales;
```

### EXPECTED OUTPUT

PRODUCT       SALES       RANK

Laptop        50000         1

Mobile        40000         2

TV            40000         2

Tablet        30000         4

Jacket        10000         5

Jeans          8000         6

Shirt          5000         7

Rice           5000         7

Oil            5000         7

Sugar          4000        10

### IMPORTANT

Mobile = 40000 → Rank 2

TV     = 40000 → Rank 2

Both get Rank 2.

### The next rank becomes

4

### NOT

3

### Therefore

### RANK pattern

1

2

2

4

5

6

7

7

7

10

WHY DOES TABLET GET 4?

Position 1 = Laptop

Position 2 = Mobile

Position 3 = TV

Position 4 = Tablet

Mobile and TV are tied.

Therefore Tablet receives Rank 4.

## 3. DENSE_RANK()

DENSE_RANK also gives the SAME rank to duplicate values.

But unlike RANK, it DOES NOT skip ranks.

```sql
SELECT

    product_name,

    sales_amount,

    DENSE_RANK() OVER (

        ORDER BY sales_amount DESC

    ) AS dense_rank

FROM retail_sales;
```

### EXPECTED OUTPUT

PRODUCT       SALES       DENSE_RANK

Laptop        50000           1

Mobile        40000           2

TV            40000           2

Tablet        30000           3

Jacket        10000           4

Jeans          8000           5

Shirt          5000           6

Rice           5000           6

Oil            5000           6

Sugar          4000           7

### Mobile and TV

40000 → Rank 2

40000 → Rank 2

### Next value

Tablet 30000 → Rank 3

### DENSE_RANK pattern

1

2

2

3

4

5

6

6

6

7

### COMPARE

### ROW_NUMBER

1

2

3

4

### RANK

1

2

2

4

### DENSE_RANK

1

2

2

3

## 4. RANK() WITH PARTITION BY

Rank products separately inside each category.

```sql
SELECT

    category,

    product_name,

    sales_amount,

    RANK() OVER (

        PARTITION BY category

        ORDER BY sales_amount DESC

    ) AS category_rank

FROM retail_sales;
```

### EXAMPLE ELECTRONICS

Laptop      50000    1

Mobile      40000    2

TV          40000    2

Tablet      30000    4

### EXAMPLE CLOTHING

Jacket      10000    1

Jeans        8000    2

Shirt        5000    3

PARTITION BY category

### means

Start ranking again whenever category changes.

## 5. DENSE_RANK() WITH PARTITION BY

```sql
SELECT

    category,

    product_name,

    sales_amount,

    DENSE_RANK() OVER (

        PARTITION BY category

        ORDER BY sales_amount DESC

    ) AS category_dense_rank

FROM retail_sales;
```

### ELECTRONICS

Laptop      50000    1

Mobile      40000    2

TV          40000    2

Tablet      30000    3

### Notice

DENSE_RANK does not skip 3.

## 6. ROW_NUMBER() WITH PARTITION BY

```sql
SELECT

    category,

    product_name,

    sales_amount,

    ROW_NUMBER() OVER (

        PARTITION BY category

        ORDER BY sales_amount DESC, sale_id

    ) AS row_num

FROM retail_sales;
```

### ELECTRONICS

Laptop     50000    1

Mobile     40000    2

TV         40000    3

Tablet     30000    4

### CLOTHING

Jacket     10000    1

Jeans       8000    2

Shirt       5000    3

ROW_NUMBER restarts from 1 for each category.

## 7. FIRST_VALUE()

FIRST_VALUE returns the FIRST value from the window.

Here we order sales from highest to lowest.

Therefore FIRST_VALUE returns the highest sales amount.

```sql
SELECT

    product_name,

    sales_amount,


    FIRST_VALUE(sales_amount) OVER (

        ORDER BY sales_amount DESC

    ) AS highest_sales


FROM retail_sales;
```

### EXPECTED OUTPUT

Laptop      50000      50000

Mobile      40000      50000

TV          40000      50000

Tablet      30000      50000

Jacket      10000      50000

Jeans        8000      50000

Shirt        5000      50000

Rice         5000      50000

Oil          5000      50000

Sugar        4000      50000

WHY?

ORDER BY sales_amount DESC

### produces

50000

40000

40000

30000

10000

8000

5000

5000

5000

4000

### The FIRST value is

50000

Therefore FIRST_VALUE returns 50000.

## 8. FIRST_VALUE() BY CATEGORY

Find the highest sales value within each category.

```sql
SELECT

    category,

    product_name,

    sales_amount,


    FIRST_VALUE(sales_amount) OVER (

        PARTITION BY category

        ORDER BY sales_amount DESC

    ) AS highest_category_sales


FROM retail_sales;
```

### ELECTRONICS

Laptop      50000      50000

Mobile      40000      50000

TV          40000      50000

Tablet      30000      50000

### CLOTHING

Jacket      10000      10000

Jeans        8000      10000

Shirt        5000      10000

### GROCERY

Rice         5000       5000

Oil          5000       5000

Sugar        4000       5000

PARTITION BY category

creates a separate window for each category.

## 9. FIRST_VALUE() PRODUCT NAME

We can also return the product name instead of the amount.

```sql
SELECT

    product_name,

    sales_amount,


    FIRST_VALUE(product_name) OVER (

        ORDER BY sales_amount DESC, sale_id

    ) AS highest_sales_product


FROM retail_sales;
```

### OUTPUT

Laptop      50000      Laptop

Mobile      40000      Laptop

TV          40000      Laptop

Tablet      30000      Laptop

...

Laptop appears because Laptop is the first row after

sorting sales_amount DESC.

## 10. LAST_VALUE()

LAST_VALUE returns the LAST value in the specified window.

### IMPORTANT

For LAST_VALUE, the window frame is very important.

```sql
SELECT

    product_name,

    sales_amount,


    LAST_VALUE(sales_amount) OVER (

        ORDER BY sales_amount DESC

        ROWS BETWEEN UNBOUNDED PRECEDING

                 AND UNBOUNDED FOLLOWING

    ) AS lowest_sales


FROM retail_sales;
```

### ORDER

50000

40000

40000

30000

10000

8000

5000

5000

5000

4000

First Value = 50000

Last Value = 4000

### EXPECTED OUTPUT

Laptop      50000      4000

Mobile      40000      4000

TV          40000      4000

Tablet      30000      4000

Jacket      10000      4000

Jeans        8000      4000

Shirt        5000      4000

Rice         5000      4000

Oil          5000      4000

Sugar        4000      4000

## 11. LAST_VALUE() BY CATEGORY

Find the lowest sales amount in every category.

```sql
SELECT

    category,

    product_name,

    sales_amount,


    LAST_VALUE(sales_amount) OVER (

        PARTITION BY category

        ORDER BY sales_amount DESC


        ROWS BETWEEN UNBOUNDED PRECEDING

                 AND UNBOUNDED FOLLOWING


    ) AS lowest_category_sales


FROM retail_sales;
```

### ELECTRONICS

50000

40000

40000

30000

Last value = 30000

### CLOTHING

10000

8000

5000

Last value = 5000

### GROCERY

5000

5000

4000

Last value = 4000

## 12. FIRST_VALUE() AND LAST_VALUE() TOGETHER

```sql
SELECT

    product_name,

    sales_amount,


    FIRST_VALUE(sales_amount) OVER (

        ORDER BY sales_amount DESC

        ROWS BETWEEN UNBOUNDED PRECEDING

                 AND UNBOUNDED FOLLOWING

    ) AS highest_sales,


    LAST_VALUE(sales_amount) OVER (

        ORDER BY sales_amount DESC

        ROWS BETWEEN UNBOUNDED PRECEDING

                 AND UNBOUNDED FOLLOWING

    ) AS lowest_sales


FROM retail_sales;
```

### RESULT

PRODUCT       SALES       HIGHEST      LOWEST

Laptop        50000        50000        4000

Mobile        40000        50000        4000

TV            40000        50000        4000

Tablet        30000        50000        4000

Jacket        10000        50000        4000

Jeans          8000        50000        4000

Shirt          5000        50000        4000

Rice           5000        50000        4000

Oil            5000        50000        4000

Sugar          4000        50000        4000

## FINAL COMPARISON

### Assume values are

50000

40000

40000

30000

ROW_NUMBER()

50000     1

40000     2

40000     3

30000     4

Unique number for every row.

RANK()

50000     1

40000     2

40000     2

30000     4

Same values = same rank.

Rank is skipped.

DENSE_RANK()

50000     1

40000     2

40000     2

30000     3

Same values = same rank.

Rank is NOT skipped.

FIRST_VALUE()

Returns first value from the ordered window.

### DESC order

50000 ← FIRST VALUE

40000

40000

30000

LAST_VALUE()

Returns last value from the window.

### DESC order

50000

40000

40000

30000 ← LAST VALUE

### EASY INTERVIEW MEMORY

ROW_NUMBER = Unique numbering

RANK       = Same rank + Skip

DENSE_RANK = Same rank + No skip

FIRST_VALUE = First value in window

LAST_VALUE  = Last value in window

---

## Easy Interview Memory

| Function | Easy Meaning |
|---|---|
| `ROW_NUMBER()` | Unique numbering |
| `RANK()` | Same rank + skip next rank(s) |
| `DENSE_RANK()` | Same rank + no skip |
| `FIRST_VALUE()` | First value in the ordered window |
| `LAST_VALUE()` | Last value in the specified window |

# Oracle SQL Analytic Functions
# ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

---

## 1. What Does UNBOUNDED PRECEDING Mean?

The following Oracle SQL window frame:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

means:

> Start from the FIRST ROW of the current window/partition and continue up to the CURRENT ROW.

For example, suppose sales are:

| Row | Sales |
|---:|---:|
| 1 | 50,000 |
| 2 | 40,000 |
| 3 | 5,000 |
| 4 | 30,000 |

Running calculation:

```text
Row 1 = 50,000
Row 2 = 50,000 + 40,000 = 90,000
Row 3 = 50,000 + 40,000 + 5,000 = 95,000
Row 4 = 50,000 + 40,000 + 5,000 + 30,000 = 125,000
```

So the window keeps expanding as Oracle processes each row.

---

# Dummy Retail Table

```sql
CREATE TABLE retail_sales (
    sale_id       NUMBER,
    sale_date     DATE,
    store_name    VARCHAR2(30),
    category      VARCHAR2(30),
    product_name  VARCHAR2(50),
    quantity      NUMBER,
    unit_price    NUMBER,
    sales_amount  NUMBER
);

INSERT INTO retail_sales VALUES
(1, DATE '2026-01-01', 'Bangalore', 'Electronics', 'Laptop', 1, 50000, 50000);

INSERT INTO retail_sales VALUES
(2, DATE '2026-01-02', 'Bangalore', 'Electronics', 'Mobile', 2, 20000, 40000);

INSERT INTO retail_sales VALUES
(3, DATE '2026-01-03', 'Bangalore', 'Clothing', 'Shirt', 5, 1000, 5000);

INSERT INTO retail_sales VALUES
(4, DATE '2026-01-04', 'Hyderabad', 'Electronics', 'Tablet', 2, 15000, 30000);

INSERT INTO retail_sales VALUES
(5, DATE '2026-01-05', 'Hyderabad', 'Clothing', 'Jeans', 4, 2000, 8000);

INSERT INTO retail_sales VALUES
(6, DATE '2026-01-06', 'Hyderabad', 'Grocery', 'Rice', 10, 500, 5000);

INSERT INTO retail_sales VALUES
(7, DATE '2026-01-07', 'Chennai', 'Electronics', 'TV', 1, 40000, 40000);

INSERT INTO retail_sales VALUES
(8, DATE '2026-01-08', 'Chennai', 'Grocery', 'Oil', 5, 1000, 5000);

INSERT INTO retail_sales VALUES
(9, DATE '2026-01-09', 'Chennai', 'Clothing', 'Jacket', 2, 5000, 10000);

INSERT INTO retail_sales VALUES
(10, DATE '2026-01-10', 'Bangalore', 'Grocery', 'Sugar', 8, 500, 4000);

COMMIT;
```

---

# Original Data

| ID | Date | Store | Category | Product | Qty | Price | Sales |
|---:|---|---|---|---|---:|---:|---:|
| 1 | 01-Jan | Bangalore | Electronics | Laptop | 1 | 50000 | 50000 |
| 2 | 02-Jan | Bangalore | Electronics | Mobile | 2 | 20000 | 40000 |
| 3 | 03-Jan | Bangalore | Clothing | Shirt | 5 | 1000 | 5000 |
| 4 | 04-Jan | Hyderabad | Electronics | Tablet | 2 | 15000 | 30000 |
| 5 | 05-Jan | Hyderabad | Clothing | Jeans | 4 | 2000 | 8000 |
| 6 | 06-Jan | Hyderabad | Grocery | Rice | 10 | 500 | 5000 |
| 7 | 07-Jan | Chennai | Electronics | TV | 1 | 40000 | 40000 |
| 8 | 08-Jan | Chennai | Grocery | Oil | 5 | 1000 | 5000 |
| 9 | 09-Jan | Chennai | Clothing | Jacket | 2 | 5000 | 10000 |
| 10 | 10-Jan | Bangalore | Grocery | Sugar | 8 | 500 | 4000 |

Total Sales = 197,000

Total Quantity = 40

---

# Scenario 1: Running Total of Sales

## Business Requirement

Management wants to see cumulative company revenue after every transaction.

```sql
SELECT
    sale_id,
    product_name,
    sales_amount,
    SUM(sales_amount) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_sales
FROM retail_sales
ORDER BY sale_date, sale_id;
```

## Expected Output

| ID | Product | Sales | Running Sales |
|---:|---|---:|---:|
| 1 | Laptop | 50000 | 50000 |
| 2 | Mobile | 40000 | 90000 |
| 3 | Shirt | 5000 | 95000 |
| 4 | Tablet | 30000 | 125000 |
| 5 | Jeans | 8000 | 133000 |
| 6 | Rice | 5000 | 138000 |
| 7 | TV | 40000 | 178000 |
| 8 | Oil | 5000 | 183000 |
| 9 | Jacket | 10000 | 193000 |
| 10 | Sugar | 4000 | 197000 |

## Output Explanation

For row 1:

```text
50000 = 50000
```

For row 2:

```text
50000 + 40000 = 90000
```

For row 3:

```text
50000 + 40000 + 5000 = 95000
```

The final row contains 197000 because that is the sum of all transactions.

---

# Scenario 2: Running Quantity Sold

## Business Requirement

Find the cumulative number of units sold.

```sql
SELECT
    sale_id,
    product_name,
    quantity,
    SUM(quantity) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_quantity
FROM retail_sales
ORDER BY sale_date, sale_id;
```

## Expected Output

| Product | Qty | Cumulative Qty |
|---|---:|---:|
| Laptop | 1 | 1 |
| Mobile | 2 | 3 |
| Shirt | 5 | 8 |
| Tablet | 2 | 10 |
| Jeans | 4 | 14 |
| Rice | 10 | 24 |
| TV | 1 | 25 |
| Oil | 5 | 30 |
| Jacket | 2 | 32 |
| Sugar | 8 | 40 |

## Explanation

For Mobile:

```text
1 + 2 = 3
```

For Shirt:

```text
1 + 2 + 5 = 8
```

For Sugar:

```text
Total quantity = 40
```

---

# Scenario 3: Running Average Sales

## Business Requirement

Calculate the average transaction amount from the beginning up to every transaction.

```sql
SELECT
    sale_id,
    product_name,
    sales_amount,
    ROUND(
        AVG(sales_amount) OVER (
            ORDER BY sale_date, sale_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_avg
FROM retail_sales
ORDER BY sale_date, sale_id;
```

## Expected Output

| Product | Sales | Running Average |
|---|---:|---:|
| Laptop | 50000 | 50000.00 |
| Mobile | 40000 | 45000.00 |
| Shirt | 5000 | 31666.67 |
| Tablet | 30000 | 31250.00 |
| Jeans | 8000 | 26600.00 |

## Explanation

Row 1:

```text
50000 / 1 = 50000
```

Row 2:

```text
(50000 + 40000) / 2
= 45000
```

Row 3:

```text
95000 / 3
= 31666.67
```

---

# Scenario 4: Running Transaction Count

## Business Requirement

Find how many transactions have occurred so far.

```sql
SELECT
    sale_id,
    product_name,
    COUNT(*) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS transaction_count
FROM retail_sales
ORDER BY sale_date, sale_id;
```

## Expected Output

| Product | Count |
|---|---:|
| Laptop | 1 |
| Mobile | 2 |
| Shirt | 3 |
| Tablet | 4 |
| Jeans | 5 |
| Rice | 6 |
| TV | 7 |
| Oil | 8 |
| Jacket | 9 |
| Sugar | 10 |

## Explanation

The window grows by one row for every transaction.

Therefore:

```text
Row 1 → 1 row
Row 2 → 2 rows
Row 3 → 3 rows
...
Row 10 → 10 rows
```

---

# Scenario 5: Highest Sale So Far

## Business Requirement

Find the highest transaction amount encountered up to each transaction.

```sql
SELECT
    sale_id,
    product_name,
    sales_amount,
    MAX(sales_amount) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS highest_sale_so_far
FROM retail_sales
ORDER BY sale_date, sale_id;
```

## Expected Output

| Product | Sales | Highest So Far |
|---|---:|---:|
| Laptop | 50000 | 50000 |
| Mobile | 40000 | 50000 |
| Shirt | 5000 | 50000 |
| Tablet | 30000 | 50000 |
| Jeans | 8000 | 50000 |
| Rice | 5000 | 50000 |
| TV | 40000 | 50000 |

## Explanation

Laptop created the initial maximum:

```text
MAX(50000) = 50000
```

Mobile:

```text
MAX(50000,40000) = 50000
```

No later transaction exceeds 50000.

---

# Scenario 6: Lowest Sale So Far

## Business Requirement

Find the lowest transaction value encountered up to each row.

```sql
SELECT
    sale_id,
    product_name,
    sales_amount,
    MIN(sales_amount) OVER (
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS lowest_sale_so_far
FROM retail_sales
ORDER BY sale_date, sale_id;
```

## Expected Output

| Product | Sales | Minimum |
|---|---:|---:|
| Laptop | 50000 | 50000 |
| Mobile | 40000 | 40000 |
| Shirt | 5000 | 5000 |
| Tablet | 30000 | 5000 |
| Jeans | 8000 | 5000 |
| Rice | 5000 | 5000 |
| TV | 40000 | 5000 |
| Oil | 5000 | 5000 |
| Jacket | 10000 | 5000 |
| Sugar | 4000 | 4000 |

## Explanation

When Shirt appears:

```text
MIN(50000,40000,5000)
= 5000
```

At the final row Sugar has sales of 4000.

Therefore:

```text
MIN(...,5000,4000)
= 4000
```

---

# Scenario 7: Running Sales by Store

## Business Requirement

Calculate cumulative sales separately for every store.

```sql
SELECT
    store_name,
    sale_date,
    product_name,
    sales_amount,
    SUM(sales_amount) OVER (
        PARTITION BY store_name
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS store_running_sales
FROM retail_sales
ORDER BY store_name, sale_date, sale_id;
```

## Bangalore Output

| Product | Sales | Running Sales |
|---|---:|---:|
| Laptop | 50000 | 50000 |
| Mobile | 40000 | 90000 |
| Shirt | 5000 | 95000 |
| Sugar | 4000 | 99000 |

## Explanation

`PARTITION BY store_name` creates separate calculation windows.

Bangalore calculation:

```text
Laptop = 50000

Mobile =
50000 + 40000
= 90000

Shirt =
90000 + 5000
= 95000

Sugar =
95000 + 4000
= 99000
```

Hyderabad and Chennai start their own calculations from zero.

---

# Scenario 8: Running Quantity by Store

```sql
SELECT
    store_name,
    product_name,
    quantity,
    SUM(quantity) OVER (
        PARTITION BY store_name
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS store_running_quantity
FROM retail_sales
ORDER BY store_name, sale_date, sale_id;
```

## Bangalore Output

| Product | Qty | Running Qty |
|---|---:|---:|
| Laptop | 1 | 1 |
| Mobile | 2 | 3 |
| Shirt | 5 | 8 |
| Sugar | 8 | 16 |

## Explanation

Only Bangalore transactions participate in the Bangalore calculation.

```text
1
1 + 2 = 3
1 + 2 + 5 = 8
1 + 2 + 5 + 8 = 16
```

---

# Scenario 9: Running Sales by Category

```sql
SELECT
    category,
    product_name,
    sales_amount,
    SUM(sales_amount) OVER (
        PARTITION BY category
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS category_running_sales
FROM retail_sales
ORDER BY category, sale_date, sale_id;
```

## Electronics Output

| Product | Sales | Running |
|---|---:|---:|
| Laptop | 50000 | 50000 |
| Mobile | 40000 | 90000 |
| Tablet | 30000 | 120000 |
| TV | 40000 | 160000 |

## Explanation

Electronics is treated as its own partition.

```text
Laptop = 50000

Laptop + Mobile
= 90000

+ Tablet
= 120000

+ TV
= 160000
```

---

# Scenario 10: Running Quantity by Category

```sql
SELECT
    category,
    product_name,
    quantity,
    SUM(quantity) OVER (
        PARTITION BY category
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_quantity
FROM retail_sales
ORDER BY category, sale_date, sale_id;
```

## Electronics Output

| Product | Quantity | Running Quantity |
|---|---:|---:|
| Laptop | 1 | 1 |
| Mobile | 2 | 3 |
| Tablet | 2 | 5 |
| TV | 1 | 6 |

## Explanation

Each category gets its own cumulative quantity.

Electronics total:

```text
1 + 2 + 2 + 1
= 6
```

---

# Scenario 11: Running Average Sales by Store

```sql
SELECT
    store_name,
    product_name,
    sales_amount,
    ROUND(
        AVG(sales_amount) OVER (
            PARTITION BY store_name
            ORDER BY sale_date, sale_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_avg
FROM retail_sales
ORDER BY store_name, sale_date, sale_id;
```

## Bangalore Example

```text
Laptop:
50000 / 1
= 50000

Mobile:
(50000 + 40000) / 2
= 45000

Shirt:
(50000 + 40000 + 5000) / 3
= 31666.67

Sugar:
99000 / 4
= 24750
```

## Explanation

The average resets whenever the store changes because of:

```sql
PARTITION BY store_name
```

---

# Scenario 12: Running Maximum Sale by Store

```sql
SELECT
    store_name,
    product_name,
    sales_amount,
    MAX(sales_amount) OVER (
        PARTITION BY store_name
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS store_max_so_far
FROM retail_sales
ORDER BY store_name, sale_date, sale_id;
```

## Bangalore Output

| Product | Sales | Max |
|---|---:|---:|
| Laptop | 50000 | 50000 |
| Mobile | 40000 | 50000 |
| Shirt | 5000 | 50000 |
| Sugar | 4000 | 50000 |

## Explanation

Once Laptop establishes ₹50,000 as the maximum, none of the later Bangalore transactions exceed it.

---

# Scenario 13: Running Minimum Sales by Category

```sql
SELECT
    category,
    product_name,
    sales_amount,
    MIN(sales_amount) OVER (
        PARTITION BY category
        ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS category_min_so_far
FROM retail_sales
ORDER BY category, sale_date, sale_id;
```

## Electronics Example

```text
Laptop = 50000

# Oracle SQL Subqueries — Complete Notes with 40 Examples

## Topics Covered

1. Introduction to Subqueries
2. Single-Row Subqueries
3. Multiple-Row Subqueries
4. `IN` and `NOT IN`
5. `ANY` and `ALL`
6. Scalar Subqueries
7. Correlated Subqueries
8. `EXISTS` and `NOT EXISTS`
9. Inline Queries / Inline Views
10. Two-Level Nested Subqueries
11. Three-Level Nested Subqueries

---

# 1. What is a Subquery?

A **subquery** is a SQL query written inside another SQL query.

The inner query generates a result that is used by the outer query.

### General Syntax

```sql
SELECT column1,
       column2
FROM table_name
WHERE column1 >
(
    SELECT column1
    FROM table_name
);
```

### Execution Flow

```text
Inner Query
     ↓
Inner Query Result
     ↓
Outer Query
     ↓
Final Result
```

For example:

```sql
SELECT employee_id,
       first_name,
       salary
FROM hr.employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM hr.employees
);
```

The inner query:

```sql
SELECT AVG(salary)
FROM hr.employees;
```

might return:

```text
6500
```

The outer query then logically becomes:

```sql
SELECT employee_id,
       first_name,
       salary
FROM hr.employees
WHERE salary > 6500;
```

---

# 2. Main Types of Subqueries

| Type | Description |
|---|---|
| Single-Row | Returns one row |
| Multiple-Row | Returns multiple rows |
| Scalar | Returns one row and one column |
| Correlated | Inner query depends on outer query |
| Inline View | Subquery inside `FROM` |
| Nested | Subquery inside another subquery |
| Two-Level | Two nested inner queries |
| Three-Level | Three nested inner queries |

---

# PART 1 — SINGLE-ROW SUBQUERIES

A single-row subquery returns only one row.

Common operators:

```text
=
>
<
>=
<=
<>
```

---

## Query 1 — Employees Earning More Than Company Average

### Business Requirement

Find employees whose salary is greater than the overall company average.

```sql
SELECT
    employee_id,               -- Unique employee ID
    first_name,                -- Employee first name
    last_name,                 -- Employee last name
    salary                     -- Employee salary
FROM hr.employees
WHERE salary >
(
    -- Inner query calculates one average salary
    SELECT AVG(salary)
    FROM hr.employees
);
```

### How It Works

First Oracle executes:

```sql
SELECT AVG(salary)
FROM hr.employees;
```

Suppose the result is:

```text
6500
```

The outer query becomes logically:

```text
salary > 6500
```

Therefore, only employees earning more than ₹6,500 are returned.

---

## Query 2 — Employees Earning Below Company Average

```sql
SELECT
    employee_id,               -- Employee ID
    first_name,                -- Employee name
    salary                     -- Current salary
FROM hr.employees
WHERE salary <
(
    -- Calculate company-wide average salary
    SELECT AVG(salary)
    FROM hr.employees
);
```

### Explanation

If:

```text
AVG(salary) = 6500
```

Oracle checks:

```text
salary < 6500
```

This returns employees earning below the company average.

---

## Query 3 — Highest-Paid Employee

```sql
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM hr.employees
WHERE salary =
(
    -- Find the maximum salary in the company
    SELECT MAX(salary)
    FROM hr.employees
);
```

### Execution

Inner query:

```sql
SELECT MAX(salary)
FROM hr.employees;
```

Suppose:

```text
MAX = 24000
```

Oracle then checks:

```text
salary = 24000
```

If multiple employees earn ₹24,000, all of them are returned.

---

## Query 4 — Lowest-Paid Employee

```sql
SELECT
    employee_id,
    first_name,
    salary
FROM hr.employees
WHERE salary =
(
    -- Find minimum salary
    SELECT MIN(salary)
    FROM hr.employees
);
```

### Explanation

If:

```text
MIN(salary) = 2100
```

Oracle checks:

```text
salary = 2100
```

---

## Query 5 — Employees Earning More Than Employee 101

```sql
SELECT
    employee_id,
    first_name,
    salary
FROM hr.employees
WHERE salary >
(
    -- Find salary of employee 101
    SELECT salary
    FROM hr.employees
    WHERE employee_id = 101
);
```

### Execution

Suppose employee `101` earns:

```text
17000
```

Oracle then finds:

```text
salary > 17000
```

---

## Query 6 — Employees in the Same Department as Employee 103

```sql
SELECT
    employee_id,
    first_name,
    department_id
FROM hr.employees
WHERE department_id =
(
    -- Find employee 103's department
    SELECT department_id
    FROM hr.employees
    WHERE employee_id = 103
);
```

### Example

Suppose:

```text
Employee 103
Department = 60
```

Outer query condition becomes:

```text
department_id = 60
```

---

## Query 7 — Employees Hired After Employee 100

```sql
SELECT
    employee_id,
    first_name,
    hire_date
FROM hr.employees
WHERE hire_date >
(
    -- Find employee 100's joining date
    SELECT hire_date
    FROM hr.employees
    WHERE employee_id = 100
);
```

### Explanation

If employee 100 joined on:

```text
17-JUN-2003
```

Oracle finds employees where:

```text
hire_date > 17-JUN-2003
```

---

## Query 8 — Employees Working in Sales

```sql
SELECT
    employee_id,
    first_name,
    department_id
FROM hr.employees
WHERE department_id =
(
    -- Find department ID for Sales
    SELECT department_id
    FROM hr.departments
    WHERE department_name = 'Sales'
);
```

If:

```text
Sales = Department 80
```

then Oracle checks:

```text
department_id = 80
```

---

## Query 9 — Employees Not Working in Sales

```sql
SELECT
    employee_id,
    first_name,
    department_id
FROM hr.employees
WHERE department_id <>
(
    -- Find Sales department
    SELECT department_id
    FROM hr.departments
    WHERE department_name = 'Sales'
);
```

`<>` means:

```text
NOT EQUAL TO
```

---

## Query 10 — Employees Above Department 80 Average

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary
FROM hr.employees
WHERE salary >
(
    -- Calculate average salary specifically for department 80
    SELECT AVG(salary)
    FROM hr.employees
    WHERE department_id = 80
);
```

If department 80 average is:

```text
9000
```

Oracle checks:

```text
salary > 9000
```

Note that this outer query checks employees from **all departments** against department 80's average.

---

# PART 2 — MULTIPLE-ROW SUBQUERIES

A multiple-row subquery returns more than one row.

Common operators:

```text
IN
NOT IN
ANY
ALL
```

---

## Query 11 — Employees Working in Sales or IT

```sql
SELECT
    employee_id,
    first_name,
    department_id
FROM hr.employees
WHERE department_id IN
(
    -- This can return multiple department IDs
    SELECT department_id
    FROM hr.departments
    WHERE department_name IN ('Sales', 'IT')
);
```

Suppose the inner query returns:

```text
60
80
```

Oracle checks:

```text
department_id IN (60,80)
```

---

## Query 12 — Employees Not Working in Sales or IT

```sql
SELECT
    employee_id,
    first_name,
    department_id
FROM hr.employees
WHERE department_id NOT IN
(
    SELECT department_id
    FROM hr.departments
    WHERE department_name IN ('Sales', 'IT')
);
```

### Important

Be careful with `NOT IN` if the subquery can return `NULL`.

---

## Query 13 — Employees Who Are Managers

```sql
SELECT
    employee_id,
    first_name,
    last_name
FROM hr.employees
WHERE employee_id IN
(
    -- Get all employee IDs appearing as manager IDs
    SELECT manager_id
    FROM hr.employees

    -- Remove NULL because the top-level manager may have no manager
    WHERE manager_id IS NOT NULL
);
```

The inner query creates a list of manager IDs.

The outer query retrieves their employee details.

---

## Query 14 — Employees Who Are Not Managers

```sql
SELECT
    employee_id,
    first_name,
    last_name
FROM hr.employees
WHERE employee_id NOT IN
(
    SELECT manager_id
    FROM hr.employees

    -- Very important when using NOT IN
    WHERE manager_id IS NOT NULL
);
```

---

# PART 3 — ANY AND ALL

---

## Query 15 — Salary Greater Than ANY Salary in Department 50

```sql
SELECT
    employee_id,
    first_name,
    salary
FROM hr.employees
WHERE salary > ANY
(
    SELECT salary
    FROM hr.employees
    WHERE department_id = 50
);
```

Suppose department 50 salaries are:

```text
2500
3000
4000
5000
```

`> ANY` means greater than **at least one** value.

For example:

```text
3500 > 2500 = TRUE
```

So ₹3,500 satisfies the condition.

A useful memory rule for a non-empty set without NULL complications:

```text
> ANY ≈ > MIN
```

---

## Query 16 — Salary Greater Than ALL Salaries in Department 50

```sql
SELECT
    employee_id,
    first_name,
    salary
FROM hr.employees
WHERE salary > ALL
(
    SELECT salary
    FROM hr.employees
    WHERE department_id = 50
);
```

If salaries are:

```text
2500
3000
4000
5000
```

the employee must satisfy:

```text
salary > 5000
```

Memory:

```text
> ALL ≈ > MAX
```

---

## Query 17 — Salary Less Than ANY Salary in Department 80

```sql
SELECT
    employee_id,
    first_name,
    salary
FROM hr.employees
WHERE salary < ANY
(
    SELECT salary
    FROM hr.employees
    WHERE department_id = 80
);
```

Memory:

```text
< ANY ≈ < MAX
```

for a non-empty set without NULL complications.

---

## Query 18 — Salary Less Than ALL Salaries in Department 80

```sql
SELECT
    employee_id,
    first_name,
    salary
FROM hr.employees
WHERE salary < ALL
(
    SELECT salary
    FROM hr.employees
    WHERE department_id = 80
);
```

Memory:

```text
< ALL ≈ < MIN
```

---

# PART 4 — SCALAR SUBQUERIES

A scalar subquery returns:

```text
ONE ROW
+
ONE COLUMN
```

---

## Query 19 — Show Company Average Beside Every Employee

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Scalar subquery returns one average value
    (
        SELECT ROUND(AVG(salary), 2)
        FROM hr.employees
    ) AS company_avg_salary

FROM hr.employees;
```

Example:

```text
Steven      24000      6461.68
Neena       17000      6461.68
Lex         17000      6461.68
```

The same company average appears beside every employee.

---

## Query 20 — Show Maximum Salary Beside Every Employee

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- One maximum salary value
    (
        SELECT MAX(salary)
        FROM hr.employees
    ) AS company_max_salary

FROM hr.employees;
```

---

## Query 21 — Difference Between Salary and Company Average

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Employee salary minus overall company average
    ROUND(
        salary -
        (
            SELECT AVG(salary)
            FROM hr.employees
        ),
        2
    ) AS difference_from_average

FROM hr.employees;
```

Suppose:

```text
Salary  = 10000
Average = 6500
```

Then:

```text
10000 - 6500 = 3500
```

Positive result = above average.

Negative result = below average.

---

# PART 5 — CORRELATED SUBQUERIES

A correlated subquery depends on the current row from the outer query.

---

## Query 22 — Employees Above Their Own Department Average

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary
FROM hr.employees e
WHERE salary >
(
    -- Calculate average salary for the CURRENT employee's department
    SELECT AVG(e2.salary)
    FROM hr.employees e2

    -- Correlation between inner and outer queries
    WHERE e2.department_id = e.department_id
);
```

### How It Works

Suppose current employee is:

```text
John
Department = 80
Salary = 14000
```

The inner query becomes logically:

```sql
SELECT AVG(salary)
FROM hr.employees
WHERE department_id = 80;
```

Suppose:

```text
Average = 9000
```

Oracle checks:

```text
14000 > 9000
```

Therefore John is returned.

---

## Query 23 — Employees Below Their Department Average

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary
FROM hr.employees e
WHERE salary <
(
    -- Department average for current employee
    SELECT AVG(e2.salary)
    FROM hr.employees e2
    WHERE e2.department_id = e.department_id
);
```

---

## Query 24 — Highest-Paid Employee in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary
FROM hr.employees e
WHERE salary =
(
    -- Maximum salary for current employee's department
    SELECT MAX(e2.salary)
    FROM hr.employees e2
    WHERE e2.department_id = e.department_id
);
```

Suppose department 60 has:

```text
9000
6000
4800
4200
```

The subquery returns:

```text
9000
```

Only employee(s) earning ₹9,000 in that department are returned.

---

## Query 25 — Lowest-Paid Employee in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary
FROM hr.employees e
WHERE salary =
(
    -- Minimum salary within current employee's department
    SELECT MIN(e2.salary)
    FROM hr.employees e2
    WHERE e2.department_id = e.department_id
);
```

---

# PART 6 — EXISTS AND NOT EXISTS

`EXISTS` checks whether at least one matching row exists.

---

## Query 26 — Departments That Have Employees

```sql
SELECT
    department_id,
    department_name
FROM hr.departments d
WHERE EXISTS
(
    -- We only care whether a matching employee exists
    SELECT 1
    FROM hr.employees e

    -- Connect employee to current department
    WHERE e.department_id = d.department_id
);
```

### Why `SELECT 1`?

`EXISTS` does not care about the selected value.

It only asks:

```text
Does a matching row exist?
```

---

## Query 27 — Departments With No Employees

```sql
SELECT
    department_id,
    department_name
FROM hr.departments d
WHERE NOT EXISTS
(
    SELECT 1
    FROM hr.employees e
    WHERE e.department_id = d.department_id
);
```

Useful for:

```text
Departments without employees
Customers without orders
Products without sales
Students without attendance
```

---

## Query 28 — Employees Who Manage Someone

```sql
SELECT
    employee_id,
    first_name,
    last_name
FROM hr.employees e
WHERE EXISTS
(
    -- Search for an employee reporting to current employee
    SELECT 1
    FROM hr.employees subordinate

    WHERE subordinate.manager_id = e.employee_id
);
```

If another employee has:

```text
manager_id = current employee_id
```

the current employee is a manager.

---

## Query 29 — Employees Who Manage Nobody

```sql
SELECT
    employee_id,
    first_name,
    last_name
FROM hr.employees e
WHERE NOT EXISTS
(
    -- Search for subordinates
    SELECT 1
    FROM hr.employees subordinate

    WHERE subordinate.manager_id = e.employee_id
);
```

---

# PART 7 — INLINE QUERIES / INLINE VIEWS

An **inline view** is a subquery written inside the `FROM` clause.

General structure:

```sql
SELECT *
FROM
(
    SELECT ...
    FROM ...
) x;
```

The inner query behaves like a temporary result table.

---

## Query 30 — Departments With Average Salary Above 8000

```sql
SELECT
    department_id,
    avg_salary
FROM
(
    -- INNER QUERY creates department summary
    SELECT
        department_id,
        ROUND(AVG(salary), 2) AS avg_salary

    FROM hr.employees

    GROUP BY department_id
) dept_summary

-- OUTER QUERY filters the calculated result
WHERE avg_salary > 8000;
```

### Inner Query Result Might Look Like

```text
DEPARTMENT     AVG_SALARY
----------     ----------
20                 9500
30                 4150
50                 3475
60                 5760
80                 8955
```

Outer query keeps:

```text
avg_salary > 8000
```

---
