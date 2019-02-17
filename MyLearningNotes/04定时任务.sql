select * from dba_jobs t 
select * from dba_jobs_running

select * from user_jobs t;
select * from user_join_ind_columns

select to_char(sysdate,'ww') from dual 


---创建job,Oracle11gR2 11.2.0.1
declare
  JOB_SEQ number;
begin
  DBMS_JOB.SUBMIT(JOB       => JOB_SEQ, ---注意：JOB_SEQ中的冒号":"再11g没有了,否则报ora-01008错
                  WHAT      => 'PRO_RESET_SEQUENCE_EVERYDAY();', --注意过程后的分号(;)不能忘记
                  NEXT_DATE => sysdate,
                  interval  => 'TRUNC(sysdate, ''mi'') + 1 / (24 * 60)'); --字符串中有 ' 的使用双 ''
  commit; --别忘记commit
end;


--每分钟执行
select TRUNC(sysdate, 'mi') + 1 / (24 * 60) from DUAL
--每隔5分钟执行
select TRUNC(sysdate,'mi')+5/(24*60) from dual 
--每天凌晨0点执行
select trunc(sysdate+1) from dual 
--每天凌晨1点执行
select TRUNC(sysdate+1)+1/24 from dual 
--每天早晨8点30执行
select TRUNC(SYSDATE+1)+(8*60+30)/(24*60) from dual 

select 24 * 60 from dual 

1、每分钟执行
TRUNC(sysdate,'mi')+1/(24*60)
  
2、每天定时执行
例如：
每天凌晨0点执行
TRUNC(sysdate+1)
每天凌晨1点执行
TRUNC(sysdate+1)+1/24
每天早上8点30分执行
TRUNC(SYSDATE+1)+(8*60+30)/(24*60)
 
3、每周定时执行
例如：
每周一凌晨2点执行
TRUNC(next_day(sysdate,1))+2/24
TRUNC(next_day(sysdate,'星期一'))+2/24
每周二中午12点执行
TRUNC(next_day(sysdate,2))+12/24
TRUNC(next_day(sysdate,'星期二'))+12/24
 
4、每月定时执行
例如：
每月1日凌晨0点执行
TRUNC(LAST_DAY(SYSDATE)+1)
每月1日凌晨1点执行
TRUNC(LAST_DAY(SYSDATE)+1)+1/24
 
5、每季度定时执行
每季度的第一天凌晨0点执行
TRUNC(ADD_MONTHS(SYSDATE,3),'q')
每季度的第一天凌晨2点执行
TRUNC(ADD_MONTHS(SYSDATE,3),'q')+2/24
每季度的最后一天的晚上11点执行
TRUNC(ADD_MONTHS(SYSDATE+ 2/24,3),'q')-1/24
 
6、每半年定时执行
例如：
每年7月1日和1月1日凌晨1点执行
ADD_MONTHS(TRUNC(sysdate,'yyyy'),6)+1/24
 
7、每年定时执行
例如：
每年1月1日凌晨2点执行
ADD_MONTHS(TRUNC(sysdate,'yyyy'),12)+2/24
