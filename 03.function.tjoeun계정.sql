/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과를 반환
    
    - 단일행 함수 : n개의 값을 읽어들여 n개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수 : n개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/

----------------------------------단일행 함수------------------------------------
=============================================================================
--                              <문자 처리 함수>
=============================================================================
/*
    * LENGTH / LENGTHB => NUMBER로 반환
    
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수를 반환
    LENGTHB(컬럼|'문자열') : 해당 문자열의 BYTE를 반환
    - 한글 : XE버전일 때 => 1글자당 3byte(ㄱ,ㅏ, 등도 1글자에 해당)
             EE버전일 때 =>
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; --- 오라클에서 제공해주는 가상 테이블

SELECT LENGTH('oracle'), LENGTHB('orcale')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

------------------------------------------------------------------------------
/*
    *INSTR : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(반환형: NUMBER)
    -ORACLE은 INDEX번호는 1번부터 시작, 찾는 문자가 없을 때 0 반환
    
    INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]] )
     - 찾을 위치 값
     1 : 앞에서부터 찾기(기본값)
     -1: 뒤에서부터 찾기
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', -1) FROM DUAL;

SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 1,3) FROM DUAL; --1번서부터 'A'를 찾는데 그 중에서 3번째 나오는 'A' INDEX 번호
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', -1,2) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '_')"_위치", INSTR(EMAIL,'@') "@위치" 
FROM EMPLOYEE;

------------------------------------------------------------------------------
/*
    *SUBSTR: 문자열에서 특정 문자열을 추출하여 반환(반환형: CHARACTER)
    
    SUBSTR('문자열', POSITION, [LENGTH])   => [] 표현이 들어간 것은 옵셔널이라는 뜻
    - POSITION : 문자열을 추출할 시작위치 INDEX 
    - LENGTH   : 추출할 문자의 갯수(생략시 맨 끝까지) 
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;

SELECT SUBSTR('ORACLEHTMLCSS', -3) FROM DUAL;null
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;

--EMPLOYEE 테이블에서 주민번호에서 성별만 추출하여 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;


--EMPLOYEE 테이블에서 주민번호에서 성별만 추출하여 여성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8, 1) IN('2','4');

--EMPLOYEE 테이블에서 주민번호에서 성별만 추출하여 남성 사원만 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8, 1) IN('1','3');

--EMPLOYEE 테이블에서 EMAIL에서 아이디만 추출하여 사원명,이메일,아이디 조회

SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;
------------------------------------------------------------------------------
/*
    *LPAD/RPAD : 문자열을 조회할 때 통일감 있게 자리수에 맞춰서 조회하고자 할 때(반환형 CHAR)
    
     LPAD/RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
     문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 n길이 만큼의 문자열 반환
*/

SELECT EMP_NAME, LPAD(EMAIL,25)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,25, '#')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,25, '#')
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 주민번호를 123456-1****** 형식으로 사번,사원명,주민번호 조회
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8),14,'*') 주민번호
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8) ||'******' 주민번호
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    *LTRIM/RTRIM : 문자열에서 특정 문자를 제거한 나머지 반환(반환형: char)
    *TRIM : 문자열의 앞/뒤 양쪽에 있는 특정 문자를 제거한 나머지 반환
    
    [표현법]
    LTRIM/RTRIM('문자열', [제거하고자하는 문자])
    TRIM([LEADING|TRAILING|BOTH] 제거하고자하는 문자들 FROM '문자열') => 제거하고자하는 문자는 1개만 가능
*/

SELECT LTRIM('     TJOEUN     ') ||'더조은' FROM DUAL; --제거할 문자를 안넣으면 공백 제거
SELECT RTRIM('     TJOEUN     ') ||'더조은' FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPTJAVA', 'JAVA') FROM DUAL;
SELECT LTRIM('BAABCABFDSIA', 'ABC') FROM DUAL;
SELECT LTRIM('37284DFAD2446', '0123456789') FROM DUAL;

SELECT RTRIM('JAVAJAVASCRIPTJAVA', 'JAVA') FROM DUAL;
SELECT RTRIM('BAABCABFDSIA', 'ABC') FROM DUAL;
SELECT RTRIM('37284DFAD2446', '0123456789') FROM DUAL;

SELECT TRIM('     TJOEUN     ') ||'더조은' FROM DUAL;

SELECT TRIM(LEADING 'A' FROM 'AAABKDISLAAAA') FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAABKDISLAAAA') FROM DUAL;
SELECT TRIM(BOTH 'A' FROM 'AAABKDISLAAAA') FROM DUAL;
SELECT TRIM('A' FROM 'AAABKDISLAAAA') FROM DUAL; --BOTH 기본값 생략 가능

------------------------------------------------------------------------
/*
    *LOWER/UPPER/INITCAP : 문자열을 모두 대문자로 혹은 소문자로, 첫글자만 대문자로 변환(반환형 : char)
    
    [표현법]
    LOWER/UPPER/INITCAP('문자열')
*/

SELECT LOWER('JAVA JAVASCRIPT Oracle') FROM DUAL;
SELECT UPPER('JAVA JAVASCRIPT Oracle') FROM DUAL;
SELECT INITCAP('JAVA JAVASCRIPT Oracle') FROM DUAL;

------------------------------------------------------------------------
/*
    *CONCAT: 문자열 2개를 전달받아 하나로 합친 문자 반환
    
    [표현법]
    CONCAT('문자열', '문자열')
*/

SELECT CONCAT('Oracle','오라클')FROM DUAL;
SELECT 'Oracle'||'오라클' FROM DUAL;
--SELECT CONCAT('Oracle','오라클','참 재밌어요')FROM DUAL; 문자열 2개만 가능
SELECT 'Oracle'||'오라클'||'참 재밌어요' FROM DUAL;

------------------------------------------------------------------------
/*
    *REPLACE: 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열', '기존문자열', '바꿀문자열')
*/

SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'tjoeun.or.kr', 'naver.com')  --데이터는 대소문자 가림
From Employee;

------------------------------------------------------------------------
/*
    *ABS: 숫자의 절대값을 구해주는 함수
    
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-10)FROM DUAL;

------------------------------------------------------------------------
/*
    *MOD: 두 수를 나눈 나머지값을 반환해주는 함수     
    [표현법]
    MOD(NUMBER, NUMBER)
*/

SELECT MOD(10,3) FROM DUAL;

------------------------------------------------------------------------
/*
    *ROUND: 반올림한 결과를 반환해주는 함수
    
    [표현법]
    ROUND(NUMBER, [위치])
*/

SELECT ROUND(1234.567) FROM DUAL; --위치 생략시 0
SELECT ROUND(12.345) FROM DUAL;
SELECT ROUND(1234.56789, 2) FROM DUAL;
SELECT ROUND(12.34, 4) FROM DUAL;
SELECT ROUND(1234.5678,-2) FROM DUAL;
SELECT ROUND(1734.5678,-3) FROM DUAL;

------------------------------------------------------------------------
/*
    *CEIL : 무조건 올림
    
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.45) FROM DUAL;
SELECT CEIL(-123.45) FROM DUAL;

------------------------------------------------------------------------
/*
    *FLOOR : 무조건 내림
    
    [표현법]
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.45) FROM DUAL;
SELECT FLOOR(-123.45) FROM DUAL;

------------------------------------------------------------------------
/*
    *TRUNC : 위치 지정 가능한 버림처리 함수
    
    [표현법]
    TRUNC(NUMBER, [위치])
*/

SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;

SELECT TRUNC(-123.456) FROM DUAL;
SELECT TRUNC(-123.456, -2) FROM DUAL;

=============================================================================
--                              <날짜 처리 함수>
=============================================================================
/*
    *SYSDATE: 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

------------------------------------------------------------------------------
/*
    *MONTHS_BETWEEN(DATE1,DATE2): 두 날짜 사이의 개월 수
*/
--EMPLOYEE에서 오늘날까지 근무 일수(소수점까지 나옴)
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE 근무일수
FROM EMPLOYEE;

--EMPLOYEE에서 오늘날까지 근무 일수(정수)
SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE - HIRE_DATE) 근무일수
FROM EMPLOYEE;

--EMPLOYEE에서 오늘날까지 근무 개월수(소수점까지)
SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) 근무개월수
FROM EMPLOYEE;

--EMPLOYEE에서 오늘날까지 근무 개월수(정수)
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' 근무개월수
FROM EMPLOYEE;

------------------------------------------------------------------------------
/*
    *ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼의 개월수를 더해 그 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL;

--EMPLOYEE테이블에서 사원명, 입사일, 정직원이 된 날짜(입사일에서 6개월 후)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원 전환 날짜"
FROM EMPLOYEE;

------------------------------------------------------------------------------
/*
    *NEXT_DAY(DATE, 요일(문자|숫자)) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE,'월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'금') FROM DUAL;

--  1 : 일요일
SELECT SYSDATE, NEXT_DAY(SYSDATE, 2) FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; --오류 현재 언어가 KOREA 이기 떄문에

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'금') FROM DUAL; --오류 현재 언어가 AMERICAN 이기 떄문에

ALTER SESSION SET NLS_LANGUAGE = KOREAN;
------------------------------------------------------------------------------
/*
    *LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해주는 함수
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

--EMPLOYEE테이블에서 사원명, 입사일, 입사한 달의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날짜"
FROM EMPLOYEE;

------------------------------------------------------------------------------
/*
    *EXTRACT : 특정날짜로부터 년|월|일 값을 추출하여 반환해주는 함수(반환형: NUMBER)
    
    EXTRACT(YEAR FROM DATE) : 년도만 추출
    EXTRACT(MONTH FROM DATE) : 월만 추출
    EXTRACT(DAY FROM DATE) : 일만 추출
*/

--EMPLOYEE 테이블에서 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, 
    EXTRACT(YEAR FROM HIRE_DATE) 입사년도, 
    EXTRACT(MONTH FROM HIRE_DATE) 입사월,  
    EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
--ORDER BY 2, 3, 4;
ORDER BY 입사년도, 입사월, 입사일;

=============================================================================
--                              <형변환 함수>
=============================================================================
/*
    *TO_CHAR: 숫자나 날짜를 문자타입으로 변환시켜주는 함수
    
    TO_CHAR(숫자|날짜, ['포맷'])    
    
    [출력 시]
    문자타입: 왼쪽 정렬 기본
    숫자타입: 오른쪽 정렬 기본
*/
-------------------------------숫자 타입 => 문자타입
/*
    9: 해당 자리에 숫자를 의미한다.
     - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
    0: 해당 자리에 숫자를 의미한다.
     - 값이 없을 경우 0으로 표시하며, 숫자의 길이를 고정적으로 표시할 때 주로 사용
    FM: 해당 자리에 값이 없을 경우 자리 차지하지 않음.
*/
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234,'999999') FROM DUAL; -- 6칸 공간 확보, 왼쪽 정렬, 빈칸은 공백
SELECT TO_CHAR(1234,'000000') FROM DUAL; -- 6칸 공간 확보, 왼쪽 정렬, 빈칸은 0으로 채움
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; --현재 설정된 나라(LOCAL) 화폐단위(빈칸 공백)

SELECT TO_CHAR(1234123,'L999,999,999') FROM DUAL; ---3자리마다 ,(컴마)

--EMPLOYEE테이블에서 사원명, 급여(￦11,111,111), 연봉(￦11,111,111)
SELECT EMP_NAME, TO_CHAR(SALARY,'L999,999,999') 급여, TO_CHAR(SALARY*12,'L999,999,999') 연봉
FROM EMPLOYEE;

SELECT TO_CHAR(123.456,'FM999990.999'),
        TO_CHAR(1234.56,'FM9990.99'),
        TO_CHAR(0.1000,'FM9999.999'), 
        TO_CHAR(0.1000,'FM9990.999')
        FROM DUAL;
        
SELECT TO_CHAR(123.456,'999990.999'),
        TO_CHAR(1234.56,'9990.99'),
        TO_CHAR(0.1000,'9999.999'), 
        TO_CHAR(0.1000,'9990.999')
        FROM DUAL;
        
-------------------------------날짜 타입 => 문자타입
--시간
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL; --12시간제 형식
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL; -- 24시간제 형식

--날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY')FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DAY') FROM DUAL; --문자열 안에서 ""는 구분하기 위해서 사용하는 것임
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

--EMPLOYEE테이블에서 입사일(25-03-20)
SELECT TO_CHAR(HIRE_DATE, 'YY-MM-DD') FROM EMPLOYEE;
--EMPLOYEE테이블에서 입사일(2024년 3월 20일 화요일)
SELECT TO_CHAR(HIRE_DATE, 'DL') FROM EMPLOYEE;
--EMPLOYEE테이블에서 입사일(25년 03월 20일)
SELECT TO_CHAR(HIRE_DATE, 'YY"년" MM"월" DD"일"') FROM EMPLOYEE;

--년도
/*
    yy는 무조건 앞에'20'이 붙는다
    rr는 50년을 기준으로 50보다 작으면 앞에'20'붙이고, 50보다 크면'19를 붙인다
*/

SELECT HIRE_DATE, 
    TO_CHAR(HIRE_DATE, 'YYYY'),
    TO_CHAR(HIRE_DATE, 'YY'),
    TO_CHAR(HIRE_DATE, 'RRRR')
FROM EMPLOYEE;

--월
SELECT TO_CHAR(SYSDATE, 'MM'),
        TO_CHAR(SYSDATE, 'MON'), -- 영문일때 3글자만
        TO_CHAR(SYSDATE, 'MONTH'), -- 영문일때 다 출력
        TO_CHAR(SYSDATE, 'RM') -- 로마자로
FROM DUAL;

--일
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 년을 기준으로 몇일째
        TO_CHAR(SYSDATE, 'DD'), -- 월을 기준으로 몇일째
        TO_CHAR(SYSDATE, 'D') -- 주를 기준으로 몇일째
FROM DUAL;

--요일
SELECT TO_CHAR(SYSDATE, 'DAY'), 
        TO_CHAR(SYSDATE, 'DY') 
FROM DUAL;

------------------------------------------------------------------------------
/*
    *TO_DATE : 숫자 또는 문자 타입을 날짜 타입으로 변환
    
    *TO_DATE(숫자|문자, [포멧])
*/

SELECT TO_DATE(20241230) FROM DUAL;
SELECT TO_DATE(241230) FROM DUAL;

--SELECT TO_DATE(050101) FROM DUAL; -- 앞이 0일때 오류, 년도는 최소 2숫자 필수
SELECT TO_DATE('050101') FROM DUAL; -- 앞이 0 일때는 문자형태로 넣어야 함.

--SELECT TO_DATE('070204 142530', 'YYMMDD HHMISS') FROM DUAL; -- 오류 : 12시간제인데 14시는 없음.
--SELECT TO_DATE('070204 142530', 'YYMMDD HH24MISS') FROM DUAL; --  시간이 안나옴, 변환후 사용해야 함.

SELECT TO_CHAR(TO_DATE('070204 142530', 'YYMMDD HH24MISS'), 'YY-MM-DD HH:MI:SS') FROM DUAL;

SELECT TO_DATE('040325', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL; -- 현재 세기로 반영

SELECT TO_DATE('040325', 'RRMMDD') FROM DUAL;
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL; -- 50년 미만 현재 세기, 50이상이면 이전 세기 반영

--------------------------------------------------------------------------------
/*
    TO_NUMBER : 문자타입을 숫자타입으로 변환
    
    TO_NUMBER(문자, [포멧])
*/
SELECT TO_NUMBER('012341234') FROM DUAL;
SELECT '1000000' + '5000000' FROM DUAL;     --오라클은 자동 형변환 됨.
SELECT '1,000,000' + '5,000,000' FROM DUAL; --오류 : 특수문자가 포함되어 문자임. 자동형변화 안됨.
SELECT TO_NUMBER('1,000,000','9,999,999') + TO_NUMBER('5,000,000', '9,999,999') FROM DUAL;

=============================================================================
--                              <NULL 처리 함수>
=============================================================================
/*
    NVL(컬럼, 해당컬럼이 NULL일 경우 반환할 값)
*/

SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

--전 사원의 이름, 보너스 포함 연봉
SELECT EMP_NAME, (SALARY*(1+BONUS))*12
FROM EMPLOYEE;

SELECT EMP_NAME,SALARY*(1+ NVL(BONUS,0))*12
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY*NVL(1+BONUS, 1)*12
FROM EMPLOYEE;

-- 사원명,부서코드(부서가 없으면 '부서없음')
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음')
FROM EMPLOYEE;

--------------------------------------------------------------------------
/*
    *NVL2(컬럼, 반환값1, 반환값2)
    - 컬럼에 값이 존재하면 반환값1
    - 컬럼에 값이 존재하지 않으면 반환값2
*/

-- 사원명, 부서(부서에 속해있으면 '부서있음', 부서가 없으면 '부서없음)
SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음', '부서없음')
FROM EMPLOYEE;

--EMPLOYEE테이블에서 사원명, 급여, 보너스, 성과급(보너스를 받는 사람은 50%를 주고, 보너스를 못받는 사람은 10%)
SELECT EMP_NAME,SALARY, NVL(BONUS, 0), SALARY*NVL2(BONUS, 0.5, 0.1) 성과금
FROM EMPLOYEE;