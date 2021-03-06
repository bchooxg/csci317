SPOOL solution1 
SET ECHO ON 
SET FEEDBACK ON 
SET LINESIZE 300 
SET PAGESIZE 300

-- Name   : Bryan Choo
-- UOW ID : 7060452


-- Part 1

SELECT 	SEGMENT_NAME, 
	SUM(BYTES) TOTBYTES,
       	SUM(BLOCKS) TOTBLOCKS
FROM 	SYS.DBA_EXTENTS
WHERE 	SEGMENT_NAME in ('ORDERS','LINEITEM') AND
      	OWNER = 'TPCHR'
GROUP BY SEGMENT_NAME, 
	 OWNER;

-- Part 2

-- Find out the size of the two relational tables 
select sum(TOTBYTES) / 1000000 from (
SELECT 	SEGMENT_NAME, 
	SUM(BYTES) TOTBYTES
FROM 	SYS.DBA_EXTENTS
WHERE 	SEGMENT_NAME in ('ORDERS','LINEITEM') AND
      	OWNER = 'TPCHR'
GROUP BY SEGMENT_NAME, 
	 OWNER
);


-- Create table space with the value

CREATE TABLESPACE tbs1 
   DATAFILE 'tbs1_data.dbf' 
   SIZE 327M;

-- Part 3 ( Create Tables )  

CREATE TABLE ORDERS1992(
O_ORDERKEY	NUMBER(12)	NOT NULL,
O_CUSTKEY	NUMBER(12)	NOT NULL,
O_ORDERSTATUS	CHAR(1)		NOT NULL,
O_TOTALPRICE	NUMBER(12,2)	NOT NULL,
O_ORDERDATE	DATE		NOT NULL,
O_ORDERPRIORITY CHAR(15)	NOT NULL,
O_CLERK		CHAR(15)	NOT NULL,
O_SHIPPRIORITY	NUMBER(12)	NOT NULL,
O_COMMENT	VARCHAR(79)	NOT NULL,
	CONSTRAINT ORDERS_PKEY PRIMARY KEY (O_ORDERKEY),
	CONSTRAINT ORDER_CHECK1 CHECK( O_TOTALPRICE >= 0) ) 
TABLESPACE tbs1;

CREATE TABLE LINEITEM1992(
L_ORDERKEY 	NUMBER(12)	NOT NULL,
L_PARTKEY	NUMBER(12)	NOT NULL,
L_SUPPKEY	NUMBER(12)	NOT NULL,
L_LINENUMBER	NUMBER(12)	NOT NULL,
L_QUANTITY	NUMBER(12,2)	NOT NULL,
L_EXTENDEDPRICE NUMBER(12,2)	NOT NULL,
L_DISCOUNT	NUMBER(12,2)	NOT NULL,
L_TAX		NUMBER(12,2)	NOT NULL,
L_RETURNFLAG	CHAR(1)		NOT NULL,
L_LINESTATUS	CHAR(1)		NOT NULL,
L_SHIPDATE	DATE		NOT NULL,
L_COMMITDATE	DATE		NOT NULL,
L_RECEIPTDATE	DATE		NOT NULL,
L_SHIPINSTRUCT	CHAR(25)	NOT NULL,
L_SHIPMODE	CHAR(10)	NOT NULL,
L_COMMENT	VARCHAR(44)	NOT NULL,
	CONSTRAINT LINEITEM_PKEY PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
	CONSTRAINT LINEITEM_FKEY1 FOREIGN kEY (L_ORDERKEY)
		REFERENCES ORDERS1992(O_ORDERKEY),
	CONSTRAINT LINEITEM_CHECK1 CHECK (L_QUANTITY >= 0),
	CONSTRAINT LINEITEM_CHECK2 CHECK (L_EXTENDEDPRICE >= 0),
	CONSTRAINT LINEITEM_CHECK3 CHECK (L_TAX >= 0),
	CONSTRAINT LINEITEM_CHECK4 CHECK (L_DISCOUNT BETWEEN 0.00 AND 1.00) )
TABLESPACE tbs1;

-- Part 4 ( Copy Information ) 

select count(*) from TPCHR.ORDERS where extract(YEAR from o_orderdate) = 1992;

insert into ORDERS1992 ( O_ORDERKEY, 
O_CUSTKEY, O_ORDERSTATUS, 
O_TOTALPRICE, O_ORDERDATE, 
O_ORDERPRIORITY, O_CLERK, 
O_SHIPPRIORITY, O_COMMENT ) 
select * from TPCHR.ORDERS where extract(YEAR from o_orderdate) = 1992;

insert into LINEITEM1992( 
L_ORDERKEY, L_PARTKEY, 
L_SUPPKEY, L_LINENUMBER, 
L_QUANTITY, L_EXTENDEDPRICE, 
L_DISCOUNT, L_TAX, L_RETURNFLAG, 
L_LINESTATUS, L_SHIPDATE, 
L_COMMITDATE, L_RECEIPTDATE, 
L_SHIPINSTRUCT, L_SHIPMODE, L_COMMENT )
select L_ORDERKEY, L_PARTKEY, 
L_SUPPKEY, L_LINENUMBER, 
L_QUANTITY, L_EXTENDEDPRICE, 
L_DISCOUNT, L_TAX, L_RETURNFLAG, 
L_LINESTATUS, L_SHIPDATE, 
L_COMMITDATE, L_RECEIPTDATE, 
L_SHIPINSTRUCT, L_SHIPMODE, L_COMMENT from 
( select * 
  from TPCHR.LINEITEM L
  right outer join ORDERS1992 O on L.L_ORDERKEY = O.O_ORDERKEY);


-- Part 5 ( Reducing the storage requirements ) 

select sum(TOTBYTES) / 1000000 from (
SELECT 	SEGMENT_NAME, 
	SUM(BYTES) TOTBYTES
FROM 	SYS.DBA_EXTENTS
WHERE 	SEGMENT_NAME in ('ORDERS1992','LINEITEM1992')
GROUP BY SEGMENT_NAME, 
	 OWNER
);

ALTER TABLESPACE tbs1 RESIZE 52M;

-- Part 6 ( Find out the number of datablocks used ) 

SELECT 	SEGMENT_NAME, 
	SUM(BYTES) TOTBYTES,
       	SUM(BLOCKS) TOTBLOCKS
FROM 	SYS.DBA_EXTENTS
WHERE 	SEGMENT_NAME in ('ORDERS1992','LINEITEM1992')
GROUP BY SEGMENT_NAME, 
	 OWNER;

-- Clean  up

DROP TABLESPACE tbs1
   INCLUDING CONTENTS AND DATAFILES;

SPOOL OFF
