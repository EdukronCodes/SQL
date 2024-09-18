
# Oracle SQL Functions

## 1. String Functions
- `ASCII()`
- `CHR()`
- `CONCAT()`
- `INITCAP()`
- `INSTR()`
- `LENGTH()`
- `LOWER()`
- `LPAD()`
- `LTRIM()`
- `REGEXP_INSTR()`
- `REGEXP_REPLACE()`
- `REGEXP_SUBSTR()`
- `REPLACE()`
- `RPAD()`
- `RTRIM()`
- `SUBSTR()`
- `TRANSLATE()`
- `TRIM()`
- `UPPER()`
- `TO_CHAR()`

## 2. Numeric Functions
- `ABS()`
- `ACOS()`
- `ASIN()`
- `ATAN()`
- `BITAND()`
- `CEIL()`
- `COS()`
- `COSH()`
- `EXP()`
- `FLOOR()`
- `LN()`
- `LOG()`
- `MOD()`
- `POWER()`
- `ROUND()`
- `SIGN()`
- `SIN()`
- `SINH()`
- `SQRT()`
- `TAN()`
- `TANH()`
- `TRUNC()`

## 3. Date and Time Functions
- `ADD_MONTHS()`
- `CURRENT_DATE()`
- `CURRENT_TIMESTAMP()`
- `DBTIMEZONE()`
- `EXTRACT()`
- `FROM_TZ()`
- `LAST_DAY()`
- `LOCALTIMESTAMP()`
- `MONTHS_BETWEEN()`
- `NEW_TIME()`
- `NEXT_DAY()`
- `ROUND()` (for dates)
- `SYSDATE()`
- `SYSTIMESTAMP()`
- `TO_CHAR()` (for dates)
- `TO_DATE()`
- `TO_TIMESTAMP()`
- `TRUNC()` (for dates)
- `TZ_OFFSET()`

## 4. Conversion Functions
- `TO_CHAR()`
- `TO_DATE()`
- `TO_NUMBER()`
- `TO_SINGLE_BYTE()`
- `TO_MULTI_BYTE()`
- `CAST()`
- `CONVERT()`
- `HEXTORAW()`
- `RAWTOHEX()`
- `ROWIDTOCHAR()`
- `CHARTOROWID()`
- `TO_YMINTERVAL()`
- `TO_DSINTERVAL()`

## 5. Aggregate Functions
- `AVG()`
- `COUNT()`
- `COVAR_POP()`
- `COVAR_SAMP()`
- `GROUPING()`
- `MAX()`
- `MIN()`
- `SUM()`
- `VAR_POP()`
- `VAR_SAMP()`
- `STDDEV()`
- `STDDEV_POP()`
- `STDDEV_SAMP()`

## 6. Analytical Functions
- `LAG()`
- `LEAD()`
- `FIRST_VALUE()`
- `LAST_VALUE()`
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `PERCENT_RANK()`
- `CUME_DIST()`
- `NTILE()`
- `RATIO_TO_REPORT()`
- `LISTAGG()`
- `MEDIAN()`

## 7. General Functions
- `COALESCE()`
- `DECODE()`
- `DUMP()`
- `GREATEST()`
- `LEAST()`
- `NVL()`
- `NVL2()`
- `NULLIF()`
- `SYS_CONTEXT()`
- `USERENV()`

## 8. Data Type Functions
- `DUMP()`
- `VSIZE()`
- `TYPE_NAME()`
- `DATA_TYPE()`

## 9. Conditional Functions
- `CASE`
- `DECODE()`
- `NVL()`
- `NVL2()`
- `NULLIF()`
- `COALESCE()`

## 10. Object Reference Functions
- `REF()`
- `DEREF()`
- `MAKE_REF()`
- `VALUE()`

## 11. XML Functions
- `EXTRACT()`
- `EXTRACTVALUE()`
- `XMLAGG()`
- `XMLCONCAT()`
- `XMLELEMENT()`
- `XMLFOREST()`
- `XMLTYPE()`
- `SYS_XMLGEN()`
- `SYS_XMLAGG()`

## 12. Hierarchical Query Functions
- `CONNECT_BY_ISCYCLE()`
- `CONNECT_BY_ISLEAF()`
- `LEVEL()`
- `PRIOR()`
- `SYS_CONNECT_BY_PATH()`

## 13. Statistical Functions
- `CORR()`
- `COVAR_POP()`
- `COVAR_SAMP()`
- `REGR_SLOPE()`
- `REGR_INTERCEPT()`
- `REGR_COUNT()`
- `REGR_R2()`
- `REGR_AVGX()`
- `REGR_AVGY()`
- `VAR_POP()`
- `VAR_SAMP()`
- `STDDEV()`
- `STDDEV_POP()`
- `STDDEV_SAMP()`

## 14. PL/SQL Functions (Useful for PL/SQL blocks)
- `SYSDATE()`
- `DBTIMEZONE()`
- `SYSTIMESTAMP()`
- `USER()`
- `UID()`
- `USERENV()`
- `APPEND_HINT()`
- `EXISTS()` (Subquery)
- `CURSOR()`
- `NEXTVAL()` (Sequence)
- `CURRVAL()` (Sequence)

## 15. Regular Expression Functions
- `REGEXP_INSTR()`
- `REGEXP_LIKE()`
- `REGEXP_REPLACE()`
- `REGEXP_SUBSTR()`

## 16. JSON Functions
- `JSON_EXISTS()`
- `JSON_VALUE()`
- `JSON_QUERY()`
- `JSON_OBJECT()`
- `JSON_ARRAY()`
- `IS JSON`

## 17. Advanced Data Warehousing Functions
- `CUBE()`
- `ROLLUP()`
- `GROUPING_ID()`
- `GROUPING()` 
- `SYS_CONNECT_BY_PATH()`
- `GROUP_ID()`
- `PARTITION BY` (Used in Analytic Functions)

## 18. Encryption and Decryption Functions
- `DBMS_CRYPTO.ENCRYPT()`
- `DBMS_CRYPTO.DECRYPT()`
- `DBMS_CRYPTO.HASH()`

## 19. XMLType Functions
- `XMLTYPE()`
- `XMLSEQUENCE()`
- `XMLDOM()`
- `XDBURIType()`
- `EXTRACT()`

## 20. Hierarchical Functions
- `SYS_CONNECT_BY_PATH()`
- `CONNECT_BY_ROOT()`
- `LEVEL()`
- `PRIOR()`
