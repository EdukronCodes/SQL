DECLARE
  -- Declaring a numeric variable with value 10
  num NUMBER := 10;

  -- Declaring a string variable with value 'Alice'
  name VARCHAR2(50) := 'Alice';

  -- Declaring a numeric variable representing age
  age NUMBER := 25;

  -- Declaring a character variable representing grade
  grade CHAR := 'B';

  -- Declaring salary and bonus variables
  salary NUMBER := 50000;
  bonus NUMBER := 0;

  -- Declaring gender as a character
  gender CHAR := 'M';

  -- Declaring day of the week as a string
  day VARCHAR2(10) := 'Monday';

  -- Declaring marks scored
  marks NUMBER := 85;

  -- Declaring status of the user
  status VARCHAR2(10) := 'Active';

  -- Declaring score for pass/fail
  score NUMBER := 72;

  -- Declaring user level
  level NUMBER := 3;

  -- Declaring temperature value
  temperature NUMBER := 37.5;

  -- Declaring a year to check for leap year
  year NUMBER := 2024;

  -- Declaring a flag-like character
  char_value CHAR := 'Y';

  -- Declaring a boolean value
  bool_value BOOLEAN := TRUE;

  -- Declaring login attempts count
  login_attempts NUMBER := 2;

  -- Declaring product availability flag
  product_in_stock BOOLEAN := FALSE;

  -- Declaring city name
  city VARCHAR2(20) := 'Bangalore';

  -- Declaring age group as a string
  age_group VARCHAR2(20);
BEGIN
  -- 1. Check if number is positive
  IF num > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Positive number');  -- Print if number is greater than 0
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not a positive number');  -- Otherwise print this
  END IF;

  -- 2. Check if age is above 18
  IF age > 18 THEN
    DBMS_OUTPUT.PUT_LINE('Adult');  -- Print if age is greater than 18
  ELSE
    DBMS_OUTPUT.PUT_LINE('Minor');  -- Otherwise, print Minor
  END IF;

  -- 3. Check if name is Alice
  IF name = 'Alice' THEN
    DBMS_OUTPUT.PUT_LINE('Hello, Alice');  -- Greeting if name matches
  ELSE
    DBMS_OUTPUT.PUT_LINE('You are not Alice');  -- Message if name does not match
  END IF;

  -- 4. Check if grade is A
  IF grade = 'A' THEN
    DBMS_OUTPUT.PUT_LINE('Excellent');  -- Grade A is excellent
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not Excellent');  -- Otherwise, not excellent
  END IF;

  -- 5. Check if salary is greater than 40,000
  IF salary > 40000 THEN
    bonus := 5000;  -- Set higher bonus
  ELSE
    bonus := 2000;  -- Set lower bonus
  END IF;
  DBMS_OUTPUT.PUT_LINE('Bonus: ' || bonus);  -- Display assigned bonus

  -- 6. Gender-based message
  IF gender = 'M' THEN
    DBMS_OUTPUT.PUT_LINE('Male');  -- Print Male
  ELSE
    DBMS_OUTPUT.PUT_LINE('Female or Other');  -- Otherwise print this
  END IF;

  -- 7. Day check
  IF day = 'Sunday' THEN
    DBMS_OUTPUT.PUT_LINE('Weekend');  -- If it's Sunday, it's weekend
  ELSE
    DBMS_OUTPUT.PUT_LINE('Weekday');  -- Otherwise it's a weekday
  END IF;

  -- 8. Marks classification
  IF marks >= 90 THEN
    DBMS_OUTPUT.PUT_LINE('Grade A');  -- High marks receive Grade A
  ELSE
    DBMS_OUTPUT.PUT_LINE('Below Grade A');  -- Otherwise not Grade A
  END IF;

  -- 9. Status check
  IF status = 'Active' THEN
    DBMS_OUTPUT.PUT_LINE('User is Active');  -- If status is active
  ELSE
    DBMS_OUTPUT.PUT_LINE('User is Inactive');  -- Otherwise inactive
  END IF;

  -- 10. Pass or Fail
  IF score >= 50 THEN
    DBMS_OUTPUT.PUT_LINE('Pass');  -- Score 50 or more is Pass
  ELSE
    DBMS_OUTPUT.PUT_LINE('Fail');  -- Otherwise fail
  END IF;

  -- 11. Level comparison
  IF level = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Beginner');  -- Level 1 is beginner
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not Beginner');  -- Otherwise not beginner
  END IF;

  -- 12. Temperature check
  IF temperature > 37.0 THEN
    DBMS_OUTPUT.PUT_LINE('Fever');  -- Temperature over 37 is fever
  ELSE
    DBMS_OUTPUT.PUT_LINE('Normal');  -- Otherwise normal
  END IF;

  -- 13. Leap year check
  IF MOD(year, 4) = 0 AND (MOD(year, 100) != 0 OR MOD(year, 400) = 0) THEN
    DBMS_OUTPUT.PUT_LINE('Leap Year');  -- Apply leap year logic
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not a Leap Year');  -- Otherwise not a leap year
  END IF;

  -- 14. Yes or No flag
  IF char_value = 'Y' THEN
    DBMS_OUTPUT.PUT_LINE('Confirmed');  -- 'Y' means confirmed
  ELSE
    DBMS_OUTPUT.PUT_LINE('Not Confirmed');  -- Otherwise not confirmed
  END IF;

  -- 15. Boolean check
  IF bool_value THEN
    DBMS_OUTPUT.PUT_LINE('Boolean is TRUE');  -- If boolean is true
  ELSE
    DBMS_OUTPUT.PUT_LINE('Boolean is FALSE');  -- Otherwise false
  END IF;

  -- 16. Login attempts check
  IF login_attempts > 3 THEN
    DBMS_OUTPUT.PUT_LINE('Account Locked');  -- Too many login attempts
  ELSE
    DBMS_OUTPUT.PUT_LINE('Login Allowed');  -- Otherwise, still allowed
  END IF;

  -- 17. Product availability
  IF product_in_stock THEN
    DBMS_OUTPUT.PUT_LINE('Product Available');  -- If stock available
  ELSE
    DBMS_OUTPUT.PUT_LINE('Out of Stock');  -- Otherwise, out of stock
  END IF;

  -- 18. City check
  IF city = 'Bangalore' THEN
    DBMS_OUTPUT.PUT_LINE('Welcome to Bangalore');  -- City match
  ELSE
    DBMS_OUTPUT.PUT_LINE('You are not in Bangalore');  -- City mismatch
  END IF;

  -- 19. Age group classification
  IF age < 13 THEN
    age_group := 'Child';  -- Assign child group
  ELSE
    age_group := 'Teen/Adult';  -- Assign teen/adult group
  END IF;
  DBMS_OUTPUT.PUT_LINE('Age Group: ' || age_group);  -- Display age group

  -- 20. Number range
  IF num BETWEEN 1 AND 100 THEN
    DBMS_OUTPUT.PUT_LINE('Number is in range');  -- Number between 1 and 100
  ELSE
    DBMS_OUTPUT.PUT_LINE('Number out of range');  -- Otherwise out of range
  END IF;
END;


DECLARE
  i NUMBER;
BEGIN
  -- Example 1: Exit after first iteration
  FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
    EXIT;  -- Exit after first loop
  END LOOP;

  -- Example 2: Exit when i = 5
  FOR i IN 1..10 LOOP
    IF i = 5 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

  -- Example 3: Continue if i is even
  FOR i IN 1..5 LOOP
    IF MOD(i, 2) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Odd: ' || i);
  END LOOP;

  -- Example 4: Print until i = 4
  FOR i IN 1..10 LOOP
    IF i = 4 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Counting: ' || i);
  END LOOP;

  -- Example 5: Skip number 3
  FOR i IN 1..5 LOOP
    IF i = 3 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

  -- Example 6: Exit when multiple of 7 found
  FOR i IN 1..20 LOOP
    IF MOD(i, 7) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Found multiple of 7: ' || i);
      EXIT;
    END IF;
  END LOOP;

  -- Example 7: Continue when divisible by 3
  FOR i IN 1..10 LOOP
    IF MOD(i, 3) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Not divisible by 3: ' || i);
  END LOOP;

  -- Example 8: Exit from WHILE loop
  i := 1;
  WHILE i <= 10 LOOP
    IF i = 4 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
    i := i + 1;
  END LOOP;

  -- Example 9: Continue in WHILE loop
  i := 0;
  WHILE i < 5 LOOP
    i := i + 1;
    IF i = 2 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Value: ' || i);
  END LOOP;

  -- Example 10: Skip printing multiples of 4
  FOR i IN 1..10 LOOP
    IF MOD(i, 4) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

  -- Example 11: Exit if i > 3 in WHILE loop
  i := 0;
  WHILE TRUE LOOP
    i := i + 1;
    IF i > 3 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

  -- Example 12: Continue on even numbers in WHILE
  i := 0;
  WHILE i < 5 LOOP
    i := i + 1;
    IF MOD(i, 2) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Odd WHILE: ' || i);
  END LOOP;

  -- Example 13: Nested loop exit
  FOR i IN 1..3 LOOP
    FOR j IN 1..3 LOOP
      IF j = 2 THEN
        EXIT;
      END IF;
      DBMS_OUTPUT.PUT_LINE('i=' || i || ', j=' || j);
    END LOOP;
  END LOOP;

  -- Example 14: Nested loop continue
  FOR i IN 1..2 LOOP
    FOR j IN 1..3 LOOP
      IF j = 2 THEN
        CONTINUE;
      END IF;
      DBMS_OUTPUT.PUT_LINE('Pair: ' || i || ',' || j);
    END LOOP;
  END LOOP;

  -- Example 15: Exit on first multiple of 6
  FOR i IN 1..20 LOOP
    IF MOD(i, 6) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Exit on: ' || i);
      EXIT;
    END IF;
  END LOOP;

  -- Example 16: Continue on 5
  FOR i IN 1..7 LOOP
    IF i = 5 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Number: ' || i);
  END LOOP;

  -- Example 17: Exit when i = 10 in REVERSE loop
  FOR i IN REVERSE 1..15 LOOP
    IF i = 10 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Reverse: ' || i);
  END LOOP;

  -- Example 18: Continue if i is divisible by 2 or 3
  FOR i IN 1..10 LOOP
    IF MOD(i, 2) = 0 OR MOD(i, 3) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Special: ' || i);
  END LOOP;

  -- Example 19: Exit when square of i > 50
  FOR i IN 1..10 LOOP
    IF i * i > 50 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i squared = ' || i*i);
  END LOOP;

  -- Example 20: Continue on single digit numbers
  FOR i IN 1..15 LOOP
    IF i < 10 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Double-digit: ' || i);
  END LOOP;

  -- Example 21: Loop from 20 to 25 and exit at 23
  FOR i IN 20..25 LOOP
    IF i = 23 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

  -- Example 22: Loop from 1 to 6 and skip 4
  FOR i IN 1..6 LOOP
    IF i = 4 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

  -- Example 23: Print only prime numbers (1 to 10)
  FOR i IN 2..10 LOOP
    DECLARE
      is_prime BOOLEAN := TRUE;
      j NUMBER;
    BEGIN
      FOR j IN 2..i-1 LOOP
        IF MOD(i, j) = 0 THEN
          is_prime := FALSE;
          EXIT;
        END IF;
      END LOOP;
      IF is_prime THEN
        DBMS_OUTPUT.PUT_LINE('Prime: ' || i);
      END IF;
    END;
  END LOOP;

  -- Example 24: Exit after printing first 3 odd numbers
  i := 0;
  DECLARE
    odd_count NUMBER := 0;
  BEGIN
    WHILE i < 20 LOOP
      i := i + 1;
      IF MOD(i, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Odd: ' || i);
        odd_count := odd_count + 1;
      END IF;
      IF odd_count = 3 THEN
        EXIT;
      END IF;
    END LOOP;
  END;

  -- Example 25: Continue when i mod 5 = 0
  FOR i IN 1..15 LOOP
    IF MOD(i, 5) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Not multiple of 5: ' || i);
  END LOOP;

  -- Example 26: Exit on first multiple of both 3 and 4
  FOR i IN 1..20 LOOP
    IF MOD(i, 3) = 0 AND MOD(i, 4) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Multiple of 3 and 4: ' || i);
      EXIT;
    END IF;
  END LOOP;

  -- Example 27: Continue on vowels (simulate ASCII values)
  FOR i IN 65..70 LOOP  -- A to F
    IF CHR(i) IN ('A', 'E') THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Letter: ' || CHR(i));
  END LOOP;

  -- Example 28: Exit when sum exceeds 20
  DECLARE
    total NUMBER := 0;
  BEGIN
    FOR i IN 1..10 LOOP
      total := total + i;
      IF total > 20 THEN
        DBMS_OUTPUT.PUT_LINE('Total exceeded at i=' || i);
        EXIT;
      END IF;
    END LOOP;
  END;

  -- Example 29: Continue when i squared is even
  FOR i IN 1..8 LOOP
    IF MOD(i*i, 2) = 0 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Square is odd: ' || i*i);
  END LOOP;

  -- Example 30: Exit after 5 iterations using simple LOOP
  i := 0;
  LOOP
    i := i + 1;
    IF i > 5 THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  END LOOP;

END;







