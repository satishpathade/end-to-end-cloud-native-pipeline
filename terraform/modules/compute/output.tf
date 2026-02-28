output "jenkins_public_ip" {
  description = "Jenkins public IP"
  value       = aws_eip.jenkins.public_ip
}

output "jenkins_private_ip" {
  description = "Jenkins private IP"
  value       = aws_instance.jenkins.private_ip
}

output "k8s_master_public_ip" {
  description = "K8s master public IP"
  value       = aws_eip.k8s_master.public_ip
}

output "k8s_master_private_ip" {
  description = "K8s master private IP"
  value       = aws_instance.k8s_master.private_ip
}

output "k8s_worker_public_ips" {
  description = "K8s worker public IPs"
  value       = aws_instance.k8s_worker[*].public_ip
}

output "k8s_worker_private_ips" {
  description = "K8s worker private IPs"
  value       = aws_instance.k8s_worker[*].private_ip
}