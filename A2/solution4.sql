SPOOL solution4
SET ECHO ON 
SET FEEDBACK ON 
SET LINESIZE 300 
SET PAGESIZE 300

-- Name   : Bryan Choo
-- UOW ID : 7060452

connect TPCHR/oracle

/* Create indexes */

/*
CREATE INDEX o_idx ON ORDERS (o_orderdate, o_totalprice, o_orderstatus);
CREATE INDEX c_idx ON CUSTOMER( c_acctbal ) ;
CREATE INDEX l_idx ON LINEITEM( l_quantity ) ;
CREATE INDEX p_idx ON PART ( p_name ) ;
CREATE INDEX ps_idx on PARTSUPP ( ps_supplycost );
*/

-- Bare min
CREATE INDEX o_idx ON ORDERS (o_orderdate, o_totalprice, o_orderstatus);
CREATE INDEX l_idx ON LINEITEM( l_quantity ) ;

/* Find size of indexes */

connect system/oracle as sysdba

SELECT	SEGMENT_NAME, 
	SEGMENT_TYPE, 
	BYTES, 
	BLOCKS
FROM 	DBA_SEGMENTS
WHERE 	SEGMENT_NAME in ( 'O_IDX', 'L_IDX');

/* Query Processing Plan for queries */

connect TPCHR/oracle

-- First Query 

EXPLAIN PLAN FOR
SELECT COUNT(DISTINCT O_TOTALPRICE)
FROM ORDERS;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Second Query 
EXPLAIN PLAN FOR 
SELECT * 
FROM CUSTOMER JOIN ORDERS
              ON CUSTOMER.C_CUSTKEY = ORDERS.O_CUSTKEY
WHERE C_ACCTBAL = 1000 AND O_TOTALPRICE = 1000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Third Query 
EXPLAIN PLAN FOR
SELECT * 
FROM ORDERS JOIN LINEITEM
            ON ORDERS.O_ORDERKEY = LINEITEM.L_ORDERKEY
WHERE O_ORDERDATE = '09-SEP-2021' OR L_QUANTITY = 500;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Fourth Query 
EXPLAIN PLAN FOR 
SELECT *
FROM LINEITEM JOIN PART
              ON LINEITEM.L_PARTKEY = PART.P_PARTKEY
WHERE L_QUANTITY = 100 AND P_NAME = 'bolt';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Fifth Query 
EXPLAIN PLAN FOR
SELECT COUNT(PS_AVAILQTY)
FROM PARTSUPP JOIN LINEITEM
              ON PARTSUPP.PS_PARTKEY = LINEITEM.L_PARTKEY
	      JOIN ORDERS
	      ON LINEITEM.L_ORDERKEY = ORDERS.O_ORDERKEY
WHERE O_ORDERSTATUS = 'F' AND L_QUANTITY > 200 AND PS_SUPPLYCOST > 100;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);




/* Drop Indexes */
DROP INDEX o_idx;
DROP INDEX l_idx;
/*
DROP INDEX c_idx;
DROP INDEX p_idx;
DROP INDEX ps_idx;
*/

SPOOL OFF