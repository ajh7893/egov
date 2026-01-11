package biz.lms.chm.service;

import biz.lms.chm.vo.ChargerManageVO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

/**
 * 담당자 관리 Service 인터페이스
 */
public interface ChargerManageService {

    /**
     * 제공책임관 목록 조회
     */
    Page<ChargerManageVO> selectRspnofcrChargerList(ChargerManageVO searchVO, Pageable pageable)
            throws InvocationTargetException, IOException, SQLException;

    /**
     * 실무담당자 목록 조회
     */
    Page<ChargerManageVO> selectPrcafsChargerList(ChargerManageVO searchVO, Pageable pageable)
            throws InvocationTargetException, IOException, SQLException;
}
