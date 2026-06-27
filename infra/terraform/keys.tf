# 把各專案的 SA JSON key 寫到本機 keys/（gitignored），供離線/攜出使用。
# VM 本身用 attached SA（ADC），不需要這些檔；這是「兩者都要」的攜出版本。
resource "local_file" "shared_key" {
  count           = var.create_sa_key ? 1 : 0
  filename        = "${path.module}/keys/${module.shared.project_id}.json"
  content         = base64decode(module.shared.sa_key_json)
  file_permission = "0600"
}

resource "local_file" "learner_keys" {
  for_each        = var.create_sa_key ? module.learner : {}
  filename        = "${path.module}/keys/${each.value.project_id}.json"
  content         = base64decode(each.value.sa_key_json)
  file_permission = "0600"
}
