#!/bin/bash
PASSWORD=mc3PtnaJBuDH1cT1IPv9vBggiWaDKWTH

LOCAL_DOWNLOAD_FOLDER=~/Downloads
HOST_NAME=core-postgres-postgresql-ha-pgpool.core
TENANT_ID=5 #echo please enter the tenantid && read TENANT_ID

echo exporting data to $LOCAL_DOWNLOAD_FOLDER for Tenant $TENANT_ID @ $HOST_NAME

#echo please enter the tenantid && read TENANT_ID

kubectl delete pod postgres-export -n core > /dev/null
kubectl run postgres-export -n core --rm -it --restart=Never --image=postgres:16.4 -- sh -c "

export PGPASSWORD=$PASSWORD &&

sleep 1 &&

echo 'dumping core ...' &&
pg_dump -h $HOST_NAME --data-only -U core -d core --schema core_$TENANT_ID &&

echo 'dumping catalog ...' &&
pg_dump -h $HOST_NAME --data-only -U core -d core --schema catalog &&

echo 'dump done'

" | tee >(gzip > $LOCAL_DOWNLOAD_FOLDER/pgdump_$TENANT_ID.sql.gz)

