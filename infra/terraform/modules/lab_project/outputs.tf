output "project_id" {
  value = google_project.this.project_id
}
output "project_number" {
  value = google_project.this.number
}
output "subnetwork_id" {
  value = google_compute_subnetwork.subnet.id
}
output "nightly_stop_id" {
  value = google_compute_resource_policy.nightly_stop.id
}
