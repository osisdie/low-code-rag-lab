# 每台 VM 的 SA JSON key 寫到本機 keys/（gitignored），供離線/攜出。
# VM 本身用 attached SA（ADC），不需這些檔；這是「也要 JSON」的攜出版本。
resource "local_file" "shared_key" {
  count           = var.create_sa_key ? 1 : 0
  filename        = "${path.module}/keys/lab-shared.json"
  content         = base64decode(module.vm_shared.sa_key_json)
  file_permission = "0600"
}

resource "local_file" "teacher_key" {
  count           = var.create_sa_key ? 1 : 0
  filename        = "${path.module}/keys/lab-teacher.json"
  content         = base64decode(module.vm_teacher.sa_key_json)
  file_permission = "0600"
}

resource "local_file" "student_keys" {
  for_each        = var.create_sa_key ? module.vm_student : {}
  filename        = "${path.module}/keys/lab-${each.key}.json"
  content         = base64decode(each.value.sa_key_json)
  file_permission = "0600"
}
