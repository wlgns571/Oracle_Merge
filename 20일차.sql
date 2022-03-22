/*
    MERGE 특정 조건에 따라 INSERT OR UPDATE, DELETE 수행
    
    MERGE INTO 대상테이블 a
    USING DUAL <- 비교 테이블
            (SELECT... )
            
    ON( )  조건
    WHEN MATCHED THEN
     on의 조건이 맞을 때
     update
     
    WHEN NOT MATCHED THEN
     on의 조건이 맞지 않을 때
     insert
*/

-- MERGE DUAL문으로 쓸 경우
MERGE INTO MOVIE a
USING DUAL
ON(a.MOVIE_CODE = '비교값')
WHEN MATCHED THEN
 UPDATE SET a.MOVIE_SCORE = '업데이트 값'
WHEN NOT MATCHED THEN
 INSERT (a.MOVIE_CODE, MOVIE_NM) VALUES ('코드값','영화명')
;

SELECT *
FROM 과목;
-- 과목 테이블에 '빅데이터' 과목이 없으면 INSERT (과목명 : 빅데이터, 학점 : 2)
--                             있으면 학점을 3으로 UPDATE
MERGE INTO 과목 a
USING DUAL
ON(a.과목이름 = '빅데이터')
WHEN MATCHED THEN
 UPDATE SET 학점 = 3
WHEN NOT MATCHED THEN
 INSERT (a.과목번호, a.과목이름, a.학점) 
 VALUES ((SELECT NVL(MAX(과목번호),0)+1 FROM 과목 )
         ,'빅데이터'
         , 2
         );
         
MERGE INTO 과목 a
USING DUAL
ON(a.과목이름 = :1)
WHEN MATCHED THEN
 UPDATE SET 학점 = 3
WHEN NOT MATCHED THEN
 INSERT (a.과목번호, a.과목이름, a.학점) 
 VALUES ((SELECT NVL(MAX(과목번호),0)+1 FROM 과목 )
             , :1
             , :2
         );

-- MERGE를 다른 테이블과 연동시킬때
CREATE TABLE ex_과목 (
    과목번호 number(3) primary key
  , 과목이름 varchar2(50)
  , 학점 number(3)
);

-- ex_과목 테이블에 같은 과목번호가 있으면 학점만 수정
--                              없으면 삽입
MERGE INTO ex_과목 a
USING (SELECT 과목번호
            , 과목이름
            , 학점
       FROM 과목
    )b
ON(a.과목번호 = b.과목번호)
WHEN MATCHED THEN
 UPDATE SET a.학점 = b.학점
WHEN NOT MATCHED THEN
 INSERT (a.과목번호, a.과목이름, a.학점) 
 VALUES (b.과목번호, b.과목이름, b.학점)
;

select *
from ex_과목;