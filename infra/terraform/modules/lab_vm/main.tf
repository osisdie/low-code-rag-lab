terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

# 此 VM 專屬 SA（走 ADC 呼叫本專案 Vertex）
# 靜態 IP（保留），讓 VM stop/start 後 IP 不變
resource "google_compute_address" "ext" {
  project      = var.project_id
  name         = "${var.name}-ext"
  region       = var.region
  address_type = "EXTERNAL"
}

resource "google_compute_address" "int" {
  project      = var.project_id
  name         = "${var.name}-int"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork_id
}

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
    network_ip = google_compute_address.int.address
    access_config {
      nat_ip = google_compute_address.ext.address
    }
  }
  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }
  # 不自動關機（彩排期間常在晚上，20:00 自動關機會打斷）。要省成本就手動停。
  resource_policies       = []
  desired_status          = "RUNNING"
  metadata                = merge({ ssh-keys = var.ssh_meta }, var.extra_metadata)
  metadata_startup_script = var.startup_script

  depends_on = [google_project_iam_member.vertex_user]
}
