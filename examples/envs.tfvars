config = {
  "windows" = {
    "type" = "windows_standalone"
    "nodes" = {
      "windows01" = {
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
  "linux" = {
    "type" = "linux_standalone"
    "nodes" = {
      "linux01" = {
        "type" = "linux"
        "enabled_roles" = {
          "linux_funcionality01" = true
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
