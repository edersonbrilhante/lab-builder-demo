#!/usr/bin/env bash

CMD=$(terraform -chdir=./terraform/wire output -json)
REGION=$(echo $CMD | jq -r '.region.value')
STATUS=$(echo $CMD | jq -r '.environments.value[].ids[]' | aws ec2 describe-instance-status --instance-ids $(xargs) --include-all-instances --region=$REGION | jq '.InstanceStatuses[] | {id: .InstanceId, status: .InstanceState.Name}' | jq -s '.')
IDS=$(echo $CMD | jq -r '.environments.value[].ids | to_entries[] | {id: .value, name: .key}' | jq -s '.')
jq --argjson arr1 "$IDS" --argjson arr2 "$STATUS" -n '$arr2 + $arr1 | group_by(.id) | map(add) | .[]'