# kafka
Kafka

# Steps to deploy
- kubectl create namespace kafka
- kubectl apply -f application.yaml

# Some useful kube commands to run bash in a pod
## To run bash in any one pod of given deployment
```kubectl exec -it deployment/mykafka -n mykafka -- bash```

## To run bash in any one pod of given statefulSet
```kubectl exec -it statefulSet/mykafka -n mykafka -- bash```

## To run bash in a given pod
```kubectl exec -it mykafka-0 -n mykafka -- bash```

# Some useful kafka commands
## Create topic
```kafka-topics --bootstrap-server mykafka:9092 --create --topic transactions --partitions 1 --replication-factor 1```

## List topics
```kafka-topics --bootstrap-server mykafka:9092 --list```

## Consume from topic
```kafka-console-consumer --bootstrap-server mykafka:9092 --topic transactions --from-beginning```

## Produce to topic
```kafka-console-producer --bootstrap-server mykafka:9092 --topic transactions```
