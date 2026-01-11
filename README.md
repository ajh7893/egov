# 전자정부 프레임워크 프로젝트

전자정부 표준프레임워크 기반 웹 애플리케이션입니다.

## 기술 스택

- **Java**: 17
- **Spring Framework**: 5.3.27
- **E-Government Framework**: 4.2.0
- **MyBatis**: 2.1.2
- **Database**: Oracle (jdbc:oracle:thin:@//localhost:1521/FREEPDB1)
- **Build Tool**: Maven
- **View**: JSP
- **Grid**: W2UI
- **Utility**: Lombok 1.18.28, Apache POI 5.2.3

## 프로젝트 구조

```
egov/
├── src/
│   └── main/
│       ├── java/
│       │   ├── biz/lms/chm/          # 담당자 관리 도메인
│       │   │   ├── controller/       # Controller
│       │   │   ├── service/          # Service
│       │   │   ├── dao/              # DAO
│       │   │   └── vo/               # VO
│       │   └── egovframework/
│       │       └── com/cmm/
│       │           ├── service/      # 공통 Service (CustomPage)
│       │           └── util/         # 유틸리티 클래스
│       ├── resources/
│       │   ├── egovframework/
│       │   │   ├── egovProps/        # Properties 파일
│       │   │   └── sqlmap/
│       │   │       ├── config/       # MyBatis 설정
│       │   │       └── mappers/      # MyBatis Mapper XML
│       │   └── spring/               # Spring 설정 파일
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── config/           # Dispatcher 설정
│           │   ├── jsp/              # JSP 파일
│           │   └── web.xml           # Web 설정
│           └── js/                   # JavaScript 파일
├── docs/
│   └── sql/                          # SQL 스크립트
├── js/                               # 외부 JS 라이브러리
│   ├── w2ui/                         # W2UI 그리드 라이브러리
│   ├── jQuery/                       # jQuery
│   └── egovframework/                # 전자정부 JS
└── pom.xml                           # Maven 설정
```

## 주요 기능

### 담당자 관리
- **제공책임관 관리**: 기관별 제공책임관 목록 조회
- **실무담당자 관리**: 기관별 실무담당자 목록 조회
- **검색 기능**: 기관명, 담당자명, 기간별 검색
- **페이징**: Spring Data Pageable + W2UI 자동 페이징
- **엑셀 다운로드**: 데이터 엑셀 다운로드 (POI 사용)

### 주요 컴포넌트

#### 1. Controller
- `ChargerManageController`: 담당자 관리 컨트롤러
  - `/lms/chm/chargerManage.do`: 담당자 관리 페이지
  - `/lms/chm/selectRspnofcrChargerListJson.do`: 제공책임관 목록 조회
  - `/lms/chm/selectPrcafsChargerListJson.do`: 실무담당자 목록 조회

#### 2. Service
- `ChargerManageService`: 담당자 관리 서비스 인터페이스
- `ChargerManageServiceImpl`: 서비스 구현체

#### 3. DAO
- `ChargerManageDAO`: MyBatis를 사용한 데이터 접근

#### 4. 유틸리티
- `HttpUtil`: HTTP 응답 생성 유틸리티
- `SortUtil`: Spring Data Sort를 MyBatis ORDER BY로 변환
- `SecurityUtil`: SEED 암호화/복호화 (전화번호 암호화)
- `CustomPage`: MyBatis 연동을 위한 Spring Data Page 구현

#### 5. JavaScript
- `form.js`: 검색 폼 데이터 수집 및 날짜 버튼 처리
- `W2GridHelper.js`: W2UI 그리드 헬퍼 클래스

## 데이터베이스 설정

### 접속 정보
```properties
jdbc-url: jdbc:oracle:thin:@//localhost:1521/FREEPDB1
username: PDBADMIN
password: MyStrongPass1!
driver-class-name: oracle.jdbc.OracleDriver
```

### 테이블 구조
SQL 파일은 `docs/sql/` 디렉토리에 있습니다:
- `01_create_tables.sql`: 테이블 생성
- `02_insert_sample_data.sql`: 샘플 데이터
- `03_department_tables.sql`: 부서 테이블

주요 테이블:
- `tn_pub_data_rspnofcr`: 제공책임관 정보
- `tc_pubs_instt_code_info`: 기관 코드 정보
- `tc_member`: 회원(담당자) 정보

## 빌드 및 실행

### 1. 사전 요구사항
- JDK 17 설치
- Maven 3.x 설치
- Oracle Database 설치 및 실행
- Apache Tomcat 9.x 설치

### 2. 데이터베이스 준비
```bash
# SQL 파일 실행
sqlplus PDBADMIN/MyStrongPass1!@localhost:1521/FREEPDB1
@docs/sql/01_create_tables.sql
@docs/sql/02_insert_sample_data.sql
@docs/sql/03_department_tables.sql
```

### 3. 빌드
```bash
# Maven 빌드
mvn clean package

# WAR 파일 생성 위치
# target/egov.war
```

### 4. 배포
```bash
# Tomcat webapps 디렉토리에 WAR 파일 복사
cp target/egov.war $TOMCAT_HOME/webapps/

# Tomcat 시작
$TOMCAT_HOME/bin/startup.sh
```

### 5. 접속
브라우저에서 다음 URL로 접속:
```
http://localhost:8080/egov/
```

담당자 관리 페이지:
```
http://localhost:8080/egov/lms/chm/chargerManage.do
```

## W2UI 그리드 사용법

### 그리드 설정
```javascript
const gridHelper = new W2GridHelper({
    url: "/lms/chm/selectRspnofcrChargerListJson.do",
    target: "#grid",
    columns: [
        { field: 'rn', text: 'NO', size: '80px' },
        { field: 'insttNm', text: '기관명', size: '15%' },
        // ...
    ]
});
```

### 페이징 처리
W2UI 그리드가 자동으로 페이징 처리를 하며, Spring Data Pageable과 연동됩니다.
- 서버에서 Page 객체를 반환하면 자동으로 처리
- 페이지 크기: 기본 10개 (변경 가능)

### 검색
```javascript
SearchDataHandler.collectParams('#searchArea');  // 검색 폼에서 파라미터 수집
gridHelper.search(params);                        // 그리드 검색
```

## 보안

### 전화번호 암호화
전화번호는 SEED 암호화 알고리즘(실제로는 AES)으로 암호화되어 저장됩니다.

```java
// 암호화
String encrypted = SecurityUtil.encryptBySeed(key, plainText);

// 복호화
String decrypted = SecurityUtil.decryptBySeed(key, encrypted);
```

암호화 키는 `globals.properties`에 설정:
```properties
system.telno.seedKey=1234567890123456
```

## 개발 가이드

### 새로운 기능 추가 시

1. **VO 생성**: `biz.lms.xxx.vo` 패키지에 VO 클래스 생성
2. **DAO 생성**: `biz.lms.xxx.dao` 패키지에 DAO 생성
3. **Mapper XML 생성**: `resources/egovframework/sqlmap/mappers/xxx/` 에 XML 생성
4. **Service 생성**: `biz.lms.xxx.service` 패키지에 인터페이스 및 구현체 생성
5. **Controller 생성**: `biz.lms.xxx.controller` 패키지에 컨트롤러 생성
6. **JSP 생성**: `webapp/WEB-INF/jsp/xxx/` 에 JSP 생성

### 코드 스타일
- Java: Lombok 어노테이션 활용
- SQL: MyBatis Dynamic SQL 사용
- JavaScript: ES6+ 문법 사용

## 문제 해결

### 데이터베이스 연결 오류
- Oracle 서버가 실행 중인지 확인
- `context-datasource.xml`의 접속 정보 확인

### 404 오류
- Tomcat에 WAR 파일이 정상 배포되었는지 확인
- `web.xml`의 서블릿 매핑 확인 (*.do)

### 페이징 오류
- MyBatis Mapper XML의 페이징 쿼리 확인
- `CustomPage` 클래스의 구현 확인

## 라이선스

이 프로젝트는 내부망 프로젝트의 일부로, 전자정부 표준프레임워크를 기반으로 합니다.

## 참고 자료

- [전자정부 표준프레임워크](https://www.egovframe.go.kr/)
- [Spring Framework](https://spring.io/)
- [MyBatis](https://mybatis.org/)
- [W2UI Documentation](http://w2ui.com/)
