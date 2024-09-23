
-- 1. LOWER
-- Converts all characters of a string to lowercase.
SELECT LOWER('Edukron Data Science') FROM dual;
-- Output: edukron data science

-- 2. UPPER
-- Converts all characters of a string to uppercase.
SELECT UPPER('Edukron Data Engineering') FROM dual;
-- Output: EDUKRON DATA ENGINEERING

-- 3. INITCAP
-- Converts the first character of each word to uppercase.
SELECT INITCAP('edukron data science') FROM dual;
-- Output: Edukron Data Science

-- 4. CONCAT
-- Concatenates two strings.
SELECT CONCAT('Edukron', ' Data Science') FROM dual;
-- Output: Edukron Data Science

-- 5. SUBSTR
-- Extracts a substring from a string.
SELECT SUBSTR('Edukron Data Engineering', 9, 4) FROM dual;
-- Output: Data
-- This extracts 4 characters starting from the 9th position.

-- 6. LENGTH
-- Returns the length of a string.
SELECT LENGTH('Edukron Data Science') FROM dual;
-- Output: 21

-- 7. INSTR
-- Returns the position of a substring within a string.
SELECT INSTR('Edukron Data Engineering', 'Engineering') FROM dual;
-- Output: 12

-- 8. REPLACE
-- Replaces occurrences of a substring within a string.
SELECT REPLACE('Edukron Data Science', 'Science', 'Engineering') FROM dual;
-- Output: Edukron Data Engineering

-- 9. TRIM
-- Removes leading and trailing spaces from a string.
SELECT TRIM('  Edukron Data Science  ') FROM dual;
-- Output: Edukron Data Science

-- 10. LTRIM
-- Removes leading spaces from a string.
SELECT LTRIM('   Edukron Data Science') FROM dual;
-- Output: Edukron Data Science

-- 11. RTRIM
-- Removes trailing spaces from a string.
SELECT RTRIM('Edukron Data Engineering   ') FROM dual;
-- Output: Edukron Data Engineering

-- 12. LPAD
-- Pads the left side of a string with a specified character.
SELECT LPAD('Data Science', 15, '0') FROM dual;
-- Output: 000Data Science

-- 13. RPAD
-- Pads the right side of a string with a specified character.
SELECT RPAD('Edukron', 10, '*') FROM dual;
-- Output: Edukron***

-- 14. ASCII
-- Returns the ASCII value of the first character of a string.
SELECT ASCII('Edukron') FROM dual;
-- Output: 69
-- (ASCII value of 'E')

-- 15. CHR
-- Returns the character corresponding to an ASCII value.
SELECT CHR(69) FROM dual;
-- Output: E

-- 16. TRANSLATE
-- Replaces a sequence of characters in a string.
SELECT TRANSLATE('Edukron Data Science', 'Data', 'Info') FROM dual;
-- Output: Edukron Info Science

-- 17. REVERSE
-- Reverses a string.
SELECT REVERSE('Edukron') FROM dual;
-- Output: norkudE
