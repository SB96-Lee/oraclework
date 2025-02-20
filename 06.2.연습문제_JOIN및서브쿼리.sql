-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 1) = '7'
AND SUBSTR(EMP_NAME, 1, 1) = '전'
AND SUBSTR(EMP_NO, 8, 1) IN('2','4');

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, 
        TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'), 'YYYY') 나이, 
        DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 6) = (SELECT MAX(SUBSTR(EMP_NO, 1, 6))
                                 FROM EMPLOYEE);
 
--위의 형식으로 할 시에는 년도가 00년생 이후부터는 숫자 합이 오히려 낮아짐으로 원하지 않은 결과가 나올 수 있음.                                 
SELECT EMP_ID, EMP_NAME, 
TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'), 'YYYY') 나이, 
DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'), 'YYYY') = 
            (SELECT MAX(TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD'), 'YYYY'))
            FROM EMPLOYEE);
            
-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회.
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%하%';

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE IN ('D5','D6');

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND BONUS IS NOT NULL
ORDER BY DEPT_TITLE, LOCAL_NAME;

-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN('한국','일본')
ORDER BY NATIONAL_NAME DESC;

-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하정연')
AND EMP_NAME != '하정연';


-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE NVL(BONUS, 0) = 0
AND JOB_CODE IN ('J4','J7'); 

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회

SELECT 
    COUNT(CASE WHEN ENT_YN = 'Y' THEN 1 END) AS 퇴사자,
    COUNT(CASE WHEN ENT_YN = 'N' THEN 1 END) AS 비퇴사자
FROM EMPLOYEE;

SELECT ENT_YN, COUNT(*)
FROM EMPLOYEE
GROUP BY ENT_YN;


-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회

--ROWNUM 이용 시
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, ROWNUM 순위
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, SALARY*NVL(1+BONUS, 1)*12 연봉
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
        JOIN JOB USING(JOB_CODE)
        ORDER BY 연봉 DESC
        )
WHERE ROWNUM < 6;

--RANK() OVER 사용할 시 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 연봉, 순위
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, SALARY*NVL(1+BONUS, 1)*12 연봉,
        RANK() OVER(ORDER BY (SALARY*NVL(1+BONUS, 1)*12) DESC) 순위
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
        JOIN JOB USING(JOB_CODE)
        )
WHERE 순위 <= 5;

-- 12. 부서 별 급여 합계가 / 전체 급여 총 합의 20%보다 많은 / 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용
--부서별 급여합계
SELECT DEPT_TITLE, SUM(SALARY) 급여합
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;
--전체급여 총합의 20%
SELECT SUM(SALARY)*0.2
FROM EMPLOYEE;


SELECT DEPT_TITLE, SUM(SALARY) 급여합
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= (SELECT SUM(SALARY)*0.2
                        FROM EMPLOYEE);

-- 12-2. 인라인 뷰 사용
SELECT *
FROM(SELECT DEPT_TITLE, SUM(SALARY) 급여합
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) 
        GROUP BY DEPT_TITLE)
WHERE 급여합 >= (SELECT SUM(SALARY)*0.2
                        FROM EMPLOYEE);
                        
-- 12-3. WITH 사용

WITH 예비1 AS (SELECT DEPT_TITLE, SUM(SALARY) 급여합
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) 
        GROUP BY DEPT_TITLE)
        
SELECT DEPT_TITLE, 급여합
FROM 예비1
WHERE 급여합 >= (SELECT SUM(SALARY)*0.2
                        FROM EMPLOYEE);
                        
-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;

-- 14. WITH를 이용하여 급여합과 급여평균 조회
WITH 급여조회 AS (SELECT SUM(SALARY) 급여합, ROUND(AVG(SALARY)) 급여평균
             FROM EMPLOYEE)

SELECT *
FROM 급여조회;

