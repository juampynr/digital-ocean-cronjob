# DigitalOcean CronJob

This repository defines the Dockerfile used to create a Docker image with [doctl](https://github.com/digitalocean/doctl) and [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/).

It is meant to be used in Kubernetes [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) objects in order execute commands in a container.

## Usage example

Create a secret in the Kubernetes cluster to host your Digital Ocean personal access token with permission to read:

```
kubectl create secret generic api --from-file=key=./do-apikey.txt
``

Create the following Kubernetes object:

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: drupal-cron
spec:
  schedule: "*/5 * * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: drupal-cron
              image: juampynr/digital-ocean-cronjob:latest
              env:
                - name: DIGITALOCEAN_ACCESS_TOKEN
                  valueFrom:
                    secretKeyRef:
                      name: api
                      key: key
              command: ["/bin/sh","-c"]
              args:
                - doctl kubernetes cluster kubeconfig save <cluster-id|cluster-name>
                - POD_NAME=$(kubectl get pods -l tier=frontend -o=jsonpath='{.items[0].metadata.name}')
                - kubectl exec POD_NAME -c drupal -- vendor/bin/drush core:cron
          restartPolicy: OnFailure
```
