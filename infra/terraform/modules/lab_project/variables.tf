variable "project_id" { type = string }
variable "display_name" { type = string }
variable "folder_id" { type = string }
variable "billing_account" { type = string }
variable "region" { type = string }
variable "firewall_tcp_ports" {
  type        = list(string)
  description = "對外開放的 TCP 埠（除了 22）"
  default     = []
}
variable "stop_schedule" {
  type    = string
  default = "0 20 * * *"
}
