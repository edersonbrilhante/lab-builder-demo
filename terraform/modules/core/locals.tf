resource "random_id" "project_hash" {
  keepers = {
    name = var.project_name
  }
  byte_length = 8
}

resource "random_id" "subnet_index" {
  keepers = {
    name = var.project_name
  }
  byte_length = 2
}

locals {
  base_name               = "${var.project_name}-${random_id.project_hash.hex}"
  subnet_ids_list         = tolist(data.aws_subnets.current.ids)
  subnet_ids_random_index = random_id.subnet_index.dec % length(data.aws_subnets.current.ids)
  instance_subnet_id      = local.subnet_ids_list[local.subnet_ids_random_index]
}
