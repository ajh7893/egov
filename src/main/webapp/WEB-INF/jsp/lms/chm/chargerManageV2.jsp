<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>담당자 관리 (V2)</title>

    <!-- jQuery -->
    <script src="<c:url value='/js/jQuery/jquery-3.6.0.min.js'/>"></script>

    <!-- jQuery UI (CDN) -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

    <!-- W2UI -->
    <link rel="stylesheet" href="<c:url value='/js/w2ui/w2ui-2.0.min.css'/>">
    <script src="<c:url value='/js/w2ui/w2ui-2.0.min.js'/>"></script>

    <!-- 공통 JS -->
    <script src="<c:url value='/js/common/form.js'/>"></script>
    <script src="<c:url value='/js/common/W2RemotePager.js'/>"></script>

    <style>
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        .search-area {
            background: #f5f5f5;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .search-row {
            margin-bottom: 10px;
        }
        .search-row label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
        }
        .search-row input[type="text"],
        .search-row select {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 3px;
            width: 250px;
        }
        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin-left: 5px;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .btn-light {
            background: #f8f9fa;
            border: 1px solid #ddd;
        }
        .tab-menu {
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
        }
        .tab-menu button {
            padding: 10px 30px;
            border: none;
            background: #f5f5f5;
            cursor: pointer;
            margin-right: 5px;
            border-radius: 5px 5px 0 0;
        }
        .tab-menu button.active {
            background: #007bff;
            color: white;
        }
        .grid-container {
            height: 500px;
        }
        #grid {
            height: 100%;
        }
        .dateBtn {
            padding: 5px 10px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            margin-right: 5px;
        }
        .dateBtn.active {
            background: #007bff;
            color: white;
        }
        .pager {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 10px 0 0;
            flex-wrap: wrap;
        }
        .pager button {
            padding: 6px 10px;
            border: 1px solid #ccc;
            background: #f7f7f7;
            cursor: pointer;
        }
        .pager button:disabled {
            cursor: default;
            opacity: 0.6;
        }
        .pager select,
        .pager input {
            padding: 6px 8px;
            border: 1px solid #ccc;
        }
        .pager .info {
            min-width: 140px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>담당자 관리 (V2)</h1>

        <!-- 검색 영역 -->
        <div class="search-area" id="searchArea">
            <div class="search-row">
                <label>기관명:</label>
                <input type="text" id="searchKeyword2" name="searchKeyword2" placeholder="기관명을 입력하세요">
                <label style="margin-left: 20px;">
                    <input type="checkbox" id="searchCondition5" name="searchCondition5" value="Y">
                    하위기관 포함
                </label>
            </div>
            <div class="search-row">
                <label>담당자명:</label>
                <input type="text" id="searchKeyword3" name="searchKeyword3" placeholder="담당자명을 입력하세요">
            </div>
            <div class="search-row">
                <label>기간:</label>
                <button class="dateBtn" data-range="all">전체</button>
                <button class="dateBtn" data-range="1">1개월</button>
                <button class="dateBtn" data-range="3">3개월</button>
                <button class="dateBtn" data-range="6">6개월</button>
                <button class="dateBtn" data-range="12">1년</button>
                <input type="date" id="startDt" name="startDt"> ~
                <input type="date" id="endDt" name="endDt">
            </div>
            <div class="search-row" style="text-align: center; margin-top: 15px;">
                <button class="btn btn-primary" onclick="searchGrid()">검색</button>
                <button class="btn btn-light" onclick="resetSearch()">초기화</button>
            </div>
        </div>

        <!-- 탭 메뉴 -->
        <div class="tab-menu">
            <button class="tab-btn active" data-type="manager" onclick="changeTab('manager')">제공책임관</button>
            <button class="tab-btn" data-type="practical" onclick="changeTab('practical')">실무담당자</button>
        </div>

        <!-- 그리드 영역 -->
        <div class="grid-container">
            <div id="grid"></div>
        </div>
        <div class="pager">
            <button class="btn" type="button" id="prevBtn">Prev</button>
            <button class="btn" type="button" id="nextBtn">Next</button>
            <span class="info" id="pageInfo">Page 1 / 1</span>
            <div id="pageNumbers"></div>
            <label for="pageInput">Go to</label>
            <input type="number" id="pageInput" min="1" value="1" style="width: 80px;">
            <label for="pageSize">Page size</label>
            <select id="pageSize">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
        </div>
    </div>

    <!-- 모달 컨테이너 -->
    <div id="modal"></div>

    <script>
        const gridConfigs = {
            manager: {
                url: "/lms/chm/selectRspnofcrChargerListJson.do",
                toolbar: {
                    items: [
                        { type: 'spacer' },
                        { type: 'button', id: 'excelDownload', text: '엑셀 다운로드', icon: 'w2ui-icon-check' }
                    ],
                    onClick: function(event) {
                        if (event.target === 'excelDownload') {
                            openExcelDownloadModal('manager');
                        }
                    }
                },
                columns: [
                    { field: 'rn', text: 'NO', size: '80px', attr: 'align-center' },
                    { field: 'insttTy', text: '등록방식', size: '80px', attr: 'align-center' },
                    { field: 'insttNm', text: '기관명', size: '15%', resizable: true, attr: 'align-center' },
                    { field: 'deptNm', text: '부서명', size: '15%', resizable: true, attr: 'align-center' },
                    { field: 'provdRspnofcrNm', text: '제공책임관 명', size: '137px', min: 100, attr: 'align-center', resizable: true },
                    { field: 'telno', text: '전화번호', size: '120px', min: 100, attr: 'align-center', resizable: true },
                    { field: 'email', text: '이메일', size: '15%', attr: 'align-center', resizable: true },
                    { field: 'baseAdministrationManagerTokn', text: '행안부 공문', size: '90px', attr: 'align-center' }
                ]
            },
            practical: {
                url: "/lms/chm/selectPrcafsChargerListJson.do",
                toolbar: {
                    items: [
                        { type: 'spacer' },
                        { type: 'button', id: 'excelDownload', text: '엑셀 다운로드', icon: 'w2ui-icon-check' }
                    ],
                    onClick: function(event) {
                        if (event.target === 'excelDownload') {
                            openExcelDownloadModal('practical');
                        }
                    }
                },
                columns: [
                    { field: 'rn', text: 'NO', size: '80px', attr: 'align-center' },
                    { field: 'picNm', text: '담당자명', size: '80px', attr: 'align-center' },
                    { field: 'mbrId', text: '사용자ID', size: '15%', resizable: true, attr: 'align-center' },
                    { field: 'insttNm', text: '기관명', size: '15%', resizable: true, attr: 'align-center' },
                    { field: 'picDeptNm', text: '부서명', size: '137px', min: 100, attr: 'align-center', resizable: true },
                    { field: 'mbrTelno', text: '전화번호', size: '120px', min: 100, attr: 'align-center', resizable: true },
                    { field: 'picEmailAddr', text: '이메일', size: '15%', attr: 'align-center', resizable: true }
                ]
            }
        };

        let currentType = 'manager';
        let currentParams = {};
        let pager = null;

        function initTabGrid(type) {
            currentType = type;
            const config = gridConfigs[type];
            if (!config) return;

            pager = new W2RemotePager({
                gridName: 'grid',
                gridTarget: '#grid',
                url: config.url,
                idField: 'recid',
                pageSize: 10,
                show: {
                    selectColumn: type === 'practical',
                    toolbar: true,
                    footer: false
                },
                toolbar: config.toolbar,
                columns: config.columns,
                getParams: function() {
                    return currentParams;
                }
            });

            pager.init();
            pager.loadPage(1);
        }

        window.changeTab = function(type) {
            currentType = type;
            $('.tab-btn').removeClass('active');
            $(".tab-btn[data-type='" + type + "']").addClass('active');
            initTabGrid(type);
        };

        window.searchGrid = function() {
            currentParams = SearchDataHandler.collectParams('#searchArea');
            pager.loadPage(1);
        };

        window.resetSearch = function() {
            $('#searchArea input[type="text"]').val('');
            $('#searchArea input[type="date"]').val('');
            $('#searchArea input[type="checkbox"]').prop('checked', false);
            $('.dateBtn').removeClass('active');
            currentParams = {};
            pager.loadPage(1);
        };

        /**
         * 엑셀 다운로드 모달 열기
         */
        function openExcelDownloadModal(type) {
            $.ajax({
                url: '/lms/chm/excelDownloadPopup.do',
                method: 'GET',
                success: function(html) {
                    $('#modal').html(html);

                    // 모달의 콜백 함수 설정
                    window.excelDownloadCallback = function(reason) {
                        downloadExcel(type, reason);
                    };
                },
                error: function(xhr, status, error) {
                    alert('모달을 불러오는 중 오류가 발생했습니다.');
                    console.error(error);
                }
            });
        }

        /**
         * 엑셀 다운로드 실행
         */
        function downloadExcel(type, reason) {
            var url = '';
            if (type === 'manager') {
                url = '/lms/chm/downloadRspnofcrExcel.do';
            } else if (type === 'practical') {
                url = '/lms/chm/downloadPrcafsExcel.do';
            }

            // 검색 조건 수집
            var params = SearchDataHandler.collectParams('#searchArea');
            params.downloadReason = reason;
            // TODO: 실제 사용자 정보를 세션에서 가져와서 설정
            // params.userId = '${sessionScope.userId}';
            // params.userName = '${sessionScope.userName}';

            // form을 이용한 다운로드
            var $form = $('<form>', {
                method: 'POST',
                action: url
            });

            $.each(params, function(key, value) {
                if (value !== null && value !== undefined && value !== '') {
                    $form.append($('<input>', {
                        type: 'hidden',
                        name: key,
                        value: value
                    }));
                }
            });

            $('body').append($form);
            $form.submit();
            $form.remove();

            // 모달 닫기
            $('#modal').empty();

            alert('엑셀 다운로드가 시작되었습니다.');
        }

        $(document).ready(function() {
            SearchDataHandler.setDateBtn();
            initTabGrid('manager');
        });
    </script>
</body>
</html>
