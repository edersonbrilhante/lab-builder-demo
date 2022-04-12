#!/usr/bin/env bash

CMD=$(terraform -chdir=./terraform/wire output -json)

IDS=$(echo $CMD | jq -r '.environments.value[].ids | to_entries[] | {id: .value, name: .key}' | jq -s '.')
PUBIPS=$(echo $CMD | jq -r '.environments.value[].public_ips | to_entries[] | {public_ip: .value, name: .key}' | jq -s '.')
PRIVIPS=$(echo $CMD | jq -r '.environments.value[].private_ips | to_entries[] | {private_ip: .value, name: .key}' | jq -s '.')
PCMD=$(echo $CMD | jq -r '.environments.value[].provisioning_commands | to_entries[] | {provisioning_command:.value, name: .key}' | jq -s '.')

jq --argjson ids "$IDS" --argjson pubips "$PUBIPS" --argjson privips "$PRIVIPS" --argjson pcmd "$PCMD" -n '$ids + $pubips + $privips + $pcmd | group_by(.name) | map(add) | .[] | {name: .name, id: .id, public_ip: .public_ip, private_ip: .private_ip, provisioning_command: .provisioning_command}' | jq -s '.'
