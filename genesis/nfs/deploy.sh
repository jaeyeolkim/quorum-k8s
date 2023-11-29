#!/bin/bash

k apply -f rbac.yml
k apply -f deployment.yml
k apply -f storage.yml