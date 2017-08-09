<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">子系统API反向代理配置</span>
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
<div id="h-sso-remote-api-content"
     class="subsystem-content"
     style="padding-top: 3px;">
    <table id="h-sso-remote-api-table"
           data-toggle="table"
           data-striped="true"
           data-url="/v1/sso/proxy/api"
           data-unique-id="uuid"
           data-side-pagination="client"
           data-pagination="true"
           data-page-size="30"
           data-page-list="[20,30, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="registerUrl">路由地址</th>
            <th data-field="routeDesc">路由描述</th>
            <th data-field="serviceCd">子系统编码</th>
            <th data-field="remoteUrl">映射子系统路由地址</th>
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
            var rows = $("#h-sso-remote-api-table").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请选择需要编辑的子系统路由映射配置信息",
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
            var row = rows[0];
            $.Hmodal({
                header:"编辑子系统路由映射配置信息",
                body:$("#h-sso-remote-api-src").html(),
                height:"490px",
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/sso/proxy/api",
                        type:"put",
                        data:$("#h-sso-remote-api-form").serialize(),
                        success:function () {
                            $("#h-sso-remote-api-table").bootstrapTable('refresh');
                            $(hmode).remove();
                            $.Notify({
                                message:"编辑子系统路由映射配置信息成功",
                                type:"success",
                            })
                        },
                    })
                },
                preprocess:function () {
                    $("#h-sso-remote-api-form").find("input[name='registerUrl']").val(row.registerUrl);
                    $("#h-sso-remote-api-form").find("input[name='routeDesc']").val(row.routeDesc);
                    $("#h-sso-remote-api-form").find("input[name='remoteUrl']").val(row.remoteUrl);
                    $("#h-sso-remote-api-form").find("input[name='uuid']").val(row.uuid);

                    $.getJSON("/v1/sso/subsystem",function (data) {
                        var arr = new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.serviceCd;
                            e.text = element.serviceName;
                            e.upId = "###hzwy23###";
                            arr.push(e);
                        });

                        $("#h-sso-remote-api-form").find("select[name='serviceCd']").Hselect({
                            data:arr,
                            height:"30px",
                            value:row.serviceCd,
                        });
                    });
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增子系统路由映射关系",
                body:$("#h-sso-remote-api-src").html(),
                height:"490px",
                width:"420px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/sso/proxy/api",
                        type:"post",
                        data:$("#h-sso-remote-api-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"配置子系统路由映射关系成功",
                                type:"success",
                            });

                            $("#h-sso-remote-api-table").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function () {
                    $.getJSON("/v1/sso/subsystem",function (data) {
                        var arr = new Array();
                        $(data).each(function (index, element) {
                            var e = {};
                            e.id = element.serviceCd;
                            e.text = element.serviceName;
                            e.upId = "###hzwy23###";
                            arr.push(e)
                        });

                        $("#h-sso-remote-api-form").find("select[name='serviceCd']").Hselect({
                            data:arr,
                            height:"30px",
                        })
                    })
                }
            })
        },
        delete:function () {
            var rows = $("#h-sso-remote-api-table").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请选择需要删除的子系统路由映射配置信息",
                    type:"warning",
                });
                return
            }
            $.Hconfirm({
                body:"点击确认删除子系统路由映射关系",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/sso/proxy/api",
                        type:"Delete",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"删除子系统路由映射配置信息成功",
                                type:"success",
                            });
                            $(rows).each(function (index, element) {
                                $("#h-sso-remote-api-table").bootstrapTable('removeByUniqueId',element.uuid);
                            });
                        }
                    })
                }
            })
        },
    }
    $(document).ready(function () {
        $("#h-sso-remote-api-content").height(document.documentElement.clientHeight-130)
        $("#h-sso-remote-api-table").bootstrapTable({
            height:document.documentElement.clientHeight-130,
        });
    })
</script>

<script id="h-sso-remote-api-src" type="text/html">
    <form id="h-sso-remote-api-form">
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 12px;">
            <span>子系统</span>
            <select name="serviceCd" class="form-control" style="height: 30px; line-height: 30px;">
            </select>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 23px;">
            <span>路由地址</span>
            <input placeholder="注册地址，如：/v1/sso/user" name="registerUrl" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 23px;">
            <span>路由描述</span>
            <input placeholder="给路由取个名字吧" name="routeDesc" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 23px;">
            <span>映射子系统路由</span>
            <input placeholder="如：127.0.0.1" name="remoteUrl" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <input name="uuid" style="display: none"/>
    </form>
</script>