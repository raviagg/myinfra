# Create shared namespace
GROUP=myinfra
NS_INFRA=ns-${GROUP}
kubectl create ns ${NS_INFRA}
echo "**** Namespace ${NS_INFRA} created"

#########################
# Utility Functions
#########################

wait_for_argo_app() {
    local APP_NAME=$1
    local NS=$2
    local MAX_RETRIES=${3:-30} # Default to 30 retries if not provided
    local SLEEP_TIME=10

    echo "--- Waiting for Argo App: $APP_NAME in $NS ---"

    for ((i=1; i<=$MAX_RETRIES; i++)); do
        # Get statuses
        local STATUS=$(kubectl get app "$APP_NAME" -n "$NS" -o jsonpath='{.status.sync.status} {.status.health.status}' 2>/dev/null)
        local SYNC=$(echo $STATUS | cut -d' ' -f1)
        local HEALTH=$(echo $STATUS | cut -d' ' -f2)

        if [[ "$SYNC" == "Synced" && "$HEALTH" == "Healthy" ]]; then
            echo "✅ $APP_NAME is Synced and Healthy!"
            return 0
        fi

        if [[ "$HEALTH" == "Degraded" ]]; then
            echo "❌ $APP_NAME is Degraded! Check logs."
            return 1
        fi

        echo "Retry $i/$MAX_RETRIES: Sync=$SYNC, Health=$HEALTH..."
        sleep $SLEEP_TIME
    done

    echo "⌛ Timeout waiting for $APP_NAME"
    return 1
}

#########################
# Kafka Setup
#########################
cd kafka
# kubectl apply -f application.yaml
echo "**** Deployed kafka in K8, waiting for app to be synced and ready"

APP_NAME=app-${GROUP}-kafka
# wait_for_argo_app ${APP_NAME} argocd 50

cd ..
# kubectl port-forward svc/svc-${GROUP}-kafka -n ${NS_INFRA} 8100:9090 &
echo "**** Connect to kafka on localhost:8100"

#########################
# Kafka UI Setup
#########################
cd kafkaui
# kubectl apply -f application.yaml
echo "**** Deployed kafkaui in K8, waiting for app to be synced and ready"

APP_NAME=app-${GROUP}-kafkaui
# wait_for_argo_app ${APP_NAME} argocd 50

cd ..
# kubectl port-forward svc/svc-${GROUP}-kafkaui -n ${NS_INFRA} 8101:3000 &
echo "**** Connect to kafkaui on localhost:8101"

#########################
# Zookeeper Setup
#########################
cd zookeeper
kubectl apply -f application.yaml
echo "**** Deployed zookeeper in K8, waiting for app to be synced and ready"

APP_NAME=app-${GROUP}-zookeeper
wait_for_argo_app ${APP_NAME} argocd 50

cd ..
kubectl port-forward svc/svc-${GROUP}-zookeeper -n ${NS_INFRA} 8100:9090 &
echo "**** Connect to zookeeper on localhost:8100"

#########################
# MinIO (S3) Setup
#########################
cd minio
kubectl apply -f application.yaml
echo "**** Deployed minio in K8, waiting for app to be synced and ready"

APP_NAME=app-${GROUP}-minio
wait_for_argo_app ${APP_NAME} argocd 50

cd ..
kubectl port-forward svc/svc-${GROUP}-minio -n ${NS_INFRA} 8101:3000 &
echo "**** Connect to minio on localhost:8101"
