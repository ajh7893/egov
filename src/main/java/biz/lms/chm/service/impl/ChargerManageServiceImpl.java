package biz.lms.chm.service.impl;

import biz.lms.chm.dao.ChargerManageDAO;
import biz.lms.chm.service.ChargerManageService;
import biz.lms.chm.vo.ChargerManageVO;
import egovframework.com.cmm.service.CustomPage;
import egovframework.com.cmm.util.SortUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.List;

/**
 * 담당자 관리 Service 구현체
 */
@Service
public class ChargerManageServiceImpl implements ChargerManageService {

    @Autowired
    private ChargerManageDAO chargerManageDAO;

    @Override
    public Page<ChargerManageVO> selectRspnofcrChargerList(ChargerManageVO searchVO, Pageable pageable)
            throws InvocationTargetException, IOException, SQLException {

        String orderByClause = SortUtil.toOrderByClause(pageable);
        int offset = (pageable.getPageNumber() * pageable.getPageSize()) + 1;

        searchVO.setFirstIndex(offset);
        searchVO.setRecordCountPerPage(pageable.getPageSize());

        List<ChargerManageVO> list = chargerManageDAO.selectRspnofcrChargerList(pageable, searchVO, orderByClause);
        int totalCount = chargerManageDAO.selectRspnofcrChargerTotalCnt(searchVO);

        return new CustomPage<>(list, pageable, totalCount);
    }

    @Override
    public Page<ChargerManageVO> selectPrcafsChargerList(ChargerManageVO searchVO, Pageable pageable)
            throws InvocationTargetException, IOException, SQLException {

        String orderByClause = SortUtil.toOrderByClause(pageable);
        int offset = (pageable.getPageNumber() * pageable.getPageSize()) + 1;

        searchVO.setFirstIndex(offset);
        searchVO.setRecordCountPerPage(pageable.getPageSize());

        List<ChargerManageVO> list = chargerManageDAO.selectPrcafsChargerList(pageable, searchVO, orderByClause);
        int totalCount = chargerManageDAO.selectPrcafsChargerTotalCnt(searchVO);

        return new CustomPage<>(list, pageable, totalCount);
    }
}
