SPOOL solution1 
SET ECHO ON 
SET FEEDBACK ON 
SET LINESIZE 300 
SET PAGESIZE 300

-- Task 1


-- Part 1
connect system/oracle

select INSTANCE_NAME, HOST_NAME, STATUP_TIME, DATABASE_STATUS from v$instance;

-- Part 2
connect tpchr/oracle

	---Analyze Table
ANALYZE TABLE ORDERS COMPUTE STATISTICS;

-- Part 3
connect sys/oracle as sysdba

SELECT SYSTIMESTAMP FROM DUAL;



SPOOL OFF
