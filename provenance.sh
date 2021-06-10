#!/usr/bin/env bash

set -e

if [ -z "$TASKRUN" ]
then
      echo "TASKRUN is empty, please set it"
      exit 1
else
      echo "Starting validation for TaskRun $TASKRUN"
fi

export TASKRUN_UID=$(kubectl get taskrun $TASKRUN -o=json | jq -r '.metadata.uid')
kubectl get taskrun $TASKRUN -o=json | jq > $TASKRUN.yaml
kubectl get taskrun $TASKRUN -o=json | jq  -r ".metadata.annotations[\"chains.tekton.dev/payload-taskrun-$TASKRUN_UID\"]" | base64 --decode > payload
kubectl get taskrun $TASKRUN -o=json | jq  -r ".metadata.annotations[\"chains.tekton.dev/signature-taskrun-$TASKRUN_UID\"]" | base64 --decode > signature

echo "cosign verify-blob -key cosign.pub -signature ./signature ./payload "
cosign verify-blob -key cosign.pub -signature ./signature ./payload 
