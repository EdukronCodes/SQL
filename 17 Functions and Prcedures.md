-- Create 20 Functions
CREATE OR REPLACE FUNCTION add_numbers(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER IS
BEGIN
  RETURN p_num1 + p_num2;
END;
/

CREATE OR REPLACE FUNCTION subtract_numbers(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER IS
BEGIN
  RETURN p_num1 - p_num2;
END;
/

CREATE OR REPLACE FUNCTION multiply_numbers(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER IS
BEGIN
  RETURN p_num1 * p_num2;
END;
/

CREATE OR REPLACE FUNCTION divide_numbers(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER IS
BEGIN
  IF p_num2 = 0 THEN
    RETURN NULL;
  ELSE
    RETURN p_num1 / p_num2;
  END IF;
END;
/

CREATE OR REPLACE FUNCTION power_numbers(p_base NUMBER, p_exponent NUMBER) RETURN NUMBER IS
BEGIN
  RETURN POWER(p_base, p_exponent);
END;
/

CREATE OR REPLACE FUNCTION max_of_two(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER IS
BEGIN
  RETURN GREATEST(p_num1, p_num2);
END;
/

CREATE OR REPLACE FUNCTION min_of_two(p_num1 NUMBER, p_num2 NUMBER) RETURN NUMBER IS
BEGIN
  RETURN LEAST(p_num1, p_num2);
END;
/

CREATE OR REPLACE FUNCTION square_number(p_num NUMBER) RETURN NUMBER IS
BEGIN
  RETURN p_num * p_num;
END;
/

CREATE OR REPLACE FUNCTION factorial(p_num NUMBER) RETURN NUMBER IS
BEGIN
  IF p_num = 0 OR p_num = 1 THEN
    RETURN 1;
  ELSE
    RETURN p_num * factorial(p_num - 1);
  END IF;
END;
/

CREATE OR REPLACE FUNCTION is_even(p_num NUMBER) RETURN VARCHAR2 IS
BEGIN
  IF MOD(p_num, 2) = 0 THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END;
/

CREATE OR REPLACE FUNCTION is_odd(p_num NUMBER) RETURN VARCHAR2 IS
BEGIN
  IF MOD(p_num, 2) <> 0 THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END;
/

CREATE OR REPLACE FUNCTION reverse_string(p_str VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  RETURN REVERSE(p_str);
END;
/

CREATE OR REPLACE FUNCTION string_length(p_str VARCHAR2) RETURN NUMBER IS
BEGIN
  RETURN LENGTH(p_str);
END;
/

CREATE OR REPLACE FUNCTION concat_strings(p_str1 VARCHAR2, p_str2 VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  RETURN p_str1 || p_str2;
END;
/

CREATE OR REPLACE FUNCTION upper_string(p_str VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  RETURN UPPER(p_str);
END;
/

CREATE OR REPLACE FUNCTION lower_string(p_str VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  RETURN LOWER(p_str);
END;
/

CREATE OR REPLACE FUNCTION count_vowels(p_str VARCHAR2) RETURN NUMBER IS
  l_count NUMBER := 0;
BEGIN
  FOR i IN 1..LENGTH(p_str) LOOP
    IF SUBSTR(UPPER(p_str), i, 1) IN ('A', 'E', 'I', 'O', 'U') THEN
      l_count := l_count + 1;
    END IF;
  END LOOP;
  RETURN l_count;
END;
/

CREATE OR REPLACE FUNCTION trim_string(p_str VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  RETURN TRIM(p_str);
END;
/

CREATE OR REPLACE FUNCTION is_palindrome(p_str VARCHAR2) RETURN VARCHAR2 IS
BEGIN
  IF p_str = REVERSE(p_str) THEN
    RETURN 'Yes';
  ELSE
    RETURN 'No';
  END IF;
END;
/

CREATE OR REPLACE FUNCTION generate_random(p_lower_bound NUMBER, p_upper_bound NUMBER) RETURN NUMBER IS
BEGIN
  RETURN DBMS_RANDOM.VALUE(p_lower_bound, p_upper_bound);
END;
/

-- Call all functions in a single block
DECLARE
  v_result NUMBER;
  v_str VARCHAR2(100);
BEGIN
  -- Call mathematical functions
  DBMS_OUTPUT.PUT_LINE('Addition: ' || add_numbers(10, 5));
  DBMS_OUTPUT.PUT_LINE('Subtraction: ' || subtract_numbers(10, 5));
  DBMS_OUTPUT.PUT_LINE('Multiplication: ' || multiply_numbers(10, 5));
  DBMS_OUTPUT.PUT_LINE('Division: ' || divide_numbers(10, 5));
  DBMS_OUTPUT.PUT_LINE('Power: ' || power_numbers(2, 3));
  DBMS_OUTPUT.PUT_LINE('Max: ' || max_of_two(10, 20));
  DBMS_OUTPUT.PUT_LINE('Min: ' || min_of_two(10, 20));
  DBMS_OUTPUT.PUT_LINE('Square: ' || square_number(5));
  DBMS_OUTPUT.PUT_LINE('Factorial of 5: ' || factorial(5));
  DBMS_OUTPUT.PUT_LINE('Is 10 Even?: ' || is_even(10));
  DBMS_OUTPUT.PUT_LINE('Is 11 Odd?: ' || is_odd(11));
  
  -- Call string manipulation functions
  DBMS_OUTPUT.PUT_LINE('Reverse String: ' || reverse_string('Oracle'));
  DBMS_OUTPUT.PUT_LINE('String Length: ' || string_length('Oracle'));
  DBMS_OUTPUT.PUT_LINE('Concatenated String: ' || concat_strings('Hello ', 'World'));
  DBMS_OUTPUT.PUT_LINE('Uppercase String: ' || upper_string('oracle'));
  DBMS_OUTPUT.PUT_LINE('Lowercase String: ' || lower_string('ORACLE'));
  DBMS_OUTPUT.PUT_LINE('Count of Vowels in Oracle: ' || count_vowels('Oracle'));
  DBMS_OUTPUT.PUT_LINE('Trimmed String: ' || trim_string('   Oracle   '));
  DBMS_OUTPUT.PUT_LINE('Is "madam" a Palindrome?: ' || is_palindrome('madam'));
  
  -- Call random number generator
  v_result := generate_random(1, 100);
  DBMS_OUTPUT.PUT_LINE('Random Number between 1 and 100: ' || v_result);
END;
/
