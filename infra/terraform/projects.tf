# 2 個專案（配合 billing 3-project 上限）：
#   core     = 老師 VM + 共用服務 VM（Neo4j/TEI）
#   students = 全部學員 VM
# 以 VM 區分每個人，各 VM 有自己的 SA(+JSON key)。

locals {
  ssh_meta = "${var.ssh_user}:${file(pathexpand(var.ssh_pubkey_path))}"
}

# ---------- 專案 ----------
module "core" {
  source             = "./modules/lab_project"
  project_id         = "lab-core-${local.suffix}"
  display_name       = "lab-core"
  folder_id          = local.folder_num
  billing_account    = var.billing_account
  region             = var.region
  firewall_tcp_ports = ["80", "443", "7474", "7687", "8081"] # 老師 web + 共用 Neo4j/TEI
  depends_on         = [google_folder_organization_policy.allow_sa_keys]
}

module "students" {
  source             = "./modules/lab_project"
  project_id         = "lab-students-${local.suffix}"
  display_name       = "lab-students"
  folder_id          = local.folder_num
  billing_account    = var.billing_account
  region             = var.region
  firewall_tcp_ports = ["80", "443"]
  depends_on         = [google_folder_organization_policy.allow_sa_keys]
}

# ---------- 共用服務 VM（在 core）----------
module "vm_shared" {
  source          = "./modules/lab_vm"
  project_id      = module.core.project_id
  name            = "lab-shared"
  zone            = var.zone
  machine_type    = var.machine_type_svc
  subnetwork_id   = module.core.subnetwork_id
  nightly_stop_id = module.core.nightly_stop_id
  sa_account_id   = "vm-shared"
  ssh_meta        = local.ssh_meta
  create_sa_key   = var.create_sa_key
  startup_script  = file("${path.module}/../provision/svc-setup.sh")
  extra_metadata = {
    repo-url         = var.repo_url
    hf-token         = var.hf_token
    neo4j-initial-pw = var.neo4j_password
  }
}

# ---------- 老師 VM（在 core，用 core 專案的 Vertex）----------
module "vm_teacher" {
  source          = "./modules/lab_vm"
  project_id      = module.core.project_id
  name            = "lab-teacher"
  zone            = var.zone
  machine_type    = var.machine_type_learner
  subnetwork_id   = module.core.subnetwork_id
  nightly_stop_id = module.core.nightly_stop_id
  sa_account_id   = "vm-teacher"
  ssh_meta        = local.ssh_meta
  create_sa_key   = var.create_sa_key
  startup_script  = file("${path.module}/../provision/learner-setup.sh")
  extra_metadata = {
    repo-url           = var.repo_url
    shared-ip          = module.vm_shared.external_ip
    litellm-master-key = var.litellm_master_key
    graphrag-key       = var.graphrag_key
    vertex-project     = module.core.project_id
    vertex-location    = var.vertex_location
    neo4j-user         = "teacher"
    neo4j-password     = var.neo4j_password
    neo4j-database     = "lab_teacher"
  }
}

# ---------- 學員 VM（全部在 students 專案，用 students 專案的 Vertex）----------
module "vm_student" {
  for_each        = local.students
  source          = "./modules/lab_vm"
  project_id      = module.students.project_id
  name            = "lab-${each.key}"
  zone            = var.zone
  machine_type    = var.machine_type_learner
  subnetwork_id   = module.students.subnetwork_id
  nightly_stop_id = module.students.nightly_stop_id
  sa_account_id   = "vm-${each.key}"
  ssh_meta        = local.ssh_meta
  create_sa_key   = var.create_sa_key
  startup_script  = file("${path.module}/../provision/learner-setup.sh")
  extra_metadata = {
    repo-url           = var.repo_url
    shared-ip          = module.vm_shared.external_ip
    litellm-master-key = var.litellm_master_key
    graphrag-key       = var.graphrag_key
    vertex-project     = module.students.project_id
    vertex-location    = var.vertex_location
    neo4j-user         = each.value.neo4j_user
    neo4j-password     = var.neo4j_password
    neo4j-database     = each.value.neo4j_db
  }
}
