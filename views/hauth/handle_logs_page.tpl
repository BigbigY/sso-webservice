<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">操作记录</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div id="hUserLogsTableTools" class="pull-right">
        <button onclick="LogsHandle.search()" class="btn btn-info btn-sm">
            <i class="icon-search"> 搜索</i>
        </button>
        <button onclick="LogsHandle.download()" class="btn btn-info btn-sm" title="下载操作记录">
            <span class="icon-wrench"> 下载</span>
        </button>
    </div>
</div>

<div class="subsystem-content">
    <div id="h-handle-logs">
        <table id="HandleLogsPageTable"></table>
    </div>
</div>

<script type="text/javascript">
    var LogsHandle = {
        download:function(){
            var x=new XMLHttpRequest();
            x.open("GET", "/v1/auth/handle/logs/download", true);
            x.responseType = 'blob';
            x.onload=function(e){
                download(x.response, "操作记录.xlsx", "application/vnd.ms-excel" );
            }
            x.send();
        },
        showHandleLogDetails:function(obj){

            var optHtml = '<div class="panel panel-default"><table class="table table-striped table-bordered table-condensed">'
            optHtml += "<tr><th class='col-sm-2 col-md-2 col-lg-2' valign='middle'>key</th><th valign='middle'>value</th></tr>"
            var row = JSON.parse($(obj).html());
            for (var x in row) {
                try {
                    var drow = JSON.parse(row[x]);
                    var dt = "";
                    for (var i = 0; i < drow.length; i++) {
                        if (i > 0) {
                            dt += "<hr/>";
                        }
                        for (var y in drow[i]) {
                            dt += y + " = " + drow[i][y] + "<br/>";
                        }
                    }
                    if (dt == "") {
                        dt = drow;
                    }
                    optHtml += "<tr style='vertical-align:middle !important;'><td valign='middle'>" + x + "</td><td>" + dt + "</td></tr>";
                } catch (e) {
                    optHtml += "<tr style='vertical-align:middle !important;'><td valign='middle'>" + x + "</td><td>" + row[x] + "</td></tr>";
                }
            }
            optHtml += "</table></div>";
            $.Hmodal({
                header: "客户端发送到服务器的参数信息",
                body: optHtml,
                height: "420px",
                submitBtn: false,
            })
        },
        search:function(){

            var hSubmit = function(hmode){
                var userId = $("#h-logs-search-form").find("input[name='UserId']").val();
                var startDate = $("#h-logs-search-form").find("input[name='StartDate']").val();
                var endDate = $("#h-logs-search-form").find("input[name='EndDate']").val();
                $("#HandleLogsPageTable").bootstrapTable('destroy');
                var hwindow = document.documentElement.clientHeight - 120;
                $("#HandleLogsPageTable").bootstrapTable({
                    url:'/v1/auth/handle/logs/search',
                    height:hwindow,
                    uniqueId:'uuid',
                    striped: true,
                    pagination: true,
                    search:false,
                    showRefresh:false,
                    queryParams:function(params){
                        return {
                            UserId:userId,
                            StartDate:startDate,
                            EndDate:endDate,
                        }
                    },
                    pageSize: 20,
                    showExport:true,
                    sidePagination: "client",
                    showColumns: false,
                    minimunCountColumns: 2,
                    columns:[{

                        field: 'uuid',

                        title: '账号',

                        align: 'left',

                        visible:false,

                        valign: 'middle',

                        sortable: true

                    },{

                        field: 'user_id',

                        title: '账号',

                        align: 'left',

                        valign: 'middle',
                    }, {

                        field: 'handle_time',

                        title: '操作日期',

                        align: 'left',

                        valign: 'middle',

                        sortable: false,

                    }, {

                        field: 'client_ip',

                        title: '客户端IP',

                        align: 'left',

                        valign: 'middle',

                        sortable: false,

                    },{

                        field: 'method',

                        title: '请求方式',

                        align: 'left',

                        valign: 'top',

                        sortable: false

                    }, {

                        field: 'url',

                        title: '路由信息',

                        align: 'left',

                        valign: 'middle',

                        sortable: false

                    }, {

                        field: 'status_code',

                        title: '返回状态',

                        align: 'left',

                        valign: 'middle',

                        sortable: false

                    }, {

                        field: 'data',

                        title: '请求发送',

                        align: 'left',

                        valign: 'middle',

                        sortable: false,

                        formatter:function(value,rows,index){
                            return '<span ondblclick=LogsHandle.showHandleLogDetails()>'+value+'</span>'
                        }
                    }]
                });
                $(hmode).remove();
            };
            $.Hmodal({
                header:"高级搜索",
                body:$("#handle-logs-search").html(),
                callback:hSubmit,
                height:"320px",
            })
        },
        getLogs:function(args){

            //$("#h-handle-logs").height(document.documentElement.clientHeight-150)
            $("#HandleLogsPageTable").bootstrapTable({
                url:'/v1/auth/handle/logs',
                height:document.documentElement.clientHeight-120,
                uniqueId:'uuid',
                striped: true,
                pagination: true,
                pageList:[40,80,160,400,800,3000],
                showRefresh:false,
                pageSize: 80,
                search:false,
                sidePagination: "server",
                columns:[{

                    field: 'uuid',

                    title: '账号',

                    align: 'left',

                    visible:false,

                    valign: 'middle',

                    sortable: false

                },{

                    field: 'user_id',

                    title: '账号',

                    align: 'left',

                    valign: 'middle',

                    sortable: false

                }, {

                    field: 'handle_time',

                    title: '操作日期',

                    align: 'left',

                    valign: 'middle',

                    sortable: false,

                }, {

                    field: 'client_ip',

                    title: '客户端IP',

                    align: 'left',

                    valign: 'middle',

                    sortable: false,

                },{

                    field: 'method',

                    title: '请求方式',

                    align: 'left',

                    valign: 'middle',

                    sortable: false

                }, {

                    field: 'url',

                    title: '路由信息',

                    align: 'left',

                    valign: 'middle',

                    sortable: false

                }, {

                    field: 'status_code',

                    title: '返回状态',

                    align: 'left',

                    valign: 'middle',

                    sortable: false

                }, {

                    field: 'data',

                    title: '请求发送',

                    align: 'left',

                    valign: 'middle',

                    width: "360px",

                    sortable: false,

                    formatter:function(value,rows,index){
                        return '<span ondblclick=LogsHandle.showHandleLogDetails(this) >'+value+'</span>'
                    }
                }]
            });
        }
    };

    $(document).ready(function(){
        LogsHandle.getLogs();
    })

</script>
<script id="handle-logs-search" type="text/html">
    <form id="h-logs-search-form" class="form-horizontal col-sm-12 col-md-12 col-lg-12" style="margin-top: 20px;">
        <div class="form-group">
            <label class="col-sm-3 col-md-3 col-lg-3 control-label" style="font-size: 14px; font-weight: 500;">账 号：</label>
            <div class="col-sm-8 col-md-8 col-lg-8">
                <input style="height: 30px;line-height: 30px;" name="UserId"  type="text" class="form-control" placeholder="待查找的账号">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 col-md-3 col-lg-3 control-label" style="font-size: 14px;font-weight: 500;">开始时间：</label>
            <div class="col-sm-8 col-md-8 col-lg-8">
                <input style="height: 30px;line-height: 30px;" onclick="laydate()" name="StartDate" class="form-control" placeholder="开始时间">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 col-md-3 col-lg-3 control-label" style="font-size: 14px;font-weight: 500;">结束时间：</label>
            <div class="col-sm-8 col-md-8 col-lg-8">
                <input style="height: 30px;line-height: 30px;" onclick="laydate()" name="EndDate" class="form-control" placeholder="结束时间">
            </div>
        </div>
    </form>
</script>