terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

resource "google_project" "this" {
  name            = var.display_name
  project_id      = var.project_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}

resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "aiplatform.googleapis.com",
  ])
  project            = google_project.this.project_id
  service            = each.key
  disable_on_destroy = false
}

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

# 每個專案一個自動關機排程，給該專案所有 VM 共用
resource "google_compute_resource_policy" "nightly_stop" {
  project = google_project.this.project_id
  name    = "nightly-stop"
  region  = var.region
  instance_schedule_policy {
    time_zone = "Asia/Taipei"
    vm_stop_schedule { schedule = var.stop_schedule }
  }
  depends_on = [google_project_service.apis]
}
