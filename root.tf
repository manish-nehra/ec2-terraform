provider "aws" {
  region   = var.aws_region
  profile  = "default"
}

resource "aws_resourcegroups_group" "disover-dollar" {
  name = "discover-dollar"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "discover",
      "Values": ["dollar"]
    }
  ]
}
JSON
  }
}


module "dollar" {
    source = "./dollar"
    vpc_cidr        = var.vpc_cidr
    subnet          = module.dollar.subnet_output
    subnet_cidr     = var.subnet_cidr
    Ec2_count       = var.Ec2_count
    sg_grp          = module.dollar.sg_output
    key_name        = var.key_name
    instance_type   = var.instance_type
    ec2_ami         = var.ec2_ami
    
}