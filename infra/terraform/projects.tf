# 共用服務專案/VM：Neo4j Enterprise（多租戶）+ TEI(BGE-M3, CPU)
module "shared" {
  source          = "./modules/lab_project"
  project_id      = "lab-shared-${local.suffix}"
  display_name    = "lab-shared"
  folder_id       = local.folder_num
  billing_account = var.billing_account
  region          = var.region
  zone            = var.zone
  machine_type    = var.machine_type_svc
  ssh_meta        = "${var.ssh_user}:${file(pathexpand(var.ssh_pubkey_path))}"
  create_sa_key   = var.create_sa_key

  # Neo4j Browser/Bolt 給學員看圖；8081 給各 learner 的 LiteLLM 取 BGE-M3
  firewall_tcp_ports = ["7474", "7687", "8081"]
  startup_script     = file("${path.module}/../provision/svc-setup.sh")
  extra_metadata = {
    repo-url         = var.repo_url
    hf-token         = var.hf_token
    neo4j-initial-pw = var.neo4j_password
  }
  depends_on = [google_folder_organization_policy.allow_sa_keys]
}

# 每人一個專案/VM（老師 + student1..N）：Dify + 本機 LiteLLM(→自家 Vertex) + 個人服務
module "learner" {
  for_each        = local.learners
  source          = "./modules/lab_project"
  project_id      = "lab-${each.key}-${local.suffix}"
  display_name    = "lab-${each.key}"
  folder_id       = local.folder_num
  billing_account = var.billing_account
  region          = var.region
  zone            = var.zone
  machine_type    = var.machine_type_learner
  ssh_meta        = "${var.ssh_user}:${file(pathexpand(var.ssh_pubkey_path))}"
  create_sa_key   = var.create_sa_key

  firewall_tcp_ports = ["80", "443"] # Caddy/Dify/LINE
  startup_script     = file("${path.module}/../provision/learner-setup.sh")
  extra_metadata = {
    repo-url           = var.repo_url
    shared-ip          = module.shared.external_ip
    litellm-master-key = var.litellm_master_key
    graphrag-key       = var.graphrag_key
    vertex-project     = "lab-${each.key}-${local.suffix}" # 用自家專案的 Vertex
    vertex-location    = var.vertex_location
    neo4j-user         = each.value.neo4j_user
    neo4j-password     = var.neo4j_password
    neo4j-database     = each.value.neo4j_db
  }
  depends_on = [google_folder_organization_policy.allow_sa_keys, module.shared]
}
