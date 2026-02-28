# Data source for latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Jenkins Server
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jenkins_instance_type
  key_name              = var.key_name
  subnet_id             = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.jenkins_sg_id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

#   user_data = templatefile("${path.module}/user-data/jenkins.sh", {})

  tags = {
    Name = "${var.project_name}-jenkins"
    Role = "jenkins"
  }
}

# Kubernetes Master
resource "aws_instance" "k8s_master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.k8s_master_instance_type
  key_name              = var.key_name
  subnet_id             = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.k8s_master_sg_id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

#   user_data = templatefile("${path.module}/user-data/k8s-master.sh", {})

  tags = {
    Name = "${var.project_name}-k8s-master"
    Role = "k8s-master"
  }
}

# Kubernetes Workers
resource "aws_instance" "k8s_worker" {
  count                  = var.k8s_worker_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.k8s_worker_instance_type
  key_name              = var.key_name
  subnet_id             = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  vpc_security_group_ids = [var.k8s_worker_sg_id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

#   user_data = templatefile("${path.module}/user-data/k8s-worker.sh", {})

  tags = {
    Name = "${var.project_name}-k8s-worker-${count.index + 1}"
    Role = "k8s-worker"
  }
}

# Elastic IPs
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-jenkins-eip"
  }
}

resource "aws_eip" "k8s_master" {
  instance = aws_instance.k8s_master.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-k8s-master-eip"
  }
}