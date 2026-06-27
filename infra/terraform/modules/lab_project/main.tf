terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

# ---- 專案 ----
resource "google_project" "this" {
  name            = var.display_name
  project_id      = var.project_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  deletion_policy = "DELETE" # 讓 terraform destroy 能真的刪掉
}

# ---- 啟用 API ----
resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "aiplatform.googleapis.com", # 每個專案都啟用 Vertex（依需求）
  ])
  project            = google_project.this.project_id
  service            = each.key
  disable_on_destroy = false
}

# ---- 網路 ----
resource "google_compute_network" "vpc" {
  project                 = google_project.this.project_id
  name                    = "lab-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.apis]
}

resource "google_compute_subnetwork" "subnet" {
  project       = google_project.this.project_id
  name          = "lab-subnet"
  ip_cidr_range = "10.20.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "ssh" {
  project       = google_project.this.project_id
  name          = "allow-ssh"
  network       = google_compute_network.vpc.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "public" {
  count         = length(var.firewall_tcp_ports) > 0 ? 1 : 0
  project       = google_project.this.project_id
  name          = "allow-public"
  network       = google_compute_network.vpc.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = var.firewall_tcp_ports
  }
}

# ---- service account（給 VM 掛、走 ADC 呼叫本專案 Vertex）----
resource "google_service_account" "vertex" {
  project      = google_project.this.project_id
  account_id   = "lab-vertex"
  display_name = "Lab Vertex SA"
}

resource "google_project_iam_member" "vertex_user" {
  project = google_project.this.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertex.email}"
}

# JSON 金鑰（需 folder 已解除 disableServiceAccountKeyCreation；見根模組）
resource "google_service_account_key" "vertex" {
  count              = var.create_sa_key ? 1 : 0
  service_account_id = google_service_account.vertex.name
}

# ---- 每日自動關機 ----
resource "google_compute_resource_policy" "nightly_stop" {
  project = google_project.this.project_id
  name    = "nightly-stop"
  region  = var.region
  instance_schedule_policy {
    time_zone = "Asia/Taipei"
    vm_stop_schedule { schedule = var.stop_schedule }
  }
}

# ---- VM ----
resource "google_compute_instance" "vm" {
  project      = google_project.this.project_id
  name         = var.display_name
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
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {} # 外部 IP
  }
  service_account {
    email  = google_service_account.vertex.email
    scopes = ["cloud-platform"]
  }
  resource_policies       = [google_compute_resource_policy.nightly_stop.id]
  metadata                = merge({ ssh-keys = var.ssh_meta }, var.extra_metadata)
  metadata_startup_script = var.startup_script

  depends_on = [google_compute_subnetwork.subnet, google_project_iam_member.vertex_user]
}
