resource "aws_security_group" "eks_worker_sg" {
  name_prefix = "${var.cluster_name}-worker-additional-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }
}