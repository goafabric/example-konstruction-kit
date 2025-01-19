#!/bin/bash
TENANT_ID=5 #echo please enter the tenantid && read TENANT_ID

PASSWORD=minioadmin

kubectl delete pod s3-export -n core &> /dev/null

kubectl run s3-export -n core --rm -it --restart=Never --image=minio/mc --command -- /bin/sh -c "
  mc alias set myminio http://s3-minio.core:9000 minioadmin $PASSWORD &&
  mc cp --recursive myminio/core-$TENANT_ID /tmp/ &&
  echo 'Commands executed successfully!'
"
