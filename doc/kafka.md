# strimzi
https://strimzi.io/quickstarts/

kubectl create namespace kafka
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-single-node.yaml -n kafka
          
# kafka-ui
kubectl run kafka-ui \
-n kafka \
--image=ghcr.io/kafbat/kafka-ui:main \
--restart=Never \
--port=8080 \
--env="DYNAMIC_CONFIG_ENABLED=true" \
--env="KAFKA_CLUSTERS_0_NAME=kafka" \
--env="KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka-cluster-kafka-bootstrap:9092"

kubectl -n kafka port-forward pod/kafka-ui 8080:8080