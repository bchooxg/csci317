SPOOL solution4 
SET ECHO ON 
SET FEEDBACK ON 
SET LINESIZE 300 
SET PAGESIZE 300

-- Name   : Bryan Choo
-- UOW ID : 7060452

explain plan for 
select c_custkey from customer 
where exists
(select o_custkey 
from orders 
where c_custkey = o_custkey
and customer.c_name = 'Golden Bolts' 
and orders.o_totalprice > 100 
)
intersect 
select c_custkey from nation 
join customer 
on c_nationkey = n_nationkey  
where n_regionkey = 1 or n_regionkey = 2 or n_regionkey = 3 
and c_nationkey >= 0 
;

select * from table(DBMS_XPLAN.DISPLAY);


SPOOL OFF

