#!/usr/bin/env bash

get_credentials(){

    CMD=$(terraform -chdir=./terraform/wire output -json)
    
    VMS=$(echo $CMD | jq '.environments.value[] | {ids: .ids | to_entries[], cmds: .provisioning_commands | to_entries[]}  | select(.ids.key == .cmds.key )  | { id: .ids, cmd:.cmds.value } | {values: (.cmd | @base64d | capture("(?<ip>[0-9.]+)(((.)+--extra-vars=.))(?<extra>{(.)+})") | {ip: .ip, extra: (.extra | fromjson )} | {ip: .ip, type: .extra.os.type, user: .extra.ansible_user, ssh_key: .extra.ansible_ssh_private_key_file, password: .extra.ansible_password }), id: .id} | {ip: .values.ip, id: .id.value, name: .id.key, type: .values.type, password: .values.password, user: .values.user, ssh_key: .values.ssh_key} | .')
    SSH=$(echo $VMS | jq '. | select(.ssh_key != null) | {name: .name, ssh: "ssh -i \(.ssh_key) \(.user)@\(.ip)"}' | jq -s '.')
    WINDOWS=$(echo $VMS | jq '. | select(.ssh_key == null) | {name: .name, ip: .ip, user: .user, password: .password }' | jq -s '.')

    if [[ "${SSH}" != "[]" ]]; then
        echo "VMs with access through SSH:"
        echo $SSH | jq
    fi

    if [[ "${WINDOWS}" != "[]" ]]; then
        echo "VMs with access through RDP:"
        echo $WINDOWS | jq
    fi
}

get_credentials