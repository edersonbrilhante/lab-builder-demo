# Lab Builder Demo

This project is demo used to present the talk "Building labs using component-based architecture with terraform and ansible".

This demo can be used as inspiration to create a similar project and enable developers to automatically spin up environments with all the required OS distributions with all needed configuration.

- [Software Requirements](#software-requirements)
- [Running your LAB](#running-your-lab)
- [Managing your LAB](#managing-your-lab)

## Software Requirements

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/)

---

## Running your LAB

### Write a config file to describe your desired environment

You can use one of [configuration sample](examples) as inspiration for to create your own configuration file. The file must be named as `input.tfvars` and placed in this project's root path.

  You can copy one of the samples in order to deploy a demo environment:  
  
  ```bash
  cp examples/<name>.tfvars input.tfvars
  ```

### Proper environment with all needed tools to manage your lab

Run docker compose to setup a docker instance with all needed tools:

  ```bash
  docker-compose -f docker/docker-compose.yml build
  docker-compose -f docker/docker-compose.yml up -d
  ```

### Managing your LAB

#### Requirements

- All steps must be executed in the container `lab_builder`. Use a bash session for that:
  - Start a bash session:

      ```bash
      docker exec -it lab_builder bash
      ```

- AWS short-term credentials:
  - Check the [official documentation](https://aws.amazon.com/blogs/security/aws-single-sign-on-now-enables-command-line-interface-access-for-aws-accounts-using-corporate-credentials/)  

#### Lab Management commands

- Deploy the lab:

    ```bash
    make lab-deploy
    ```

- Destroy the lab:

    ```bash
    make lab-destroy
    ```

- Retrieve information about the lab(IPs, IDs, configs, etc):

    ```bash
    make lab-info
    ```


#### Stop and Start the lab instances to avoid waste

The lab builder has a feature to stop and start ec2 instances to avoid wastage in the cloud.

> :warning: **This will make the terraform state to be of sync with AWS**: Run `make lab-deploy` after starting the lab instances, in order to update the lab configuration.

Steps:

- Stop all lab instances:

  ```bash
  make instances-stop 
  ```

- Start all lab instances:

  ```bash
  make instances-start
  ```

- Retrieve instances status for all lab instances:

  ```bash
  make instances-status
  ```

- Deploy the lab to update the changes (Run after all instances change the status to `running`):

  ```bash
  make lab-deploy
  ```

#### Accessing lab instances

Depending on the type, the lab builder allows managing the instances manually through SSH, and RDP. Use `make instances-credentials` to retrieve the credentials for each instance.

- Retrieve credentials for all lab instances.

  ```bash
  make instances-credentials
  ```
