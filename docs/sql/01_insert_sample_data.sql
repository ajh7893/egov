-- ============================================
-- 샘플 데이터 입력 스크립트
-- ============================================

-- ============================================
-- 1. 기관 코드 샘플 데이터
-- ============================================
INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('1000000', '행정안전부', NULL, 'A', 'Y', 'Y', 1);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('1100000', '서울특별시', '1000000', 'B', 'Y', 'Y', 10);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('1110000', '서울시 강남구', '1100000', 'C', 'Y', 'Y', 11);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('1120000', '서울시 강서구', '1100000', 'C', 'Y', 'Y', 12);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('1130000', '서울시 종로구', '1100000', 'C', 'Y', 'Y', 13);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('2100000', '부산광역시', '1000000', 'B', 'Y', 'Y', 20);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('2110000', '부산시 해운대구', '2100000', 'C', 'Y', 'Y', 21);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('3100000', '대구광역시', '1000000', 'B', 'Y', 'Y', 30);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('4100000', '인천광역시', '1000000', 'B', 'Y', 'Y', 40);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('5100000', '경기도', '1000000', 'B', 'Y', 'Y', 50);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('5110000', '경기도 수원시', '5100000', 'C', 'Y', 'Y', 51);

INSERT INTO tc_pubs_instt_code_info (inst_cd, inst_nm, up_inst_cd, inst_ty, srch_yn, use_yn, sort_ord)
VALUES ('5120000', '경기도 성남시', '5100000', 'C', 'Y', 'Y', 52);


-- ============================================
-- 2. 제공책임관 샘플 데이터
-- ============================================

-- 서울특별시 강남구
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '1110000', '김철수', '정보통신과',
        'U2FsdGVkX1+Abc123', -- 암호화된 전화번호 (예시)
        'kim.cs@gangnam.go.kr', '일반', 'admin');

INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '1110000', '이영희', '행정지원과',
        'U2FsdGVkX1+Def456',
        'lee.yh@gangnam.go.kr', '일반', 'admin');

-- 서울특별시 강서구
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '1120000', '박민수', '전산정보과',
        'U2FsdGVkX1+Ghi789',
        'park.ms@gangseo.go.kr', '일반', 'admin');

-- 서울특별시 종로구
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '1130000', '최정희', 'ICT정책과',
        'U2FsdGVkX1+Jkl012',
        'choi.jh@jongno.go.kr', '일반', 'admin');

-- 부산광역시 해운대구
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '2110000', '정태훈', '디지털정책과',
        'U2FsdGVkX1+Mno345',
        'jung.th@haeundae.go.kr', '일반', 'admin');

-- 경기도 수원시
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '5110000', '강은경', '정보통신과',
        'U2FsdGVkX1+Pqr678',
        'kang.ek@suwon.go.kr', '일반', 'admin');

-- 경기도 성남시
INSERT INTO tn_pub_data_rspnofcr (rspnofcr_sn, pvsn_inst_cd, pvsn_rbprsn_nm, dept_nm, telno, eml_addr, instt_ty, reg_user_id)
VALUES (seq_rspnofcr_sn.NEXTVAL, '5120000', '윤서준', '스마트도시과',
        'U2FsdGVkX1+Stu901',
        'yoon.sj@seongnam.go.kr', '일반', 'admin');


-- ============================================
-- 3. 회원(실무담당자) 샘플 데이터
-- ============================================

-- 강남구 담당자들
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user001', '홍길동', '1110000', '정보통신과',
        'U2FsdGVkX1+Abc111',
        'hong.gd@gangnam.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash123', -- 암호화된 비밀번호
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user002', '김영수', '1110000', '행정지원과',
        'U2FsdGVkX1+Abc222',
        'kim.ys@gangnam.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash456',
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user003', '이지은', '1110000', '디지털혁신과',
        'U2FsdGVkX1+Abc333',
        'lee.je@gangnam.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash789',
        'admin');

-- 강서구 담당자들
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user004', '박준호', '1120000', '전산정보과',
        'U2FsdGVkX1+Def111',
        'park.jh@gangseo.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash111',
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user005', '최수진', '1120000', '기획예산과',
        'U2FsdGVkX1+Def222',
        'choi.sj@gangseo.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash222',
        'admin');

-- 종로구 담당자들
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user006', '장민재', '1130000', 'ICT정책과',
        'U2FsdGVkX1+Ghi111',
        'jang.mj@jongno.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash333',
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user007', '서연아', '1130000', '문화관광과',
        'U2FsdGVkX1+Ghi222',
        'seo.ya@jongno.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash444',
        'admin');

-- 해운대구 담당자들
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user008', '한지훈', '2110000', '디지털정책과',
        'U2FsdGVkX1+Jkl111',
        'han.jh@haeundae.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash555',
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user009', '오세영', '2110000', '행정민원과',
        'U2FsdGVkX1+Jkl222',
        'oh.sy@haeundae.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash666',
        'admin');

-- 수원시 담당자들
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user010', '임하늘', '5110000', '정보통신과',
        'U2FsdGVkX1+Mno111',
        'lim.hn@suwon.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash777',
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user011', '조예린', '5110000', '스마트시티과',
        'U2FsdGVkX1+Mno222',
        'jo.yr@suwon.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash888',
        'admin');

-- 성남시 담당자들
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user012', '안소희', '5120000', '스마트도시과',
        'U2FsdGVkX1+Pqr111',
        'ahn.sh@seongnam.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash999',
        'admin');

INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user013', '백도현', '5120000', '정보통신과',
        'U2FsdGVkX1+Pqr222',
        'baek.dh@seongnam.go.kr', 'A', 'USER',
        'U2FsdGVkX1+PasswordHash000',
        'admin');

-- 비활성 상태 샘플
INSERT INTO tc_member (mbr_sn, mbr_id, mbr_nm, inst_cd, dept_nm, mbr_telno, mbr_email_addr, mbr_sttus, mbr_ty, pswd, reg_user_id)
VALUES (seq_member_sn.NEXTVAL, 'user999', '퇴사자', '1110000', '총무과',
        'U2FsdGVkX1+Zzz999',
        'retired@gangnam.go.kr', 'I', 'USER',
        'U2FsdGVkX1+PasswordHashRetired',
        'admin');


-- ============================================
-- COMMIT
-- ============================================
COMMIT;

-- ============================================
-- 데이터 확인
-- ============================================
SELECT '기관 코드: ' || COUNT(*) || '건' AS MESSAGE FROM tc_pubs_instt_code_info;
SELECT '제공책임관: ' || COUNT(*) || '건' AS MESSAGE FROM tn_pub_data_rspnofcr;
SELECT '회원(실무담당자): ' || COUNT(*) || '건' AS MESSAGE FROM tc_member WHERE mbr_sttus = 'A';

SELECT '샘플 데이터 입력이 완료되었습니다.' AS MESSAGE FROM DUAL;
