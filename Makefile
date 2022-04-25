.SILENT:
.DEFAULT_GOAL := help

COLOR_RESET=\033[0;39;49m
COLOR_BOLD=\033[1m
COLOR_BLUE=\033[38;5;20m
COLOR_GREE=\033[38;5;35m
PROJECT := Lab Builder
AUTOMATION_TA_CONFIG_PATH := /opt/automation/tools/input.tfvars

help:

	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

	printf "\n${COLOR_GREE}${PROJECT}\n-------\n${COLOR_RESET}"
	printf "${COLOR_BOLD}  Usage:${COLOR_RESET}"
	printf "\n"
	printf "${COLOR_BLUE}    make <target>${COLOR_RESET}"
	printf "\n"
	printf "\n"
	printf "${COLOR_BOLD}  Targets(Lab management):${COLOR_RESET}"
	printf "\n"
	awk '/^[a-zA-Z\-\_0-9\.%]+:/ { \
		helpMessage = match(lastLine, /^## G1: (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 7, RLENGTH); \
			printf "${COLOR_BLUE}    make %-30s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort
	printf "\n"
	printf "\n"
	printf "${COLOR_BOLD}  Targets(Instances management):${COLOR_RESET}"
	printf "\n"
	awk '/^[a-zA-Z\-\_0-9\.%]+:/ { \
		helpMessage = match(lastLine, /^## G2: (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 7, RLENGTH); \
			printf "${COLOR_BLUE}    make %-30s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort
	printf "\n"

terraform-init:
	terraform -chdir=./terraform/wire init

## G1: Deploy the lab (Apply changes in input.tfvars).
lab-deploy: terraform-init
	terraform -chdir=./terraform/wire apply -var-file=${AUTOMATION_TA_CONFIG_PATH} -auto-approve

## G1: Destroy the lab.
lab-destroy: terraform-init
	terraform -chdir=./terraform/wire destroy -var-file=${AUTOMATION_TA_CONFIG_PATH} -auto-approve

## G1: Retrieve information about the lab (IPs, IDs, commands, etc).
lab-info:
	./scripts/lab_info.sh

## G2: Start all lab instances.
instances-start:
	./scripts/instances_start.sh

## G2: Stop all lab instances.
instances-stop:
	./scripts/instances_stop.sh

## G2: Retrieve instances status for all lab instances.
instances-status:
	./scripts/instances_status.sh

## G2: Retrieve credentials for all lab instances.
instances-credentials:
	./scripts/instances_credentials.sh
