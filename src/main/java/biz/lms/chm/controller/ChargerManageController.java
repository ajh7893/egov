package biz.lms.chm.controller;

import biz.lms.chm.service.ChargerManageService;
import biz.lms.chm.vo.ChargerManageVO;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
}
