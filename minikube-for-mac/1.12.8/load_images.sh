#!/bin/bash
# 加载并加到cache中
file="images.properties"

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    echo "${key}=${value}"
    docker pull ${value}
    docker tag ${value} ${key}
    docker rmi ${value}
    minikube cache add ${key}
  done < "$file"

else
  echo "$file not found."
fi

