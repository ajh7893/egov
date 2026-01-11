-- ============================================
-- 담당자 관리 프로젝트 통합 데이터베이스 초기화 스크립트
-- (기존 테이블 및 시퀀스 삭제 포함)
-- ============================================

-- ============================================
-- 1. 기존 객체 삭제 (충돌 방지)
-- ============================================

-- 테이블 삭제
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TB_DEPT_STATISTICS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TB_DEPARTMENT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE tc_member CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE tn_pub_data_rspnofcr CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE tc_pubs_instt_code_info CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TB_EMPLOYEE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE TB_SAMPLE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- 시퀀스 삭제
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_rspnofcr_sn'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_member_sn'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================
-- 2. 테이블 생성
-- ============================================

-- 2.1 기관 코드 정보 테이블
CREATE TABLE tc_pubs_instt_code_info (
    inst_cd VARCHAR2(20) PRIMARY KEY,
    inst_nm VARCHAR2(200) NOT NULL,
    up_inst_cd VARCHAR2(20),
    inst_ty VARCHAR2(10),
    srch_yn CHAR(1) DEFAULT 'Y',
    use_yn CHAR(1) DEFAULT 'Y',
    sort_ord NUMBER(5),
    reg_dt DATE DEFAULT SYSDATE,
    upd_dt DATE
);

COMMENT ON TABLE tc_pubs_instt_code_info IS '기관 코드 정보';
COMMENT ON COLUMN tc_pubs_instt_code_info.inst_cd IS '기관코드';
COMMENT ON COLUMN tc_pubs_instt_code_info.inst_nm IS '기관명';
COMMENT ON COLUMN tc_pubs_instt_code_info.up_inst_cd IS '상위기관코드';
COMMENT ON COLUMN tc_pubs_instt_code_info.inst_ty IS '기관유형';
COMMENT ON COLUMN tc_pubs_instt_code_info.srch_yn IS '검색여부 (Y/N)';
COMMENT ON COLUMN tc_pubs_instt_code_info.use_yn IS '사용여부 (Y/N)';
COMMENT ON COLUMN tc_pubs_instt_code_info.sort_ord IS '정렬순서';
COMMENT ON COLUMN tc_pubs_instt_code_info.reg_dt IS '등록일시';
COMMENT ON COLUMN tc_pubs_instt_code_info.upd_dt IS '수정일시';

CREATE INDEX idx_instt_code_up ON tc_pubs_instt_code_info(up_inst_cd);
CREATE INDEX idx_instt_code_nm ON tc_pubs_instt_code_info(inst_nm);

-- 2.2 제공책임관 정보 테이블
CREATE TABLE tn_pub_data_rspnofcr (
    rspnofcr_sn NUMBER(10) PRIMARY KEY,
    pvsn_inst_cd VARCHAR2(20) NOT NULL,
    pvsn_rbprsn_nm VARCHAR2(100) NOT NULL,
    dept_nm VARCHAR2(200),
    telno VARCHAR2(500),
    eml_addr VARCHAR2(200),
    atch_file_id VARCHAR2(50),
    instt_ty VARCHAR2(20) DEFAULT '일반',
    reg_dt DATE DEFAULT SYSDATE,
    upd_dt DATE,
    reg_user_id VARCHAR2(50),
    upd_user_id VARCHAR2(50),
    CONSTRAINT fk_rspnofcr_inst FOREIGN KEY (pvsn_inst_cd)
        REFERENCES tc_pubs_instt_code_info(inst_cd)
);

CREATE SEQUENCE seq_rspnofcr_sn START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

COMMENT ON TABLE tn_pub_data_rspnofcr IS '제공책임관 정보';
COMMENT ON COLUMN tn_pub_data_rspnofcr.rspnofcr_sn IS '제공책임관일련번호';
COMMENT ON COLUMN tn_pub_data_rspnofcr.pvsn_inst_cd IS '제공기관코드';
COMMENT ON COLUMN tn_pub_data_rspnofcr.pvsn_rbprsn_nm IS '제공책임관명';
COMMENT ON COLUMN tn_pub_data_rspnofcr.dept_nm IS '부서명';
COMMENT ON COLUMN tn_pub_data_rspnofcr.telno IS '전화번호(암호화)';
COMMENT ON COLUMN tn_pub_data_rspnofcr.eml_addr IS '이메일주소';
COMMENT ON COLUMN tn_pub_data_rspnofcr.atch_file_id IS '첨부파일ID';
COMMENT ON COLUMN tn_pub_data_rspnofcr.instt_ty IS '등록방식';
COMMENT ON COLUMN tn_pub_data_rspnofcr.reg_dt IS '등록일시';
COMMENT ON COLUMN tn_pub_data_rspnofcr.upd_dt IS '수정일시';
COMMENT ON COLUMN tn_pub_data_rspnofcr.reg_user_id IS '등록자ID';
COMMENT ON COLUMN tn_pub_data_rspnofcr.upd_user_id IS '수정자ID';

CREATE INDEX idx_rspnofcr_inst ON tn_pub_data_rspnofcr(pvsn_inst_cd);
CREATE INDEX idx_rspnofcr_nm ON tn_pub_data_rspnofcr(pvsn_rbprsn_nm);

-- 2.3 회원(실무담당자) 정보 테이블
CREATE TABLE tc_member (
    mbr_sn NUMBER(10) PRIMARY KEY,
    mbr_id VARCHAR2(50) NOT NULL UNIQUE,
    mbr_nm VARCHAR2(100) NOT NULL,
    inst_cd VARCHAR2(20) NOT NULL,
    dept_nm VARCHAR2(200),
    mbr_telno VARCHAR2(500),
    mbr_email_addr VARCHAR2(200),
    mbr_sttus CHAR(1) DEFAULT 'A',
    mbr_ty VARCHAR2(20),
    pswd VARCHAR2(500),
    last_login_dt DATE,
    reg_dt DATE DEFAULT SYSDATE,
    upd_dt DATE,
    reg_user_id VARCHAR2(50),
    upd_user_id VARCHAR2(50),
    CONSTRAINT fk_member_inst FOREIGN KEY (inst_cd)
        REFERENCES tc_pubs_instt_code_info(inst_cd)
);

CREATE SEQUENCE seq_member_sn START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

COMMENT ON TABLE tc_member IS '회원(실무담당자) 정보';
COMMENT ON COLUMN tc_member.mbr_sn IS '회원일련번호';
COMMENT ON COLUMN tc_member.mbr_id IS '회원ID';
COMMENT ON COLUMN tc_member.mbr_nm IS '회원명';
COMMENT ON COLUMN tc_member.inst_cd IS '기관코드';
COMMENT ON COLUMN tc_member.dept_nm IS '부서명';
COMMENT ON COLUMN tc_member.mbr_telno IS '회원전화번호(암호화)';
COMMENT ON COLUMN tc_member.mbr_email_addr IS '회원이메일주소';
COMMENT ON COLUMN tc_member.mbr_sttus IS '회원상태 (A:활성, I:비활성, D:삭제)';
COMMENT ON COLUMN tc_member.mbr_ty IS '회원유형';
COMMENT ON COLUMN tc_member.pswd IS '비밀번호(암호화)';
COMMENT ON COLUMN tc_member.last_login_dt IS '최종로그인일시';
COMMENT ON COLUMN tc_member.reg_dt IS '등록일시';
COMMENT ON COLUMN tc_member.upd_dt IS '수정일시';
COMMENT ON COLUMN tc_member.reg_user_id IS '등록자ID';
COMMENT ON COLUMN tc_member.upd_user_id IS '수정자ID';

CREATE INDEX idx_member_id ON tc_member(mbr_id);
CREATE INDEX idx_member_nm ON tc_member(mbr_nm);
CREATE INDEX idx_member_inst ON tc_member(inst_cd);
CREATE INDEX idx_member_sttus ON tc_member(mbr_sttus);

-- 2.4 부서 테이블 (TB_DEPARTMENT)
CREATE TABLE TB_DEPARTMENT (
    DEPT_CODE VARCHAR2(10) PRIMARY KEY,
    DEPT_NAME VARCHAR2(100) NOT NULL,
    DEPT_MANAGER VARCHAR2(50),
    LOCATION VARCHAR2(100),
    BUDGET NUMBER(15, 0),
    STATUS VARCHAR2(20) DEFAULT 'ACTIVE',
    REG_USER VARCHAR2(50),
    REG_DATE DATE DEFAULT SYSDATE,
    UPD_USER VARCHAR2(50),
    UPD_DATE DATE
);
CREATE INDEX IDX_DEPT_NAME ON TB_DEPARTMENT(DEPT_NAME);
CREATE INDEX IDX_DEPT_STATUS ON TB_DEPARTMENT(STATUS);

-- 2.5 직원 정보 테이블 (TB_EMPLOYEE)
CREATE TABLE TB_EMPLOYEE (
    EMP_NO VARCHAR2(20) PRIMARY KEY,
    EMP_NAME VARCHAR2(100) NOT NULL,
    EMAIL VARCHAR2(100),
    PHONE VARCHAR2(20),
    DEPT_CODE VARCHAR2(20),
    DEPT_NAME VARCHAR2(100),
    POSITION VARCHAR2(50),
    HIRE_DATE DATE,
    SALARY NUMBER(12,2),
    STATUS VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    REG_USER VARCHAR2(50) NOT NULL,
    REG_DATE DATE DEFAULT SYSDATE NOT NULL,
    UPD_USER VARCHAR2(50),
    UPD_DATE DATE
);

CREATE INDEX IDX_EMPLOYEE_DEPT ON TB_EMPLOYEE(DEPT_CODE);
CREATE INDEX IDX_EMPLOYEE_STATUS ON TB_EMPLOYEE(STATUS);
CREATE INDEX IDX_EMPLOYEE_NAME ON TB_EMPLOYEE(EMP_NAME);

-- 2.6 부서별 통계 테이블 (TB_DEPT_STATISTICS)
CREATE TABLE TB_DEPT_STATISTICS (
    DEPT_CODE VARCHAR2(10) PRIMARY KEY,
    DEPT_NAME VARCHAR2(100),
    TOTAL_EMPLOYEES NUMBER(10, 0) DEFAULT 0,
    AVG_SALARY NUMBER(15, 2) DEFAULT 0,
    MAX_SALARY NUMBER(15, 0) DEFAULT 0,
    MIN_SALARY NUMBER(15, 0) DEFAULT 0,
    TOTAL_BUDGET NUMBER(15, 0) DEFAULT 0,
    YEAR NUMBER(4),
    MONTH NUMBER(2),
    REG_DATE DATE DEFAULT SYSDATE,
    UPD_DATE DATE,
    CONSTRAINT FK_DEPT_STATS FOREIGN KEY (DEPT_CODE) REFERENCES TB_DEPARTMENT(DEPT_CODE)
);
CREATE INDEX IDX_DEPT_STATS_YEAR_MONTH ON TB_DEPT_STATISTICS(YEAR, MONTH);

-- 2.7 샘플 테이블 (TB_SAMPLE)
CREATE TABLE TB_SAMPLE (
    ID VARCHAR2(50) PRIMARY KEY,
    NAME VARCHAR2(100) NOT NULL,
    DESCRIPTION VARCHAR2(500),
    USE_YN CHAR(1) DEFAULT 'Y' NOT NULL,
    REG_USER VARCHAR2(50) NOT NULL,
    REG_DATE DATE DEFAULT SYSDATE NOT NULL
);

-- ============================================
-- 3. 샘플 데이터 입력
-- ============================================

-- 3.1 기관 코드 샘플 데이터
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('1000000', '행정안전부', NULL, 'A', 'Y', 'Y', 1);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('1100000', '서울특별시', '1000000', 'B', 'Y', 'Y', 10);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('1110000', '서울시 강남구', '1100000', 'C', 'Y', 'Y', 11);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('1120000', '서울시 강서구', '1100000', 'C', 'Y', 'Y', 12);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('1130000', '서울시 종로구', '1100000', 'C', 'Y', 'Y', 13);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('2100000', '부산광역시', '1000000', 'B', 'Y', 'Y', 20);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('2110000', '부산시 해운대구', '2100000', 'C', 'Y', 'Y', 21);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('3100000', '대구광역시', '1000000', 'B', 'Y', 'Y', 30);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('4100000', '인천광역시', '1000000', 'B', 'Y', 'Y', 40);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('5100000', '경기도', '1000000', 'B', 'Y', 'Y', 50);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('5110000', '경기도 수원시', '5100000', 'C', 'Y', 'Y', 51);
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord) VALUES ('5120000', '경기도 성남시', '5100000', 'C', 'Y', 'Y', 52);

-- 3.2 제공책임관 샘플 데이터
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '1110000', '김철수', '정보통신과', 'U2FsdGVkX1+Abc123', 'kim.cs@gangnam.go.kr', '일반', 'admin');
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '1110000', '이영희', '행정지원과', 'U2FsdGVkX1+Def456', 'lee.yh@gangnam.go.kr', '일반', 'admin');
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '1120000', '박민수', '전산정보과', 'U2FsdGVkX1+Ghi789', 'park.ms@gangseo.go.kr', '일반', 'admin');
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '1130000', '최정희', 'ICT정책과', 'U2FsdGVkX1+Jkl012', 'choi.jh@jongno.go.kr', '일반', 'admin');
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '2110000', '정태훈', '디지털정책과', 'U2FsdGVkX1+Mno345', 'jung.th@haeundae.go.kr', '일반', 'admin');
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '5110000', '강은경', '정보통신과', 'U2FsdGVkX1+Pqr678', 'kang.ek@suwon.go.kr', '일반', 'admin');
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id) VALUES (seq_rspnofcr_sn.NEXTVAL, '5120000', '윤서준', '스마트도시과', 'U2FsdGVkX1+Stu901', 'yoon.sj@seongnam.go.kr', '일반', 'admin');

-- 3.3 회원(실무담당자) 샘플 데이터
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user001', '홍길동', '1110000', '정보통신과', 'U2FsdGVkX1+Abc111', 'hong.gd@gangnam.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash123', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user002', '김영수', '1110000', '행정지원과', 'U2FsdGVkX1+Abc222', 'kim.ys@gangnam.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash456', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user003', '이지은', '1110000', '디지털혁신과', 'U2FsdGVkX1+Abc333', 'lee.je@gangnam.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash789', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user004', '박준호', '1120000', '전산정보과', 'U2FsdGVkX1+Def111', 'park.jh@gangseo.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash111', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user005', '최수진', '1120000', '기획예산과', 'U2FsdGVkX1+Def222', 'choi.sj@gangseo.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash222', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user006', '장민재', '1130000', 'ICT정책과', 'U2FsdGVkX1+Ghi111', 'jang.mj@jongno.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash333', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user007', '서연아', '1130000', '문화관광과', 'U2FsdGVkX1+Ghi222', 'seo.ya@jongno.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash444', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user008', '한지훈', '2110000', '디지털정책과', 'U2FsdGVkX1+Jkl111', 'han.jh@haeundae.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash555', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user009', '오세영', '2110000', '행정민원과', 'U2FsdGVkX1+Jkl222', 'oh.sy@haeundae.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash666', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user010', '임하늘', '5110000', '정보통신과', 'U2FsdGVkX1+Mno111', 'lim.hn@suwon.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash777', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user011', '조예린', '5110000', '스마트시티과', 'U2FsdGVkX1+Mno222', 'jo.yr@suwon.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash888', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user012', '안소희', '5120000', '스마트도시과', 'U2FsdGVkX1+Pqr111', 'ahn.sh@seongnam.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash999', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user013', '백도현', '5120000', '정보통신과', 'U2FsdGVkX1+Pqr222', 'baek.dh@seongnam.go.kr', 'A', 'USER', 'U2FsdGVkX1+PasswordHash000', 'admin');
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id) VALUES (seq_member_sn.NEXTVAL, 'user999', '퇴사자', '1110000', '총무과', 'U2FsdGVkX1+Zzz999', 'retired@gangnam.go.kr', 'I', 'USER', 'U2FsdGVkX1+PasswordHashRetired', 'admin');

-- 3.4 부서 샘플 데이터
INSERT INTO TB_DEPARTMENT (DEPT_CODE, DEPT_NAME, DEPT_MANAGER, LOCATION, BUDGET, STATUS, REG_USER, REG_DATE) VALUES ('D001', '개발팀', '김철수', '서울 본사 3층', 500000000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_DEPARTMENT (DEPT_CODE, DEPT_NAME, DEPT_MANAGER, LOCATION, BUDGET, STATUS, REG_USER, REG_DATE) VALUES ('D002', '기획팀', '정수진', '서울 본사 4층', 300000000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_DEPARTMENT (DEPT_CODE, DEPT_NAME, DEPT_MANAGER, LOCATION, BUDGET, STATUS, REG_USER, REG_DATE) VALUES ('D003', '영업팀', '조은비', '서울 본사 5층', 400000000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_DEPARTMENT (DEPT_CODE, DEPT_NAME, DEPT_MANAGER, LOCATION, BUDGET, STATUS, REG_USER, REG_DATE) VALUES ('D004', '인사팀', '박지훈', '서울 본사 2층', 200000000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_DEPARTMENT (DEPT_CODE, DEPT_NAME, DEPT_MANAGER, LOCATION, BUDGET, STATUS, REG_USER, REG_DATE) VALUES ('D005', '재무팀', '이소영', '서울 본사 6층', 250000000, 'ACTIVE', 'admin', SYSDATE);

-- 3.5 직원(TB_EMPLOYEE) 샘플 데이터
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E001', '김철수', 'kim.cs@example.com', '010-1234-5678', 'D001', '개발팀', '부장', TO_DATE('2018-03-15', 'YYYY-MM-DD'), 8000000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E002', '이영희', 'lee.yh@example.com', '010-2345-6789', 'D001', '개발팀', '차장', TO_DATE('2019-06-01', 'YYYY-MM-DD'), 6500000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E003', '박민수', 'park.ms@example.com', '010-3456-7890', 'D001', '개발팀', '과장', TO_DATE('2020-01-20', 'YYYY-MM-DD'), 5500000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E004', '최지현', 'choi.jh@example.com', '010-4567-8901', 'D001', '개발팀', '대리', TO_DATE('2021-04-10', 'YYYY-MM-DD'), 4500000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E005', '정수진', 'jung.sj@example.com', '010-5678-9012', 'D002', '기획팀', '부장', TO_DATE('2017-08-22', 'YYYY-MM-DD'), 8500000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E006', '강민지', 'kang.mj@example.com', '010-6789-0123', 'D002', '기획팀', '차장', TO_DATE('2019-11-15', 'YYYY-MM-DD'), 7000000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E007', '윤성호', 'yoon.sh@example.com', '010-7890-1234', 'D002', '기획팀', '과장', TO_DATE('2020-05-18', 'YYYY-MM-DD'), 5800000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E008', '조은비', 'jo.eb@example.com', '010-8901-2345', 'D003', '영업팀', '차장', TO_DATE('2018-09-05', 'YYYY-MM-DD'), 6800000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E009', '임재현', 'lim.jh@example.com', '010-9012-3456', 'D003', '영업팀', '과장', TO_DATE('2020-02-28', 'YYYY-MM-DD'), 5600000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E010', '한서연', 'han.sy@example.com', '010-0123-4567', 'D003', '영업팀', '대리', TO_DATE('2021-07-12', 'YYYY-MM-DD'), 4800000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E011', '송하늘', 'song.hn@example.com', '010-1111-2222', 'D004', '인사팀', '부장', TO_DATE('2016-05-10', 'YYYY-MM-DD'), 8200000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E012', '백승현', 'baek.sh@example.com', '010-2222-3333', 'D004', '인사팀', '과장', TO_DATE('2020-10-01', 'YYYY-MM-DD'), 5700000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E013', '남궁민', 'namgung.m@example.com', '010-3333-4444', 'D005', '재무팀', '차장', TO_DATE('2019-03-20', 'YYYY-MM-DD'), 6900000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E014', '선우지훈', 'sunwoo.jh@example.com', '010-4444-5555', 'D005', '재무팀', '대리', TO_DATE('2021-11-08', 'YYYY-MM-DD'), 4700000, 'ACTIVE', 'admin', SYSDATE);
INSERT INTO TB_EMPLOYEE (EMP_NO, EMP_NAME, EMAIL, PHONE, DEPT_CODE, DEPT_NAME, POSITION, HIRE_DATE, SALARY, STATUS, REG_USER, REG_DATE) VALUES ('E015', '황보미래', 'hwangbo.mr@example.com', '010-5555-6666', 'D001', '개발팀', '사원', TO_DATE('2022-03-02', 'YYYY-MM-DD'), 3800000, 'ACTIVE', 'admin', SYSDATE);

-- 3.6 부서별 통계 데이터 생성
INSERT INTO TB_DEPT_STATISTICS (DEPT_CODE, DEPT_NAME, TOTAL_EMPLOYEES, AVG_SALARY, MAX_SALARY, MIN_SALARY, TOTAL_BUDGET, YEAR, MONTH, REG_DATE)
SELECT
    e.DEPT_CODE,
    e.DEPT_NAME,
    COUNT(*) AS TOTAL_EMPLOYEES,
    ROUND(AVG(e.SALARY), 2) AS AVG_SALARY,
    MAX(e.SALARY) AS MAX_SALARY,
    MIN(e.SALARY) AS MIN_SALARY,
    d.BUDGET AS TOTAL_BUDGET,
    2026 AS YEAR,
    1 AS MONTH,
    SYSDATE AS REG_DATE
FROM TB_EMPLOYEE e
INNER JOIN TB_DEPARTMENT d ON e.DEPT_CODE = d.DEPT_CODE
GROUP BY e.DEPT_CODE, e.DEPT_NAME, d.BUDGET;

-- 3.7 샘플 테이블 (TB_SAMPLE) 샘플 데이터
INSERT INTO TB_SAMPLE (ID, NAME, DESCRIPTION, USE_YN, REG_USER, REG_DATE) VALUES ('SAMPLE001', '샘플1', '첫 번째 샘플 데이터입니다.', 'Y', 'admin', SYSDATE);
INSERT INTO TB_SAMPLE (ID, NAME, DESCRIPTION, USE_YN, REG_USER, REG_DATE) VALUES ('SAMPLE002', '샘플2', '두 번째 샘플 데이터입니다.', 'Y', 'admin', SYSDATE);
INSERT INTO TB_SAMPLE (ID, NAME, DESCRIPTION, USE_YN, REG_USER, REG_DATE) VALUES ('SAMPLE003', '샘플3', '세 번째 샘플 데이터입니다.', 'N', 'admin', SYSDATE);

COMMIT;

SELECT '기관 코드: ' || COUNT(*) || '건' AS MESSAGE FROM tc_pubs_instt_code_info;
SELECT '제공책임관: ' || COUNT(*) || '건' AS MESSAGE FROM tn_pub_data_rspnofcr;
SELECT '회원(실무담당자): ' || COUNT(*) || '건' AS MESSAGE FROM tc_member WHERE mbr_sttus = 'A';
SELECT '부서(TB_DEPARTMENT): ' || COUNT(*) || '건' AS MESSAGE FROM TB_DEPARTMENT;
SELECT '직원(TB_EMPLOYEE): ' || COUNT(*) || '건' AS MESSAGE FROM TB_EMPLOYEE;
SELECT '샘플(TB_SAMPLE): ' || COUNT(*) || '건' AS MESSAGE FROM TB_SAMPLE;

SELECT '테이블 생성 및 샘플 데이터 입력이 완료되었습니다.' AS MESSAGE FROM DUAL;