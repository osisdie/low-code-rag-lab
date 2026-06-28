variable "project_id" { type = string }
variable "name" { type = string }
variable "zone" { type = string }
variable "machine_type" { type = string }
variable "disk_size" {
  type    = number
  default = 50
}
variable "image" {
  type    = string
  default = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
}
variable "subnetwork_id" { type = string }
variable "nightly_stop_id" { type = string }
variable "sa_account_id" {
  type        = string
  description = "此 VM 專屬 service account 的 account_id（專案內唯一），例：vm-teacher"
}
variable "startup_script" { type = string }
variable "ssh_meta" { type = string }
variable "extra_metadata" {
  type    = map(string)
  default = {}
}
variable "create_sa_key" {
  type    = bool
  default = true
}
