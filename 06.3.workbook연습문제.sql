--1. 학생이름과 주소지 표시
SELECT STUDENT_NAME 학생이름, STUDENT_ADDRESS 학생주소지
FROM TB_STUDENT
ORDER BY STUDENT_NAME;

--2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'  
ORDER BY TO_NUMBER(CASE 
                    WHEN TO_NUMBER(SUBSTR(STUDENT_SSN, 1,2)) >= 0
                    AND TO_NUMBER(SUBSTR(STUDENT_SSN, 1,2)) <= 25
                    THEN '20' || SUBSTR(STUDENT_SSN, 1,2)
                    ELSE '19' || SUBSTR(STUDENT_SSN, 1,2)
                    END) DESC;
                    
--3 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생 이름, 학번, 주소를 이름의 오름차순
SELECT STUDENT_NAME, STUDENT_NO, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_ADDRESS,1,3) = '강원도' 
OR SUBSTR(STUDENT_ADDRESS,1,3) = '경기도'
AND SUBSTR(STUDENT_NO,1,1) != 'A'
ORDER BY STUDENT_NAME;

--4. 현재 법학과 교수중 가장 나이가 많은 사람부터 이름 확인 (학과코드는 DEPARTMENT 참고)
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '005'
ORDER BY PROFESSOR_SSN;

--5. 2004년 2학기에 'C3118100' 과목 수강한 학생들의 학점, 학점이 높은 학생부터 표시, 학점이 같으면 학번이 낮은 학생부터
SELECT STUDENT_NO, POINT
FROM TB_GRADE
WHERE TERM_NO = 200402
AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO;

--6. 학생번호, 이름, 학과이름을 학생이름 오름차순으로 정렬하여 출력
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME;

--7 대학교 과목이름과 과목의 학과 이름을 출력
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

--8 과목 이름, 과목별 교수이름
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
ORDER BY PROFESSOR_NAME;

--9. 8번의 결과에서 인문사회 계열에 속한 교수 이름 찾기
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.CATEGORY = '인문사회'
ORDER BY PROFESSOR_NAME, CLASS_NAME;

--10. '음악학과' 학생들의 평점 구하려고함, 음학학과 학생의 학번,학생이름,전체평점을 출력 
SELECT S.STUDENT_NO, S.STUDENT_NAME, SUM(POINT) 전체평점
FROM TB_STUDENT S
JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '음악학과'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME;

--11. 학번이 A313047인 학생이 학교에 안나옴. 학과이름, 학생이름, 지도교수이름 출력
SELECT DEPARTMENT_NAME 학과이름, STUDENT_NAME 학생이름, PROFESSOR_NAME 지도교수이름
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

--12 2007년도에 '인간관계론' 과목을 수강한 학생 찾아 학생이름과 수강학기 출력
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
JOIN TB_CLASS USING (CLASS_NO)
WHERE CLASS_NAME = '인간관계론'
AND SUBSTR(TERM_NO, 1, 4) = '2007'
ORDER BY STUDENT_NAME, TERM_NO;

--13 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 과목이름, 학과이름 출력
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
WHERE CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL
ORDER BY CLASS_NAME, DEPARTMENT_NAME;

--14 서반아어학과 학생들의 지도교수 게시, 학생이름과 지도교수 이름 출력,
--만약에 지도교수가 없다면 '지도교수 미지정' 표시, 고학번 학생들 먼저 표시
SELECT STUDENT_NAME, NVL(PROFESSOR_NAME, '지도교수 미지정')
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR P ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

--15 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생 찾아 학번, 이름, 학과이름, 평점 출력
SELECT S.STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME, AVG(POINT) 평점
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY S.STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 1;

--16 환경조경학과 전공과목들의 과목 별 평점을 파악
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM 