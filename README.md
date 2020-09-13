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

### auth_request

- auth_request
- auth_request_set

### return

- 停止处理请求，直接返回响应码或重定向到其他URL
- 执行return指令后，location中后续指令将不会被执行

### rewrite

- 根据指定正则表达式匹配规则，重写URL

### if

- 条件判断

### auto_index

- autoindex_exact_size
- autoindex_format
- autoindex_localtime

### Nginx变量分类

#### TCP连接变量

| 变量                | 含义                                                       |
| ------------------- | ---------------------------------------------------------- |
| remote_addr         | 客户端IP地址                                               |
| remote_port         | 客户端端口                                                 |
| server_addr         | 服务端IP地址                                               |
| server_port         | 服务端端口                                                 |
| server_protocol     | 服务端协议                                                 |
| binary_remote_addr  | 二进制格式的客户端IP地址                                   |
| onnection           | TCP链接的序号，递增                                        |
| connection_request  | TCP链接当前的请求数量                                      |
| proxy_protocol_addr | 若使用了proxy_protocol协议，则返回协议中的地址，否则返回空 |
| proxy_protocol_port | 若使用了proxy_protocol协议，则返回协议中的端口，否则返回空 |

#### HTTP请求变量

| 变量                 | 含义                                         |
| -------------------- | -------------------------------------------- |
| uri                  | 请求的URL，不包含参数                        |
| request_uri          | 请求的URL，包含参数                          |
| scheme               | 协议名，http或https                          |
| request_method       | 请求方法                                     |
| request_length       | 全部请求的长度，包括请求行，请求头，请求体   |
| args                 | 全部参数字符串                               |
| arg_参数名           | 特定参数值                                   |
| is_args              | URL中有参数，则返回?，负责返回空             |
| query_string         | 与args相同                                   |
| remote_user          | 由HTTP Basic Authentication协议传入的用户名  |
| host                 | 先看请求行，再看请求头，最后找server_name    |
| http_user_agent      | 用户浏览器                                   |
| http_referer         | 从哪些链接过来的请求                         |
| http_via             | 经过一层代理服务器，添加对应代理服务器的信息 |
| http_x_forwarded_for | 获取用户真实IP                               |
| http_cookie          | 用户cookie                                   |

#### Nginx处理HTTP请求产生的变量

| 变量               | 含义                                  |
| ------------------ | ------------------------------------- |
| request_time       | 处理请求已耗费的时间                  |
| request_completion | 请求处理完成返回OK，否则返回空        |
| server_name        | 匹配上请求的server_name值             |
| https              | 若开启https，则返回on，否则返回空     |
| request_filename   | 磁盘文件系统待访问文件的完整路径      |
| document_root      | 由URI和root/alias规则生成的文件夹路径 |
| realpath_root      | 将document_root中的软链接换成真实路径 |
| limit_rate         | 返回响应时的速度上限值                |

#### Nginx返回响应变量

#### Nginx内部变量

### 反向代理

- 反向代理服务器介于用户与真实服务器之间，提供请求和响应的中转服务
- 对于用户而言，访问反向代理服务器就是访问真实服务器
- 反向代理可以有效降服务器的负载消耗，提升效率

#### upstream

- 用于定义上游服务的相关信息

- 指令集说明：http://tengine.taobao.org/nginx_docs/cn/docs/http/ngx_http_upstream_module.html#variables

#### proxy_pass用法常见误区

##### 带`/`和不带`/`用法区别

- 不带 / 意味着Nginx不会修改用户URL，而是直接透传给上游的服务器
- 带 / 意味着Nginx会修改用户URL，修改方法：将location后的URL从用户URL中删除

**示例**

- 不带 / 示例

```nginx
location /bbs/ {
    proxy_pass http://127.0.0.1:8080;
}

# 用户请求url：/bbs/abc/test.html
# 请求到达Nginx的url：/bbs/abc/test.html
# 请求到达上游服务器的url: /bbs/abc/test.html
```

- 带 / 示例

```nginx
location /bbs/ {
    proxy_pass http://127.0.0.1:8080/;
}

# 用户请求url：/bbs/abc/test.html
# 请求到达Nginx的url：/bbs/abc/test.html
# 请求到达上游服务器的url: /abc/test.html
```

#####  代理到上游服务器的URL结尾是否有必要加`/`

- 上游服务器是否有该前缀，有的话就不加，没有的话就加

#### Nginx处理request_body

```nginx
upstream back_end {
	server 192.168.184.20:8080 weight=2 max_conns=1000 fail_timeout=10s max_fails=3;
	# 最大空闲长连接数
    keepalive 32;
    # 在此长连接上最大的请求数，超过则会直接断开连接
	keepalive_requests 80;
    # 长连接的超时时间
	keepalive_timeout 20s;
} 

server {
	listen 80;
	server_name proxy.kutian.edu;

	location /proxy/ {
	    proxy_pass http://back_end/proxy;
	}

	location /bbs/ {
	   proxy_pass http://192.168.184.20:8050/;
	}
    
    location /receive/ {
        proxy_pass http://test_server;
        # 最大请求体大小，如果需要通过nginx上传图片等资源，需要设置大一点
        client_max_body_size 250k;
        # 缓冲区大小，当请求体的大小超过此大小时，nginx会把请求体写入到临时文件中。可以根据业务需求设置合适的大小，尽量避免磁盘io操作
        client_body_buffer_size 100k;
        # 本地缓冲区储存路径
        client_body_temp_path test_body_path;

        client_body_in_file_only on;
        # 指示是否将请求体完整的存储在一块连续的内存中，默认为off，如果此指令被设置为on，则nginx会保证请求体在不大于client_body_buffer_size设置的值时，被存放在一块连续的内存中，但超过大小时会被整个写入一个临时文件
        client_body_in_single_buffer on;

        proxy_request_buffering on;
        clent_body_timeout 30;
    }
}
```

#### Nginx修改发往上游的请求

- 请求行信息修改
- 请求头信息修改
- 请求体信息修改

### 负载均衡

- 哈希算法
- ip_hash算法
- 最少连接数算法
- proxy_next_upstream 

### 缓存

- 客户端缓存

- 服务端缓存

#### 指令

- proxy_cache
- proxy_cache_path
- proxy_cache_key
- proxy_cache_valid
- upstream_cache_status
- proxy_no_cache
- proxy_cache_lock
- proxy_cache_lock_timeout
- proxy_cache_lock_age
- proxy_cache_use_stale
- proxy_cache_background_update
- proxy_cache_purge

### HTTPS

#### 加密算法

##### 对称加密

- DES, AES, 3DES
- 优势
  - 解密效率高
- 劣势
  - 密钥无法实现安全传输
  - 密钥的数目难以维护
  - 无法提供信息完整性校验

##### 非对称加密

- RSA, DSA, ECC
- 优势
  - 服务器仅维护一个私钥即可
- 劣势
  - 公钥是公开的
  - 非对称加密算法加解密过程中会有一定的时间消耗
  - 公钥并不包含服务器信息，存在中间人攻击的可能性

#### https的加密原理

- https混合使用对称加密和非对称加密
- 连接建立阶段使用非对称加密算法
- 内容传输阶段使用对称加密算法

### Nginx高可用

- VRRP
- keepalived
- Fast Open

