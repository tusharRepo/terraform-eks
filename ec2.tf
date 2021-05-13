data "aws_ami" "amazonLinux" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners        = ["amazon"]
  name_regex    = "^amzn2-ami-hvm-2.0.*"
}

resource "aws_instance" "bastion" {
  ami                           = data.aws_ami.amazonLinux.id
  instance_type                 = "t3.micro"
  associate_public_ip_address   = true
  key_name                      = var.key_pair
  vpc_security_group_ids        = [aws_security_group.eks_bastion_sg.id]
  subnet_id                     = module.vpc.public_subnets[0]
  iam_instance_profile          = aws_iam_instance_profile.bastion_profile.id

  root_block_device {
      encrypted     = true
      volume_size   = 20
      volume_type   = "gp2"
  }       

  tags = {
    Name = "${var.cluster_name}-Bastion"
  }
}

resource "aws_security_group" "eks_bastion_sg" {
  name_prefix = "${var.cluster_name}-bastion-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "bastion_to_cluster" {
  type                      = "ingress"
  from_port                 = 443
  to_port                   = 443
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.eks_bastion_sg.id
  security_group_id         = module.eks.cluster_security_group_id
}

resource "aws_iam_role" "bastion_role" {
  name = "${var.cluster_name}-Bastion-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "descibe-eks"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["eks:DescribeCluster"]
          Effect   = "Allow"
          Resource = "arn:aws:eks:*:*:cluster/${var.cluster_name}*"
        },
      ]
    })
  }

}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.cluster_name}-Bastion-Profile"
  role = aws_iam_role.bastion_role.name
}
