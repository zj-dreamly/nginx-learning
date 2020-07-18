### Nginx信号量

- `TERM`,`INT`：快速的杀掉进程
- `QUIT` ：优雅的关闭进程，即等请求结束后关闭进程
- `HUP` ：改变配置文件，平滑的重读配置文件
  
   + ```shell
     kill -HUP 'cat logs/nginx.pid' = nginx -s reload
     ```
- `USR1` ：重读日志，在日志按月/日分割时有用
   对于做日志备份有用  首先对access.log做备份access.log.bak，然后新建access.log 最后 kill -USR1 'cat  logs/nginx.pid`会把新生成的文件存到access.log里面
- `USR2` ：平滑的升级
- `WINCH` ：优雅的关闭旧的进程(配合上USR2来进行升级)

> 在logs/nginx.pid记录了nginx的进程号   
>
> 注意：nginx的进程号会变，只是这个文件记录了随时会变得进程号而已

**示例**

```shell
# 重读配置文件
#`cat logs/nginx.pid` 表示主进程号
nginx -s reload = kill -HUP `cat logs/nginx.pid`
# 停用nginx          
nginx -s stop 
# 重读日志文件
nginx -s reopen = kill -USR1 `cat logs/nginx.pid`
# 查看配置文件是否出错
nginx -t 
```

### nginx编译参数详解

- **configure时遇到错误**
   nginx在编译安装时，进入其源码解压目录后，使用`./configure`指令可以带上如下这些参数进行自定义编译安装，如果在编译时遇到错误，一般是相应的依赖软件包没有安装的，可以根据with后的名称，安装相应软件包的devel程序，如`--with-http_ssl_module`要是报错找不到ssl相关的配置或者文件，可以执行`yum install -y openssl-devel`，将`openssl`和`openssl-devel`及其依赖包安装上，然后再次执行`./configure`指令一般即可configure成功。
- **with和without**  
   我个人理解：凡是`./configure`指令后只能使用`without`选项的功能或者模块，其默认不明确指定时即为`with`即启用状态或者支持某功能的状态。
   只能使用`with`选项的功能或者模块，其默认不指定时即为不支持或者关闭状态。
   对于即可以`with`又可以`without`的功能或模块则务必根据需求进行明确指定。

#### nginx的configure参数

下面是nginx源码程序的configure参数：

- `--prefix=` 指向安装目录

- `--sbin-path=` 指定执行程序文件存放位置
- `--conf-path=`  指定配置文件存放位置
- `--error-log-path=` 指定错误日志存放位置。
- `--pid-path=` 指定pid文件存放位置
- `--lock-path=` 指定lock文件存放位置
- `--modules-path=` 指定第三方模块的存放路径。
- `--user=`  指定程序运行时的非特权用户。
- `--group=` 指定程序运行时的非特权用户组。
- `--with-threads`启用thread pool支持。
- `--with-file-aio`  启用file aio支持。

#### 默认with或without的选项

| 选项(功能)                   | with | without | 默认                                                         |
| ---------------------------- | ---- | ------- | ------------------------------------------------------------ |
| prefix                       | N/A  | N/A     | /usr/local/nginx                                             |
| sbin-path                    | N/A  | N/A     | prefix/sbin/nginx                                            |
| conf-path                    | N/A  | N/A     | prefix/conf/nginx.conf                                       |
| pid-path                     | N/A  | N/A     | prefix/logs/nginx.pid                                        |
| error-log-path               | N/A  | N/A     | prefix/logs/error.log                                        |
| http-log-path                | N/A  | N/A     | prefix/logs/access.log                                       |
| user                         | N/A  | N/A     | nobody                                                       |
| group                        | N/A  | N/A     | nobody                                                       |
| select_module                | with | without | 如果平台不支持kqueue,epoll,/dev/poll，它将作为自动选择的事务处理方式 |
| poll_module                  | with | without | 如果平台不支持kqueue,epoll,/dev/poll，它将作为自动选择的事务处理方式 |
| file_aio                     | with | N/A     | 关闭                                                         |
| ipv6                         | with | N/A     | 关闭                                                         |
| http_ssl_module              | with | N/A     | 关闭                                                         |
| http_realip_module           | with | N/A     | 关闭                                                         |
| http_addition_module         | with | N/A     | 关闭                                                         |
| http_xslt_module             | with | N/A     | 关闭                                                         |
| http_image_filter_module     | with | N/A     | 关闭                                                         |
| http_geoip_module            | with | N/A     | 关闭                                                         |
| http_sub_module              | with | N/A     | 关闭                                                         |
| http_dav_module              | with | N/A     | 关闭                                                         |
| http_flv_module              | with | N/A     | 关闭                                                         |
| http_gzip_static_module      | with | N/A     | 关闭                                                         |
| http_random_index_module     | with | N/A     | 关闭                                                         |
| http_secure_link_module      | with | N/A     | 关闭                                                         |
| http_degradation_module      | with | N/A     | 关闭                                                         |
| http_stub_status_module      | with | N/A     | 关闭                                                         |
| http_charset_module          | N/A  | without | 启用                                                         |
| http_gzip_module             | N/A  | without | 启用                                                         |
| http_ssi_module              | N/A  | without | 启用                                                         |
| http_userid_module           | N/A  | without | 启用                                                         |
| http_access_module           | N/A  | without | 启用                                                         |
| http_auth_basic_module       | N/A  | without | 启用                                                         |
| http_autoindex_module        | N/A  | without | 启用                                                         |
| http_geo_module              | N/A  | without | 启用                                                         |
| http_map_module              | N/A  | without | 启用                                                         |
| http_split_clients_module    | N/A  | without | 启用                                                         |
| http_referer_module          | N/A  | without | 启用                                                         |
| http_rewrite_module          | N/A  | without | 启用                                                         |
| http_proxy_module            | N/A  | without | 启用                                                         |
| http_fastcgi_module          | N/A  | without | 启用                                                         |
| http_uwsgi_module            | N/A  | without | 启用                                                         |
| http_scgi_module             | N/A  | without | 启用                                                         |
| http_memcached_module        | N/A  | without | 启用                                                         |
| http_limit_conn_module       | N/A  | without | 启用                                                         |
| http_limit_req_module        | N/A  | without | 启用                                                         |
| http_empty_gif_module        | N/A  | without | 启用                                                         |
| http_brower_module           | N/A  | without | 启用                                                         |
| http_upstream_ip_hash_module | N/A  | without | 启用                                                         |
| http_perl_module             | with | N/A     | 禁用                                                         |
| http                         | N/A  | without | 启用                                                         |
| http-cache                   | N/A  | without | 启用                                                         |
| mail                         | with | N/A     | 禁用                                                         |
| pcre                         | with | without | N/A                                                          |
| stream                       | with | N/A     | 禁用                                                         |

### devel包及非devel包的区

devel 包主要是供开发用，至少包括以下2个东西:

1. 头文件 
2. 链接库 有的还含有开发文档或演示代码。 以 glib 和 glib-devel 为例: 如果你安装基于 glib 开发的程序，只需要安装 glib 包就行了。但是如果你要编译使用了 glib 的源代码，则需要安装 glib-devel。

#### 常用配置样例

```nginx
# 设置用户、用户组
user nginx nginx;
# 设置默认开启的工作进程，auto代表cpu核心数
worker_processes auto;
# 设置master进程的PID文件位置
pid /opt/nginx/logs/nginx.pid;
# 设置工作进程的打开文件数的最大值（linux最大支持65535）
worker_rlimit_nofile 12500;
# 设置工作进程的core文件尺寸的最大值
worker_rlimit_core 50M;
# 定义工作进程的当前工作路径。 主要用于设置core文件的目标地址。工作进程应当具有指定路径的写权限
working_directory /opt/nginx/tmp;
# 绑定工作进程到指定的CPU集合。每个CPU集合使用一个标记允许使用的CPU的位图来表示。 需要为每个工作进程分别设置CPU集合。 工作进程默认不会绑定到任何特定的CPU。
worker_cpu_affinity 0001 0010 0100 1000;
# 定义工作进程的调度优先级。这与nice命令行所做的相同： number为负数代表优先级更高。通常允许的范围是[-20, 20]。
worker_priority -10;
# 设置安全地结束一个worker进程的超时时间
worker_shutdown_timeout 5s;
# 在工作进程中降低定时器的精度，因此可以减少产生gettimeofday()系统调用的次数。 默认情况下，每收到一个内核事件，nginx都会调用gettimeofday()。 使用此指令后，nginx仅在每经过指定的interval时间间隔后调用一次gettimeofday()。
timer_resolution 100ms;
# 决定nginx是否应以守护进程的方式工作。主要用于开发。
daemon on;
# nginx使用锁机制来实现accept_mutex，并将访问串行化到共享内存。 绝大多数系统中，锁是由原子操作实现，那么可以忽略这条指令。 另外一些系统使用“锁文件”的机制，那么这条指令将指定锁文件的前缀。
lock_file logs/nginx.log;

events {
    # 设置每个工作进程可以打开的最大并发连接数。
    worker_connections  17500;
    # 如果使用，nginx的多个工作进程将以串行方式接入新连接。否则，新连接将通报给所有工作进程，而且如果新连接数量较少，某些工作进程可能只是在浪费系统资源。
    accept_mutex on;
    # 使用accept_mutex时，可以指定某个工作进程检测到其它工作进程正在接入新连接时，自身等待直到重新开始尝试接入新连接的最大时间间隔
    accept_mutex_delay 100ms;
    # 关闭时，工作进程一次只会接入一个新连接。否则，工作进程一次会将所有新连接全部接入。
    multi_accept on;
}


http {
    include       mime.types;
    default_type  application/octet-stream;
    
    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    charset utf-8;

    gzip  on;
    server {
	listen 80;
        server_name www.nginx-test.com; 

	root  html;

	location /monitor_status {
	    stub_status;
	}

	location /test/ {
	    index no_sign.html;
	}
}

```

更多core配置参考：http://tengine.taobao.org/nginx_docs/cn/docs/ngx_core_module.html

### server_name

#### 用法

- 精确匹配，例如：www.example.com www.baidu.com，多个域名以空格分隔
- 通配符，支持前通配和后通配，例如：\*.example.com example.\*，多个域名以空格分隔
- 正则表达式，就是在名字前面补一个波浪线(“`~`”)，例如：~^www\d+\.example\.com$;

#### 优先级

精确匹配 > 左侧通配符匹配 > 右侧通配符匹配 > 正则表达式匹配

#### root和alias区别

- root用于http、server、location、if等上下文
- alias用于location上下文
- 相同点：URI到磁盘文件的映射
- 区别：root会将定义路径与URL叠加，alias则只取定义路径
- 使用alias时，末尾必须加/
- alias只能位于location块中

**root示例**

```nginx
location /picture {
    root /opt/nginx/html/picture
}

# 客户端请求www.test.com/picture/1.jpg，则对应磁盘映射路径：/opt/nginx/html/picture/picture/1.jpg
```

**alias示例**

```nginx
location /picture {
    alias /opt/nginx/html/picture
}

客户端请求www.test.com/picture/1.jpg，则对应磁盘映射路径：/opt/nginx/html/picture/1.jpg
```

### location

| 匹配规则     | 含义                   | 示例                            |
| ------------ | ---------------------- | ------------------------------- |
| =            | 精确匹配               | location=/images/{...}          |
| ~            | 正则匹配，区分大小写   | location ~ \\.(jpg\|gif)${...}  |
| ~*           | 正则匹配，不区分大小写 | location ~* \\.(jpg\|gif)${...} |
| ^~           | 匹配到即停止搜索       | location ^~ /images/{...}       |
| 不带任何符号 |                        | location /{...}                 |

#### 匹配顺序

`=` ＞`＾～`＞`～`＞`～＊`＞不带任何字符

#### URL写法区别

```nginx
# 首先查询root目录是否有test文件夹，然后查找test文件夹里的index.html，如果查找不到，那么查询root目录是否有test文件
location /test {
    ......
}
# 只会查询是否test文件夹
location /test/ {
    ......
}
```

### limit _conn

- 用于限制客户端并发连接数
- 默认编译进nginx，通过`without-http_limit_conn_module`禁用
- 使用共享内存，对所有的worker子进程生效

#### 常用指令

- limit_conn_zone

- limit_conn_status
- limit_conn_log_level
- limit_conn

### limit_req

- 用于限制客户端处理请求的平均速率
- 默认编译进nginx，通过`without-http_limit_req_module`禁用
- 使用共享内存，对所有的worker子进程生效
- 限流算法：leaky_bucket

#### 常用指令

- limit_req
- limit_req_log_level
- limit_req_zone

更多配置参考：http://tengine.taobao.org/nginx_docs/cn/docs

### http_access

- allow
- deny

### auth_basic

- auth_basic
- auth_basic_user_file



