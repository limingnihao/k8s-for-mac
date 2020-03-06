#!/bin/bash
bash minikube start --logtostderr --v=2 \
--kubernetes-version v1.12.8 \
--image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers \
--registry-mirror=https://registry.docker-cn.com \
--vm-driver="virtualbox" \
--cpus 4 \
--memory=8192