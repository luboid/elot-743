create or replace package GreekChar is

  -- Author  : LYUBOMIR.LYUBENOV
  -- Created : 30.10.2015 ã. 09:47:10
  -- Purpose : 

function translate(i_greek in VARCHAR2) return VARCHAR2;
  

end GreekChar;
/
create or replace package body GreekChar is

function translate(i_greek in VARCHAR2) return varchar2
as language java name 'GreekChar.translate(java.lang.String) return java.lang.String';

end GreekChar;
/
