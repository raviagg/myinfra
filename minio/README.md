# minio
MinIO service which provides S3 APIs

# Steps to deploy
- Clone this repo
- cd minio
- kubectl apply -f application.yaml

After above steps the argocd should show the minio application. Post that when we do any changes to this repo, those changes will be automatically deployed.

# To Test
## Install a client called mc which can interact with MinIO
```brew install minio/stable/mc```
```mc --version```

## MinIO api vs console
MinIO exposes an API on port 9000 and a UI-console on port 9001 (not working)
Port forward so that host can access MinIO API
```kubectl port-forward svc/minio -n minio 9000:9000```

## Accessing MinIO via MC
### To set an alias for a MinIO connection i.e. URL + Creds
```mc alias set localminio http://localhost:9000 minio minio123```
```mc alias set <name> <endpoint> <accessKey> <secretKey>```

### To list the aliases
```mc alias list```

### To list the buckets inside a given alias
```mc ls localminio```

### To create a bucket inside a given alias
```mc mb localminio/transactions```

### To copy a file within a given bucket
```mc cp test.txt localminio/transactions```

### To copy multiple files at once inside a given bucket
```mc cp --recursive ./some-folder localminio/transactions```

### To Download the file from MinIO
```mc cp localminio/transactions/test.txt .```

### To inspect file metadata
```mc stat localminio/transactions/test.txt```

