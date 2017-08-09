<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="A front-end template that helps you build fast, modern mobile web apps.">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>Asofdate</title>

    <!-- Add to homescreen for Chrome on Android -->
    <meta name="mobile-web-app-capable" content="yes">
    <link rel="icon" sizes="192x192" href="/static/images/mdui/android-desktop.png">

    <!-- Add to homescreen for Safari on iOS -->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-title" content="Material Design Lite">
    <link rel="apple-touch-icon-precomposed" href="/static/images/mdui/ios-desktop.png">

    <!-- Tile icon for Win8 (144x144 + tile color) -->
    <meta name="msapplication-TileImage" content="/static/images/mdui/touch/ms-touch-icon-144x144-precomposed.png">
    <meta name="msapplication-TileColor" content="#3372DF">

    <!--static-->
    <link rel="stylesheet" href="/static/css/metro.css">
    <link rel="stylesheet" href="/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="/static/Font-Awesome-3.2.1/css/font-awesome.min.css"/>

    <link rel="stylesheet" href="/static/theme/common.css"/>
    <link rel="stylesheet" href="/static/theme/tradition/index.css" type="text/css" />
    <link rel="stylesheet" href="/static/css/animate.css"/>
    <link rel="stylesheet" href="/static/nprogress/nprogress.css"/>

    <script type="text/javascript" src="/static/js/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="/static/nprogress/nprogress.js"></script>
    <script type="text/javascript" src="/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/static/theme/tradition/utils.min.js"></script>

    <!--bootstrap-table表格-->
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="/static/bootstrap-table/dist/bootstrap-table.min.css">
    <!-- Latest compiled and minified JavaScript -->
    <script src="/static/bootstrap-table/dist/bootstrap-table.min.js"></script>
    <!-- Latest compiled and minified Locales -->
    <script src="/static/bootstrap-table/dist/locale/bootstrap-table-zh-CN.min.js"></script>

    <!--bootstrap switch-->
    <link rel="stylesheet" href="/static/bootstrap-switch-master/dist/css/bootstrap3/bootstrap-switch.min.css"/>
    <script src="/static/bootstrap-switch-master/dist/js/bootstrap-switch.min.js"></script>

    <!--webupload-->
    <link rel="stylesheet" href="/static/webuploader/dist/webuploader.css"/>
    <script src="/static/webuploader/dist/webuploader.min.js"></script>
    <!-- SEO: If your mobile URL is different from the desktop URL, add a canonical link to the desktop page https://developers.google.com/webmasters/smartphone-sites/feature-phones -->
    <!--
    <link rel="canonical" href="http://www.example.com/">
    -->

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:regular,bold,italic,thin,light,bolditalic,black,medium&amp;lang=en">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="/static/css/material.teal-green.min.css">
    <link rel="stylesheet" href="/static/css/styles.css">
</head>
<body>
<div class="demo-layout mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--fixed-header">
    <header class="mdl-layout__header mdl-color--blue-grey-900 mdl-color-text--grey-100">
        <div class="mdl-layout__header-row">
            <span class="mdl-layout-title">Aofdate</span>
            <div class="mdl-layout-spacer"></div>
            <button class="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored" id="hdrbtn">
                <i class="icon-user">&nbsp;{{.}}</i>
            </button>
            <ul class="mdl-menu mdl-js-menu mdl-js-ripple-effect mdl-menu--bottom-right" for="hdrbtn">
                <li class="mdl-menu__item" onclick="Hutils.UserMgrInfo()">用户信息</li>
                <li class="mdl-menu__item" onclick="Hutils.HLogOut()">安全退出</li>
            </ul>
        </div>
    </header>
    <div class="demo-drawer mdl-layout__drawer mdl-color--blue-grey-900 mdl-color-text--blue-grey-50">
        <header class="sso-drawer-header">
            <img src="/static/images/mdui/logo.png"/>
        </header>
        <nav id="h-sso-menus-content"
             class="demo-navigation mdl-navigation mdl-color--blue-grey-700"
             style="padding-top: 3px; overflow: auto">
        </nav>
    </div>
    <main class="mdl-layout__content mdl-color--grey-100">
        <div id="h-sso-window"
             style="padding-top: 2px; padding-bottom: 2px;"
             class="mdl-color--white mdl-shadow--2dp mdl-cell mdl-cell--12-col mdl-grid">
        </div>
    </main>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $("#h-sso-menus-content").height(document.documentElement.clientHeight-68);

        $.HAjaxRequest({
            url:"/v1/auth/menu/all/except/button",
            type:"GET",
            success:function (data) {
                $("#h-sso-menus-content").initTraditionMenu({
                    data:data,
                });
            }
        })
    });

    Hutils.openTab = function(param){

        NProgress.start();

        // 判断子元素会否已经被打开，默认设置为未打开
        var flag = false;

        var __DEFAULT = {
            id:"",
            tile:"",
            type: "GET",
            url: "",
            data: {},
            dataType: "text",
            newIframe: undefined,
        };
        $.extend(true,__DEFAULT,param);

        $.HAjaxRequest({
            url:__DEFAULT.url,
            type:__DEFAULT.type,
            dataType:__DEFAULT.dataType,
            success:function (d) {
                var obj = document.getElementById("h-sso-window");
                obj.innerHTML = "";
                obj.style.display = "none";
                if (__DEFAULT.newIframe == "true") {
                    var iframe = document.createElement("iframe");
                    iframe.width = (document.documentElement.clientWidth) +"px";
                    iframe.height = (document.documentElement.clientHeight - 36)+"px";
                    iframe.srcdoc = d.replace("window.top.location","//window.top.location");
                    iframe.frameBorder = 0;
                    $("#h-sso-window").append(iframe).fadeIn();
                } else {
                    $("#h-sso-window").html(d).fadeIn();
                }
            }
        });
        NProgress.done();
    };

    var changeTheme = function (id) {
        $.HAjaxRequest({
            url:"/v1/auth/theme/update",
            type:'post',
            dataType:'json',
            data:{theme_id:id},
            success:function () {
                window.location.href="/HomePage"
            },
        })
    };

    var changemodifypassword = function(){
        $.Hmodal({
            header:"密码修改",
            body:$("#h-user-modify-password").html(),
            height:"420px",
            width:"720px",
            preprocess:function () {
                var user_id = $("#h-user-details-user-id").html()
                $("#h-modify-user-id").val(user_id)
            },
            callback:function(hmode){
                var newpd = $("#plat-change-passwd").find('input[name="newpasswd"]').val()
                var orapd = $("#plat-change-passwd").find('input[name="orapasswd"]').val()
                var surpd = $("#plat-change-passwd").find('input[name="surepasswd"]').val()
                if ($.trim(newpd) =="" || $.trim(orapd) == "" || $.trim(surpd)  == "" ){
                    $.Notify({
                        message:"不能将密码设置成空格",
                        type:"danger",
                    })
                    return
                }else if(newpd != surpd){
                    $.Notify({
                        message:"两次输入的新密码不一致，请确认是否存在多余的空格",
                        type:"danger",
                    })
                    return
                }
                $.HAjaxRequest({
                    type:"post",
                    url:"/v1/auth/passwd/update",
                    data:$("#plat-change-passwd").serialize(),
                    dataType:"json",
                    success:function(){
                        $(hmode).remove();
                        $.Notify({
                            message:"修改密码成功",
                            type:"success",
                        })
                    },
                });
            }
        })
    };

</script>

<script id="mas-passwd-prop" type="text/html">
    <div class="panel panel-default">
        <!-- Default panel contents -->
        <div class="panel-heading">
            <span style="font-size: 12px;font-weight: 600;">主题切换：</span>
            <button onclick="changeTheme(1001)" class="btn btn-sm theme-green-color" style="color: white;">
            </button>
            <button onclick="changeTheme(1004)" class="btn btn-sm theme-cyan-color" style="color: white;">
            </button>
            <button onclick="changeTheme(1002)" class="btn btn-sm theme-blue-color" style="color: white;">
            </button>
            <button onclick="changeTheme(1003)" class="btn btn-sm theme-apple-color" style="color: white;">
            </button>
            <button onclick="changeTheme(1005)" class="btn btn-sm theme-tradition-color" style="color: white;">
            </button>
            <div class="pull-right">
                <button onclick="changemodifypassword()" class="btn btn-success btn-xs">
                    <i class="icon-wrench"> 修改密码</i>
                </button>
            </div>
        </div>
        <!-- Table -->
        <table class="table table-bordered table-responsive">
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">用户id:&nbsp;</td>
                <td id="h-user-details-user-id" style="font-weight: 600">user_id</td>
                <td style="text-align: right;">用户名称:&nbsp;</td>
                <td id="h-user-details-user-name" style="font-weight: 600">user_name</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">邮箱:&nbsp;</td>
                <td id="h-user-details-user-email" style="font-weight: 600">user_email</td>
                <td style="text-align: right;">手机号:&nbsp;</td>
                <td id="h-user-details-user-phone" style="font-weight: 600">user_phone</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">所属域编码:&nbsp;</td>
                <td id="h-user-details-user-domain" style="font-weight: 600">user_dept</td>
                <td style="text-align: right;">所属域名称:&nbsp;</td>
                <td id="h-user-details-user-domain-name" style="font-weight: 600">user_domain</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">组织部门编码:&nbsp;</td>
                <td id="h-user-details-user-org" style="font-weight: 600">user_dept</td>
                <td style="text-align: right;">组织部门描述:&nbsp;</td>
                <td id="h-user-details-user-org-name" style="font-weight: 600">user_domain</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">创建人:&nbsp;</td>
                <td id="h-user-details-user-create" style="font-weight: 600">user_create</td>
                <td style="text-align: right;">创建时间:&nbsp;</td>
                <td id="h-user-details-user-create-date" style="font-weight: 600">user_create_date</td>
            </tr>
            <tr style="height: 36px;line-height: 36px;">
                <td style="text-align: right;">修改人:&nbsp;</td>
                <td id="h-user-details-user-modify" style="font-weight: 600">user_create</td>
                <td style="text-align: right;">修改时间:&nbsp;</td>
                <td id="h-user-details-user-modify-date" style="font-weight: 600">user_create_date</td>
            </tr>
        </table>
    </div>

</script>
<script id="h-user-modify-password" type="text/html">
    <form id="plat-change-passwd" class="col-sm-12 col-md-12 col-lg-12">
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">账　号：</label>
            <input id="h-modify-user-id" readonly="readonly" class="form-control" style="width: 100%;height: 30px; line-height: 30px;" type="text" name="userid"/>
        </div>
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">原密码：</label>
            <input placeholder="密码长度必须大于6位，小于30位" class="form-control" style="width:100%;height: 30px; line-height: 30px;" type="password" name="orapasswd"/>
        </div>
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">新密码：</label>
            <input placeholder="密码长度必须大于6位，小于30位" class="form-control" style="width:100%;height: 30px; line-height: 30px;" type="password" name="newpasswd"/>
        </div>
        <div class="form-group col-sm-12 col-md-12 col-lg-12">
            <label class="h-label" style="width: 100%;">确认密码：</label>
            <input placeholder="请确认新密码信息" class="form-control" style="height: 30px; line-height: 30px; width: 100%;" type="password" name="surepasswd"/>
        </div>
    </form>
</script>
<script type="text/javascript" src="/static/js/material.min.js"></script>
<script type="text/javascript" src="/static/js/laydate.js"></script>
<script type="text/javascript" src="/static/js/bootstrap-notify.min.js"></script>
<script type="text/javascript" src="/static/js/download.js"></script>
<script type="text/javascript" src="/static/js/spin.min.js"></script>
</body>
</html>
