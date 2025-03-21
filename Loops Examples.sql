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









