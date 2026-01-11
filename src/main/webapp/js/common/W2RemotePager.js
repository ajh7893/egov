/**
 * W2RemotePager
 * w2ui grid + custom pager for remote JSON (Spring Page)
 */
class W2RemotePager {
    constructor(options) {
        this.options = $.extend(true, {
            gridName: 'grid',
            gridTarget: '#grid',
            url: '',
            method: 'GET',
            idField: 'recid',
            pageSize: 10,
            columns: [],
            show: {
                selectColumn: false,
                toolbar: true,
                footer: false,
                lineNumbers: false
            },
            getParams: function() { return {}; },
            onDblClick: null,
            pager: {
                prevBtn: '#prevBtn',
                nextBtn: '#nextBtn',
                pageInfo: '#pageInfo',
                pageNumbers: '#pageNumbers',
                pageInput: '#pageInput',
                pageSize: '#pageSize'
            }
        }, options);

        this.state = {
            page: 1,
            size: this.options.pageSize,
            total: 0
        };
    }

    init() {
        if (w2ui[this.options.gridName]) {
            w2ui[this.options.gridName].destroy();
        }

        $(this.options.gridTarget).w2grid({
            name: this.options.gridName,
            show: this.options.show,
            recid: this.options.idField,
            columns: this.options.columns,
            onDblClick: this.options.onDblClick
        });

        const $pageSize = $(this.options.pager.pageSize);
        if ($pageSize.length) {
            $pageSize.val(String(this.state.size));
        }

        this.bindPager();
    }

    bindPager() {
        const self = this;
        $(this.options.pager.prevBtn).off('click').on('click', function() {
            self.loadPage(self.state.page - 1);
        });
        $(this.options.pager.nextBtn).off('click').on('click', function() {
            self.loadPage(self.state.page + 1);
        });
        $(this.options.pager.pageInput).off('change').on('change', function() {
            const page = parseInt($(this).val(), 10);
            if (!Number.isNaN(page)) {
                self.loadPage(page);
            }
        });
        $(this.options.pager.pageSize).off('change').on('change', function() {
            const size = parseInt($(this).val(), 10);
            if (!Number.isNaN(size) && size > 0) {
                self.state.size = size;
                self.loadPage(1);
            }
        });
    }

    loadPage(page) {
        const maxPage = Math.max(1, Math.ceil(this.state.total / this.state.size));
        const targetPage = Math.min(Math.max(1, page), maxPage);
        const params = $.extend({}, this.options.getParams(), {
            page: targetPage - 1,
            size: this.state.size
        });

        const self = this;
        $.ajax({
            url: this.options.url,
            method: this.options.method,
            data: params,
            success: function(response) {
                const content = response && response.content ? response.content : [];
                const total = response && Number.isFinite(Number(response.totalElements))
                    ? Number(response.totalElements)
                    : content.length;
                const records = content.map((item, index) => {
                    item.recid = item[self.options.idField]
                        || ((targetPage - 1) * self.state.size + index + 1);
                    return item;
                });

                self.state.page = targetPage;
                self.state.total = total;

                const grid = w2ui[self.options.gridName];
                grid.records = records;
                grid.total = total;
                grid.refresh();
                grid.resize();
                self.updatePagerUI();
            }
        });
    }

    updatePagerUI() {
        const maxPage = Math.max(1, Math.ceil(this.state.total / this.state.size));
        $(this.options.pager.pageInfo).text('Page ' + this.state.page + ' / ' + maxPage);
        $(this.options.pager.pageInput).val(this.state.page);
        $(this.options.pager.prevBtn).prop('disabled', this.state.page <= 1);
        $(this.options.pager.nextBtn).prop('disabled', this.state.page >= maxPage);

        const $numbers = $(this.options.pager.pageNumbers);
        $numbers.empty();
        const windowSize = 5;
        let start = Math.max(1, this.state.page - Math.floor(windowSize / 2));
        let end = Math.min(maxPage, start + windowSize - 1);
        start = Math.max(1, end - windowSize + 1);

        for (let p = start; p <= end; p++) {
            const $btn = $('<button type="button"></button>').text(p);
            if (p === this.state.page) {
                $btn.prop('disabled', true);
            } else {
                const self = this;
                $btn.on('click', function() { self.loadPage(p); });
            }
            $numbers.append($btn);
        }
    }
}

window.W2RemotePager = W2RemotePager;
