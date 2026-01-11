<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원 관리</title>

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
        .search-row input[type="date"],
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
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-light {
            background: #f8f9fa;
            border: 1px solid #ddd;
        }
        .grid-container {
            height: 500px;
        }
        #grid {
            height: 100%;
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
        .button-group {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>직원 관리</h1>

        <!-- 검색 영역 -->
        <div class="search-area" id="searchArea">
            <div class="search-row">
                <label>검색조건:</label>
                <select id="searchCondition" name="searchCondition">
                    <option value="">전체</option>
                    <option value="empNo">사번</option>
                    <option value="empName">직원명</option>
                    <option value="email">이메일</option>
                </select>
                <input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요">
            </div>
            <div class="search-row">
                <label>부서:</label>
                <select id="searchDeptCode" name="searchDeptCode">
                    <option value="">전체</option>
                    <option value="DEPT001">개발팀</option>
                    <option value="DEPT002">영업팀</option>
                    <option value="DEPT003">인사팀</option>
                    <option value="DEPT004">총무팀</option>
                </select>
                <label style="margin-left: 20px;">상태:</label>
                <select id="searchStatus" name="searchStatus">
                    <option value="">전체</option>
                    <option value="ACTIVE">재직</option>
                    <option value="INACTIVE">휴직</option>
                    <option value="RETIRED">퇴사</option>
                </select>
            </div>
            <div class="search-row">
                <label>입사일:</label>
                <input type="date" id="startDt" name="startDt"> ~
                <input type="date" id="endDt" name="endDt">
            </div>
            <div class="search-row" style="text-align: center; margin-top: 15px;">
                <button class="btn btn-primary" onclick="searchGrid()">검색</button>
                <button class="btn btn-light" onclick="resetSearch()">초기화</button>
            </div>
        </div>

        <!-- 버튼 그룹 -->
        <div class="button-group">
            <button class="btn btn-success" onclick="openAddModal()">신규 등록</button>
            <button class="btn btn-danger" onclick="deleteSelected()">선택 삭제</button>
            <button class="btn btn-light" onclick="excelDownload()">엑셀 다운로드</button>
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

    <script>
        let currentParams = {};
        const pagerState = {
            page: 1,
            size: 10,
            total: 0
        };

        /**
         * 그리드 초기화
         */
        function initGrid() {
            // 기존 그리드 제거
            if (w2ui['grid']) {
                w2ui['grid'].destroy();
            }

            $('#grid').w2grid({
                name: 'grid',
                show: {
                    selectColumn: true,
                    toolbar: true,
                    footer: false
                },
                multiSelect: true,
                columns: [
                    { field: 'rn', text: 'NO', size: '60px', attr: 'align-center' },
                    { field: 'empNo', text: '사번', size: '100px', attr: 'align-center' },
                    { field: 'empName', text: '직원명', size: '100px', attr: 'align-center' },
                    { field: 'email', text: '이메일', size: '15%', attr: 'align-center' },
                    { field: 'phone', text: '전화번호', size: '120px', attr: 'align-center' },
                    { field: 'deptName', text: '부서', size: '120px', attr: 'align-center' },
                    { field: 'position', text: '직급', size: '100px', attr: 'align-center' },
                    { field: 'hireDate', text: '입사일', size: '100px', attr: 'align-center',
                        render: function(record) {
                            if (record.hireDate) {
                                const date = new Date(record.hireDate);
                                return date.toISOString().split('T')[0];
                            }
                            return '';
                        }
                    },
                    { field: 'salary', text: '급여', size: '120px', attr: 'align-right',
                        render: function(record) {
                            if (record.salary) {
                                return Number(record.salary).toLocaleString() + '원';
                            }
                            return '';
                        }
                    },
                    { field: 'status', text: '상태', size: '80px', attr: 'align-center',
                        render: function(record) {
                            const statusMap = {
                                'ACTIVE': '<span style="color:green;">재직</span>',
                                'INACTIVE': '<span style="color:orange;">휴직</span>',
                                'RETIRED': '<span style="color:red;">퇴사</span>'
                            };
                            return statusMap[record.status] || record.status;
                        }
                    }
                ],
                onDblClick: function(event) {
                    const record = w2ui.grid.get(event.recid);
                    openEditModal(record);
                }
            });
        }

        function buildQueryParams(page) {
            return $.extend({}, currentParams, {
                page: page - 1,
                size: pagerState.size
            });
        }

        function updatePagerUI() {
            const maxPage = Math.max(1, Math.ceil(pagerState.total / pagerState.size));
            $('#pageInfo').text('Page ' + pagerState.page + ' / ' + maxPage);
            $('#pageInput').val(pagerState.page);
            $('#prevBtn').prop('disabled', pagerState.page <= 1);
            $('#nextBtn').prop('disabled', pagerState.page >= maxPage);

            const $numbers = $('#pageNumbers');
            $numbers.empty();
            const windowSize = 5;
            let start = Math.max(1, pagerState.page - Math.floor(windowSize / 2));
            let end = Math.min(maxPage, start + windowSize - 1);
            start = Math.max(1, end - windowSize + 1);

            for (let p = start; p <= end; p++) {
                const $btn = $('<button type="button"></button>').text(p);
                if (p === pagerState.page) {
                    $btn.prop('disabled', true);
                } else {
                    $btn.on('click', function() { loadPage(p); });
                }
                $numbers.append($btn);
            }
        }

        function loadPage(page) {
            const query = buildQueryParams(page);
            $.ajax({
                url: "/lms/emp/selectEmployeeListJson.do",
                method: "GET",
                data: query,
                success: function(response) {
                    const content = response && response.content ? response.content : [];
                    const total = response && Number.isFinite(Number(response.totalElements))
                        ? Number(response.totalElements)
                        : content.length;
                    const records = content.map((item, index) => {
                        item.recid = item.empNo || ((page - 1) * pagerState.size + index + 1);
                        return item;
                    });

                    pagerState.page = page;
                    pagerState.total = total;

                    w2ui.grid.records = records;
                    w2ui.grid.total = total;
                    w2ui.grid.refresh();
                    w2ui.grid.resize();
                    updatePagerUI();
                }
            });
        }

        /**
         * 검색
         */
        window.searchGrid = function() {
            currentParams = SearchDataHandler.collectParams('#searchArea');
            loadPage(1);
        }

        /**
         * 검색 초기화
         */
        window.resetSearch = function() {
            $('#searchArea input[type="text"]').val('');
            $('#searchArea input[type="date"]').val('');
            $('#searchArea select').val('');
            currentParams = {};
            loadPage(1);
        }

        /**
         * 신규 등록 모달
         */
        window.openAddModal = function() {
            alert('신규 등록 기능은 추후 구현 예정입니다.');
            // TODO: 모달 팝업 구현
        }

        /**
         * 수정 모달
         */
        window.openEditModal = function(record) {
            alert('수정 기능은 추후 구현 예정입니다.\n선택한 직원: ' + record.empName);
            // TODO: 모달 팝업 구현
        }

        /**
         * 선택 삭제
         */
        window.deleteSelected = function() {
            const selection = w2ui.grid.getSelection();
            if (selection.length === 0) {
                alert('삭제할 직원을 선택해주세요.');
                return;
            }

            if (!confirm(selection.length + '명의 직원을 삭제하시겠습니까?')) {
                return;
            }

            alert('삭제 기능은 추후 구현 예정입니다.');
            // TODO: 삭제 API 호출
        }

        /**
         * 엑셀 다운로드
         */
        window.excelDownload = function() {
            alert('엑셀 다운로드 기능은 추후 구현 예정입니다.');
            // TODO: 엑셀 다운로드 구현
        }

        // 페이지 로드 시 초기화
        $(document).ready(function() {
            initGrid();
            $('#pageSize').on('change', function() {
                const size = parseInt($(this).val(), 10);
                if (!Number.isNaN(size) && size > 0) {
                    pagerState.size = size;
                    loadPage(1);
                }
            });
            $('#prevBtn').on('click', function() { loadPage(pagerState.page - 1); });
            $('#nextBtn').on('click', function() { loadPage(pagerState.page + 1); });
            $('#pageInput').on('change', function() {
                const page = parseInt($(this).val(), 10);
                if (!Number.isNaN(page)) {
                    loadPage(page);
                }
            });
            loadPage(1);
        });
    </script>
</body>
</html>
