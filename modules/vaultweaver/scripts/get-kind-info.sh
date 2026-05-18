#!/bin/bash
# get_kind_ip.sh

# Recive cluster name as parameter from terraform
CLUSTER_NAME=$1

# Search internal ip from the container
KIND_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${CLUSTER_NAME}-control-plane")

# Returns a JSON with the formated Host

jq -n --arg ip "$KIND_IP" '{"host": ("https://"+$ip+":6443")}'
