-- 시퀀스 생성
CREATE SEQUENCE seq_excel_download_log
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 엑셀 다운로드 이력 테이블
CREATE TABLE excel_download_log (
    log_id NUMBER(19) PRIMARY KEY,
    download_type VARCHAR2(20) NOT NULL,
    download_reason CLOB NOT NULL,
    user_id VARCHAR2(50),
    user_name VARCHAR2(100),
    download_dt DATE DEFAULT SYSDATE NOT NULL,
    search_params CLOB,
    download_count NUMBER(10) DEFAULT 0,
    created_at DATE DEFAULT SYSDATE NOT NULL,
    updated_at DATE
);

-- 코멘트 추가
COMMENT ON TABLE excel_download_log IS '엑셀 다운로드 이력';
COMMENT ON COLUMN excel_download_log.log_id IS '로그ID';
COMMENT ON COLUMN excel_download_log.download_type IS '다운로드 타입 (manager: 제공책임관, practical: 실무담당자)';
COMMENT ON COLUMN excel_download_log.download_reason IS '다운로드 사유';
COMMENT ON COLUMN excel_download_log.user_id IS '다운로드한 사용자 ID';
COMMENT ON COLUMN excel_download_log.user_name IS '다운로드한 사용자 이름';
COMMENT ON COLUMN excel_download_log.download_dt IS '다운로드 일시';
COMMENT ON COLUMN excel_download_log.search_params IS '검색 조건 JSON';
COMMENT ON COLUMN excel_download_log.download_count IS '다운로드 건수';
COMMENT ON COLUMN excel_download_log.created_at IS '생성일시';
COMMENT ON COLUMN excel_download_log.updated_at IS '수정일시';

-- 인덱스 생성
CREATE INDEX idx_download_type ON excel_download_log(download_type);
CREATE INDEX idx_user_id ON excel_download_log(user_id);
CREATE INDEX idx_download_dt ON excel_download_log(download_dt);

-- 트리거 생성 (자동 증가)
CREATE OR REPLACE TRIGGER trg_excel_download_log
BEFORE INSERT ON excel_download_log
FOR EACH ROW
BEGIN
    IF :NEW.log_id IS NULL THEN
        SELECT seq_excel_download_log.NEXTVAL INTO :NEW.log_id FROM DUAL;
    END IF;
END;
/

-- 업데이트 트리거 생성
CREATE OR REPLACE TRIGGER trg_excel_download_log_upd
BEFORE UPDATE ON excel_download_log
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSDATE;
END;
/
