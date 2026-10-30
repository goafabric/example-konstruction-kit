#!/bin/bash

LOCAL_DOWNLOAD_FOLDER=~/Downloads
S3_URL=http://s3-minio.core:9000
TENANT_ID=5 #echo please enter the tenantid && read TENANT_ID

PASSWORD=minioadmin

kubectl delete pod s3-export -n core &> /dev/null

kubectl run -i --rm --tty --namespace core s3-export --image=busybox --restart=Never -- /bin/sh -c "
  wget -qO- https://dl.min.io/client/mc/release/linux-arm64/mc > /usr/bin/mc && chmod +x /usr/bin/mc
  mc alias set myminio $S3_URL minioadmin $PASSWORD &&

  mc cp --recursive myminio/core-$TENANT_ID /tmp/ ;

  
  echo 'export done .. please manually execute the following and terminate this pod with ctrl-c' &&
  echo 'kubectl cp core/s3-export:/tmp $LOCAL_DOWNLOAD_FOLDER/s3' &&
  sleep 6000000 #tail -f /dev/null
"
kubectl delete pod s3-export -n core &> /dev/null
