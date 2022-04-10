resource "aws_vpc" "dollar_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    
    Name     = "disover-dollar-vpc"
  }
}

data "aws_availability_zones" "az" {
    state = "available"
}

resource "aws_subnet" "subnet" {
  count                     = 2
  vpc_id                    = aws_vpc.dollar_vpc.id
  cidr_block                = element(var.subnet_cidr, count.index)
  availability_zone         = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch   = true

  tags = {
    Name = "public-${count.index+1}"
  }

}

resource "aws_internet_gateway" "router" {
  vpc_id = aws_vpc.dollar_vpc.id

  tags = {
   
    Name = "dollar-igw"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.dollar_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.router.id
  }

  tags = {
    Name = "route"
  }
}

resource "aws_route_table_association" "association" {
  count             = length(var.subnet_cidr)
  subnet_id         = element(aws_subnet.subnet.*.id, count.index)
  route_table_id    = aws_route_table.route.id
}


resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  vpc_id      = aws_vpc.dollar_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 

tags = {
    Name = "ec2-sg"
  }
}

resource "aws_instance" "vm" {
    ami    = var.ec2_ami
    instance_type = var.instance_type
    key_name = var.key_name
    count = var.Ec2_count
    vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
    subnet_id = element(var.subnet, count.index)

    tags = {
        disover = "dollar"
        Name    = "vm.${count.index + 1}"
    }
  
}