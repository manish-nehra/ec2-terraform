variable "subnet_cidr" {
  type =  list
  default = ["192.0.1.0/25",
             "192.0.2.0/25"
            ]
}

variable "vpc_cidr" {
    default = "192.0.0.0/20"
}

variable "Ec2_count" {
     default = "2"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "common-key"
}

variable "ec2_ami" {
    default = "ami-04b21e29a03aa7701"
}

variable "aws_region" {
    default = "ap-south-1"
}

