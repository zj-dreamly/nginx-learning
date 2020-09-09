#### 准备阶段

**查看是否有iptables规则**

```shell
iptables -L
iptables -t nat -L
```

**关闭iptables规则**

```shell
iptables -F
iptables -t nat -F
```

**关闭SELinux**

```shell
#查看状态
getenforce
#关闭
setenforce  0
```

**安装依赖包**

```shell
yum -y install gcc fcc-c++ autoconf pcre pcre-devel make automake
```

```shell
yum -y install wegt httpd-tools vim
```

#### 常见的HTTP服务

- HTTPD-Apache基金会
- IIS-微软
- GWS-Google

#### Nginx优点

##### IO多路复用

多个描述符的I/O操作都能在一个线程内并发交替的顺序完成，这就叫I/O多路复用，这里的复用指的是复用同一个线程。

IO多路复用的实现方式：select，poll，epoll

