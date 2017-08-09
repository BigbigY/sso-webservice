<div class="row subsystem-header">
    <div class="pull-left">
        <span style="font-size: 14px;">子系统配置管理</span>
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
<div id="h-sso-subsystem-content"
     class="subsystem-content"
     style="padding-top: 3px;">
    <table id="h-sso-subsystem-table"
           data-toggle="table"
           data-striped="true"
           data-unique-id="serviceCd"
           data-url="/v1/sso/subsystem"
           data-side-pagination="client"
           data-pagination="true"
           data-page-size="30"
           data-page-list="[20,30, 50, 100, 200]"
           data-search="false">
        <thead>
        <tr>
            <th data-field="state" data-checkbox="true"></th>
            <th data-field="serviceCd">子系统代码</th>
            <th data-field="serviceName">子系统名称</th>
            <th data-field="remoteScheme">协议</th>
            <th data-field="remoteHost">主机名</th>
            <th data-field="remotePort">端口</th>
            <th data-field="prefixUrl">基准路径</th>
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
            var rows = $("#h-sso-subsystem-table").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请选择需要更新的子系统",
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
                header:"编辑子系统配置信息",
                body:$("#h-sso-subsystem-src").html(),
                width:"420px",
                height:"490px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/sso/subsystem",
                        type:"put",
                        data:$("#h-sso-subsystem-form").serialize(),
                        success:function () {
                            $("#h-sso-subsystem-table").bootstrapTable('refresh');
                            $(hmode).remove();
                            $.Notify({
                                message:"更新子系统配置信息成功",
                                type:"success",
                            })
                        },
                    })
                },
                preprocess:function () {
                    $("#h-sso-subsystem-form").find("input[name='serviceCd']").val(row.serviceCd).attr("readonly","readonly");
                    $("#h-sso-subsystem-form").find("input[name='serviceName']").val(row.serviceName);
                    $("#h-sso-subsystem-form").find("input[name='remoteHost']").val(row.remoteHost);
                    $("#h-sso-subsystem-form").find("input[name='remotePort']").val(row.remotePort);
                    $("#h-sso-subsystem-form").find("input[name='prefixUrl']").val(row.prefixUrl);
                    $("#h-sso-subsystem-form").find("select[name='remoteScheme']").Hselect({
                        height:"30px",
                        value:row.remoteScheme,
                    });
                }
            })
        },
        add:function () {
            $.Hmodal({
                header:"新增子系统配置信息",
                body:$("#h-sso-subsystem-src").html(),
                width:"420px",
                height:"490px",
                callback:function (hmode) {
                    $.HAjaxRequest({
                        url:"/v1/sso/subsystem",
                        type:"post",
                        data:$("#h-sso-subsystem-form").serialize(),
                        success:function () {
                            $.Notify({
                                message:"新增子系统配置信息成功",
                                type:"success",
                            });

                            $("#h-sso-subsystem-table").bootstrapTable('refresh');
                            $(hmode).remove();
                        },
                    })
                },
                preprocess:function () {
                    $("#h-sso-subsystem-form").find("select[name='remoteScheme']").Hselect({
                        height:"30px",
                        value:"https",
                    })
                }
            })
        },
        delete:function () {
            var rows = $("#h-sso-subsystem-table").bootstrapTable('getSelections');
            if (rows.length == 0) {
                $.Notify({
                    message:"请选择需要删除的配置信息",
                    type:"warning",
                });
                return
            }
            $.Hconfirm({
                body:"点击确认删除信息",
                callback:function () {
                    $.HAjaxRequest({
                        url:"/v1/sso/subsystem",
                        type:"Delete",
                        data:{JSON:JSON.stringify(rows)},
                        success:function () {
                            $.Notify({
                                message:"子系统配置信息删除成功",
                                type:"success",
                            });
                            $(rows).each(function (index, element) {
                                $("#h-sso-subsystem-table").bootstrapTable('removeByUniqueId',element.serviceCd);
                            });
                        }
                    })
                }
            })
        },
    };

    $(document).ready(function () {
        $("#h-sso-subsystem-content").height(document.documentElement.clientHeight-130)
        $("#h-sso-subsystem-table").bootstrapTable({
            height:document.documentElement.clientHeight-130,
        });
    })
</script>

<script id="h-sso-subsystem-src" type="text/html">
    <form id="h-sso-subsystem-form">
        <div class="col-sm-12 col-md-12 col-lg-12">
            <span>子系统编码</span>
            <input placeholder="由1-30位字母、数字组成" name="serviceCd" class="form-control" style="height: 30px; line-height: 30px;"/>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
            <span>子系统名称</span>
            <input placeholder="给系统取个洋气的名字吧" name="serviceName" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
            <span>协议</span>
            <select name="remoteScheme" class="form-control" style="height: 30px; line-height: 30px;">
                <option value="http" selected>http</option>
                <option value="https" selected>https</option>
            </select>
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
            <span>主机名</span>
            <input placeholder="如：127.0.0.1" name="remoteHost" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
            <span>端口号</span>
            <input placeholder="如：8080" name="remotePort" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
        <div class="col-sm-12 col-md-12 col-lg-12" style="margin-top: 8px;">
            <span>基准路径</span>
            <input placeholder="如：/AM" name="prefixUrl" class="form-control" style="height: 30px; line-height: 30px;" />
        </div>
    </form>
</script>