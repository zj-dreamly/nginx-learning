#### Nginx信号量

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

#### 常用命令

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