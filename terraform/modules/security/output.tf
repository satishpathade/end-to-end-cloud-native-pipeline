output "jenkins_sg_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}

output "k8s_master_sg_id" {
  description = "K8s master security group ID"
  value       = aws_security_group.k8s_master.id
}

output "k8s_worker_sg_id" {
  description = "K8s worker security group ID"
  value       = aws_security_group.k8s_worker.id
}