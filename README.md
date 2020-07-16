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
- `--builddir=`  指向编译目录。
- `--with-rtsig_module`  启用rtsig模块支持。
- `--with-select_module`  启用select模块支持，一种轮询处理方式，不推荐在高并发环境中使用，禁用：--without-select_module。
- `--with-poll_module` 启用poll模块支持,功能与select相同，不推荐在高并发环境中使用。
- `--with-threads`启用thread pool支持。
- `--with-file-aio`  启用file aio支持。
- `--with-http_ssl_module` 启用https支持。
- `--with-http_v2_module` 启用ngx_http_v2_module支持。
- `--with-ipv6` 启用ipv6支持。
- `--with-http_realip_module` 允许从请求报文头中更改客户端的ip地址，默认为关。
- `--with-http_addition_module` 启用ngix_http_additon_mdoule支持（作为一个输出过滤器，分部分响应请求)。
- `--with -http_xslt_module` 启用ngx_http_xslt_module支持，过滤转换XML请求 。
- `--with-http_image_filter_mdoule` 启用ngx_http_image_filter_module支持，传输JPEG\GIF\PNG图片的一个过滤器，默认不启用，需要安装gd库。
- `--with-http_geoip_module` 启用ngx_http_geoip_module支持，用于创建基于MaxMind GeoIP二进制文件相配的客户端IP地址的ngx_http_geoip_module变量。
- `--with-http_sub_module` 启用ngx_http_sub_module支持，允许用一些其他文本替换nginx响应中的一些文本。
- `--with-http_dav_module` 启用ngx_http_dav_module支持，增加PUT、DELETE、MKCOL创建集合，COPY和MOVE方法，默认为关闭，需要编译开启。
- `--with-http_flv_module` 启用ngx_http_flv_module支持，提供寻求内存使用基于时间的偏移量文件。
- `--with-http_mp4_module` 启用ngx_http_mp4_module支持，启用对mp4类视频文件的支持。
- `--with-http_gzip_static_module` 启用ngx_http_gzip_static_module支持，支持在线实时压缩输出数据流。
- `--with-http_random_index_module` 启用ngx_http_random_index_module支持，从目录中随机挑选一个目录索引。
- `--with-http_secure_link_module` 启用ngx_http_secure_link_module支持，计算和检查要求所需的安全链接网址。
- `--with-http_degradation_module` 启用ngx_http_degradation_module 支持允许在内存不足的情况下返回204或444代码。
- `--with-http_stub_status_module` 启用ngx_http_stub_status_module 支持查看nginx的状态页。
- `--without-http_charset_module` 禁用ngx_http_charset_module这一模块，可以进行字符集间的转换，从其它字符转换成UTF-8或者从UTF8转换成其它字符。它只能从服务器到客户端方向，只有一个字节的字符可以转换。
- `--without-http_gzip_module` 禁用ngx_http_gzip_module支持，同--with-http_gzip_static_module功能一样。
- `--without-http_ssi_module` 禁用ngx_http_ssi_module支持，提供了一个在输入端处理服务器包含文件（SSI）的过滤器。
- `--without-http_userid_module`  禁用ngx_http_userid_module支持，该模块用来确定客户端后续请求的cookies。
- `--without-http_access_module` 禁用ngx_http_access_module支持，提供了基于主机ip地址的访问控制功能。
- `--without-http_auth_basic_module` 禁用ngx_http_auth_basic_module支持，可以使用用户名和密码认证的方式来对站点或部分内容进行认证。
- `--without-http_autoindex_module` 禁用ngx_http_authindex_module，该模块用于在ngx_http_index_module模块没有找到索引文件时发出请求，用于自动生成目录列表。
- `--without-http_geo_module` 禁用ngx_http_geo_module支持，这个模块用于创建依赖于客户端ip的变量。
- `--without-http_map_module` 禁用ngx_http_map_module支持，使用任意的键、值 对设置配置变量。
- `--without-http_split_clients_module` 禁用ngx_http_split_clients_module支持，该模块用于基于用户ip地址、报头、cookies划分用户。
- `--without-http_referer_module` 禁用ngx_http_referer_modlue支持，该模块用来过滤请求，报头中Referer值不正确的请求。
- `--without-http_rewrite_module` 禁用ngx_http_rewrite_module支持。该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置。如果在server级别设置该选项，那么将在location之前生效，但如果location中还有更进一步的重写规则，location部分的规则依然会被执行。如果这个URI重写是因为location部分的规则造成的，那么location部分会再次被执行作为新的URI，这个循环会被执行10次，最后返回一个500错误。
- `--without-http_proxy_module` 禁用ngx_http_proxy_module支持，http代理功能。
- `--without-http_fastcgi_module` 禁用ngx_http_fastcgi_module支持，该模块允许nginx与fastcgi进程交互，并通过传递参数来控制fastcgi进程工作。
- `--without-http_uwsgi_module` 禁用ngx_http_uwsgi_module支持，该模块用来使用uwsgi协议，uwsgi服务器相关。
- `--without-http_scgi_module` 禁用ngx_http_scgi_module支持，类似于fastcgi，也是应用程序与http服务的接口标准。
- `--without-http_memcached_module` 禁用ngx_http_memcached支持，用来提供简单的缓存，提高系统效率。
- `--without-http_limit_conn_module` 禁用ngx_http_limit_conn_module支持，该模块可以根据条件进行会话的并发连接数进行限制。
- `--without-http_limit_req_module` 禁用ngx_limit_req_module支持，该模块可以实现对于一个地址进行请求数量的限制。
- `--without-http_empty_gif_module` 禁用ngx_http_empty_gif_module支持，该模块在内存中常驻了一个1*1的透明gif图像，可以被非常快速的调用。
- `--without-http_browser_module` 禁用ngx_http_browser_mdoule支持，创建依赖于请求报头的值 。如果浏览器为modern，则$modern_browser等于modern_browser_value的值；如果浏览器为old，则$ancient_browser等于$ancient_browser_value指令分配的值；如果浏览器为MSIE，则$msie等于1。
- `--without-http_upstream_ip_hash_module` 禁用ngx_http_upstream_ip_hash_module支持，该模块用于简单的负载均衡。
- `--with-http_perl_module` 启用ngx_http_perl_module支持，它使nginx可以直接使用perl或通过ssi调用perl。
- `--with-perl_modules_path=`  设定perl模块路径
- `--with-perl=`  设定perl库文件路径
- `--http-log-path=`  设定access log路径
- `--http-client-body-temp-path=`  设定http客户端请求临时文件路径
- `--http-proxy-temp-path=`  设定http代理临时文件路径
- `--http-fastcgi-temp-path=`  设定http fastcgi临时文件路径
- `--http-uwsgi-temp-path=` 设定http scgi临时文件路径
- `--http-scgi-temp-path=`  设定http scgi临时文件路径
- `--without-http`   禁用http server功能
- `--without-http-cache`  禁用http cache功能
- `--with-mail`  启用POP3、IMAP4、SMTP代理模块
- `--with-mail_ssl_module`  启用ngx_mail_ssl_module支持
- `--without-mail_pop3_module` 禁用pop3协议。
- `--without-mail_iamp_module` 禁用iamp协议。
- `--without-mail_smtp_module` 禁用smtp协议。
- `--with-google_perftools_module` 启用ngx_google_perftools_mdoule支持，调试用，可以用来分析程序性能瓶颈。
- `--with-cpp_test_module` 启用ngx_cpp_test_module支持。
- `--add-module=`  指定外部模块路径，启用对外部模块的支持。
- `--with-cc=`  指向C编译器路径。
- `--with-cpp=`  指向C预处理路径。
- `--with-cc-opt=` 设置C编译器参数，指定--with-cc-opt="-I /usr/lcal/include",如果使用select()函数，还需要同时指定文件描述符数量--with-cc-opt="-D FD_SETSIZE=2048"。  (PCRE库）
- `--with-ld-opt=` 设置连接文件参数，需要指定--with-ld-opt="-L /usr/local/lib"。（PCRE库）
- `--with-cpu-opt=` 指定编译的CPU类型，如pentium,pentiumpro,...amd64,ppc64...
- `--without-pcre` 禁用pcre库。
- `--with-pcre`  启用pcre库。
- `--with-pcre=` 指向pcre库文件目录。
- `--with-pcre-opt=` 在编译时为pcre库设置附加参数 。
- `--with-md5=` 指向md5库文件目录。
- `--with-md5-opt=`  编译时为md5库设置附加参数。
- `--with-md5-asm`  使用md5汇编源。
- `--with-sha1=`  指向sha1库文件目录。
- `--with-sha1-opt=`  编译时为sha1库设置附加参数。
- `--with-sha1-asm` 使用sha1汇编源。
- `--with-zlib=` 指向zlib库文件目录。
- `--with-zlib-opt=` 在编译时为zlib设置附加参数。
- `--with-zlib-asm=` 为指定的CPU使用汇编源进行优化。
- `--with-libatomic` 为原子内存的更新操作的实现提供一个架构。
- `--with-libatomic=` 指向libatomic_ops的安装目录。
- `--with-openssl=` 指向openssl安装目录。
- `--with-openssl-opt=`  在编译时为openssl设置附加参数。
- `--with-debug` 启用debug日志。

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

### Nginx Core参数配置说明

先来一个配置示例：

```php
user www www;
worker_processes 2;

error_log /var/log/nginx-error.log info;

events {
    use kqueue;
    worker_connections 2048;
}

...
```

**daemon**

```csharp
Syntax:     daemon on | off;
Default:    

daemon on;

Context:    main
```

指示Nginx是否需要成为守护进程，一般用于开发期间。

**debug_points**

```cpp
Syntax:     debug_points abort | stop;
Default:    —
Context:    main
```

这个指令用于调试。
 当出现内部错误时，如在重启worker时socket泄漏，设置了 `debug_points` 会产生 core 文件或停止process，以便调试系统收集更多的信息来分析。

**error_log**

```cpp
Syntax:     error_log file [level];
Default:    

error_log logs/error.log error;

Context:    main, http, mail, stream, server, location
```

配置Nginx的日志，同等级日志可以有多条日志配置。如果 `main` 级别的配置没有明确定义，也即没有定义日志文件，那么Nginx将使用默认的文件来输出日志。

第一个参数 `file` 定义了存放日志文件的路径，如果是 `stderr` ，则日志直接输出到系统标准输入输出上，如果需要将日志传输到另外的日志服务器上，可配置 `syslog`,以 `syslog:` 为前缀，如 `syslog:server=address[,parameter=value]`,还可以设置参数 `memory`来将日志记录到 `cyclic memory buffer` 中。

```bash
示例：
error_log syslog:server=192.168.1.1 debug;

access_log syslog:server=unix:/var/log/nginx.sock,nohostname;
access_log syslog:server=[2001:db8::1]:12345,facility=local7,tag=nginx,severity=info combined;
```

第二个可选参数 `level` ，设置日志的等级，可使用的值有：
 `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert`, `emerg`. 上述等级严重性也顺序递增。
 设置其中一个等级，日志中出现的内容包括本等级及等级后边的日志等级，例如：如果设置日志等级为 `error` ，则所有的的 `error` 和 `crit` 、`alert` 以及 `emerg` 等级的日志也会出现。
 配置为 `debug` 等级，必须在编译时使用了 `--with-debug` 参数。

**env**

```csharp
Syntax:     env variable[=value];
Default:    

env TZ;

Context:    main
```

Nginx默认会移除继承自父进程的所有变量（TZ变量除外），`env` 指令允许从父进程继承变量、更改变量、创建新变量。这些变量包括：

- 继承自在线升级的二进制文件
- `ngx_http_perl_module` 模块使用的变量
- worker 进程中使用的变量，我们须知道，这种方式控制系统库不总是有效的，因为系统库通常只在初始化的时候检查变量，之前他们可以使用这个指令，有一个例外的情况，就是上面提到的在线升级的文件

TZ变量总是被继承的，来自 `ngx_http_perl_module` 模块，除非有对它有显式的配置。
 示例

```jsx
env MALLOC_OPTIONS;
env PERL5LIB=/data/site/modules;
env OPENSSL_ALLOW_PROXY_CERTS=1;
```

**events**

```php
Syntax:     events { ... }
Default:    —
Context:    main
```

设置event的一些参数配置。

```csharp
Syntax:     accept_mutex on | off;
Default:    

accept_mutex off;

Context:    events
```

**accept_mutex**

如果设置允许 `accept_mutex` ，则 worker 会轮流的也即串行的方式接受新连接。其中一个worker被唤醒来处理新来的连接，其他的worker保持不动；如果不允许 `accept_mutex`，Nginx会通知所有的worker，唤醒他们【惊群问题】，以便让其中一个worker来接受处理新来的连接，Nginx默认禁用该功能（一个保守的设置，预防惊群问题）。
 1.11.3版本之前，该功能默认是开启的。

**accept_mutex_delay**

```php
Syntax:     accept_mutex_delay time;
Default:    

accept_mutex_delay 500ms;

Context:    events
```

跟上面的 `accept_mutex` 搭配设置的，如果启用了 `accept_mutex`，这个参数是设置每个worker在别的worker试图接受处理新连接后，必须要等待的最大时间，是一种锁机制，保护避免惊群现象，防止所有worker都呼啦一下子来获取这个新连接。默认为500ms,0.5s。

**debug_connection**

```objectivec
Syntax:     debug_connection address | CIDR | unix:;
Default:    —
Context:    events
```

允许指定的客户端IP调试日志，其他IP使用 `error_log` 指令设置的级别来输出日志。调试日志IP使用IPV4或网段，也可以指定主机名，unix socket等。

示例:

> events {
>  debug_connection 127.0.0.1;
>  debug_connection localhost;
>  debug_connection 192.0.2.0/24;
>  debug_connection ::1;
>  debug_connection 2001:0db8::/32;
>  debug_connection unix:;
>  ...
>  }
>  要正常使用该功能，必须在编译时使用 `--with-debug` 参数。

**worker_aio_requests**

```css
Syntax:     worker_aio_requests number;
Default:    

worker_aio_requests 32;

Context:    event

This directive appeared in versions 1.1.4 and 1.0.7. 
```

仅出现在V1.1.4和V1.0.7上。

当在 `epoll` 上 使用 `aio` 时，设置单个 worker 进程未处理的异步IO数量。

**worker_connections**

```csharp
Syntax:     worker_connections number;
Default:    

worker_connections 512;

Context:    event
```

设置单个worker进程能同时打开的最大连接数。

 切记，这个数值包含所有的连接（包括跟后端server间的连接，不仅仅是跟客户端间的连接），另外要注意的

是，这个数值不能大于单个worker进程能打开的最大文件数限制（这个值可由 `worker_rlimit_nofile` 指令设置）。

**use**

```php
Syntax:     use method;
Default:    —
Context:    events
```

设定使用什么类型的事件处理类型，可选值有如下：

- `select`,标准方法，各平台默认自动编译支持，如果没有更有效的方法是，使用该方法。`--with-select_module` 和 `--without-select_module` 这2个编译参数可以强制设定是否使用 select 或不使用 select.
- `poll` ，标准方法，各平台默认自动编译支持，如果没有更有效的方法是，使用该方法。`--with-poll_module` 和 `--without-poll_module` 这2个编译参数可以强制设定是否使用 select 或不使用 select.
- `kqueue` ，在FreeBSD 4.1+, OpenBSD 2.9+, NetBSD 2.0, 和 macOS 等系统上更高效的方法。
- `epoll` ，在Linux 2.6+ 上更高效的方法。
- `/dev/poll` , Solaris 7 11/99+, HP/UX 11.22+ , IRIX 6.5.15+, 和 Tru64 UNIX 5.1A+ 系统上更高效的方法。
- `eventport` ,Solaris 10 系统上更高效的方法。

**multi_accept**

```csharp
Syntax:     multi_accept on | off;
Default:    

multi_accept off;

Context:    events
```

设置了 `multi_accept` off 后，worker进程一次只能处理一个连接，设置为on的时候，worker 进程一次可以接受所有连接。

**include**

```php
Syntax:     include file | mask;
Default:    —
Context:    any
```

这个指令配置嵌套的配置文件，即走Nginx.conf里再包含一个其他的配置文件，可放在配置文件的任何位置。

```php
include mime.types;
include vhosts/*.conf;
```

**load_module**

```css
Syntax:     load_module file;
Default:    —
Context:    main

This directive appeared in version 1.9.11. 
```

加载一个模块。

示例：

```tsx
load_module modules/ngx_mail_module.so;
```

**lock_file**

```csharp
Syntax:     lock_file file;
Default:    

lock_file logs/nginx.lock;

Context:    main
```

Nginx使用锁机制来实现 `accept_mutex` 以及序列化访问来实现共享内存，大多数系统使用原子操作来实现锁，那么这个指令将会被忽略，其他一些系统使用 `lock file`来实现锁，这个指令设置锁的名称和路径前缀。

**master_process**

```csharp
Syntax:     master_process on | off;
Default:    

master_process on;

Context:    main
```

这是一个给Nginx开发者使用的指令，标识worker进程是否已启动。

**pcre_jit**

```csharp
Syntax:     pcre_jit on | off;
Default:    

pcre_jit off;

Context:    main

This directive appeared in version 1.1.12. 
```

设置是否允许 JIT  编译的开关，启用 JIT 能极大的提高正则表达式处理的速度。

**pid**

```css
Syntax:     pid file;
Default:    

pid nginx.pid;

Context:    main
```

设置 pid 存放到哪个文件里。

**ssl_engine**

```php
Syntax:     ssl_engine device;
Default:    —
Context:    main
```

定义硬件SSL加速器的名称。

**thread_pool**

```tsx
Syntax:     thread_pool name threads=number [max_queue=number];
Default:    

thread_pool default threads=32 max_queue=65536;

Context:    main

This directive appeared in version 1.7.11. 
```

定义一个线程池的名称，用来非阻塞的使用多线程读取或发送文件。
 `threads` 参数是线程池大小的数值，如果线程池中的所有线程均处于忙碌状态，新任务将会在队列里等候，`max_queue` 设置了队列里可等待的最大值，默认为 65536 ，如果队列溢出了，新任务将以错误结束。

**timer_resolution**

```php
Syntax:     timer_resolution interval;
Default:    —
Context:    main
```

worker进程中的减时计时器，因此会调用 `gettimeofday()` ,默认情况下，每收到一次内核事件将会调用一次 `gettimeofday()` ，使用减时方案，`gettimeofday()`只会在设定的时间间隔内调用一次。如：

```undefined
timer_resolution 100ms;
```

内部时间的时间间隔取决于使用如下哪个方法：

- 如果使用`kqueue`，则值为 `EVFILT_TIMER`
- 如果使用`eventport`，则值为 `timer_create()`
- 其他情况为 `setitimer()`

**user**

```csharp
Syntax:     user user [group];
Default:    

user nobody nobody;

Context:    main
```

定义Nginx运行时的用户和组，如果组没有指定，则用户和组一致。

**worker_cpu_affinity**

```cpp
Syntax:     worker_cpu_affinity cpumask ...;
worker_cpu_affinity auto [cpumask];
Default:    —
Context:    main
```

设置CPU亲和性，每个CPU使用位掩码来描述其亲和性，需要单独设置每个worker，默认情况下，worker进程不绑定任何CPU。

示例：

```cpp
worker_processes    4;
worker_cpu_affinity 0001 0010 0100 1000;  //4个worker，所以要对每个worker都进行设置。
```

又如示例

```undefined
worker_processes    2;
worker_cpu_affinity 0101 1010;
```

这里将第一个worker绑定到CPU0和CPU2上，将worker 2绑定到CPU1和CPU3上。这个例子适合超线程。
 也可以设置`auto`值，让系统自动的绑定CPU到具体的worker上。如：

```cpp
worker_processes auto;
worker_cpu_affinity auto;
```

也可用掩码来设定自动绑定到哪些CPU上，即有些CPU不用于Nginx。如：

```cpp
worker_cpu_affinity auto 01010101;//8个CPU，只有CPU0,CPU2,CPU4,CPU6这几颗CPU参与自动绑定。
```

这个指令仅用于Linux和FreeBSD。

**worker_priority**

```php
Syntax:     worker_priority number;
Default:    

worker_priority 0;

Context:    main
```

定义 Nginx 的 worker 进程的优先级，就像 `nice` 命令一样：负值意味着更高的优先级，可选范围是 -20 到 20。

**worker_processes**

```cpp
Syntax:     worker_processes number | auto;
Default:    

worker_processes 1;

Context:    main
```

定义Nginx的worker进程的数量。
 最佳值取决于很多因素，包括（但不限于）CPU的核数、硬盘分区的数量、负载模式。如果不知怎么设置好，将该值设置为CPU的数量不失一个不错的选择（设置了 `auto` 的话，Nginx将会自动侦探CPU的核数）

**worker_rlimit_core**

```php
Syntax:     worker_rlimit_core size;
Default:    —
Context:    main
```

设置每个worker最大能打开的核心文件数，用于突破上限而不用重启master进程。
 core文件中Nginx发生crash的时候会产生的文件。一般用于调试,gdb等。

> worker_rlimit_core  50M;
>  working_directory   /tmp/;

**worker_rlimit_nofile**

```php
Syntax:     worker_rlimit_nofile number;
Default:    —
Context:    main
```

设置每个worker最大能打开的核件数，用于突破上限而不用重启master进程。
 这个值未设置的话，采用系统的值，`ulimit -a`，一般会把它调高点，以防报错 "too many open files" 的问题。

> worker_rlimit_nofile 100000;

**worker_shutdown_timeout**

```css
Syntax:     worker_shutdown_timeout time;
Default:    —
Context:    main

This directive appeared in version 1.11.11. 
```

配置Nginx能优雅的停止，如果超过时间还未停止，Nginx会关闭当前所有连接，来保证Nginx停止。

**working_directory**

```php
Syntax:     working_directory directory;
Default:    —
Context:    main
```

设定Nginx的worker进程的工作目录，仅用于定义core文件的位置，该目录必须要让Nginx的运行时用户有写的权限，一般会配套的有 `worker_rlimit_core` 指令设置。