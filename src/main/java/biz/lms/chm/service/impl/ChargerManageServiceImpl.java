package biz.lms.chm.service.impl;

import biz.lms.chm.dao.ChargerManageDAO;
import biz.lms.chm.service.ChargerManageService;
import biz.lms.chm.vo.ChargerManageVO;
import biz.lms.chm.vo.ExcelDownloadLogVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.com.cmm.service.CustomPage;
import egovframework.com.cmm.util.SortUtil;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
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

    @Override
    public void downloadRspnofcrChargerExcel(ChargerManageVO searchVO, ExcelDownloadLogVO logVO, HttpServletResponse response)
            throws InvocationTargetException, IOException, SQLException {

        // 데이터 조회
        List<ChargerManageVO> dataList = chargerManageDAO.selectRspnofcrChargerListForExcel(searchVO);

        // 다운로드 로그 저장
        logVO.setDownloadType("manager");
        logVO.setDownloadCount(dataList.size());
        ObjectMapper objectMapper = new ObjectMapper();
        logVO.setSearchParams(objectMapper.writeValueAsString(searchVO));
        chargerManageDAO.insertExcelDownloadLog(logVO);

        // 엑셀 생성
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("제공책임관 목록");

        // 헤더 스타일
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // 헤더 생성
        Row headerRow = sheet.createRow(0);
        String[] headers = {"NO", "등록방식", "기관명", "부서명", "제공책임관 명", "전화번호", "이메일", "행안부 공문"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 데이터 스타일
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);

        // 데이터 생성
        int rowNum = 1;
        for (ChargerManageVO vo : dataList) {
            Row row = sheet.createRow(rowNum++);

            Cell cell0 = row.createCell(0);
            cell0.setCellValue(rowNum - 1);
            cell0.setCellStyle(dataStyle);

            Cell cell1 = row.createCell(1);
            cell1.setCellValue(vo.getInsttTy() != null ? vo.getInsttTy() : "");
            cell1.setCellStyle(dataStyle);

            Cell cell2 = row.createCell(2);
            cell2.setCellValue(vo.getInsttNm() != null ? vo.getInsttNm() : "");
            cell2.setCellStyle(dataStyle);

            Cell cell3 = row.createCell(3);
            cell3.setCellValue(vo.getDeptNm() != null ? vo.getDeptNm() : "");
            cell3.setCellStyle(dataStyle);

            Cell cell4 = row.createCell(4);
            cell4.setCellValue(vo.getProvdRspnofcrNm() != null ? vo.getProvdRspnofcrNm() : "");
            cell4.setCellStyle(dataStyle);

            Cell cell5 = row.createCell(5);
            cell5.setCellValue(vo.getTelno() != null ? vo.getTelno() : "");
            cell5.setCellStyle(dataStyle);

            Cell cell6 = row.createCell(6);
            cell6.setCellValue(vo.getEmail() != null ? vo.getEmail() : "");
            cell6.setCellStyle(dataStyle);

            Cell cell7 = row.createCell(7);
            cell7.setCellValue(vo.getBaseAdministrationManagerTokn() != null ? vo.getBaseAdministrationManagerTokn() : "");
            cell7.setCellStyle(dataStyle);
        }

        // 컬럼 너비 자동 조정
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1024);
        }

        // 파일명 생성
        String fileName = "제공책임관_목록_" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".xlsx";
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

        // 응답 헤더 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

        // 엑셀 파일 출력
        OutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);
        workbook.close();
        outputStream.flush();
        outputStream.close();
    }

    @Override
    public void downloadPrcafsChargerExcel(ChargerManageVO searchVO, ExcelDownloadLogVO logVO, HttpServletResponse response)
            throws InvocationTargetException, IOException, SQLException {

        // 데이터 조회
        List<ChargerManageVO> dataList = chargerManageDAO.selectPrcafsChargerListForExcel(searchVO);

        // 다운로드 로그 저장
        logVO.setDownloadType("practical");
        logVO.setDownloadCount(dataList.size());
        ObjectMapper objectMapper = new ObjectMapper();
        logVO.setSearchParams(objectMapper.writeValueAsString(searchVO));
        chargerManageDAO.insertExcelDownloadLog(logVO);

        // 엑셀 생성
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("실무담당자 목록");

        // 헤더 스타일
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // 헤더 생성
        Row headerRow = sheet.createRow(0);
        String[] headers = {"NO", "담당자명", "사용자ID", "기관명", "부서명", "전화번호", "이메일"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 데이터 스타일
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);

        // 데이터 생성
        int rowNum = 1;
        for (ChargerManageVO vo : dataList) {
            Row row = sheet.createRow(rowNum++);

            Cell cell0 = row.createCell(0);
            cell0.setCellValue(rowNum - 1);
            cell0.setCellStyle(dataStyle);

            Cell cell1 = row.createCell(1);
            cell1.setCellValue(vo.getPicNm() != null ? vo.getPicNm() : "");
            cell1.setCellStyle(dataStyle);

            Cell cell2 = row.createCell(2);
            cell2.setCellValue(vo.getMbrId() != null ? vo.getMbrId() : "");
            cell2.setCellStyle(dataStyle);

            Cell cell3 = row.createCell(3);
            cell3.setCellValue(vo.getInsttNm() != null ? vo.getInsttNm() : "");
            cell3.setCellStyle(dataStyle);

            Cell cell4 = row.createCell(4);
            cell4.setCellValue(vo.getPicDeptNm() != null ? vo.getPicDeptNm() : "");
            cell4.setCellStyle(dataStyle);

            Cell cell5 = row.createCell(5);
            cell5.setCellValue(vo.getMbrTelno() != null ? vo.getMbrTelno() : "");
            cell5.setCellStyle(dataStyle);

            Cell cell6 = row.createCell(6);
            cell6.setCellValue(vo.getPicEmailAddr() != null ? vo.getPicEmailAddr() : "");
            cell6.setCellStyle(dataStyle);
        }

        // 컬럼 너비 자동 조정
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1024);
        }

        // 파일명 생성
        String fileName = "실무담당자_목록_" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + ".xlsx";
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

        // 응답 헤더 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

        // 엑셀 파일 출력
        OutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);
        workbook.close();
        outputStream.flush();
        outputStream.close();
    }
}
