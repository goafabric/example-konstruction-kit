kubectl run pg-client -n core --rm -it --restart=Never --image=postgres:16.4 -- bash

psql -h core-postgres-postgresql-ha-pgpool.core -p 5432 -U core -d core

export PGPASSWORD=mc3PtnaJBuDH1cT1IPv9vBggiWaDKWTH

pg_dump -h core-postgres-postgresql-ha-pgpool.core --data-only -U core -d core --schema core_5 -f /tmp/core.sql
pg_dump -h core-postgres-postgresql-ha-pgpool.core --data-only -U core -d core --schema catalog -f /tmp/catalog.sql

kubectl cp core/pg-client:/tmp/core.sql  ~/Downloads/core.sql
kubectl cp core/pg-client:/tmp/catalog.sql  ~/Downloads/catalog.sql