resource "aws_security_group" "eks_worker_sg" {
  name_prefix = "${var.cluster_name}-worker-additional-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    
    security_groups = [aws_security_group.eks_bastion_sg.id]
  }

}