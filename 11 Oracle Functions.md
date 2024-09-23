SQL
-- Mathematical Functions
-- ABS: Returns the absolute value of a number.
SELECT ABS(-10) FROM DUAL; -- Output: 10

-- CEIL: Rounds a number up to the nearest integer.
SELECT CEIL(3.14) FROM DUAL; -- Output: 4

-- FLOOR: Rounds a number down to the nearest integer.
SELECT FLOOR(3.14) FROM DUAL; -- Output: 3

-- MOD: Returns the remainder of division.
SELECT MOD(10, 3) FROM DUAL; -- Output: 1

-- POWER: Raises a number to a power.
SELECT POWER(2, 3) FROM DUAL; -- Output: 8

-- SQRT: Calculates the square root of a number.
SELECT SQRT(16) FROM DUAL; -- Output: 4

-- EXP: Calculates the exponential of a number (e raised to the power of x).
SELECT EXP(2) FROM DUAL; -- Output: 7.38905609893065

-- LOG: Calculates the logarithm of a number to a base.
SELECT LOG(10, 100) FROM DUAL; -- Output: 2

-- LN: Calculates the natural logarithm of a number (logarithm to base e).
SELECT LN(1) FROM DUAL; -- Output: 0

-- GREATEST: Returns the largest value from a list of values.
SELECT GREATEST(10, 20, 4) FROM DUAL; -- Output: 20

-- LEAST: Returns the smallest value from a list of values.
SELECT LEAST(10, 20, 5) FROM DUAL; -- Output: 5

-- SIGN: Returns -1 if the number is negative, 1 if positive, and 0 if zero.
SELECT SIGN(-10) FROM DUAL; -- Output: -1

-- SIN, COS, TAN: Calculate trigonometric functions (sine, cosine, tangent).
SELECT SIN(30), COS(60), TAN(45) FROM DUAL;

-- PI: Returns the value of pi.
SELECT PI() FROM DUAL;

-- Character-based Functions
-- LOWER: Converts a string to lowercase.
SELECT LOWER('Hello, World!') FROM DUAL; -- Output: hello, world!

-- UPPER: Converts a string to uppercase.
SELECT UPPER('Hello, World!') FROM DUAL; -- Output: HELLO, WORLD!

-- INITCAP: Capitalizes the first letter of each word.
SELECT INITCAP('hello world') FROM DUAL; -- Output: Hello World

-- CONCAT: Concatenates two or more strings.
SELECT CONCAT('Hello', ' ', 'World') FROM DUAL; -- Output: Hello World

-- SUBSTR: Extracts a substring from a string.
SELECT SUBSTR('Hello, World!', 7, 5) FROM DUAL; -- Output: World

-- LENGTH: Returns the length of a string.
SELECT LENGTH('Hello, World!') FROM DUAL; -- Output: 13

-- INSTR: Finds the position of a substring within a string.
SELECT INSTR('Hello, World!', 'World') FROM DUAL; -- Output: 7

-- REPLACE: Replaces occurrences of a substring with another.
SELECT REPLACE('Hello, World!', 'World', 'Universe') FROM DUAL; -- Output: Hello, Universe!

-- TRIM: Removes leading and trailing whitespace from a string.
SELECT TRIM('  Hello, World!  ') FROM DUAL; -- Output: Hello, World!

-- LTRIM: Removes leading whitespace from a string.
SELECT LTRIM('  Hello, World!') FROM DUAL; -- Output: Hello, World!

-- RTRIM: Removes trailing whitespace from a string.
SELECT RTRIM('Hello, World!  ') FROM DUAL; -- Output: Hello, World!

-- LPAD: Pads a string with characters on the left.
SELECT LPAD('Hello', 10, '*') FROM DUAL; -- Output: *****Hello

-- RPAD: Pads a string with characters on the right.
SELECT RPAD('Hello', 10, '*') FROM DUAL; -- Output: Hello*****

-- ASCII: Returns the ASCII value of a character.
SELECT ASCII('A') FROM DUAL; -- Output: 65

-- CHR: Returns the character corresponding to an ASCII value.
SELECT CHR(65) FROM DUAL; -- Output: A
