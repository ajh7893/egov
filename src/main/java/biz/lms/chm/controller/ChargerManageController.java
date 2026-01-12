package biz.lms.chm.controller;

import biz.lms.chm.service.ChargerManageService;
import biz.lms.chm.vo.ChargerManageVO;
import biz.lms.chm.vo.ExcelDownloadLogVO;
import egovframework.com.cmm.util.HttpUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;

/**
 * 담당자 관리 Controller
 */
@Slf4j
@Controller
@RequestMapping("/lms/chm")
public class ChargerManageController {

    @Autowired
    private ChargerManageService chargerManageService;

    /**
     * 담당자 관리 페이지
     */
    @RequestMapping("/chargerManage.do")
    public ModelAndView chargerManagePage() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("lms/chm/chargerManage");
        return mav;
    }

    /**
     * 담당자 관리 페이지 (V2)
     */
    @RequestMapping("/chargerManageV2.do")
    public ModelAndView chargerManagePageV2() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("lms/chm/chargerManageV2");
        return mav;
    }

    /**
     * 제공책임관 목록 조회 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/selectRspnofcrChargerListJson.do")
    public ResponseEntity<Page<ChargerManageVO>> selectRspnofcrChargerListJson(
            @ModelAttribute("searchVO") ChargerManageVO searchVO,
            @PageableDefault(size = 10, sort = "created_at", direction = Sort.Direction.DESC) Pageable pageable)
            throws InvocationTargetException, IOException, SQLException {

        log.info("searchVO: {}", searchVO);

        Page<ChargerManageVO> dataList = chargerManageService.selectRspnofcrChargerList(searchVO, pageable);
        return HttpUtil.createResultOk(dataList);
    }

    /**
     * 실무담당자 목록 조회 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/selectPrcafsChargerListJson.do")
    public ResponseEntity<Page<ChargerManageVO>> selectPrcafsChargerListJson(
            @ModelAttribute("searchVO") ChargerManageVO searchVO,
            @PageableDefault(size = 10, sort = "created_at", direction = Sort.Direction.DESC) Pageable pageable)
            throws InvocationTargetException, IOException, SQLException {

        log.info("searchVO: {}", searchVO);

        Page<ChargerManageVO> dataList = chargerManageService.selectPrcafsChargerList(searchVO, pageable);
        return HttpUtil.createResultOk(dataList);
    }

    /**
     * 엑셀 다운로드 팝업
     */
    @RequestMapping("/excelDownloadPopup.do")
    public ModelAndView excelDownloadPopup() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("lms/chm/excelDownloadPopup");
        return mav;
    }

    /**
     * 제공책임관 엑셀 다운로드
     */
    @RequestMapping(value = "/downloadRspnofcrExcel.do")
    public void downloadRspnofcrExcel(
            @ModelAttribute("searchVO") ChargerManageVO searchVO,
            @RequestParam(value = "downloadReason", required = true) String downloadReason,
            @RequestParam(value = "userId", required = false) String userId,
            @RequestParam(value = "userName", required = false) String userName,
            HttpServletResponse response)
            throws InvocationTargetException, IOException, SQLException {

        log.info("제공책임관 엑셀 다운로드 - searchVO: {}, downloadReason: {}", searchVO, downloadReason);

        // 다운로드 로그 VO 생성
        ExcelDownloadLogVO logVO = new ExcelDownloadLogVO();
        logVO.setDownloadReason(downloadReason);
        logVO.setUserId(userId);
        logVO.setUserName(userName);

        chargerManageService.downloadRspnofcrChargerExcel(searchVO, logVO, response);
    }

    /**
     * 실무담당자 엑셀 다운로드
     */
    @RequestMapping(value = "/downloadPrcafsExcel.do")
    public void downloadPrcafsExcel(
            @ModelAttribute("searchVO") ChargerManageVO searchVO,
            @RequestParam(value = "downloadReason", required = true) String downloadReason,
            @RequestParam(value = "userId", required = false) String userId,
            @RequestParam(value = "userName", required = false) String userName,
            HttpServletResponse response)
            throws InvocationTargetException, IOException, SQLException {

        log.info("실무담당자 엑셀 다운로드 - searchVO: {}, downloadReason: {}", searchVO, downloadReason);

        // 다운로드 로그 VO 생성
        ExcelDownloadLogVO logVO = new ExcelDownloadLogVO();
        logVO.setDownloadReason(downloadReason);
        logVO.setUserId(userId);
        logVO.setUserName(userName);

        chargerManageService.downloadPrcafsChargerExcel(searchVO, logVO, response);
    }
}
