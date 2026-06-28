output "core_project" {
  value = module.core.project_id
}
output "students_project" {
  value = module.students.project_id
}

output "shared" {
  description = "共用服務 VM（在 core 專案）"
  value = {
    external_ip   = module.vm_shared.external_ip
    neo4j_browser = "http://${module.vm_shared.external_ip}:7474"
    tei_endpoint  = "http://${module.vm_shared.external_ip}:8081"
  }
}

output "teacher" {
  description = "老師 VM（在 core 專案）"
  value = {
    external_ip = module.vm_teacher.external_ip
    dify_url    = "https://${replace(module.vm_teacher.external_ip, ".", "-")}.sslip.io"
    neo4j_db    = "labteacher"
  }
}

output "students" {
  description = "學員 VM（在 students 專案）"
  value = {
    for k, m in module.vm_student : k => {
      external_ip = m.external_ip
      dify_url    = "https://${replace(m.external_ip, ".", "-")}.sslip.io"
      neo4j_user  = local.students[k].neo4j_user
      neo4j_db    = local.students[k].neo4j_db
    }
  }
}
