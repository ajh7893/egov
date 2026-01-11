/**
 * W2UI Grid Helper
 * w2ui 그리드를 쉽게 생성하고 관리하기 위한 헬퍼 클래스
 */
class W2GridHelper {
    constructor(options) {
        this.options = $.extend(true, {
            target: '#grid',
            url: '',
            params: {},
            multiSelect: false,
            show: {
                toolbar: true,
                footer: true,
                selectColumn: false,
                lineNumbers: false
            },
            buttons: [],
            columns: [],
            columnGroups: [],
            idField: 'recid',
            offset: 0,
            useLocalStorage: true,
            stateId: null,
            sort: {},
            multiSort: false,
            customToolbar: false,
            onSearch: null,
            onRequest: null,
            onLoad: null
        }, options);

        this.init();
    }

    /**
     * 그리드 초기화
     */
    init() {
        const self = this;
        const config = {
            name: 'grid',
            url: this.options.url,
            method: 'POST',
            recid: this.options.idField,
            offset: this.options.offset,
            useLocalStorage: this.options.useLocalStorage,
            stateId: this.options.stateId,
            multiSelect: this.options.multiSelect,
            show: this.options.show,
            columns: this.options.columns,
            columnGroups: this.options.columnGroups,
            sortData: this.buildSortData(),
            parser: function(response) {
                if (response && response.content) {
                    return {
                        total: response.totalElements || 0,
                        records: response.content.map((item, index) => {
                            item.recid = item.recid || (response.number * response.size + index + 1);
                            return item;
                        })
                    };
                }
                return response;
            },

            /**
             * 서버 요청 전 처리
             */
            onRequest: function(event) {
                event.postData = $.extend({}, self.options.params, event.postData);

                // 페이징 처리
                if (event.postData.offset !== undefined) {
                    event.postData.page = Math.floor(event.postData.offset / event.postData.limit) + 1;
                    event.postData.size = event.postData.limit;
                }

                if (self.options.onRequest) {
                    self.options.onRequest(event);
                }
            },

            /**
             * 서버 응답 후 처리
             */
            onLoad: function(event) {
                if (event.xhr && event.xhr.done) {
                    event.xhr.done(function(response) {
                        if (self.options.onLoad) {
                            self.options.onLoad(event);
                        }
                    });
                } else {
                    if (self.options.onLoad) {
                        self.options.onLoad(event);
                    }
                }
            }
        };

        // 커스텀 툴바 버튼 추가
        if (this.options.customToolbar && this.options.buttons.length > 0) {
            config.toolbar = {
                items: this.buildToolbarButtons()
            };
        }

        // 그리드 생성
        $(this.options.target).w2grid(config);
    }

    /**
     * 정렬 데이터 생성
     */
    buildSortData() {
        const sortData = [];
        if (this.options.sort) {
            Object.keys(this.options.sort).forEach((key, index) => {
                sortData.push({
                    field: key,
                    direction: this.options.sort[key].toUpperCase()
                });
            });
        }
        return sortData;
    }

    /**
     * 툴바 버튼 생성
     */
    buildToolbarButtons() {
        return this.options.buttons.map(btn => ({
            type: 'button',
            id: btn.id,
            text: btn.text,
            icon: btn.icon,
            class: btn.class || 'btn btn-primary',
            onClick: btn.click
        }));
    }

    /**
     * 그리드 새로고침
     */
    reload(params) {
        if (params) {
            this.options.params = $.extend({}, this.options.params, params);
        }
        w2ui.grid.url = this.options.url;
        w2ui.grid.reload();
    }

    /**
     * 그리드 검색
     */
    search(params) {
        this.reload(params);
    }

    /**
     * 선택된 행 가져오기
     */
    getSelection() {
        return w2ui.grid.getSelection();
    }

    /**
     * 선택된 레코드 가져오기
     */
    getSelectedRecords() {
        const selection = this.getSelection();
        return selection.map(recid => w2ui.grid.get(recid));
    }

    /**
     * 그리드 제거
     */
    destroy() {
        if (w2ui.grid) {
            w2ui.grid.destroy();
        }
    }
}

// 전역으로 사용할 수 있도록 window 객체에 추가
window.W2GridHelper = W2GridHelper;
