package biz.lms.common.vo;

import lombok.Data;

@Data
public class CommonDefault {

    // 페이징 관련
    private int firstIndex = 0;
    private int recordCountPerPage = 10;
    private int pageIndex = 1;

    // 공통 필드
    private Long rn;                    // 행 번호
    private Long recid;                 // 레코드 ID

    // 검색 조건
    private String searchCondition;     // 검색조건
    private String searchKeyword;       // 검색키워드
    private String searchKeyword2;      // 검색키워드2 (기관)
    private String searchKeyword3;      // 검색키워드3 (책임관명)
    private String searchCondition5;    // 검색조건5 (하위기관 포함 여부)

    // 날짜 검색
    private String startDt;             // 시작일
    private String endDt;               // 종료일
}
