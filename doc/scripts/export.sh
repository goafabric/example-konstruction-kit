#!/bin/bash

TENANT_ID=5
PASSWORD=mc3PtnaJBuDH1cT1IPv9vBggiWaDKWTH

#echo please enter the tenantid && read -t 10 TENANT_ID

kubectl run postgres-export -n core --rm -it --restart=Never --image=postgres:16.4 -- sh -c "

export PGPASSWORD=$PASSWORD &&

echo 'dumping core ...' &&
pg_dump -h core-postgres-postgresql-ha-pgpool.core --data-only -U core -d core --schema core_$TENANT_ID &&

echo 'dumping catalog ...' &&
pg_dump -h core-postgres-postgresql-ha-pgpool.core --data-only -U core -d core --schema catalog &&

echo 'dump done'

" | tee >(gzip > ~/Downloads/pgdump_$TENANT_ID.sql.gz)

