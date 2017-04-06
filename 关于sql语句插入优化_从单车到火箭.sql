oracle jdbc批量插入数据优化
  批量写入问题。开始时应用程序是一条一条的执行insert来写入报表结果。写入也是比较慢的。主要原因是单条写入时候需要应用于db之间大量的
请求响应交互。每个请求都是一个独立的事务提交。这样网络延迟大的情况下多次请求会有大量的时间消耗的网络延迟上。第二个是由于每个事务db都会
有刷新磁盘操作写事务日志，保证事务的持久性。由于每个事务只是写入一条数据 所以磁盘io利用率不高，因为对于磁盘io是按块来的，所以连续写入大量数据效率
更好。所以必须改成批量插入的方式，减少请求数与事务数。还有mysql  jdbc连接串必须加下rewriteBatchedStatements=true 并保证5.1.13以上版本的驱动，才能实现高性能的批量插入

例如： String connectionUrl="jdbc:mysql://192.168.1.100:3306/test?rewriteBatchedStatements=true" ; 





//////////////////////
////从单车到火箭
///////////////////////
//////////////////
//准备过程
/////////////////
C:\Users\Ned>sqlplus aaa/aaa

SQL*Plus: Release 11.2.0.1.0 Production on 星期四 11月 24 15:49:43 2016

Copyright (c) 1982, 2010, Oracle.  All rights reserved.


连接到:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> drop table t purge;

表已删除。

SQL> create table t (x int );

表已创建。

SQL> alter system flush shared_pool;

系统已更改。

//////////////
//----首次 普通的插入 1000000条数据
//----花费时间   已用时间:  00: 04: 25.45
//////////////


SQL> create or replace procedure proc1
  2  as
  3  begin
  4  for i in 1..1000000
  5  loop
  6  execute immediate
  7  'insert into t values('||i||')';
  8  commit;
  9  end loop;
 10  end;
 11  /

过程已创建。

SQL> set timing on
SQL> exec proc1;

PL/SQL 过程已成功完成。

已用时间:  00: 04: 25.45



//////////////
//------通过绑定变量优化执行效率
//------花费时间  已用时间:  00: 00: 48.60
//////////////

SQL> create or replace procedure proc2
  2  as
  3  begin
  4  for i in 1..1000000
  5  loop
  6  execute immediate
  7  'insert into t values(:x)' using i;
  8  commit;
  9  end loop;
 10  end;
 11  /

过程已创建。

已用时间:  00: 00: 00.01

SQL> drop table t purge;

表已删除。


已用时间:  00: 00: 00.12
SQL> create table t(x int);

表已创建。

已用时间:  00: 00: 00.05
SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.34

SQL>  exec proc2;

PL/SQL 过程已成功完成。

已用时间:  00: 00: 48.60

////////////////
//------静态改写
//-----花费时间 已用时间:  00: 00: 45.92
/////////////////


SQL> create or replace procedure proc3
  2  as
  3  begin
  4  for i in 1..1000000
  5  loop
  6  insert into t values(i);
  7  commit;
  8  end loop;
  9  end;
 10  /

过程已创建。

SQL> drop table t purge;

表已删除。

SQL> create table t(x int);

表已创建。

SQL> alter system flush shared_pool;

系统已更改。

SQL> set timing on
SQL> exec proc3;

PL/SQL 过程已成功完成。

已用时间:  00: 00: 45.92

///////////////////////
//----批量提交
//----已用时间:  00: 00: 16.02
//////////////////////
SQL> create or replace procedure proc4
  2  as
  3  begin
  4  for i in 1..1000000
  5  loop
  6  insert into t values(i);
  7  end loop;
  8  commit;
  9  end;
 10  /

过程已创建。

已用时间:  00: 00: 00.01
SQL> drop table t purge;

表已删除。

已用时间:  00: 00: 00.07
SQL> create table t(x int);

表已创建。

已用时间:  00: 00: 00.02
SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.05
SQL> exec proc4;

PL/SQL 过程已成功完成。

已用时间:  00: 00: 16.02

////////////////////
//-------集合写法
//-----花费时间 已用时间:  00: 00: 00.56
///////////////////


SQL> drop table t purge;

表已删除。

已用时间:  00: 00: 00.12

SQL> create table t(x int);

表已创建。

已用时间:  00: 00: 00.03
SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.05

SQL> insert into t select rownum from dual connect by level<=1000000;

已创建1000000行。

已用时间:  00: 00: 00.56

///////////////////
///----直接路径
///-----花费时间 :  500万条 : 已用时间:  00: 00: 02.42
///---------------约100万条 ： 00: 00: 00.48
/////////////////


SQL> drop table t purge;

表已删除。

已用时间:  00: 00: 00.12

SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.05

SQL> create table t as select rownum x from dual connect by level<=5000000;

表已创建。

已用时间:  00: 00: 02.42

///////////////
//-----并行设置
//----关闭日志nologging
//-----花费时间：500万条数据 已用时间:  00: 00: 01.80
//----以下都是500万条数据
//-----------ps：因为是使用笔记本进行的优化测试，笔记本只有4核心，所以优化效果相对理论效果不明显。
///////////////

SQL> drop table t purge;

表已删除。

已用时间:  00: 00: 00.10

SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.05
SQL> create table t nologging parallel 4 as select rownum x from dual connect by level <=5000000;

表已创建。

已用时间:  00: 00: 01.80


////////////////
//-----更改存储介质为内存盘
//-------花费时间 已用时间:  00: 00: 01.57
//-------因为前面本身就是使用固体，瓶颈不在磁盘上，所以这里效果不明显
////////////////////

SQL> select name from v$datafile;

NAME
--------------------------------------------------------------------------------
Z:\ORACLE\SYSTEM01.DBF
Z:\ORACLE\SYSAUX01.DBF
Z:\ORACLE\UNDOTBS01.DBF
Z:\ORACLE\USERS01.DBF
Z:\ORACLE\EXAMPLE01.DBF


SQL> drop table t purge;

表已删除。

已用时间:  00: 00: 00.09
SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.04
SQL> create table t nologging parallel 4 as select rownum x from dual connect by level <=5000000;

表已创建。

已用时间:  00: 00: 01.57



/////////////
//---更改创建的数据
//---目前瓶颈是数据的创建
//---花费时间 ： 已用时间:  00: 00: 00.78
////////////



SQL> create table s nologging parallel 4 as select rownum x from t;

表已创建。

已用时间:  00: 00: 00.78


/////////////
//---直接通过表拷贝进行插入
//---花费时间 已用时间:  00: 00: 00.32
////////////


SQL> drop table s purge;

已用时间:  00: 00: 00.03
SQL> alter system flush shared_pool;

系统已更改。

已用时间:  00: 00: 00.04
SQL> create table s nologging parallel 4 as select * from t;

表已创建。

已用时间:  00: 00: 00.32










