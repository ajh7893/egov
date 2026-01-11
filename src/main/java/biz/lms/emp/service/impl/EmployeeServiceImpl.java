package biz.lms.emp.service.impl;

import biz.lms.emp.dao.EmployeeDAO;
import biz.lms.emp.service.EmployeeService;
import biz.lms.emp.vo.EmployeeVO;
import egovframework.com.cmm.service.CustomPage;
import egovframework.com.cmm.util.SortUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 직원 관리 Service 구현체
 */
@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeDAO employeeDAO;

    @Override
    public Page<EmployeeVO> selectEmployeeList(EmployeeVO searchVO, Pageable pageable) {
        String orderByClause = SortUtil.toOrderByClause(pageable);
        int offset = (pageable.getPageNumber() * pageable.getPageSize()) + 1;

        searchVO.setFirstIndex(offset);
        searchVO.setRecordCountPerPage(pageable.getPageSize());

        List<EmployeeVO> list = employeeDAO.selectEmployeeList(pageable, searchVO, orderByClause);
        int totalCount = employeeDAO.selectEmployeeTotalCnt(searchVO);

        return new CustomPage<>(list, pageable, totalCount);
    }

    @Override
    public EmployeeVO selectEmployeeDetail(String empNo) {
        return employeeDAO.selectEmployeeDetail(empNo);
    }

    @Override
    @Transactional
    public int insertEmployee(EmployeeVO employeeVO) {
        return employeeDAO.insertEmployee(employeeVO);
    }

    @Override
    @Transactional
    public int updateEmployee(EmployeeVO employeeVO) {
        return employeeDAO.updateEmployee(employeeVO);
    }

    @Override
    @Transactional
    public int deleteEmployee(String empNo) {
        return employeeDAO.deleteEmployee(empNo);
    }
}
