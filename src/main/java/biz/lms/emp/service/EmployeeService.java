package biz.lms.emp.service;

import biz.lms.emp.vo.EmployeeVO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * 직원 관리 Service 인터페이스
 */
public interface EmployeeService {

    /**
     * 직원 목록 조회
     */
    Page<EmployeeVO> selectEmployeeList(EmployeeVO searchVO, Pageable pageable);

    /**
     * 직원 상세 조회
     */
    EmployeeVO selectEmployeeDetail(String empNo);

    /**
     * 직원 등록
     */
    int insertEmployee(EmployeeVO employeeVO);

    /**
     * 직원 수정
     */
    int updateEmployee(EmployeeVO employeeVO);

    /**
     * 직원 삭제
     */
    int deleteEmployee(String empNo);
}
