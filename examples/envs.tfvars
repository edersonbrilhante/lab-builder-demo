config = {
  "linux" = {
    "type" = "windows_standalone"
    "nodes" = {
      "dc1" = {
        "type" = "windows"
        "enabled_roles" = {
          "windows_funcionality01" = true
        }
        "os" = {
          "size"    = "t2.medium"
          "distro"  = "windows"
          "type"    = "windows"
          "version" = "2016"
        }
      }
    }
  }
  "windows" = {
    "type" = "linux_standalone"
    "nodes" = {
      "dc1" = {
        "type" = "linux"
        "enabled_roles" = {
          "windows_funcionality01" = true
        }
        "os" = {
          "size"    = "t2.medium"
          "distro"  = "ubuntu"
          "type"    = "linux"
          "version" = "20"
        }
      }
    }
  }
}

region = "us-west-1"

project_name = "mylab"
