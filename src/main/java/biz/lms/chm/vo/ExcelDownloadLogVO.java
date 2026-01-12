package biz.lms.chm.vo;

import lombok.Data;

import java.util.Date;

/**
 * 엑셀 다운로드 이력 VO
 */
@Data
public class ExcelDownloadLogVO {

    private Long logId;                 // 로그ID
    private String downloadType;        // 다운로드 타입 (manager: 제공책임관, practical: 실무담당자)
    private String downloadReason;      // 다운로드 사유
    private String userId;              // 다운로드한 사용자 ID
    private String userName;            // 다운로드한 사용자 이름
    private Date downloadDt;            // 다운로드 일시
    private String searchParams;        // 검색 조건 JSON
    private Integer downloadCount;      // 다운로드 건수
    private Date createdAt;             // 생성일시
    private Date updatedAt;             // 수정일시
}
