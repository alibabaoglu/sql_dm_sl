# sql_dm_sl

``` sql
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


**Schema (PostgreSQL v13)**

    create table dept(
      deptno numeric(2,0), 
      dname varchar(14), 
      loc varchar(13), 
      constraint pk_dept primary key (deptno)
    );
    
    create table emp(
      empno numeric(4,0), 
      ename varchar(10), 
      job varchar(9), 
      mgr numeric(4,0), 
      hiredate date, 
      sal numeric(7,2), 
      comm numeric(7,2), 
      deptno numeric(2,0), 
      constraint pk_emp primary key (empno), 
      constraint fk_deptno foreign key (deptno) references dept (deptno)
    );
    
    insert into dept values(10, 'ACCOUNTING', 'NEW YORK'); 
    insert into dept values(20, 'RESEARCH', 'DALLAS'); 
    insert into dept values(30, 'SALES', 'CHICAGO'); 
    insert into dept values(40, 'OPERATIONS', 'BOSTON');
    
    insert into emp values( 7839, 'KING', 'PRESIDENT', null, to_date('17-11-1981','dd-mm-yyyy'), 5000, null, 10 ); 
    insert into emp values( 7698, 'BLAKE', 'MANAGER', 7839, to_date('1-5-1981','dd-mm-yyyy'), 2850, null, 30 );
    insert into emp values( 7782, 'CLARK', 'MANAGER', 7839, to_date('9-6-1981','dd-mm-yyyy'), 2450, null, 10 ); 
    insert into emp values( 7566, 'JONES', 'MANAGER', 7839, to_date('2-4-1981','dd-mm-yyyy'), 2975, null, 20 ); 
    insert into emp values( 7788, 'SCOTT', 'ANALYST', 7566, to_date('13-07-1987','dd-mm-yyyy'), 3000, null, 20 ); 
    insert into emp values( 7902, 'FORD', 'ANALYST', 7566, to_date('3-12-1981','dd-mm-yyyy'), 3000, null, 20 ); 
    insert into emp values( 7369, 'SMITH', 'CLERK', 7902, to_date('17-12-1980','dd-mm-yyyy'), 800, null, 20 ); 
    insert into emp values( 7499, 'ALLEN', 'SALESMAN', 7698, to_date('20-2-1981','dd-mm-yyyy'), 1600, 300, 30 ); 
    insert into emp values( 7521, 'WARD', 'SALESMAN', 7698, to_date('22-2-1981','dd-mm-yyyy'), 1250, 500, 30 ); 
    insert into emp values( 7654, 'MARTIN', 'SALESMAN', 7698, to_date('28-9-1981','dd-mm-yyyy'), 1250, 1400, 30 ); 
    insert into emp values( 7844, 'TURNER', 'SALESMAN', 7698, to_date('8-9-1981','dd-mm-yyyy'), 1500, 0, 30 ); 
    insert into emp values( 7876, 'ADAMS', 'CLERK', 7788, to_date('13-07-1987', 'dd-mm-yyyy'), 1100, null, 20 ); 
    insert into emp values( 7900, 'JAMES', 'CLERK', 7698, to_date('3-12-1981','dd-mm-yyyy'), 950, null, 30 ); 
    insert into emp values( 7934, 'MILLER', 'CLERK', 7782, to_date('23-1-1982','dd-mm-yyyy'), 1300, null, 10 );
    
    

---

**Query #1**

    select deptno, sal 
    from emp 
    where sal >  (select avg(sal) from emp) and deptno = 20;

| deptno | sal     |
| ------ | ------- |
| 20     | 2975.00 |
| 20     | 3000.00 |
| 20     | 3000.00 |

---
**Query #2**

    select dname, min(sal) as minGehalt, max(sal) as maxGehalt 
    from dept 
    left outer join emp on dept.deptno= emp.deptno  group by dname;

| dname      | mingehalt | maxgehalt |
| ---------- | --------- | --------- |
| ACCOUNTING | 1300.00   | 5000.00   |
| SALES      | 950.00    | 2850.00   |
| OPERATIONS |           |           |
| RESEARCH   | 800.00    | 3000.00   |

---
**Query #3**

    select ename, hiredate 
    from emp 
    where extract(year from hiredate)= '1981' order by sal;

| ename  | hiredate                 |
| ------ | ------------------------ |
| JAMES  | 1981-12-03T00:00:00.000Z |
| WARD   | 1981-02-22T00:00:00.000Z |
| MARTIN | 1981-09-28T00:00:00.000Z |
| TURNER | 1981-09-08T00:00:00.000Z |
| ALLEN  | 1981-02-20T00:00:00.000Z |
| CLARK  | 1981-06-09T00:00:00.000Z |
| BLAKE  | 1981-05-01T00:00:00.000Z |
| JONES  | 1981-04-02T00:00:00.000Z |
| FORD   | 1981-12-03T00:00:00.000Z |
| KING   | 1981-11-17T00:00:00.000Z |

---
**Query #4**

    with win as(
    	select ename, sal, lead (sal) over( order by sal) as nextBetterSalary 
      	from emp 
      	where job='ANALYST' or job='SALESMAN'
    )
    select *, nextBetterSalary - sal as differenz 
    from win;

| ename  | sal     | nextbettersalary | differenz |
| ------ | ------- | ---------------- | --------- |
| WARD   | 1250.00 | 1250.00          | 0.00      |
| MARTIN | 1250.00 | 1500.00          | 250.00    |
| TURNER | 1500.00 | 1600.00          | 100.00    |
| ALLEN  | 1600.00 | 3000.00          | 1400.00   |
| SCOTT  | 3000.00 | 3000.00          | 0.00      |
| FORD   | 3000.00 |                  |           |

---
**Query #5**

    with win as(
    	select ename, sal, avg (sal) over( order by sal
                 rows between 1 following and unbounded following) as durchschnitt
      	from emp 
      	where job='ANALYST' or job='SALESMAN'
    )
    select *, durchschnitt - sal as differenz 
    from win;

| ename  | sal     | durchschnitt          | differenz             |
| ------ | ------- | --------------------- | --------------------- |
| WARD   | 1250.00 | 2070.0000000000000000 | 820.0000000000000000  |
| MARTIN | 1250.00 | 2275.0000000000000000 | 1025.0000000000000000 |
| TURNER | 1500.00 | 2533.3333333333333333 | 1033.3333333333333333 |
| ALLEN  | 1600.00 | 3000.0000000000000000 | 1400.0000000000000000 |
| SCOTT  | 3000.00 | 3000.0000000000000000 | 0.0000000000000000    |
| FORD   | 3000.00 |                       |                       |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/9XMyq5aMrXHV3kyoCc5GFx/215)
