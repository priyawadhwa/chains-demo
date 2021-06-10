#!/usr/bin/env bash

kubectl delete taskrun kaniko-run || true
rm *.pem payload signature kaniko-run.yaml
rm *.pub
rm *.key
