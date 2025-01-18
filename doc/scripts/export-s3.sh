#!/bin/bash

TENANT_ID=5 #echo please enter the tenantid && read TENANT_ID

# Set variables
MINIO_URL="http://s3-minio.core:9000"         # Replace with your MinIO service URL
NAMESPACE=core
POD_NAME=mc-client
ACCESS_KEY="minioadmin"   # Replace with your MinIO access key
SECRET_KEY="minioadmin"   # Replace with your MinIO secret key
BUCKET_NAME="core-5"
DEST_DIR="/tmp"

# Run the MinIO client (mc) pod
kubectl delete pod $POD_NAME -n $NAMESPACE

kubectl run -i --rm --tty --namespace $NAMESPACE $POD_NAME --image=busybox --restart=Never -- \
  /bin/sh -c "
    wget -qO- https://dl.min.io/client/mc/release/linux-arm64/mc > /usr/bin/mc && chmod +x /usr/bin/mc

    mc alias set myminio $MINIO_URL $ACCESS_KEY $SECRET_KEY

    mc cp --recursive myminio/$BUCKET_NAME /tmp/

  "

  kubectl cp core/s3-minio:/tmp ~/Downloads/s3

