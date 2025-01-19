#!/bin/bash
TENANT_ID=5 #echo please enter the tenantid && read TENANT_ID

PASSWORD=minioadmin

kubectl delete pod s3-export -n core &> /dev/null

kubectl run s3-export -n core -it --restart=Never --image=minio/mc --command -- /bin/sh -c "
  mc alias set myminio http://s3-minio.core:9000 minioadmin $PASSWORD &&
  mc cp --recursive myminio/core-$TENANT_ID /tmp/ &&
  echo 'export done .. please manually execute the following and terminate this pod with ctrl-c' &&
  echo 'kubectl cp core/s3-export:/tmp ~/Downloads/s3' &&
  sleep 60000 #tail -f /dev/null
"