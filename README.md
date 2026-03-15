# Infra
This repo is meant to setup Infra capabilities, that can be used by various services.

# Instruction to setup
## Run the script run.sh. It does following things:
* All the following resources are created on current K8 context/cluster
* Create a namespace called ```ns-myinfra```
* Apply the application.yaml K8 manifests for all capabilities to make sure relevant capabilities are deployed on K8.
* Port forward so that relevant functionality is available on host machine on specific ports.

# Capabilities
Please look at README inside specific capability git path to understand specifics

## Kafka
```Git Path = /kafka```
```Port exposed = 8100```

## Kafka UI
```Git Path = /kafkaui```
```Port exposed = 8101```

## Zookeeper
```Git Path = /zookeeper```
```Port exposed = 8100```

## MinIO (S3)
```Git Path = /minio```
```Port exposed = 8101```
