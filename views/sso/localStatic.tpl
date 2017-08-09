<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">本地静态资源配置管理</span>
    </div>
</div>
<div class="row subsystem-toolbar">
    <div class="pull-left" style="height: 44px; line-height: 44px; width: 260px;">
    </div>
    <div class="pull-right">
        <button onclick="CaDriverInfoObj.add()" class="btn btn-info btn-sm" title="新增机构信息">
            <i class="icon-plus"> 新增</i>
        </button>
        <button onclick="CaDriverInfoObj.edit()" class="btn btn-info btn-sm" title="编辑机构信息">
            <span class="icon-edit"> 编辑</span>
        </button>
        <!--<button onclick="CaDriverInfoObj.upload()" class="btn btn-info btn-sm" title="导入机构信息">-->
            <!--<span class="icon-edit"> 导入</span>-->
        <!--</button>-->
        <!--<button onclick="CaDriverInfoObj.download()" class="btn btn-info btn-sm" title="导出机构信息">-->
            <!--<span class="icon-trash"> 导出</span>-->
        <!--</button>-->
        <button onclick="CaDriverInfoObj.delete()" class="btn btn-danger btn-sm" title="删除机构信息">
            <span class="icon-trash"> 删除</span>
        </button>
    </div>
</div>
<div id="h-sso-local-static-content"
     class="subsystem-content"
     style="padding-top: 3px;">
    <table id="h-sso-local-static-table-info"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/sso/local/static"
           data-side-pagination="client"
           data-pagination="true"
           data-page-size="30"
           data-page-list="[20,30, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="url">路由地址</th>
            <th data-field="path">资源本地路径</th>
            <th data-align="center" data-field="createTime">创建日期</th>
            <th data-align="center" data-field="createUser">创建人</th>
            <th data-align="center" data-field="modifyTime">修改日期</th>
            <th data-align="center" data-field="modifyUser">修改人</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
    var CaDriverInfoObj = {
        edit:function () {
            var rows = $("#h-sso-local-static-table-info").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"您没有选择需要编辑的动因信息",
                    type:"info",
                });
                return
            } else if (rows.length > 1) {
                $.Notify({
                    message:"只能选择<span style='font-weight: 600;color: red'> 一项 </span>进行编辑",
                    type:"warning",
                });
                return
            }

            $.Hmodal({
                header:"编辑静态路由信息",
                body:$("#h-sso-local-static-form-src").html(),
                height:"360px",
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/sso/local/static",
                        type:"put",
                        data:$("#h-sso-local-static-form-table").serialize(),
                        success:function () {
                            $("#h-sso-local-static-table-info").bootstrapTable('refresh');
                            $(hmode).remove();
                            $.Notify({
                                message:"编辑静态路由信息成功，系统重启后生效",
                                type:"success",
                            })
                        },
                    })
                },
                preprocess:function () {
                    $("#h-sso-local-static-form-table").find("input[name='uuid']").val(rows[0].uuid);
                    $("#h-sso-local-static-form-table").find("input[name='url']").val(rows[0].url);
                    $("#h-sso-local-static-form-table").find("input[name='path']").val(rows[0].path);
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增静态路由信息",
                body:$("#h-sso-local-static-form-src").html(),
                height:"360px",
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/sso/local/static",
                        type:"post",
                        data:$("#h-sso-local-static-form-table").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增静态路由信息成功，系统重启后生效",
                                type:"success",
                            });

                            $("#h-sso-local-static-table-info").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                }
            })
        },
        delete:function () {
            var rows = $("#h-sso-local-static-table-info").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"您没有选择需要删除的静态路由配置信息",
                    type:"warning",
                });
                return
            }
            $.Hconfirm({
                body:"点击确认,将会删除静态路由信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/sso/local/static",
                        type:"Delete",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除静态路由信息成功，系统重启后生效",
                                type:"success",
                            });
                            $("#h-sso-local-static-table-info").bootstrapTable('refresh');
                        }
                    })
                }
            })
        },
    }
    $(document).ready(function () {
        $("#h-sso-local-static-content").height(document.documentElement.clientHeight-130)
        $("#h-sso-local-static-table-info").bootstrapTable({
            height:document.documentElement.clientHeight-130,
        });
    })
</script>

<script id="h-sso-local-static-form-src" type="text/html">
    <form id="h-sso-local-static-form-table">
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 12px">
            <span>路由地址</span>
            <input placeholder="url地址" name="url" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 23px;">
            <span>本地路径</span>
            <input placeholder="本地相对路径" name="path" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <input name="uuid" style="display: none;"/>
    </form>
</script>