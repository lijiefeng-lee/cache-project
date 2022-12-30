# cache-project
openresty + lua 多级缓存架构




# 缓存架构设计及集群划分
## 、集群划分

redis集群

```
容器名称容器名称 容器容器 IP 地址地址 映射端口号映射端口号 服务运行模式服务运行模式
redis-master1 192.198.0.2 6391 -> 6397 16391 -> 16397 Master
redis-master2 192.198.0.3 6392 -> 6397 16392 -> 16397 Master
redis-master3 192.198.0.4 6393 -> 6397 16393 -> 16397 Master
redis-slave1 192.198.0.5 6394 -> 6397 16394 -> 16397 slave
redis-slave2 192.198.0.6 6395 -> 6397 16395 -> 16397 slave
redis-slave3 192.198.0.7 6396 -> 6397 16396 -> 16397 slave
```

Ngin x集群

```
容器名称容器名称 容器容器 IP 地址地址 映射端口号映射端口号 服务运行模式服务运行模式
Nginx 192.198.0.8 8001 -> 80 Nginx分发层
Nginx-lua1 192.198.0.9 8002 -> 80 Nginx应用层
Nginx-lua2 192.198.0.10 8003 -> 80 Nginx应用层
```




# 1 、nginx分发层到应用层

通过调用本身的nginx的hash分发模块分发到应用层并且实现动态负载均衡，并且在应用层当中调用php-fpm

```
consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -node=ali_1 -bind=172.27.0.8 -ui -client 0.0.0.
upstream servers {
server 118.24.109.254:8002 max_fails=3 fail_timeout=5s;
upsync 118.24.109.254:8500/v1/kv/upstreams/servers upsync_timeout=20s upsync_interval=500ms upsync_type=consul
strong_dependency=off;
upsync_dump_path /usr/local/openresty/conf/servers.conf;
include /usr/local/openresty/conf/servers.conf;
}
docker run -d -p 8700:8500 -h node1 --name node1 consul agent -server -bootstrap-expect=1 -node=node1 -client 0.0.0.0 -ui
curl -X PUT -d '{"weight":1,"max_fails":2,"fail_timeout":10}' http://127.0.0.1:8700/v1/kv/upstreams/servers/118.24.109.254:
```
# 2 、lua连接redis集群定时获取consul  地址

```
redis集群包地址 https://github.com/steve0511/resty-redis-cluster
1 、源码目录通过make生成.so文件，通过lua_package_cpath加载.so文件
2 、定时获取集群信息，动态获取集群地址
通过在进程启动的时候定时获取redis连接地址,在使用时获取内存内的redis集群地址
curl -X PUT -d '118.24.109.254:6392' http://127.0.0.1:8700/v1/kv/redis-cluster-2/
```
使用Open Resty 组件管理工具
很多开发语言/环境都会提供配套的包管理工具，例如 npm/Node.js、cpan/Perl、gem/Ruby 等，它们可以方便地安装功能组件，辅助用户的开发工作，节约
用户的时间和经理。OpenResty 也有功能类似的工具，名叫 opm。
OpenResty 维护一个官方组件库（opm.openresty.org）,opm 就是库的客户端，可以把组件库里的组件下载到本地，并管理本地的组件列表。
opm 的用法很简单，常用的命令有：
search：以关键字搜索关键的组件。
get：安装功能组件（注意不是 install）。
info：显示已安装组件的详细信息。
list：列出所有本地已经安装的组件。
upgrad：更新某个已安装组件。
update：更新所有已安装组件。
remove：移除某个已安装组件。
opm 默认的操作目录是 “/usr/local/openresty/site”，但是也可以在命令行参数 “--install-dir=PATH” 安装到其他目录，或者用参数 “–cwd” 安装到当前目录的
"./resty_module/" 目录里。
注意：要使用opm我们的环境当中还缺少一个依赖 yum install perl-Digest-MD5 -y

# 声明一个共享内存区域

```
syntax：lua_shared_dict <name> <size>
```



```
default: nocontext: httpphase: depends on usage
```
声明一个共享内存区域 name，以充当基于 Lua 字典 ngx.shared. 的共享存储。 共享内存总是被当前 Nginx 服务器实例中所有的 Nginx worker 进程所共享。

lua定时获取集群地址

# 核心的api地址

https://github.com/openresty/lua-nginx-module












