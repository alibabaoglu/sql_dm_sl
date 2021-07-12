# sql_dm_sl

``` psql
#Aufgabe 1.1
select deptno, sal 
from emp 
where sal >  (select avg(sal) from emp) and deptno = 20;

# Aufgabe 1.2
#select dname, min(sal) as minGehalt, max(sal) as maxGehalt 
#from dept 
#natural join emp  group by dname;
#Mit Operations Abteilung mit werten Null

# Aufgabe 1.2.2
select dname, min(sal) as minGehalt, max(sal) as maxGehalt 
from dept 
left outer join emp on dept.deptno= emp.deptno  group by dname;

#Aufgabe 1.3
select ename, hiredate 
from emp 
where extract(year from hiredate)= '1981' order by sal;

# Aufgabe 1.4
with win as(
	select ename, sal, lead (sal) over( order by sal) as nextBetterSalary 
  	from emp 
  	where job='ANALYST' or job='SALESMAN'
)
select *, nextBetterSalary - sal as differenz 
from win;


#Aufgabe 1.5
with win as(
	select ename, sal, avg (sal) over( order by sal
             rows between 1 following and unbounded following) as durchschnitt
  	from emp 
  	where job='ANALYST' or job='SALESMAN'
)
select *, durchschnitt - sal as differenz 
from win;


```
