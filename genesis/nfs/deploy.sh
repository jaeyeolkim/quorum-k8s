#!/bin/bash

kubectl apply -f rbac.yml
kubectl apply -f deployment.yml
kubectl apply -f storage.yml