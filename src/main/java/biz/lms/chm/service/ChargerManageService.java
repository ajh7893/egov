package biz.lms.chm.service;

import biz.lms.chm.vo.ChargerManageVO;
import biz.lms.chm.vo.ExcelDownloadLogVO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.List;

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

    /**
     * 제공책임관 엑셀 다운로드
     */
    void downloadRspnofcrChargerExcel(ChargerManageVO searchVO, ExcelDownloadLogVO logVO, HttpServletResponse response)
            throws InvocationTargetException, IOException, SQLException;

    /**
     * 실무담당자 엑셀 다운로드
     */
    void downloadPrcafsChargerExcel(ChargerManageVO searchVO, ExcelDownloadLogVO logVO, HttpServletResponse response)
            throws InvocationTargetException, IOException, SQLException;
}
