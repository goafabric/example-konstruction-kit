# kafka-ui

kubectl run kafka-ui \
-n data \
--image=ghcr.io/kafbat/kafka-ui:main \
--restart=Never \
--port=8080 \
--env="DYNAMIC_CONFIG_ENABLED=true" \
--env="KAFKA_CLUSTERS_0_NAME=kafka" \
--env="KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka.data:9092"

kubectl -n kafka port-forward pod/kafka-ui 8080:8080

# strimzi
https://strimzi.io/quickstarts/

kubectl create namespace kafka
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-single-node.yaml -n kafka

kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.50.0-kafka-4.1.1 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic

kubectl run kafka-ui \
-n kafka \
--image=ghcr.io/kafbat/kafka-ui:main \
--restart=Never \
--port=8080 \
--env="DYNAMIC_CONFIG_ENABLED=true" \
--env="KAFKA_CLUSTERS_0_NAME=kafka" \
--env="KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=my-cluster-kafka-bootstrap:9092"