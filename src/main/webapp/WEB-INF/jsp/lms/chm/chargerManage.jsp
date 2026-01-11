<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>담당자 관리</title>

    <!-- jQuery -->
    <script src="<c:url value='/js/jQuery/jquery-3.6.0.min.js'/>"></script>

    <!-- W2UI -->
    <link rel="stylesheet" href="<c:url value='/js/w2ui/w2ui-2.0.min.css'/>">
    <script src="<c:url value='/js/w2ui/w2ui-2.0.min.js'/>"></script>

    <!-- 공통 JS -->
    <script src="<c:url value='/js/common/form.js'/>"></script>
    <script src="<c:url value='/js/common/W2GridHelper.js'/>"></script>

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
    </style>
</head>
<body>
    <div class="container">
        <h1>담당자 관리</h1>

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
    </div>

    <script type="module">
        // 그리드 설정
        const gridConfigs = {
            // 제공책임관
            manager: {
                url: "/lms/chm/selectRspnofcrChargerListJson.do",
                multiSelect: false,
                show: {
                    selectColumn: false,
                    footer: true,
                    toolbar: true,
                    saveRestoreState: false
                },
                buttons: [
                    {
                        id: "excelDownload",
                        text: "엑셀다운로드",
                        icon: "svg-icon ico-download",
                        class: "btn btn-light",
                        click: function() { alert("엑셀 다운로드 기능 준비중"); }
                    }
                ],
                columnGroups: [
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true }
                ],
                columns: [
                    { field: 'recid', hidden: true },
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

            // 실무담당자
            practical: {
                url: "/lms/chm/selectPrcafsChargerListJson.do",
                multiSelect: false,
                show: {
                    selectColumn: true,
                    footer: true,
                    toolbar: true,
                    saveRestoreState: false
                },
                buttons: [
                    {
                        id: "excelDownload",
                        text: "엑셀다운로드",
                        icon: "svg-icon ico-download",
                        class: "btn btn-light",
                        click: function() { alert("엑셀 다운로드 기능 준비중"); }
                    }
                ],
                columnGroups: [
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true },
                    { text: "", span: 1, main: true }
                ],
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

        let currentGridHelper = null;
        let currentType = 'manager';

        /**
         * 그리드 초기화
         */
        function initTabGrid(type) {
            // 기존 그리드 제거
            if (w2ui['grid']) {
                w2ui['grid'].destroy();
            }

            const config = gridConfigs[type];
            if (!config) return;

            currentGridHelper = new W2GridHelper({
                url: config.url,
                multiSelect: config.multiSelect,
                show: config.show,
                buttons: config.buttons,
                useLocalStorage: false,
                stateId: "chm-" + type,
                offset: 0,
                target: "#grid",
                params: {
                    page: 1
                },
                sort: {
                    createdAt: "desc",
                    title: "desc"
                },
                multiSort: true,
                customToolbar: true,
                idField: "recid",
                columnGroups: config.columnGroups,
                columns: config.columns,

                onSearch: function(event) {
                    console.log(event.postData);
                },

                onRequest: function(event) {
                    console.log(event.postData);
                }
            });
            if (w2ui.grid) {
                w2ui.grid.offset = 0;
                if (w2ui.grid.last && w2ui.grid.last.fetch) {
                    w2ui.grid.last.fetch.offset = 0;
                    w2ui.grid.last.fetch.hasMore = false;
                }
                w2ui.grid.total = 0;
                w2ui.grid.records = [];
                w2ui.grid.resize();
            }
        }

        /**
         * 탭 변경
         */
        window.changeTab = function(type) {
            currentType = type;

            // 탭 버튼 활성화
            $('.tab-btn').removeClass('active');
            $(`.tab-btn[data-type="${type}"]`).addClass('active');

            // 그리드 초기화
            initTabGrid(type);
        }

        /**
         * 검색
         */
        window.searchGrid = function() {
            const params = SearchDataHandler.collectParams('#searchArea');
            if (currentGridHelper) {
                currentGridHelper.search(params);
            }
        }

        /**
         * 검색 초기화
         */
        window.resetSearch = function() {
            $('#searchArea input[type="text"]').val('');
            $('#searchArea input[type="date"]').val('');
            $('#searchArea input[type="checkbox"]').prop('checked', false);
            $('.dateBtn').removeClass('active');
            searchGrid();
        }

        // 페이지 로드 시 초기화
        $(document).ready(function() {
            // 날짜 버튼 이벤트 초기화
            SearchDataHandler.setDateBtn();

            // 초기 그리드 로드
            initTabGrid('manager');
        });
    </script>
</body>
</html>
