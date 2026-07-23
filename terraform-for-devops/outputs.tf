output "ec2_public_ip" {
    value=aws_instance.my_instance_ec2_public_ip
}

output "ec2_public_dns" {
    value=aws_instance.my_instance.ec2_public_dns
}