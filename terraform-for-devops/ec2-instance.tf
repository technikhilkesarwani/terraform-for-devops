# 1. Key pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# 2. Default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# 3. Security Group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "This will add a TF generated Security Group"
  vpc_id      = aws_default_vpc.default.id

  # 4. Inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH-Open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP-Open"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask-app"
  }

  # 5. Outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

  # 6. Tag
  tags = {
    Name = "automate-sg"
  }
}

# 7. EC2 instance
resource "aws_instance" "my_instance" {
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  #instance_type           = "t2.micro"
  instance_type=var.ec2_instance_type

  # ami                     = "ami-0c02fb55956c7d316" # replace with correct AMI for your region
  ami=var.ec2_ami_id


  root_block_device {
    #volume_size = 15
    volume_size=var.ec2_root_storage_size

    volume_type = "gp3"
  }

  tags = {
    Name = "TWS-Junoon-Automate"
  }
}