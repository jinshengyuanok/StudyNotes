select * from dba_jobs t 
select * from dba_jobs_running

select * from user_jobs t;
select * from user_join_ind_columns

select to_char(sysdate,'ww') from dual 


---����job,Oracle11gR2 11.2.0.1
declare
  JOB_SEQ number;
begin
  DBMS_JOB.SUBMIT(JOB       => JOB_SEQ, ---ע�⣺JOB_SEQ�е�ð��":"��11gû����,����ora-01008��
                  WHAT      => 'PRO_RESET_SEQUENCE_EVERYDAY();', --ע����̺�ķֺ�(;)��������
                  NEXT_DATE => sysdate,
                  interval  => 'TRUNC(sysdate, ''mi'') + 1 / (24 * 60)'); --�ַ������� ' ��ʹ��˫ ''
  commit; --������commit
end;


--ÿ����ִ��
select TRUNC(sysdate, 'mi') + 1 / (24 * 60) from DUAL
--ÿ��5����ִ��
select TRUNC(sysdate,'mi')+5/(24*60) from dual 
--ÿ���賿0��ִ��
select trunc(sysdate+1) from dual 
--ÿ���賿1��ִ��
select TRUNC(sysdate+1)+1/24 from dual 
--ÿ���糿8��30ִ��
select TRUNC(SYSDATE+1)+(8*60+30)/(24*60) from dual 

select 24 * 60 from dual 

1��ÿ����ִ��
TRUNC(sysdate,'mi')+1/(24*60)
  
2��ÿ�춨ʱִ��
���磺
ÿ���賿0��ִ��
TRUNC(sysdate+1)
ÿ���賿1��ִ��
TRUNC(sysdate+1)+1/24
ÿ������8��30��ִ��
TRUNC(SYSDATE+1)+(8*60+30)/(24*60)
 
3��ÿ�ܶ�ʱִ��
���磺
ÿ��һ�賿2��ִ��
TRUNC(next_day(sysdate,1))+2/24
TRUNC(next_day(sysdate,'����һ'))+2/24
ÿ�ܶ�����12��ִ��
TRUNC(next_day(sysdate,2))+12/24
TRUNC(next_day(sysdate,'���ڶ�'))+12/24
 
4��ÿ�¶�ʱִ��
���磺
ÿ��1���賿0��ִ��
TRUNC(LAST_DAY(SYSDATE)+1)
ÿ��1���賿1��ִ��
TRUNC(LAST_DAY(SYSDATE)+1)+1/24
 
5��ÿ���ȶ�ʱִ��
ÿ���ȵĵ�һ���賿0��ִ��
TRUNC(ADD_MONTHS(SYSDATE,3),'q')
ÿ���ȵĵ�һ���賿2��ִ��
TRUNC(ADD_MONTHS(SYSDATE,3),'q')+2/24
ÿ���ȵ����һ�������11��ִ��
TRUNC(ADD_MONTHS(SYSDATE+ 2/24,3),'q')-1/24
 
6��ÿ���궨ʱִ��
���磺
ÿ��7��1�պ�1��1���賿1��ִ��
ADD_MONTHS(TRUNC(sysdate,'yyyy'),6)+1/24
 
7��ÿ�궨ʱִ��
���磺
ÿ��1��1���賿2��ִ��
ADD_MONTHS(TRUNC(sysdate,'yyyy'),12)+2/24
