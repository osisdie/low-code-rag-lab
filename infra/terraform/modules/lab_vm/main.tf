terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

# 此 VM 專屬 SA（走 ADC 呼叫本專案 Vertex）
resource "google_service_account" "vm" {
  project      = var.project_id
  account_id   = var.sa_account_id
  display_name = "Lab SA ${var.name}"
}

resource "google_project_iam_member" "vertex_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_service_account_key" "vm" {
  count              = var.create_sa_key ? 1 : 0
  service_account_id = google_service_account.vm.name
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["lab"]

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }
  network_interface {
    subnetwork = var.subnetwork_id
    access_config {}
  }
  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }
  resource_policies       = [var.nightly_stop_id]
  metadata                = merge({ ssh-keys = var.ssh_meta }, var.extra_metadata)
  metadata_startup_script = var.startup_script

  depends_on = [google_project_iam_member.vertex_user]
}
