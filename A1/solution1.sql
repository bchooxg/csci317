SPOOL solution1 
SET ECHO ON 
SET FEEDBACK ON 
SET LINESIZE 300 
SET PAGESIZE 300

-- Name   : Bryan Choo
-- UOW ID : 7060452

-- Task 1 --


-- Part 1
connect system/oracle

select INSTANCE_NAME, HOST_NAME, STARTUP_TIME, DATABASE_STATUS from v$instance;

-- Part 2
connect tpchr/oracle

---Analyze Table
analyze table lineitem compute statistics;
analyze table orders compute statistics;
analyze table customer compute statistics;
analyze table part compute statistics;
analyze table supplier compute statistics;
analyze table partsupp compute statistics;
analyze table nation compute statistics;
analyze table region compute statistics;

-- Part 3
connect sys/oracle as sysdba

-- Part 3(i)
SELECT SYSTIMESTAMP FROM DUAL;

-- Part 3(ii)
select 
	ds.segment_name as table_name ,
	ds.blocks as total_blocks, 
	ds.bytes as total_bytes, 
	ds.extents as total_extents,
	ut.num_rows as total_rows
from dba_segments ds
left outer join user_tables ut 
on ut.table_name = ds.segment_name
where ds.owner = 'TPCHR' and ds.segment_type = 'TABLE';


-- Part 3(iii)
select 
	ds.segment_name as index_name ,
	ds.blocks as total_blocks, 
	ds.extents as total_extents,
	ds.bytes as total_bytes
from dba_segments ds
where ds.owner = 'TPCHR' and ds.segment_type = 'INDEX';


SPOOL OFF
