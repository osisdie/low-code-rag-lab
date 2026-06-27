terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = { source = "hashicorp/random", version = "~> 3.6" }
    local  = { source = "hashicorp/local", version = "~> 2.5" }
  }
}

provider "google" {
  region                = var.region
  zone                  = var.zone
  billing_project       = var.quota_project
  user_project_override = true
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  suffix     = random_string.suffix.result
  folder_num = element(split("/", google_folder.lab.name), 1)

  # teacher + student1..N，含各自的 Neo4j 帳號/資料庫（與 neo4j/init-users.cypher 對齊）
  learners = merge(
    { teacher = { neo4j_user = "teacher", neo4j_db = "lab_teacher" } },
    { for i in range(var.student_count) : "student${i + 1}" => {
      neo4j_user = "student${i + 1}", neo4j_db = "lab_student_${i + 1}"
    } }
  )
}

# ---- 教學用 folder ----
resource "google_folder" "lab" {
  display_name = var.folder_name
  parent       = "organizations/${var.org_id}"
}

# ---- 在 folder 解除「禁止產生 SA JSON key」----
resource "google_folder_organization_policy" "allow_sa_keys" {
  folder     = google_folder.lab.name
  constraint = "iam.disableServiceAccountKeyCreation"
  boolean_policy {
    enforced = false
  }
}
