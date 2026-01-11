전자정부 프레임 워크프로젝트
내부망 프로젝트라 해당프로젝트의 일부 발췌

- db 정보
  jdbc-url: jdbc:oracle:thin:@//localhost:1521/FREEPDB1
  username: PDBADMIN
  password: MyStrongPass1!
  driver-class-name: oracle.jdbc.OracleDriver

info
spring 5.3.27
egov version 4.2.0
jsp
java 17
mybatis 2.1.2
poi 5.2.3
lombok 1.18.28

sql 파일 경로 : docs/sql
js 파일 경로: js/\* (w2ui, jquery, egovCommonjs)

w2ui 그리드 기반으로 페이징 처리가 자동으로 되는거 같음. jsp 일부만 가져옴..
1. html (제가 진행하는 egov 프로젝트에서 가져온, html파일 일부인데 이렇게 프론트를 보여주는데, 자동으로 페이징이 생성이 되더라고. 한번 참고해줘)
```html
<div class="tit-group">
<div class="data-table">
<script>
import("*");

const gridConfigs = {

    // 제공책임관
    manager : {
        url: "/lms/chm/selectRspnofcrChargerListJson.do",
        multiSelect : false,
        show : {
            selectColumn : false
        },
        buttons : [
            {
                id: "tmpBtn",
                text: "엑셀다운로드",
                icon: "svg-icon ico-download",
                class: "btn btn-light",
                click: alert("임시")
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
            { field: 'provdrRspnofcrNm', text: '제공책임관 명', size: '137px', min: 100, attr: 'align-center', resizable: true },
            { field: 'telno', text: '전화번호', size: '120px', min: 100, attr: 'align-center', resizable: true },
            { field: 'email', text: '이메일', size: '15%', attr: 'align-center', resizable: true },
            { field: 'baseAdministrationManagerTokn', text: '행안부 공문', size: '90px', attr: 'align-center' }
        ]
    },

    // 실무담당자
    practical : {
        url: "/lms/chm/selectPrcafsChargerListJson.do",
        multiSelect : false,
        show : {
            selectColumn : true
        },
        buttons : [
            {
                id: "tmpBtn",
                text: "엑셀다운로드",
                icon: "svg-icon ico-download",
                class: "btn btn-light",
                click: alert("임시")
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



<script>
function initTabGrid(type){

    // 기존 그리드 제거
    if (w2ui['grid']) {
        w2ui['grid'].destroy();
    }

    const config = gridConfigs[type];
    if (!config) return;

    new W2GridHelper({
        url : config.url,
        multiSelect : config.multiSelect,
        show : config.show,
        buttons : config.buttons,
        target : "#grid",
        params : {
            page: 1
        },
        sort : {
            createdAt: "desc",
            title: "desc"
        },
        multiSort: true,
        customToolbar: true,
        idField: "id",
        columnGroups : config.columnGroups,
        columns : config.columns,

        onSearch: function(event){
            console.log(event.postData);
        },

        onRequest: function(event){
            console.log(event.postData);
        }
    });
}

</script>

```

일부 소스:
#js(form.js)

```js
// 데이터 검색 할때 자동으로 값을 가져오는것 같다.
var SearchDataHandler = {
  /**
   * 날짜버튼 그룹 이벤트 초기화
   * @param {string} groupSelector -- 버튼 감싸고 있는 div
   * class dataBtn 해야 인식 및 동작
   * data-range 데이터를 선언 해둬야 해당 일자 계산.
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
        //시작일 계산
        const startDateObj = new Date();
        startDateObj.setMonth(today.getMonth() - parseInt(range));
        const startDate = startDateObj.toISOString().split("T")[0];
        startInput.val(startDate);
        endInput.val(endData);
      }
    });
  },

  collertParams: function (containerSelector) {
    var params = {};
    var container = $(containerSelector);

    if (container.length === 0) {
      console.log("컨테이너를 찾을수 없습니다.");
      return params;
    }

    $(containerSelector)
      .find("input, select")
      .each(function () {
        var $el = $(this);
        var val = $el.val();
        var name = $el.attr("name") || $el.attr("id");
        //console.log("params!!!" , name);
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
          // 일반 text , date , select ...처리
          params[name] = val;
        }
      });
    return params;
  },
};
```

```java

#controller
@ResponseBody
@RequestMapping(value="/selectRspnofcrChargerListJson.do")
public ResponseEntity<Page<ChargerManageVO>> selectPubDataDlbrtList(@ModelAttribute("searchVO") ChargerManageVO searchVO
,@PageableDefault(size = 10, sort = "created_at", direction = Sort.Direction.DESC) Pageable pageable) throws InvocationTargetException, IOException, SQLException{
//Page<ChargerManageVO> dataList = chargerManageService.selectRspnofcrChargerList(searchVO, pageable);
log.info("searchVO: {}", searchVO);
Page<ChargerManageVO> dataList = chargerManageService.selectRspnofcrChargerList(searchVO, pageable);
return HttpUtil.createResultOk(dataList);

#service
@Override
public Page<ChargerManageVO> selectRspnofcrChargerList(ChargerManageVO searchVO, Pageable pageable) throws InvocationTargetException, IOException, SQLException {
String orderByClause = SortUtil.toOrderByClause(pageable);
int offset = 1 + pageable.getPageSize() * (pageable.getPageNumber() - 1);
searchVO.setFirstIndex(offset);
searchVO.setRecordCountPerPage(pageable.getPageSize());
List<ChargerManageVO> list = chargerManageDAO.selectRspnofcrChargerList(pageable, searchVO, orderByClause);
return new CustomPage<ChargerManageVO>(list, pageable, chargerManageDAO.selectRspnofcrChargerTotalCnt(searchVO));
}

#mapper
public List<ChargerManageVO> selectRspnofcrChargerList(Pageable pageable, ChargerManageVO searchVO, String orderByClause) throws IOException, InvocationTargetException, SQLException {
List<ChargerManageVO> rspnofcrChargerList = selectList("ChargerManageDAO.selectRspnofcrChargerList", searchVO);
for(int i = 0; i<rspnofcrChargerList.size(); i++){
String mberTelno = rspnofcrChargerList.get(i).getTelno();

            if(mberTelno != null && !mberTelno.trim().equals("")){
                //전화번호 복호화
                mberTelno = SecurityUtil.decryptBySeed(EgovProperties.getProperty("system.telno.seedKey").trim(),mberTelno);
                if(mberTelno.equals("nullnullnull")){
                    mberTelno = "-";
                }
            }else{
                mberTelno = "-";
            }
            rspnofcrChargerList.get(i).setTelno(mberTelno);
        }
        return rspnofcrChargerList;
	}
```

#sql

```oracle
<select id="selectRspnofcrChargerList" parameterType="biz.lms.chm.service.ChargerManageVO" resultType="biz.lms.chm.service.ChargerManageVO">
/* ChargerManageDAO.selectRspnofcrChargerList */
SELECT * FROM ( SELECT (ROW_NUMBER() OVER()) AS RN, TB.* FROM (
SELECT
TPDR.pvsn_inst_cd AS PROVD_INSTT_CODE
,TPDR.pvsn_rbprsn_nm AS PROVD_RSPNOFCR_NM
,TPDR.DEPT_NM
,TPIC.inst_cd AS INSTT_CODE
,TPIC.inst_nm AS INSTT_NM
,TPDR.TELNO
,TPDR.eml_addr AS EMAIL
,TPDR.ATCH_FILE_ID
FROM
tn_pub_data_rspnofcr TPDR
INNER JOIN tc_pubs_instt_code_info TPIC ON TPIC.inst_cd = TPDR.pvsn_inst_cd
<where>
<if test='searchKeyword2 != null and searchKeyword2 != ""'>
<choose>
<when test='searchCondition5 == "Y"'>
AND TPDR.pvsn_inst_cd  IN (SELECT inst_cd
FROM tc_pubs_instt_code_info
WHERE up_inst_cd = #{searchKeyword2}
AND srch_yn = 'Y'
OR inst_cd = #{searchKeyword2})
</when>
<otherwise>
AND TPDR.pvsn_inst_cd = #{searchKeyword2}
</otherwise>
</choose>
</if>
<if test='searchKeyword3 != null and searchKeyword3 != ""'>
AND TPDR.pvsn_rbprsn_nm LIKE '%'||#{searchKeyword3}||'%'
</if>
</where>
ORDER BY TPIC.inst_nm, TPDR.pvsn_rbprsn_nm
) AS TB ) AS TB_ALL
<if test="recordCountPerPage > 0">
WHERE RN BETWEEN #{firstIndex}  AND #{firstIndex} + #{recordCountPerPage} -1
</if>
</select>
```

이소스를 기반으로 참고 해서 프로젝트 비슷하게 만들어주세요.
