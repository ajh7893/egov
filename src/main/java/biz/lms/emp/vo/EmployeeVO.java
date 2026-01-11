package biz.lms.emp.vo;

import biz.lms.common.vo.CommonDefault;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Calendar;
import java.util.Date;

/**
 * 직원 정보 VO
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class EmployeeVO extends CommonDefault {

    // 직원 정보
    private String empNo;               // 사번
    private String empName;             // 직원명
    private String email;               // 이메일
    private String phone;               // 전화번호
    private String deptCode;            // 부서코드
    private String deptName;            // 부서명
    private String position;            // 직급
    private Date hireDate;              // 입사일
    private Double salary;              // 급여
    private String status;              // 상태 (ACTIVE/INACTIVE/RETIRED)
    private String regUser;             // 등록자
    private Date regDate;               // 등록일시
    private String updUser;             // 수정자
    private Date updDate;               // 수정일시
    private String searchDeptCode;
    private String searchStatus;
}
