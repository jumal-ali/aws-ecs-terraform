resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = var.ssh-public-key
}

resource "aws_instance" "bastion" {
  count = var.create-bastion ? 1 : 0

  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.bastion.id
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  tags = {
    Name = "Bastion"
  }
}

resource "aws_security_group" "bastion-sg" {
  name_prefix = "${lower(var.env)}-${local.project-name-hyphated}-bastion-sg"
  description = "${var.env} ${var.project-name} Bastion SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
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

  tags = local.common_tags
}