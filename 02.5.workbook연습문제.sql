--전체 학과명, 계열 조회
SELECT DEPARTMENT_NAME "학과 명", CATEGORY 계열
FROM TB_DEPARTMENT;

--학과별 정원 조회
SELECT DEPARTMENT_NAME ||'의 '||'정원은 '||CAPACITY||'명 입니다.' "학과별 정원"
FROM TB_DEPARTMENT;