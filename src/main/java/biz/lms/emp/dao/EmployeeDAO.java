package biz.lms.emp.dao;

import biz.lms.emp.vo.EmployeeVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 직원 관리 DAO
 */
@Repository
public class EmployeeDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    /**
     * SQL 조회
     */
    private <T> List<T> selectList(String queryId, Object params) {
        return sqlSessionTemplate.selectList(queryId, params);
    }

    /**
     * SQL 단건 조회
     */
    private <T> T selectOne(String queryId, Object params) {
        return sqlSessionTemplate.selectOne(queryId, params);
    }

    /**
     * 직원 목록 조회
     */
    public List<EmployeeVO> selectEmployeeList(Pageable pageable, EmployeeVO searchVO, String orderByClause) {
        return selectList("EmployeeDAO.selectEmployeeList", searchVO);
    }

    /**
     * 직원 총 개수 조회
     */
    public int selectEmployeeTotalCnt(EmployeeVO searchVO) {
        Integer count = selectOne("EmployeeDAO.selectEmployeeTotalCnt", searchVO);
        return count != null ? count : 0;
    }

    /**
     * 직원 상세 조회
     */
    public EmployeeVO selectEmployeeDetail(String empNo) {
        return selectOne("EmployeeDAO.selectEmployeeDetail", empNo);
    }

    /**
     * 직원 등록
     */
    public int insertEmployee(EmployeeVO employeeVO) {
        return sqlSessionTemplate.insert("EmployeeDAO.insertEmployee", employeeVO);
    }

    /**
     * 직원 수정
     */
    public int updateEmployee(EmployeeVO employeeVO) {
        return sqlSessionTemplate.update("EmployeeDAO.updateEmployee", employeeVO);
    }

    /**
     * 직원 삭제
     */
    public int deleteEmployee(String empNo) {
        return sqlSessionTemplate.delete("EmployeeDAO.deleteEmployee", empNo);
    }
}
