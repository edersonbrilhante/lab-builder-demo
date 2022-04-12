resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "-_=+()[]{}"
}

locals {
  amis = {
    "windows-2016" = {
      os_name        = "windows"
      os_version     = "2016"
      ami_regex      = "Windows_Server-2016-English-Full-Base-*"
      winrm_user     = "Administrator"
      winrm_password = random_string.random.result
      owner          = "801119661308" # Amazon
      instance_type  = "t2.medium"
    }
    "windows-2019" = {
      os_name        = "windows"
      os_version     = "2019"
      ami_regex      = "Windows_Server-2019-English-Full-Base-*"
      winrm_user     = "Administrator"
      winrm_password = random_string.random.result
      owner          = "801119661308" # Amazon
      instance_type  = "t2.medium"
    }
    "ubuntu-16" = {
      os_name       = "ubuntu"
      os_version    = "16"
      ami_regex     = "ubuntu/images/*ubuntu*16.04-amd64-server-*"
      ssh_username  = "ubuntu"
      owner         = "099720109477" # CANONICAL
      instance_type = "t2.medium"
    }
    "ubuntu-18" = {
      os_name       = "ubuntu"
      os_version    = "18"
      ami_regex     = "ubuntu/images/*ubuntu*18.04-amd64-server-*"
      ssh_username  = "ubuntu"
      owner         = "099720109477" # CANONICAL
      instance_type = "t2.medium"
    }
    "ubuntu-20" = {
      os_name       = "ubuntu"
      os_version    = "20"
      ami_regex     = "ubuntu/images/*ubuntu*20.04-amd64-server-*"
      ssh_username  = "ubuntu"
      owner         = "099720109477" # CANONICAL
      instance_type = "t2.medium"
    }
    "rhel-7" = {
      os_name       = "rhel"
      os_version    = "7"
      ami_regex     = "RHEL-7*_HVM-*-x86_64*"
      ssh_username  = "ec2-user"
      owner         = "309956199498" # Amazon Web Services
      instance_type = "t2.medium"
    }
    "rhel-8" = {
      os_name       = "rhel"
      os_version    = "8"
      ami_regex     = "RHEL-8*_HVM-*-x86_64*"
      ssh_username  = "ec2-user"
      owner         = "309956199498" # Amazon Web Services
      instance_type = "t2.medium"
    }
    "centos-7" = {
      os_name       = "centos"
      os_version    = "7"
      ami_regex     = "CentOS 7.9.2009 x86_64"
      ssh_username  = "centos"
      owner         = "125523088429" # https://wiki.centos.org/Cloud/AWS
      instance_type = "t2.medium"
    }
    "centos-stream-8" = {
      os_name       = "centos-stream"
      os_version    = "8"
      ami_regex     = "CentOS Stream 8 x86_64*"
      ssh_username  = "centos"
      owner         = "125523088429" # https://wiki.centos.org/Cloud/AWS
      instance_type = "t2.medium"
    }
    "debian-9" = {
      os_name       = "debian"
      os_version    = "9"
      ami_regex     = "debian-stretch-hvm-x86_64*"
      ssh_username  = "admin"
      owner         = "379101102735" # https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch
      instance_type = "t2.medium"
    }
    "debian-10" = {
      os_name       = "debian"
      os_version    = "10"
      ami_regex     = "debian-10-amd64*"
      ssh_username  = "admin"
      owner         = "136693071363" # https://wiki.debian.org/Cloud/AmazonEC2Image/Buster
      instance_type = "t2.medium"
    }
    "debian-11" = {
      os_name       = "debian"
      os_version    = "11"
      ami_regex     = "debian-11-amd64-*"
      ssh_username  = "admin"
      owner         = "136693071363" # https://wiki.debian.org/Cloud/AmazonEC2Image/Bullseye
      instance_type = "t2.medium"
    }
    "suse-15" = {
      os_name       = "suse"
      os_version    = "15"
      ami_regex     = "suse-sles-15-sp2-v20200721-hvm-ssd-x86_64"
      ssh_username  = "ec2-user"
      owner         = "013907871322" # https://aws.amazon.com/marketplace/pp/prodview-o5wqlcnuzvyv2
      instance_type = "t2.medium"
    }
  }
}
