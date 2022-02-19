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
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
kubectl get pods -n kubernetes-dashboard
```
启动代理和访问：http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.

```
kubectl proxy
```

添加权限
kubectl apply -f admin-user-admin.rbac.yaml
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
# Create ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
```


查看token
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```

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


### 添加tiller到 [k8s] service account

在kube-system命名空间中创建tiller账户
kubectl create serviceaccount --namespace kube-system tiller

创建角色并授予cluster-admin权限
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

安装tiller
```
helm init --service-account tiller
helm init --upgrade --service-account tiller --tiller-image=registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.16.3 --skip-refresh --history-max 255
```


如果只显示客户端版本，表示 helm 无法连接到服务端。通过 kubectl 查看 tiller pod 是否在运行：
```
kubectl -n kube-system get pods -l app=helm
```