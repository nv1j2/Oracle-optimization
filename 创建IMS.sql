---������,��������
---oracle�Ľ���˳�򣬲�ѯ��whereʱ��С��ź��档
---���ɸѡwhere��䣬id��ǰ�档��ɸѡ��С��
---joinС����ǰ
---��С��



----sql����Ż�

1.����˳���Ż�
1.1 �����������,��������й���ʱ�������ٵı�ı������ұ�
1.2 �����ֶ����ʱ,��������֮Ϊ�����,�������Ϊ������
    ����������ں���,������ִ���ٶȻ����Կ�ܶࡣ

2.whereִ��˳��
2.1 �ڷ�where�Ӿ�ʱ,���ܹ��˴������ݵ������������±�
2.2 is null ��is not null
    ��Ҫ������Ϊ�����ݻ�Ϊ�յ�����ʱʹ��
    ��ǰ���е�nullΪ����ʱ��is not null,����is null
2.3ʹ�ñ����
    ����ѯʱ���ֶ����ʱ,��ѯʱ���ϱ���,
    ������ּ��ٽ�����ʱ���ֶ�����������﷨����
2.4whereִ���ٶȱ�having��
    �����ܵ�ʹ��where����having
2.5* �������ִ��Ч��
    ��������ʹ��select * �����в�ѯ,�����ѯʹ��*,
    ���ݿ����н�������*ת��Ϊȫ���С�

    
    
3������Ż�
3.1����>=���>  ִ��ʱ>=���>ִ�е�Ҫ�� 
3.2 ��UNION�滻OR (������������) ������Ҫ��OR, ���԰ѷ��ؼ�¼���ٵ�������д����ǰ��
3.3 ��in ����or ִ�л����Ч��
3.4 Union All ��Union
    Union All�ظ�������������������ͬ��¼
    ����������������ݶ���һ��.��ôʹ��Union All ��Union��û�������,  ��Union All���UnionҪִ�еÿ�



    
---��Ӵ洢����,��߶���в�ѯʱ��Ч��

startup pfile='C:\app\oracle\admin\orcl\pfile\init.ora.10252016185549';


Student     Class      Spec     Dept       Teacher      Course
һ��ѧ��,һǧ��༶,һ����רҵ,ʮ���ϵ,��������ʦ,һ������γ�,
    Teaching
ÿ����ʦ�����ڿ�һ��,ÿ���γ�������һ����ʦ��,��ǧ������ڿ���Ϣ,
    Learn
ÿ��ѧ��������һ�ſ�,ÿ�ſ�������һ��ѧ����,�������Ͽ���Ϣ,
    AttendCourse
ÿ����ʦ�����Ͽ�һ����,ÿ��������һ����ʦ�Ͽ�,��ǧ������




-----------------------------------------------
-----------------------------------------------
���·��___Ч�ʽϵ�
-----------------------------------------------
-----------------------------------------------

                                    ---ѧ����
                                    create table Student1 nologging parallel 4 
                                        as select 
                                            rownum StudentNum 
                                            ,dbms_random.string('a',4) Name
                                            ,trunc(dbms_random.value(0,1)) Sex 
                                            ,trunc(dbms_random.value(18,30)) Age 
                                        from xmltable('1 to 100000000')
                                    ;
                                    -----Ϊ�˽�Ĭ�ϴ�����ʱ��Ĭ��Ϊvarchar2(4000)  ת��Ϊchar(4),����Ϊ�˷�ֹ�ڴ����ñ�������һ��
                                    -----������ʵ������ dbms_random.string('a',4) as char(4) Name
                                    create table Student1 (StudentNum number , Name char(4) , Sex number , Age number ,ClassNum number)

                                    ;

                                    insert into Student (StudentNum,Name,Sex,Age) select * from Student1 ;

                                    drop table Student1 purge ;


                                    --�༶��
                                    create table Class1 nologging parallel 4
                                        as select
                                            rownum ClassNum
                                            ,sys_guid() ClassName
                                        from xmltable('1 to 10000000')
                                    ;    

                                    create table Class (ClassNum number , ClassName char(32),SpecNum number);

                                    insert into Class(ClassNum,ClassName) select * from Class1;

                                    drop table Class1 purge ;

                                    ---���༶����ѧ�������
                                    ---Ϊ�˷�ֹ���ֿհ༶
                                    update Student set ClassNum = rownum where rownum <= 10000000;
                                    -----������������ʵЧ�ʲ��ߣ�Ӧ���ڴ���ʱֱ�Ӳ������id���ڰ�ǰ10000000 rownum���θ�ֵ
                                    update Student set ClassNum = trunc(dbms_random.value(1,10000000)) where Student.ClassNum is null;



                                    ---רҵ��

                                    create table Spec1 nologging parallel 4
                                        as select
                                            rownum ClassNum
                                            ,dbms_random.string('a',5) Name
                                        from xmltable('1 to 1000000')
                                    ;

                                    create table Spec(ClassNum number,SpecName char(5),DeptName number);

                                    insert into Spec(number,SpecName) select * from Spec1

                                    drop table Spec1 purge ;

                                    update Class set SpecNum = rownum where rownum <= 1000000 ;

                                    update Class set SpecNum = trunc(dbms_random.value(1,1000000)) where Class.SpecNum is null ;

                                    drop table Spec1 purge ;
                                    ---ϵ��
                                    create table Dept nologging parallel 4
                                        as select
                                            rownum DeptNum
                                            ,sys_guid() DeptName
                                            ,sys_guid() Director
                                            ,trunc(dbms_random.value(13000000000,13999999999)) PhoneNum
                                        from xmltable('1 to 100000')
                                    ;

                                    update Spec set DeptNum = rownum where rownum <=100000;
                                    update Spec set DeptNum = rownum where Spec.DeptName is null ;


--------------------------------------------------------------
����ʧЧ ��Ϊ����
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------



---�����
create table Student(
    StudentNum number , 
    Name char(4) not null, 
    Sex number not null, 
    Age number not null,
    ClassNum number
) ;--ѧ���� 

create table Class (
    ClassNum number , 
    ClassName char(32),
    SpecNum number
);--�༶��

create table Spec(
    SpecNum number,
    SpecName char(5),
    DeptNum number
);--רҵ��


create table Dept(
    DeptNum number,
    DeptName char(32),
    Director char(32),
    PhoneNum char(11)
);--ϵ��

create table Teacher(
    TeacherNum number , 
    TeacherName char(32) , 
    Sex number not null, 
    Age number not null,  
    Title number not null, 
    PhoneNum char(11) , 
    DeptNum number
);--��ʦ��


create table Course(
    CourseNum number,
    CourseName char(32)
);--�γ̱�


create table Teaching (
    TeacherNum number
    ,CourseNum number
);--��ѧ��

create table Learn1(
    StudentNum number not null
    ,CourseNum number not null
    ,Results number
);--ѧϰ��


create table AttendCourse(
    ClassNum number
    ,TeacherNum number
);--�Ͽα�


---���ӱ�ռ�
alter tablespace SYSTEM add datafile 'C:\app\oracle\oradata\orcl\SYSTEM02.DBF' size 2m ;

ALTER TABLESPACE SYSTEM ADD DATAFILE
'C:\app\oracle\oradata\orcl\SYSTEM02.DBF' SIZE 512M
AUTOEXTEND ON NEXT 128M MAXSIZE 32G;


ALTER DATABASE DATAFILE 'C:\app\oracle\oradata\orcl\SYSTEM02.DBF' 
AUTOEXTEND ON NEXT 5M ;

--��������
create index Class_id on Class(ClassNum) compress;
create index Spec_id on Spec(SpecNum) compress;
create index Dept_id on Dept(DeptNum) compress;
create index Learn_StudentNum on Learn(StudentNum) compress;
create index Learn_CourseNum on Learn(CourseNum) compress;
create index Course_id on Course(CourseNum) compress;
create index Teacher_id on Teacher(TeacherNum) compress;
create index Student_id on student(studentNum) compress ;



////////////////////////
///������
///////////////////////

----ѧ����
create table Student1 nologging parallel 4 
    as select 
        rownum StudentNum 
        ,dbms_random.string('a',4) Name 
        ,trunc(dbms_random.value(0,2)) Sex 
        ,trunc(dbms_random.value(18,30)) Age 
        ,trunc(dbms_random.value(1,10000001)) ClassNum
    from xmltable('1 to 100000000')
;

create table Student(StudentNum number , Name char(4) not null, Sex number not null, Age number not null,ClassNum number) 
    partition by range (StudentNum)(
        partition Student_num_0 values less than(1000000)
        ,partition Student_num_1 values less than(2000000)
        ,partition Student_num_2 values less than(3000000)
        ,partition Student_num_3 values less than(4000000)
        ,partition Student_num_4 values less than(5000000)
        ,partition Student_num_5 values less than(6000000)
        ,partition Student_num_6 values less than(7000000)
        ,partition Student_num_7 values less than(8000000)
        ,partition Student_num_8 values less than(9000000)
        ,partition Student_num_9 values less than(10000000)
        ,partition Student_num_10 values less than(11000000)
        ,partition Student_num_11 values less than(12000000)
        ,partition Student_num_12 values less than(13000000)
        ,partition Student_num_13 values less than(14000000)
        ,partition Student_num_14 values less than(15000000)
        ,partition Student_num_15 values less than(16000000)
        ,partition Student_num_16 values less than(17000000)
        ,partition Student_num_17 values less than(18000000)
        ,partition Student_num_18 values less than(19000000)
        ,partition Student_num_19 values less than(20000000)
        ,partition Student_num_20 values less than(21000000)
        ,partition Student_num_21 values less than(22000000)
        ,partition Student_num_22 values less than(23000000)
        ,partition Student_num_23 values less than(24000000)
        ,partition Student_num_24 values less than(25000000)
        ,partition Student_num_25 values less than(26000000)
        ,partition Student_num_26 values less than(27000000)
        ,partition Student_num_27 values less than(28000000)
        ,partition Student_num_28 values less than(29000000)
        ,partition Student_num_29 values less than(30000000)
        ,partition Student_num_30 values less than(31000000)
        ,partition Student_num_31 values less than(32000000)
        ,partition Student_num_32 values less than(33000000)
        ,partition Student_num_33 values less than(34000000)
        ,partition Student_num_34 values less than(35000000)
        ,partition Student_num_35 values less than(36000000)
        ,partition Student_num_36 values less than(37000000)
        ,partition Student_num_37 values less than(38000000)
        ,partition Student_num_38 values less than(39000000)
        ,partition Student_num_39 values less than(40000000)
        ,partition Student_num_40 values less than(41000000)
        ,partition Student_num_41 values less than(42000000)
        ,partition Student_num_42 values less than(43000000)
        ,partition Student_num_43 values less than(44000000)
        ,partition Student_num_44 values less than(45000000)
        ,partition Student_num_45 values less than(46000000)
        ,partition Student_num_46 values less than(47000000)
        ,partition Student_num_47 values less than(48000000)
        ,partition Student_num_48 values less than(49000000)
        ,partition Student_num_49 values less than(50000000)
        ,partition Student_num_50 values less than(51000000)
        ,partition Student_num_51 values less than(52000000)
        ,partition Student_num_52 values less than(53000000)
        ,partition Student_num_53 values less than(54000000)
        ,partition Student_num_54 values less than(55000000)
        ,partition Student_num_55 values less than(56000000)
        ,partition Student_num_56 values less than(57000000)
        ,partition Student_num_57 values less than(58000000)
        ,partition Student_num_58 values less than(59000000)
        ,partition Student_num_59 values less than(60000000)
        ,partition Student_num_60 values less than(61000000)
        ,partition Student_num_61 values less than(62000000)
        ,partition Student_num_62 values less than(63000000)
        ,partition Student_num_63 values less than(64000000)
        ,partition Student_num_64 values less than(65000000)
        ,partition Student_num_65 values less than(66000000)
        ,partition Student_num_66 values less than(67000000)
        ,partition Student_num_67 values less than(68000000)
        ,partition Student_num_68 values less than(69000000)
        ,partition Student_num_69 values less than(70000000)
        ,partition Student_num_70 values less than(71000000)
        ,partition Student_num_71 values less than(72000000)
        ,partition Student_num_72 values less than(73000000)
        ,partition Student_num_73 values less than(74000000)
        ,partition Student_num_74 values less than(75000000)
        ,partition Student_num_75 values less than(76000000)
        ,partition Student_num_76 values less than(77000000)
        ,partition Student_num_77 values less than(78000000)
        ,partition Student_num_78 values less than(79000000)
        ,partition Student_num_79 values less than(80000000)
        ,partition Student_num_80 values less than(81000000)
        ,partition Student_num_81 values less than(82000000)
        ,partition Student_num_82 values less than(83000000)
        ,partition Student_num_83 values less than(84000000)
        ,partition Student_num_84 values less than(85000000)
        ,partition Student_num_85 values less than(86000000)
        ,partition Student_num_86 values less than(87000000)
        ,partition Student_num_87 values less than(88000000)
        ,partition Student_num_88 values less than(89000000)
        ,partition Student_num_89 values less than(90000000)
        ,partition Student_num_90 values less than(91000000)
        ,partition Student_num_91 values less than(92000000)
        ,partition Student_num_92 values less than(93000000)
        ,partition Student_num_93 values less than(94000000)
        ,partition Student_num_94 values less than(95000000)
        ,partition Student_num_95 values less than(96000000)
        ,partition Student_num_96 values less than(97000000)
        ,partition Student_num_97 values less than(98000000)
        ,partition Student_num_98 values less than(99000000)
        ,partition Student_num_99 values less than(100000000)
        ,partition Student_num_max values less than (maxvalue)
    )
;


insert into Student select * from Student1 ;

update Student set StudentNum = rownum where rownum<=10000000;

drop table Student1 purge ;


---�༶��
create table Class1 nologging parallel 4
    as select
        rownum ClassNum
        ,sys_guid() ClassName
        ,trunc(dbms_random.value(1,1000001)) SpecNum
    from xmltable('1 to 10000000')
;    

create table Class (ClassNum number , ClassName char(32),SpecNum number);

insert into Class select * from Class1;

drop table Class1 purge ;

update Class set SpecNum = rownum where rownum <= 1000000 ;


----רҵ��
create table Spec1 nologging parallel 4
    as select
        rownum SpecNum
        ,dbms_random.string('a',5) SpecName
        ,trunc(dbms_random.value(1,100001)) DeptNum
    from xmltable('1 to 1000000')
;

create table Spec(SpecNum number,SpecName char(5),DeptNum number);

insert into Spec select * from Spec1;

drop table Spec1 purge ;

update Spec set DeptNum = rownum where rownum <= 100000 ;

----ϵ��
create table Dept1 nologging parallel 4
    as select
        rownum DeptNum
        ,sys_guid() DeptName
        ,sys_guid() Director
        ,to_char(trunc(dbms_random.value(13000000000,14000000000))) PhoneNum
    from xmltable('1 to 100000')
;

create table Dept(DeptNum number,DeptName char(32),Director char(32),PhoneNum char(11));

insert into Dept select * from Dept1 ;

drop table Dept1 purge ;

---��ʦ��
create table Teacher1 nologging parallel 4
    as select
        rownum TeacherNum
        ,sys_guid() TeacherName
        ,trunc(dbms_random.value(0,2)) Sex
        ,trunc(dbms_random.value(20,60)) Age
        ,trunc(dbms_random.value(1,10)) Title
        ,to_char(trunc(dbms_random.value(13000000000,14000000000))) PhoneNum
        ,trunc(dbms_random.value(1,100001)) DeptNum
    from xmltable('1 to 5000000')
;

create table Teacher(TeacherNum number , TeacherName char(32) , Sex number not null, Age number not null,  Title number not null, PhoneNum char(11) , DeptNum number);

insert into Teacher select * from Teacher1 ;

drop table Teacher1 purge ;

update Teacher set DeptNum = rownum where rownum <= 100000 ;

---�γ̱�
create table Course1 nologging parallel 4
    as select
        rownum CourseNum
        ,sys_guid() CourseName
    from xmltable('1 to 1000000')
;
create table Course(CourseNum number,CourseName char(32));

insert into Course select * from Course1 ;

drop table Course1 purge ;

---��ѧ��
create table Teaching1 nologging parallel 4
    as select
    rownum TeacherNum
    ,trunc(dbms_random.value(1,1000001)) CourseNum
    from xmltable('1 to 5000000')
;    
   
create table Teaching2 nologging parallel 4
    as select
        trunc(dbms_random.value(1,5000001)) TeacherNum
        ,rownum CourseNum
    from xmltable('1 to 1000000')
;

create table Teaching nologging parallel 4
    as select
        trunc(dbms_random.value(1,5000001)) TeacherNum
        ,trunc(dbms_random.value(1,1000001)) CourseNum
    from xmltable('1 to 19000000')
;

insert into Teaching select * from Teaching1 ;

insert into Teaching select * from Teaching2 ;

drop table Teaching1 purge ;

drop table Teaching2 purge ;



-----ѧϰ��
create table Learn1 nologging parallel 4
    as select
        rownum StudentNum
        ,trunc(dbms_random.value(1,1000001)) CourseNum
        ,trunc(dbms_random.value(1,101)) Results
    from xmltable('1 to 100000000')
;

create table Learn2 nologging parallel 4
    as select
        trunc(dbms_random.value(1,100000001)) StudentNum
        ,rownum CourseNum
        ,trunc(dbms_random.value(1,101)) Results
    from xmltable('1 to 1000000')
;

create table Learn nologging parallel 4
    as select
        trunc(dbms_random.value(1,100000001)) StudentNum
        ,trunc(dbms_random.value(1,1000001)) CourseNum
        ,trunc(dbms_random.value(1,101)) Results
    from xmltable('1 to 199000000')
;

insert into Learn select * from Learn1 ;

insert into Learn select * from Learn2 ;

drop table Learn1 purge ;

drop table Learn2 purge ;




----�Ͽα�

create table AttendCourse1 nologging parallel 4
    as select
        rownum ClassNum
        ,trunc(dbms_random.value(1,5000001)) TeacherNum
    from xmltable('1 to 1000000')
;

create table AttendCourse2 nologging parallel 4
    as select
        trunc(dbms_random.value(1,1000001)) ClassNum
        ,rownum TeacherNum
    from xmltable('1 to 5000000')
;

create table AttendCourse nologging parallel 4
    as select
        trunc(dbms_random.value(1,1000001)) ClassNum
        ,trunc(dbms_random.value(1,5000001)) TeacherNum
    from xmltable('1 to 64000000')
; 

insert into AttendCourse select * from AttendCourse1 ;

insert into AttendCourse select * from AttendCourse2 ;
    
drop table AttendCourse1 purge ;

drop table AttendCourse2 purge ;



-----------------��ѯ
set timing on --��ִ��ʱ��
set autotrace off   -- �ر�ִ�мƻ�,��ʾ���(Ĭ��)
set autotrace traceonly -- ����ִ�мƻ�,����ʾ���



---��ѯѧ����Ϣ
------Student * Class * Spec * Dept

select ss.StudentNum ѧ�����, ss.Name ���� , ss.Sex �Ա� , ss.Age ���� , ss.ClassName �༶��, ss.ClassNum �༶�� , ss.SpecNum רҵ��, ss.SpecName רҵ�� ,d.DeptNum ϵ��, d.DeptName ϵ�� from
    (
        select sc.StudentNum, sc.Name , sc.Sex , sc.Age , sc.ClassNum , sc.ClassName , sc.SpecNum , sp.SpecName , sp.DeptNum from 
        (
            select s.StudentNum, s.Name , s.Sex , s.Age , s.ClassNum , c.ClassName , c.SpecNum from
                (select StudentNum,Name,Sex,Age,ClassNum from Student where Student.StudentNum = 54443345) s
                left join
                (select ClassNum,ClassName,SpecNum from Class ) c
            on c.ClassNum = s.ClassNum 
        )sc
        left join
        (select SpecNum,SpecName,DeptNum from Spec) sp
        on sp.SpecNum = sc.SpecNum
    )ss
left join
(select DeptNum , DeptName from Dept) d
on d.DeptNum = ss.DeptNum
;

---��ѯѧ���ɼ�
---Student * Learn * Course
select sl.StudentNum ѧ����� ,  sl.Name ���� , c.CourseName �γ��� , sl.Results �ɼ� from 
    (
        select s.StudentNum, s.Name , l.CourseNum , l.Results from
            (select StudentNum,Name,Sex,Age,ClassNum from Student where Student.StudentNum = 345356) s
            left join
            (select StudentNum,CourseNum,Results from Learn ) l
        on l.StudentNum = s.StudentNum 
    ) sl
left join
(select CourseNum , CourseName from Course) c
on sl.CourseNum = c.CourseNum;



---��ѯ�γ����гɼ�
---Course * Learn * Student
select cl.CourseNum �γ̱��, cl.CourseName �γ���, cl.StudentNum ѧ����� , cl.Results �ɼ�, s.Name ѧ������ from
    (
        select c.CourseNum,c.CourseName,l.StudentNum,l.Results from
            (select CourseNum , CourseName from Course where CourseNum = 88744)c
            left join
            (select StudentNum,CourseNum,Results from Learn ) l
        on c.CourseNum = l.CourseNum 
    ) cl
    left join
    (select StudentNum , Name from Student)s
on cl.StudentNum = s.StudentNum;


---��ʦ��Ϣ
--Teacher * Dept
select t.TeacherNum ��ʦ��� , t.TeacherName ��ʦ���� , t.Sex �Ա�, t.Age ���� , t.Title ְ�� , t.PhoneNum �绰���� , t.DeptNum ϵ���, d.DeptName ϵ�� from
    (select TeacherNum , TeacherName , Sex , Age , Title ,PhoneNum ,DeptNum from Teacher where TeacherNum = 34544) t
    left join
    (select DeptNum , DeptName from Dept) d
on t.DeptNum = d.DeptNum ;


---��ʦ�ڿ���Ϣ
---Teaching * Teacher * Course
select th.TeacherNum ��ʦ���, th.CourseNum �γ̱��, c.CourseName �γ���, th.TeacherName ��ʦ����, th.Title ְ��, th.PhoneNum �绰����, th.DeptNum ϵ���  from
    (
        select ti.TeacherNum , ti.CourseNum , t.TeacherName , t.Title , t.PhoneNum , t.DeptNum from
            (select TeacherNum,CourseNum from Teaching where TeacherNum = 4558454) ti
            left join
            (select TeacherNum , TeacherName , Title ,PhoneNum ,DeptNum from Teacher) t
        on t.TeacherNum = ti.TeacherNum
    ) th
    left join
    (select CourseNum , CourseName from Course) c
on th.CourseNum = c.CourseNum ;