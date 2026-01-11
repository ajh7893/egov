package biz.lms.emp.controller;

import biz.lms.emp.service.EmployeeService;
import biz.lms.emp.vo.EmployeeVO;
import egovframework.com.cmm.util.HttpUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

/**
 * 직원 관리 Controller
 */
@Slf4j
@Controller
@RequestMapping("/lms/emp")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    /**
     * 직원 관리 페이지
     */
    @RequestMapping("/employeeManage.do")
    public ModelAndView employeeManagePage() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("lms/emp/employeeManage");
        return mav;
    }

    /**
     * 직원 관리 페이지 (V2)
     */
    @RequestMapping("/employeeManageV2.do")
    public ModelAndView employeeManagePageV2() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("lms/emp/employeeManageV2");
        return mav;
    }

    /**
     * 직원 목록 조회 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/selectEmployeeListJson.do")
    public ResponseEntity<Page<EmployeeVO>> selectEmployeeListJson(
            @ModelAttribute("searchVO") EmployeeVO searchVO,
            @PageableDefault(size = 10, sort = "regDate", direction = Sort.Direction.DESC) Pageable pageable) {

        log.info("searchVO: {}", searchVO);

        Page<EmployeeVO> dataList = employeeService.selectEmployeeList(searchVO, pageable);
        return HttpUtil.createResultOk(dataList);
    }

    /**
     * 직원 상세 조회 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/selectEmployeeDetailJson.do")
    public ResponseEntity<EmployeeVO> selectEmployeeDetailJson(@RequestParam("empNo") String empNo) {
        EmployeeVO employee = employeeService.selectEmployeeDetail(empNo);
        return HttpUtil.createResultOk(employee);
    }

    /**
     * 직원 등록 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/insertEmployeeJson.do", method = RequestMethod.POST)
    public ResponseEntity<String> insertEmployeeJson(@ModelAttribute EmployeeVO employeeVO) {
        log.info("insertEmployee: {}", employeeVO);

        int result = employeeService.insertEmployee(employeeVO);
        if (result > 0) {
            return HttpUtil.createResultOk("SUCCESS");
        } else {
            return HttpUtil.createResultOk("FAIL");
        }
    }

    /**
     * 직원 수정 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/updateEmployeeJson.do", method = RequestMethod.POST)
    public ResponseEntity<String> updateEmployeeJson(@ModelAttribute EmployeeVO employeeVO) {
        log.info("updateEmployee: {}", employeeVO);

        int result = employeeService.updateEmployee(employeeVO);
        if (result > 0) {
            return HttpUtil.createResultOk("SUCCESS");
        } else {
            return HttpUtil.createResultOk("FAIL");
        }
    }

    /**
     * 직원 삭제 (JSON)
     */
    @ResponseBody
    @RequestMapping(value = "/deleteEmployeeJson.do", method = RequestMethod.POST)
    public ResponseEntity<String> deleteEmployeeJson(@RequestParam("empNo") String empNo) {
        log.info("deleteEmployee: {}", empNo);

        int result = employeeService.deleteEmployee(empNo);
        if (result > 0) {
            return HttpUtil.createResultOk("SUCCESS");
        } else {
            return HttpUtil.createResultOk("FAIL");
        }
    }
}
