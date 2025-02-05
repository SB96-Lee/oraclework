/*
    <GROUP BY 절>
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

--각 부서별 총 급여액
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--각 부서별 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 직급별 사원수와 급여의 총합  
SELECT JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 직급별 사원수와 보너스를 받는 사원수, 급여합, 평균급여, 최저급여, 최고급여
SELECT JOB_CODE, COUNT(*)"직급별 사원수", COUNT(BONUS)"보너스 받는 사원수", SUM(SALARY) 총급여합, ROUND(AVG(SALARY))평균급여, MIN(SALARY)최저급여, MAX(SALARY)최고급여
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

--남,여 별 사원수
SELECT DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여','3','남','4','여') 성별, COUNT(*) 사원수
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여','3','남','4','여');

--모든 DB 다 사용

SELECT CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '남'
                    WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '여'
                    WHEN SUBSTR(EMP_NO,8,1) = '3' THEN '남'
                    WHEN SUBSTR(EMP_NO,8,1) = '4' THEN '여'
            END "성별 사원수"
            , COUNT(*)
FROM EMPLOYEE
GROUP BY CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '남'
                         WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '여'
                         WHEN SUBSTR(EMP_NO,8,1) = '3' THEN '남'
                         WHEN SUBSTR(EMP_NO,8,1) = '4' THEN '여'
                 END;


--GROUP BY절에 여러 칼럼 기술 가능
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;

-------------------------------------------------------------------------------
/*
   <HAVING 절>
   그룹에 대한 조건을 제시할 때 사용되는 구문
*/
--각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

---------------------------- 실습문제------------------------------
--1. 직급별 총 급여합(단, 직급별 급여합이 1000만원 이상인 직급만 조회) 직급코드, 급여합 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE;

--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

/*
    <SELECT문 실행 순서>
    FROM
    ON : 조인 조건 확인
    JOIN : 테이블간의 조인
    WHERE
    GROUP BY
    HAVING
    SELECT
    DISTINCT
    ORDER BY
*/

-----------------------------------------------------------------------------
/*
    <집계함수>
    그룹별로 산출된 결과 값에 중간집계를 계산해 주는 함수
    
    ROLLUP, CUBE
    => GROUP BY 절에만 기술하는 함수
    
    -ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
    -CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2도 중간집계를 내는 함수
*/
--각 직급별 급여의 합
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;
--컬럼이 1개 일때는 CUBE, ROLLUP, 안쓴 것 모두 동일함

--ROLLUP
SELECT JOB_CODE, DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE, DEPT_CODE)
ORDER BY JOB_CODE, DEPT_CODE;

--CUBE
SELECT JOB_CODE, DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE, DEPT_CODE)
ORDER BY JOB_CODE, DEPT_CODE;

-----------------------------------------------------------------------------
/*
    <집합 연산자>
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    -UNION: OR|합집합
    -INTERSECT : AND|교집합
    -UNION ALL: 합집합 + 교집합
    -MINUS : 차집합    => A 집합에서 B 집합을 뺸 나머지
*/

-------------------------1. Union----------------------------------------------
--부서코드가 D5인 사원 또는 급여 300만원 초과인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--OR
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;