package biz.lms.chm.dao;

import biz.lms.chm.vo.ChargerManageVO;
import biz.lms.chm.vo.ExcelDownloadLogVO;
import egovframework.com.cmm.util.EgovProperties;
import egovframework.com.cmm.util.SecurityUtil;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.util.List;

/**
 * 담당자 관리 DAO
 */
@Repository
public class ChargerManageDAO {

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
     * 제공책임관 목록 조회
     */
    public List<ChargerManageVO> selectRspnofcrChargerList(Pageable pageable, ChargerManageVO searchVO, String orderByClause)
            throws IOException, InvocationTargetException, SQLException {
        List<ChargerManageVO> rspnofcrChargerList = selectList("ChargerManageDAO.selectRspnofcrChargerList", searchVO);

        // 전화번호 복호화
        for (int i = 0; i < rspnofcrChargerList.size(); i++) {
            String mberTelno = rspnofcrChargerList.get(i).getTelno();

            if (mberTelno != null && !mberTelno.trim().equals("")) {
                // 전화번호 복호화
                mberTelno = SecurityUtil.decryptBySeed(
                        EgovProperties.getProperty("system.telno.seedKey").trim(), mberTelno);
                if (mberTelno.equals("nullnullnull")) {
                    mberTelno = "-";
                }
            } else {
                mberTelno = "-";
            }
            rspnofcrChargerList.get(i).setTelno(mberTelno);
        }
        return rspnofcrChargerList;
    }

    /**
     * 제공책임관 총 개수 조회
     */
    public int selectRspnofcrChargerTotalCnt(ChargerManageVO searchVO) {
        Integer count = selectOne("ChargerManageDAO.selectRspnofcrChargerTotalCnt", searchVO);
        return count != null ? count : 0;
    }

    /**
     * 실무담당자 목록 조회
     */
    public List<ChargerManageVO> selectPrcafsChargerList(Pageable pageable, ChargerManageVO searchVO, String orderByClause)
            throws IOException, InvocationTargetException, SQLException {
        List<ChargerManageVO> prcafsChargerList = selectList("ChargerManageDAO.selectPrcafsChargerList", searchVO);

        // 전화번호 복호화
        for (int i = 0; i < prcafsChargerList.size(); i++) {
            String mbrTelno = prcafsChargerList.get(i).getMbrTelno();

            if (mbrTelno != null && !mbrTelno.trim().equals("")) {
                // 전화번호 복호화
                mbrTelno = SecurityUtil.decryptBySeed(
                        EgovProperties.getProperty("system.telno.seedKey").trim(), mbrTelno);
                if (mbrTelno.equals("nullnullnull")) {
                    mbrTelno = "-";
                }
            } else {
                mbrTelno = "-";
            }
            prcafsChargerList.get(i).setMbrTelno(mbrTelno);
        }
        return prcafsChargerList;
    }

    /**
     * 실무담당자 총 개수 조회
     */
    public int selectPrcafsChargerTotalCnt(ChargerManageVO searchVO) {
        Integer count = selectOne("ChargerManageDAO.selectPrcafsChargerTotalCnt", searchVO);
        return count != null ? count : 0;
    }

    /**
     * 엑셀 다운로드 이력 저장
     */
    public int insertExcelDownloadLog(ExcelDownloadLogVO logVO) {
        return sqlSessionTemplate.insert("ChargerManageDAO.insertExcelDownloadLog", logVO);
    }

    /**
     * 제공책임관 전체 목록 조회 (엑셀 다운로드용)
     */
    public List<ChargerManageVO> selectRspnofcrChargerListForExcel(ChargerManageVO searchVO)
            throws IOException, InvocationTargetException, SQLException {
        List<ChargerManageVO> rspnofcrChargerList = selectList("ChargerManageDAO.selectRspnofcrChargerListForExcel", searchVO);

        // 전화번호 복호화
        for (int i = 0; i < rspnofcrChargerList.size(); i++) {
            String mberTelno = rspnofcrChargerList.get(i).getTelno();

            if (mberTelno != null && !mberTelno.trim().equals("")) {
                // 전화번호 복호화
                mberTelno = SecurityUtil.decryptBySeed(
                        EgovProperties.getProperty("system.telno.seedKey").trim(), mberTelno);
                if (mberTelno.equals("nullnullnull")) {
                    mberTelno = "-";
                }
            } else {
                mberTelno = "-";
            }
            rspnofcrChargerList.get(i).setTelno(mberTelno);
        }
        return rspnofcrChargerList;
    }

    /**
     * 실무담당자 전체 목록 조회 (엑셀 다운로드용)
     */
    public List<ChargerManageVO> selectPrcafsChargerListForExcel(ChargerManageVO searchVO)
            throws IOException, InvocationTargetException, SQLException {
        List<ChargerManageVO> prcafsChargerList = selectList("ChargerManageDAO.selectPrcafsChargerListForExcel", searchVO);

        // 전화번호 복호화
        for (int i = 0; i < prcafsChargerList.size(); i++) {
            String mbrTelno = prcafsChargerList.get(i).getMbrTelno();

            if (mbrTelno != null && !mbrTelno.trim().equals("")) {
                // 전화번호 복호화
                mbrTelno = SecurityUtil.decryptBySeed(
                        EgovProperties.getProperty("system.telno.seedKey").trim(), mbrTelno);
                if (mbrTelno.equals("nullnullnull")) {
                    mbrTelno = "-";
                }
            } else {
                mbrTelno = "-";
            }
            prcafsChargerList.get(i).setMbrTelno(mbrTelno);
        }
        return prcafsChargerList;
    }
}
