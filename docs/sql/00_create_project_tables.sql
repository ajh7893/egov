-- ============================================
-- 담당자 관리 프로젝트 테이블 생성 스크립트
-- ============================================

-- 기존 테이블 삭제 (주의: 데이터도 함께 삭제됩니다)
-- DROP TABLE tc_member CASCADE CONSTRAINTS;
-- DROP TABLE tn_pub_data_rspnofcr CASCADE CONSTRAINTS;
-- DROP TABLE tc_pubs_instt_code_info CASCADE CONSTRAINTS;

-- ============================================
-- 1. 기관 코드 정보 테이블
-- ============================================
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


-- ============================================
-- 2. 제공책임관 정보 테이블
-- ============================================
CREATE TABLE tn_pub_data_rspnofcr (
    rspnofcr_sn NUMBER(10) PRIMARY KEY,
    pvsn_inst_cd VARCHAR2(20) NOT NULL,
    pvsn_rbprsn_nm VARCHAR2(100) NOT NULL,
    dept_nm VARCHAR2(200),
    telno VARCHAR2(500),  -- 암호화된 전화번호 저장
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

-- 시퀀스 생성
CREATE SEQUENCE seq_rspnofcr_sn
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

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


-- ============================================
-- 3. 회원(실무담당자) 정보 테이블
-- ============================================
CREATE TABLE tc_member (
    mbr_sn NUMBER(10) PRIMARY KEY,
    mbr_id VARCHAR2(50) NOT NULL UNIQUE,
    mbr_nm VARCHAR2(100) NOT NULL,
    inst_cd VARCHAR2(20) NOT NULL,
    dept_nm VARCHAR2(200),
    mbr_telno VARCHAR2(500),  -- 암호화된 전화번호 저장
    mbr_email_addr VARCHAR2(200),
    mbr_sttus CHAR(1) DEFAULT 'A',  -- A:활성, I:비활성, D:삭제
    mbr_ty VARCHAR2(20),
    pswd VARCHAR2(500),  -- 암호화된 비밀번호
    last_login_dt DATE,
    reg_dt DATE DEFAULT SYSDATE,
    upd_dt DATE,
    reg_user_id VARCHAR2(50),
    upd_user_id VARCHAR2(50),
    CONSTRAINT fk_member_inst FOREIGN KEY (inst_cd)
        REFERENCES tc_pubs_instt_code_info(inst_cd)
);

-- 시퀀스 생성
CREATE SEQUENCE seq_member_sn
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

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


-- ============================================
-- 완료 메시지
-- ============================================
SELECT '테이블 생성이 완료되었습니다.' AS MESSAGE FROM DUAL;
