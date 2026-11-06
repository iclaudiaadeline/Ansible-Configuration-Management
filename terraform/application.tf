data "aws_subnet" "application_public" {
  id = sort(data.aws_subnets.public.ids)[0]
}

resource "aws_security_group" "application" {
  name        = "campus-notifier-application"
  description = "SSH administration and NairobiPulse health traffic."
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from the application administrator"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.db_admin_cidr]
  }

  ingress {
    description = "NairobiPulse HTTP health endpoint"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.db_admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "campus-notifier-application"
    Role      = "application"
    ManagedBy = "Terraform"
  }
}

resource "aws_instance" "application" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = var.application_instance_type
  subnet_id                   = data.aws_subnet.application_public.id
  vpc_security_group_ids      = [aws_security_group.application.id]
  key_name                    = aws_key_pair.database_admin.key_name
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted             = true
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name      = "campus-notifier-application"
    Role      = "application"
    ManagedBy = "Terraform"
  }
}
