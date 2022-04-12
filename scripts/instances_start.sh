#!/usr/bin/env bash

CMD=$(terraform -chdir=./terraform/wire output -json)
REGION=$(echo $CMD | jq -r '.region.value')
echo $CMD | jq -r '.environments.value[].ids[]' | aws ec2 start-instances --instance-ids $(xargs) --region=$REGION > /dev/null
./scripts/instances_status.sh
