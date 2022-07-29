SPOOL solution3
SET ECHO ON 
SET FEEDBACK ON 
SET LINESIZE 300 
SET PAGESIZE 300

-- Name   : Bryan Choo
-- UOW ID : 7060452

/*

Find the total quantity of all items (attribute L_QUANTITY in a table LINEITEM) ordered 
by the customers from a given country (attribute N_NAME in a table NATION). 

*/

/*  Part 1  */

connect TPCHR/oracle

SET TIMING ON

SELECT n_name as Nation_Name , sum(l_quantity) as Total_Qty 
FROM lineitem l
LEFT OUTER JOIN orders o
ON l.l_orderkey = o.o_orderkey
LEFT OUTER JOIN customer c
ON o.o_custkey = c.c_custkey 
LEFT OUTER JOIN nation n
ON c.c_nationkey = n.n_nationkey
WHERE n_name = 'JAPAN'
GROUP BY n.n_name ;

SET TIMING off

/*  Part 2  */

EXPLAIN PLAN FOR 
SELECT n_name as Nation_Name , sum(l_quantity) as Total_Qty 
FROM lineitem l
LEFT OUTER JOIN orders o
ON l.l_orderkey = o.o_orderkey
LEFT OUTER JOIN customer c
ON o.o_custkey = c.c_custkey 
LEFT OUTER JOIN nation n
ON c.c_nationkey = n.n_nationkey
WHERE n_name = 'JAPAN'
GROUP BY n.n_name ;

-- Display Plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);



/*  Part 3  */

ALTER TABLE LINEITEM ADD l_custnation CHAR(25);

/*  Part 4  */

SET TIMING ON

SELECT l_custnation, sum(l_quantity) as Total_Qty
FROM LINEITEM
WHERE l_custnation = 'JAPAN'
GROUP BY l_custnation;

SET TIMING OFF


/*  Part 5  */

EXPLAIN PLAN FOR 
SELECT l_custnation, sum(l_quantity) as Total_Qty
FROM LINEITEM
WHERE l_custnation = 'JAPAN'
GROUP BY l_custnation;

-- Display Plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/*  Part 6  */

CREATE INDEX idx ON lineitem ( l_custnation );

SET TIMING ON

SELECT l_custnation, sum(l_quantity) as Total_Qty
FROM LINEITEM
WHERE l_custnation = 'JAPAN'
GROUP BY l_custnation;

SET TIMING OFF


/*  Part 7  */

EXPLAIN PLAN FOR 
SELECT l_custnation, sum(l_quantity) as Total_Qty
FROM LINEITEM
WHERE l_custnation = 'JAPAN'
GROUP BY l_custnation;

-- Display Plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);



/* Clean up */
ALTER TABLE LINEITEM DROP COLUMN l_custnation;


SPOOL OFF
