# SQL 스크립트 실행 가이드

이 디렉토리에는 담당자 관리 프로젝트에 필요한 데이터베이스 테이블 생성 및 샘플 데이터 입력 스크립트가 포함되어 있습니다.

## 파일 구성

- `00_create_project_tables.sql` - **프로젝트 테이블 생성 (필수)**
- `01_insert_sample_data.sql` - **샘플 데이터 입력 (테스트용)**
- `01_create_tables.sql` - 기타 샘플 테이블 (선택)
- `02_insert_sample_data.sql` - 기타 샘플 데이터 (선택)

## 실행 순서

### 1. 데이터베이스 접속

```bash
sqlplus PDBADMIN/MyStrongPass1!@localhost:1521/FREEPDB1
```

### 2. 테이블 생성 (필수)

```sql
@00_create_project_tables.sql
```

**생성되는 테이블:**
- `tc_pubs_instt_code_info` - 기관 코드 정보
- `tn_pub_data_rspnofcr` - 제공책임관 정보
- `tc_member` - 회원(실무담당자) 정보

### 3. 샘플 데이터 입력 (테스트용)

```sql
@01_insert_sample_data.sql
```

**입력되는 데이터:**
- 기관 코드: 13건
- 제공책임관: 7건
- 회원: 14건

## 주요 테이블 구조

### tc_pubs_instt_code_info (기관 코드)
| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| inst_cd | VARCHAR2(20) | 기관코드 (PK) |
| inst_nm | VARCHAR2(200) | 기관명 |
| up_inst_cd | VARCHAR2(20) | 상위기관코드 |

### tn_pub_data_rspnofcr (제공책임관)
| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| rspnofcr_sn | NUMBER(10) | 일련번호 (PK) |
| pvsn_inst_cd | VARCHAR2(20) | 기관코드 (FK) |
| pvsn_rbprsn_nm | VARCHAR2(100) | 책임관명 |
| dept_nm | VARCHAR2(200) | 부서명 |
| telno | VARCHAR2(500) | 전화번호(암호화) |
| eml_addr | VARCHAR2(200) | 이메일 |

### tc_member (회원)
| 컬럼명 | 타입 | 설명 |
|--------|------|------|
| mbr_sn | NUMBER(10) | 일련번호 (PK) |
| mbr_id | VARCHAR2(50) | 회원ID |
| mbr_nm | VARCHAR2(100) | 회원명 |
| inst_cd | VARCHAR2(20) | 기관코드 (FK) |
| mbr_sttus | CHAR(1) | 상태 (A/I/D) |

## 데이터 확인

```sql
-- 데이터 개수 확인
SELECT COUNT(*) FROM tc_pubs_instt_code_info;
SELECT COUNT(*) FROM tn_pub_data_rspnofcr;
SELECT COUNT(*) FROM tc_member WHERE mbr_sttus = 'A';
```

## 주의사항

- Oracle Database 12c 이상 권장
- 전화번호 필드는 암호화 저장용 (VARCHAR2(500))
- 실행 전 백업 권장
