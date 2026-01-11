package biz.lms.chm.vo;

import biz.lms.common.vo.CommonDefault;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 담당자 관리 VO
 * 제공책임관 및 실무담당자 정보를 담는 VO
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class ChargerManageVO extends CommonDefault {

    // 제공책임관 관련 필드
    private String provdInsttCode;      // 제공기관코드
    private String provdRspnofcrNm;     // 제공책임관명
    private String deptNm;              // 부서명
    private String insttCode;           // 기관코드
    private String insttNm;             // 기관명
    private String telno;               // 전화번호
    private String email;               // 이메일
    private String atchFileId;          // 첨부파일ID
    private String insttTy;             // 등록방식
    private String baseAdministrationManagerTokn;  // 행안부공문

    // 실무담당자 관련 필드
    private String picNm;               // 담당자명
    private String mbrId;               // 사용자ID
    private String picDeptNm;           // 담당자부서명
    private String mbrTelno;            // 회원전화번호
    private String picEmailAddr;        // 담당자이메일주소


}
