oracle jdbc�������������Ż�
  ����д�����⡣��ʼʱӦ�ó�����һ��һ����ִ��insert��д�뱨������д��Ҳ�ǱȽ����ġ���Ҫԭ���ǵ���д��ʱ����ҪӦ����db֮�������
������Ӧ������ÿ��������һ�������������ύ�����������ӳٴ������¶��������д�����ʱ�����ĵ������ӳ��ϡ��ڶ���������ÿ������db����
��ˢ�´��̲���д������־����֤����ĳ־��ԡ�����ÿ������ֻ��д��һ������ ���Դ���io�����ʲ��ߣ���Ϊ���ڴ���io�ǰ������ģ���������д���������Ч��
���á����Ա���ĳ���������ķ�ʽ��������������������������mysql  jdbc���Ӵ��������rewriteBatchedStatements=true ����֤5.1.13���ϰ汾������������ʵ�ָ����ܵ���������

���磺 String connectionUrl="jdbc:mysql://192.168.1.100:3306/test?rewriteBatchedStatements=true" ; 





//////////////////////
////�ӵ��������
///////////////////////
//////////////////
//׼������
/////////////////
C:\Users\Ned>sqlplus aaa/aaa

SQL*Plus: Release 11.2.0.1.0 Production on ������ 11�� 24 15:49:43 2016

Copyright (c) 1982, 2010, Oracle.  All rights reserved.


���ӵ�:
Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> drop table t purge;

����ɾ����

SQL> create table t (x int );

���Ѵ�����

SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

//////////////
//----�״� ��ͨ�Ĳ��� 1000000������
//----����ʱ��   ����ʱ��:  00: 04: 25.45
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

�����Ѵ�����

SQL> set timing on
SQL> exec proc1;

PL/SQL �����ѳɹ���ɡ�

����ʱ��:  00: 04: 25.45



//////////////
//------ͨ���󶨱����Ż�ִ��Ч��
//------����ʱ��  ����ʱ��:  00: 00: 48.60
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

�����Ѵ�����

����ʱ��:  00: 00: 00.01

SQL> drop table t purge;

����ɾ����


����ʱ��:  00: 00: 00.12
SQL> create table t(x int);

���Ѵ�����

����ʱ��:  00: 00: 00.05
SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.34

SQL>  exec proc2;

PL/SQL �����ѳɹ���ɡ�

����ʱ��:  00: 00: 48.60

////////////////
//------��̬��д
//-----����ʱ�� ����ʱ��:  00: 00: 45.92
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

�����Ѵ�����

SQL> drop table t purge;

����ɾ����

SQL> create table t(x int);

���Ѵ�����

SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

SQL> set timing on
SQL> exec proc3;

PL/SQL �����ѳɹ���ɡ�

����ʱ��:  00: 00: 45.92

///////////////////////
//----�����ύ
//----����ʱ��:  00: 00: 16.02
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

�����Ѵ�����

����ʱ��:  00: 00: 00.01
SQL> drop table t purge;

����ɾ����

����ʱ��:  00: 00: 00.07
SQL> create table t(x int);

���Ѵ�����

����ʱ��:  00: 00: 00.02
SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.05
SQL> exec proc4;

PL/SQL �����ѳɹ���ɡ�

����ʱ��:  00: 00: 16.02

////////////////////
//-------����д��
//-----����ʱ�� ����ʱ��:  00: 00: 00.56
///////////////////


SQL> drop table t purge;

����ɾ����

����ʱ��:  00: 00: 00.12

SQL> create table t(x int);

���Ѵ�����

����ʱ��:  00: 00: 00.03
SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.05

SQL> insert into t select rownum from dual connect by level<=1000000;

�Ѵ���1000000�С�

����ʱ��:  00: 00: 00.56

///////////////////
///----ֱ��·��
///-----����ʱ�� :  500���� : ����ʱ��:  00: 00: 02.42
///---------------Լ100���� �� 00: 00: 00.48
/////////////////


SQL> drop table t purge;

����ɾ����

����ʱ��:  00: 00: 00.12

SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.05

SQL> create table t as select rownum x from dual connect by level<=5000000;

���Ѵ�����

����ʱ��:  00: 00: 02.42

///////////////
//-----��������
//----�ر���־nologging
//-----����ʱ�䣺500�������� ����ʱ��:  00: 00: 01.80
//----���¶���500��������
//-----------ps����Ϊ��ʹ�ñʼǱ����е��Ż����ԣ��ʼǱ�ֻ��4���ģ������Ż�Ч���������Ч�������ԡ�
///////////////

SQL> drop table t purge;

����ɾ����

����ʱ��:  00: 00: 00.10

SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.05
SQL> create table t nologging parallel 4 as select rownum x from dual connect by level <=5000000;

���Ѵ�����

����ʱ��:  00: 00: 01.80


////////////////
//-----���Ĵ洢����Ϊ�ڴ���
//-------����ʱ�� ����ʱ��:  00: 00: 01.57
//-------��Ϊǰ�汾�����ʹ�ù��壬ƿ�����ڴ����ϣ���������Ч��������
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

����ɾ����

����ʱ��:  00: 00: 00.09
SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.04
SQL> create table t nologging parallel 4 as select rownum x from dual connect by level <=5000000;

���Ѵ�����

����ʱ��:  00: 00: 01.57



/////////////
//---���Ĵ���������
//---Ŀǰƿ�������ݵĴ���
//---����ʱ�� �� ����ʱ��:  00: 00: 00.78
////////////



SQL> create table s nologging parallel 4 as select rownum x from t;

���Ѵ�����

����ʱ��:  00: 00: 00.78


/////////////
//---ֱ��ͨ���������в���
//---����ʱ�� ����ʱ��:  00: 00: 00.32
////////////


SQL> drop table s purge;

����ʱ��:  00: 00: 00.03
SQL> alter system flush shared_pool;

ϵͳ�Ѹ��ġ�

����ʱ��:  00: 00: 00.04
SQL> create table s nologging parallel 4 as select * from t;

���Ѵ�����

����ʱ��:  00: 00: 00.32










