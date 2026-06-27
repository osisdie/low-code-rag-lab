variable "project_id" { type = string }
variable "display_name" { type = string }
variable "folder_id" { type = string }
variable "billing_account" { type = string }
variable "region" { type = string }
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
variable "startup_script" { type = string }
variable "ssh_meta" { type = string }
variable "extra_metadata" {
  type    = map(string)
  default = {}
}
variable "firewall_tcp_ports" {
  type        = list(string)
  description = "對外開放的 TCP 埠（除了 22）"
  default     = []
}
variable "create_sa_key" {
  type    = bool
  default = true
}
variable "stop_schedule" {
  type    = string
  default = "0 20 * * *" # 每日 20:00 自動關機
}
