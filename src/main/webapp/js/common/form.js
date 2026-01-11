/**
 * 검색 데이터 핸들러
 * 데이터 검색 시 자동으로 값을 가져오는 기능 제공
 */
var SearchDataHandler = {
    /**
     * 날짜버튼 그룹 이벤트 초기화
     * @param {string} groupSelector - 버튼 감싸고 있는 div
     * class dateBtn 해야 인식 및 동작
     * data-range 데이터를 선언 해둬야 해당 일자 계산
     */
    setDateBtn: function (groupSelector) {
        $(document).on("click", ".dateBtn", function (e) {
            var $this = $(this);
            var range = $this.data("range");

            $this.addClass("active").siblings().removeClass("active");
            var startInput = $("#startDt");
            var endInput = $("#endDt");

            if (range == "all") {
                startInput.val("");
                endInput.val("");
            } else {
                const today = new Date();
                const endData = today.toISOString().split("T")[0];
                // 시작일 계산
                const startDateObj = new Date();
                startDateObj.setMonth(today.getMonth() - parseInt(range));
                const startDate = startDateObj.toISOString().split("T")[0];
                startInput.val(startDate);
                endInput.val(endData);
            }
        });
    },

    /**
     * 파라미터 수집
     * @param {string} containerSelector - 검색 폼 컨테이너 selector
     * @returns {Object} 수집된 파라미터 객체
     */
    collectParams: function (containerSelector) {
        var params = {};
        var container = $(containerSelector);

        if (container.length === 0) {
            console.log("컨테이너를 찾을 수 없습니다.");
            return params;
        }

        $(containerSelector)
            .find("input, select")
            .each(function () {
                var $el = $(this);
                var val = $el.val();
                var name = $el.attr("name") || $el.attr("id");

                if (!name) {
                    console.log("Name or ID Missing for element: ", $el[0]);
                    return;
                }
                if (val == "" || val == void 0) return;

                if ($el.is(":checkbox")) {
                    // 체크박스 처리 (배열)
                    if ($el.is(":checked")) {
                        if (!params[name]) {
                            params[name] = val; // 첫값
                        } else {
                            params[name] += "," + val; // 두번째 값부터 쉼표로 합침
                        }
                    }
                } else if ($el.is(":radio")) {
                    // 라디오 버튼 처리
                    if ($el.is(":checked")) params[name] = val;
                } else {
                    // 일반 text, date, select 처리
                    params[name] = val;
                }
            });
        return params;
    }
};

// 오타 수정을 위한 별칭
SearchDataHandler.collertParams = SearchDataHandler.collectParams;
