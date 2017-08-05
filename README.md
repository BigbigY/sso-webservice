## sso-webservice web系统单点登录解决方案

## 源码获取方式
```go
    go get github.com/asofdate/vender
    go get github.com/asofdate/sso-webservice
```
请严格按照上边的执行顺序执行，项目中修改了beego代码，所以，只能使用vendor中的beego代码才有效。

## 项目简介
sso-webservice目标是使多个系统单点登录，实现系统集成。用户与应用服务使用Json web token (JWT)传递身份认证信息。
目前项目分为4个部分，分别是：
1. sso-core         单点登录核心服务组件
2. sso-jwt-auth     系统授权管理服务组件
3. sso-webservice   前端服务组件
4. vendor           第三方依赖包

## 数据库配置
sso-webservice目前使用的数据库为MySQL，如果需要支持其他数据库，需要添加相应数据库的驱动，以及sql配置文件。

**导入数据文件**

数据文件在sso-jwt-auth/script/init_hauth.sql。 如将数据导入本地数据库sso中
```shell
    mysql -uroot -p sso < ./init_hauth.sql
```

**修改数据库配置**

数据库配置信息在sso-webservice/conf/asofdate.conf中
```
# 数据库类型，目前默认是mysql
DB.type=mysql
# 数据库连接信息，数据库机器名，端口号，数据库名
DB.tns = "tcp(localhost:3306)/sso"
# 连接数据库用户
DB.user = root
#连接数据库密码，直接写明文，系统会自动加密
DB.passwd="xzPEh+SfFL3aimN0zGNB9w=="
```

## 编译与运行
进入sso-webservice目录，执行下边命令
```go
go build
```

编译完成后，可以直接运行可执行程序。

默认系统登录方式：
1. 在浏览器中输入： http://localhost:8090
2. 数据用户名： admin, 密码： hzwy23


## 交流方式
e-mail：hzwy23@163.com

QQ: 309810957