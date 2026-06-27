output "shared" {
  description = "共用服務 VM"
  value = {
    project       = module.shared.project_id
    external_ip   = module.shared.external_ip
    neo4j_browser = "http://${module.shared.external_ip}:7474"
    tei_endpoint  = "http://${module.shared.external_ip}:8081"
  }
}

output "learners" {
  description = "每人的專案、VM、Dify 網址、Neo4j db"
  value = {
    for k, m in module.learner : k => {
      project     = m.project_id
      external_ip = m.external_ip
      dify_url    = "https://${replace(m.external_ip, ".", "-")}.sslip.io"
      neo4j_user  = local.learners[k].neo4j_user
      neo4j_db    = local.learners[k].neo4j_db
    }
  }
}

output "next_steps" {
  value = "SA JSON keys 已寫到 infra/terraform/keys/（gitignored）。各 VM /etc/motd 有 UI 待辦；驗證跑 scripts/preflight.sh。"
}
