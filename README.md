## sso-webservice 单点登录解决方案

## 源码获取方式，任选其一
**Github下载地址：**
```go
    go get github.com/asofdate/vender
    go get github.com/asofdate/sso-webservice
```

**码云下载地址**
```go
    go get github.com/asofdate/vender
    go get git.oschina.net/hzwy23/sso-webservice
```

请严格按照上边的执行顺序执行，项目中修改了beego代码，所以，只能使用vendor中的beego代码才有效。

## 项目简介
sso-webservice目标是使多个系统单点登录，实现系统集成。用户与应用服务使用Json web token (JWT)传递身份认证信息。
目前项目分为4个部分，分别是：
1. sso-core         单点登录核心服务组件
2. sso-jwt-auth     系统授权管理服务组件
3. sso-webservice   前端服务组件
4. vendor           第三方依赖包

sso-webservice主要是通过反向代理，接入所有子系统中API，实现单点登录，访问。所以需要将子系统中所有的路由信息配置到sso-webservice中。
主要涉及到的配置是：
1. 子系统管理， 主要配置子系统机器名，服务使用的协议，端口号，路由基准地址。
2. 本地静态路由, 可以将子系统中的静态文件放到sso-webservice中，让sso-webservice来管理。
3. 子系统静态路由, 如果不想把子系统中的静态文件复制到sso-webservice中，也可以使用反向代理子系统静态路由来实现静态文件转发。
4. 子系统API，子系统中除了静态路由以外的服务API配置管理，sso-webservice会自动将注册的路由转发到响应的子系统中。

存在的问题：如果多个子系统API地址相同，在请求的时候，除非指定子系统（serviceCd），否则会造成默认访问匹配到的第一个子系统的API。


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