#!/usr/bin/env bash

kubectl delete taskrun kaniko-run || true
rm *.pem
rm *.pub
