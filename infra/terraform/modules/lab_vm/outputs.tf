output "external_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
output "internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}
output "sa_email" {
  value = google_service_account.vm.email
}
output "sa_key_json" {
  value     = var.create_sa_key ? google_service_account_key.vm[0].private_key : ""
  sensitive = true
}
