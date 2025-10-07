# 🧮 SQL Scenario-Based Questions on `SH.CUSTOMERS`

---

## 🧱 A. Aggregation & Grouping (20 Questions)

1. Find the total, average, minimum, and maximum credit limit of all customers.  
2. Count the number of customers in each income level.  
3. Show total credit limit by state and country.  
4. Display average credit limit for each marital status and gender combination.  
5. Find the top 3 states with the highest average credit limit.  
6. Find the country with the maximum total customer credit limit.  
7. Show the number of customers whose credit limit exceeds their state average.  
8. Calculate total and average credit limit for customers born after 1980.  
9. Find states having more than 50 customers.  
10. List countries where the average credit limit is higher than the global average.  
11. Calculate the variance and standard deviation of customer credit limits by country.  
12. Find the state with the smallest range (max–min) in credit limits.  
13. Show the total number of customers per income level and the percentage contribution of each.  
14. For each income level, find how many customers have NULL credit limits.  
15. Display countries where the sum of credit limits exceeds 10 million.  
16. Find the state that contributes the highest total credit limit to its country.  
17. Show total credit limit per year of birth, sorted by total descending.  
18. Identify customers who hold the maximum credit limit in their respective country.  
19. Show the difference between maximum and average credit limit per country.  
20. Display the overall rank of each state based on its total credit limit (using GROUP BY + analytic rank).  

---

## 📊 B. Analytical / Window Functions (30 Questions)

1. Assign row numbers to customers ordered by credit limit descending.  
2. Rank customers within each state by credit limit.  
3. Use DENSE_RANK() to find the top 5 credit holders per country.  
4. Divide customers into 4 quartiles based on their credit limit using NTILE(4).  
5. Calculate a running total of credit limits ordered by customer_id.  
6. Show cumulative average credit limit by country.  
7. Compare each customer’s credit limit to the previous one using LAG().  
8. Show next customer’s credit limit using LEAD().  
9. Display the difference between each customer’s credit limit and the previous one.  
10. For each country, display the first and last credit limit using FIRST_VALUE() and LAST_VALUE().  
11. Compute percentage rank (PERCENT_RANK()) of customers based on credit limit.  
12. Show each customer’s position in percentile (CUME_DIST() function).  
13. Display the difference between the maximum and current credit limit for each customer.  
14. Rank income levels by their average credit limit.  
15. Calculate the average credit limit over the last 10 customers (sliding window).  
16. For each state, calculate the cumulative total of credit limits ordered by city.  
17. Find customers whose credit limit equals the median credit limit (use PERCENTILE_CONT(0.5)).  
18. Display the highest 3 credit holders per state using ROW_NUMBER() and PARTITION BY.  
19. Identify customers whose credit limit increased compared to previous row (using LAG).  
20. Calculate moving average of credit limits with a window of 3.  
21. Show cumulative percentage of total credit limit per country.  
22. Rank customers by age (derived from CUST_YEAR_OF_BIRTH).  
23. Calculate difference in age between current and previous customer in the same state.  
24. Use RANK() and DENSE_RANK() to show how ties are treated differently.  
25. Compare each state’s average credit limit with country average using window partition.  
26. Show total credit per state and also its rank within each country.  
27. Find customers whose credit limit is above the 90th percentile of their income level.  
28. Display top 3 and bottom 3 customers per country by credit limit.  
29. Calculate rolling sum of 5 customers’ credit limit within each country.  
30. For each marital status, display the most and least wealthy customers using analytical functions.  

---

## 🧠 C. Conditional, CASE, and DECODE (10 Questions)

1. Categorize customers into income tiers: Platinum, Gold, Silver, Bronze.  
2. Display “High”, “Medium”, or “Low” income categories based on credit limit.  
3. Replace NULL income levels with “Unknown” using NVL.  
4. Show customer details and mark whether they have above-average credit limit or not.  
5. Use DECODE to convert marital status codes (S/M/D) into full text.  
6. Use CASE to show age group (≤30, 31–50, >50) from CUST_YEAR_OF_BIRTH.  
7. Label customers as “Old Credit Holder” or “New Credit Holder” based on year of birth < 1980.  
8. Create a loyalty tag — “Premium” if credit limit > 50,000 and income_level = ‘E’.  
9. Assign grades (A–F) based on credit limit range using CASE.  
10. Show country, state, and number of premium customers using conditional aggregation.  

---

## 📅 D. Date & Conversion Functions (10 Questions)

1. Convert CUST_YEAR_OF_BIRTH to age as of today.  
2. Display all customers born between 1980 and 1990.  
3. Format date of birth into “Month YYYY” using TO_CHAR.  
4. Convert income level text (like 'A: Below 30,000') to numeric lower limit.  
5. Display customer birth decades (e.g., 1960s, 1970s).  
6. Show customers grouped by age bracket (10-year intervals).  
7. Convert country_id to uppercase and state name to lowercase.  
8. Show customers where credit limit > average of their birth decade.  
9. Convert all numeric credit limits to currency format `$999,999.00`.  
10. Find customers whose credit limit was NULL and replace with average (using NVL).  

---

## 🔢 E. String Functions (10 Questions)

1. Show customers whose first and last name start with the same letter.  
2. Display full names in “Last, First” format.  
3. Find customers whose last name ends with 'SON'.  
4. Display length of each customer’s full name.  
5. Replace vowels in customer names with '*'.  
6. Show customers whose income level description contains ‘90’.  
7. Display initials of each customer (first letters of first and last name).  
8. Concatenate city and state to create full address.  
9. Extract numeric value from income level using REGEXP_SUBSTR.  
10. Count how many customers have a 3-letter first name.  

---

## 🧩 F. Joins with Analytical Logic (10 Questions)

1. Join `SH.CUSTOMERS` and `SH.SALES` to find customers with the highest sales totals.  
2. For each customer, show their total sales amount and their rank within country.  
3. Find customers who purchased more than average sales amount of their country.  
4. Display top 3 spenders per state.  
5. Rank customers within each country by total sales quantity.  
6. Calculate each customer’s contribution percentage to country-level sales.  
7. Identify customers whose sales have decreased compared to previous month.  
8. Show customers who have never made a sale.  
9. Find correlation between credit limit and total sales (using GROUP BY + analytics).  
10. Show moving average of monthly sales per customer.  

---

## 📈 G. Advanced Analytical Patterns (10 Questions)

1. Compute z-score normalization of customer credit limits.  
2. Calculate the Gini coefficient of credit limit inequality per country.  
3. Find customers whose credit limit is above the 75th percentile and below the 90th percentile.  
4. Use analytical functions to compute the rank difference between two states.  
5. Find the median and interquartile range of credit limit per state.  
6. Identify outliers in credit limit using IQR method.  
7. Calculate credit limit growth per customer over years (if historical data exists).  
8. Create a running average of credit limit by customer ID.  
9. Compute total cumulative credit per income group sorted by rank.  
10. Generate a leaderboard view showing top N customers dynamically using analytic functions.  

---

## 💼 Bonus: Scenario-Based SQL on `SH.CUSTOMERS`

1. Display the top 5 customers with the highest credit limit.  
2. Find customers having the same income level as the customer with the maximum credit limit.  
3. Display customers who have a credit limit higher than the average credit limit of all customers.  
4. Rank all customers based on their credit limit in descending order and display rank along with name.  
5. Find customers who belong to the top 3 credit limit ranks in each income level.  
6. Categorize customers into “Platinum”, “Gold”, and “Standard” tiers based on their credit limit ranges.  
7. Display each customer’s credit limit along with the previous and next customer’s limit (using LAG and LEAD).  
8. Find customers whose credit limit difference from the previous customer is more than 10,000.  
9. Display the highest, lowest, and average credit limit per income level.  
10. Find the youngest and oldest customers (based on CUST_YEAR_OF_BIRTH).  
11. Display customers who belong to the same city as the customer “David Lee”.  
12. For each state, display the top 2 customers by credit limit.  
13. Show customers whose names start and end with the same letter.  
14. Create a ranking of customers within each country by credit limit.  
15. Find customers whose credit limit is below the minimum of their income category.  
16. Display the percentage contribution of each customer’s credit limit compared to total credit limit of their country.  
17. Split customers into 4 quartiles (Q1–Q4) based on their credit limit using NTILE(4).  
18. Display customers whose last name has more than 7 characters and income level is “E: 90,000–109,999”.  
19. For each marital status, find the customer with the maximum credit limit.  
20. Identify customers whose credit limit equals the department average of their state (using analytical average).  
