output "subnet_output" {
    value = aws_subnet.subnet.*.id
}

output "sg_output" {
  value = aws_security_group.ec2-sg.id
}