# 使用minikube在mac上部署kubernetes环境

## 安装minikube命令

### brew 安装升级

安装：
```
brew install minikube
```

升级：
```
brew update
brew upgrade minikube
```


### 下载安装包
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 \
  && sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

## 选择虚拟机
支持三种HyperKit、VirtualBox、Parallels Desktop、VMware Fusion

### VirtualBox
[下载VirtualBox](https://www.virtualbox.org/wiki/Downloads),5.2以上版本。

设置默认driver：
```
minikube config set driver virtualbox
```

或者启动时指定：
```
minikube start --driver=virtualbox
```

### minikube start 命令
`minikube start `命令将进行启动kubernetes。
有以下一些参数：

#### -v 日志等级
* --v=0 INFO level logs
* --v=1 WARNING level logs
* --v=2 ERROR level logs
* --v=3 libmachine logging
* --v=7 libmachine --debug level logging

#### --kubernetes-version 指定版本
```
minikube start --v=2 \
--kubernetes-version v1.12.8 \
```

### --image-repository 镜像代理
使用中国地区的镜像地址
```
--image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers
```

### --cpus --memory 资源设定
```
--cpus 4
--memory=8192
```

### minikube dashboard
开启kubernetes的dashboard


### minikube addons enable ingress
安装ingress
然后可以给部署的service配置ingress.
查看是否安装完毕：
```
kubectl get pods -n kube-system -o wide
```

### minikube cache
当在kubernetes部署docker时，时长会有一些镜像下载不下来，可以现在个人电脑上下载好（你懂得）,然后通过cache将images缓存到kubernetes的虚拟机上。
```
minikube cache add docker.elastic.co/elasticsearch/elasticsearch-oss:7.6.0
```
可以执行项目中`load_images.sh`脚本，他将kubernetes的基础包进行下载和添加到cache中。

查看缓存列表：
```
minikube cache list
```