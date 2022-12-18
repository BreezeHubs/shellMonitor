# 简单监控脚本

<br>

## 1 使用

<br>

### 1.1 启动服务
```shell
nohup ./server.sh > /dev/null 2>&1 & 
```

<br>

### 1.2 查看cpu信息
```shell
./client.sh get cpu
```
输出：
> cpu 最新数据为：  
		used_rate: 10.00%  

<br>

### 1.3 查看内存信息
```shell
./client.sh get memory
```
输出：
> memory 最新数据为：
	    total: 32509M
	    used: 10470M
	    free: 21757M
	    share: 17M
	    buffcache: 223M
	    available: 21925M
	    used_rate: 32.21%

<br>

### 1.4 查看磁盘信息
```shell
./client.sh get disk
```
输出：
> disk 最新数据为：
	    -
	        file_system: rootfs
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /
	    -
	        file_system: none
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /dev
	    -
	        file_system: none
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /run
	    -
	        file_system: none
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /run/lock
	    -
	        file_system: none
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /run/shm
	    -
	        file_system: none
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /run/user
	    -
	        file_system: tmpfs
	        blocks: 204801M
	        used: 87372M
	        available: 117430M
	        used_rate: 43%
	        mounted: /sys/fs/cgroup

<br>

### 1.5 查看指标
```shell
./client.sh target
```
输出：

> 使用率统计:  
> cpu: 10.00% [正常]
> \------------------------------ 
> 内存: 33.46% [正常]
> \------------------------------ 
> 磁盘:    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rootfs (/)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 43% [正常]    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;none (/dev)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 43% [正常]    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;none (/run)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 43% [正常]    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;none (/run/lock)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 43% [正常]    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;none  (/run/shm)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 43% [正常]    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;none (/run/user)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 43% [正常]    
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tmpfs (/sys/fs/cgroup) : 43% [正常]

<br>

## 2 架构

<br>

### 1.1 目录
![在这里插入图片描述](https://img-blog.csdnimg.cn/40db5f879e96439aaa0a5792d9e3d602.png)
> \- data **#数据目录**  
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- .data **#数据文件**  
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
> \- module **#模块文件**
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- collectFunc **#采集模块函数**
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- cpu.sh **#cpu函数**
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- df.sh **#磁盘函数**
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- free.sh **#内存函数**
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- collect.sh **#采集模块**：获取cpu、磁盘、内存信息
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- init.sh **#初始化方法**：加载模块函数
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- parse.sh **#解析数据模块**：解析数据文件
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- store.sh **#存储模块**：存储采集的信息到数据文件
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
> \- client.sh **#client服务**：获取信息、获取指标
> \- server.sh **#server服务**：周期性调用采集模块、调用存储模块

<br>

### 1.2 模块调用
![在这里插入图片描述](https://img-blog.csdnimg.cn/776e103a946442a08e4d9fd332b81313.png)
