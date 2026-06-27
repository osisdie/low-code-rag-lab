output "project_id" {
  value = google_project.this.project_id
}
output "external_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
output "internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}
output "sa_email" {
  value = google_service_account.vertex.email
}
output "sa_key_json" {
  description = "base64 的 SA JSON key（create_sa_key=true 時）"
  value       = var.create_sa_key ? google_service_account_key.vertex[0].private_key : ""
  sensitive   = true
}
