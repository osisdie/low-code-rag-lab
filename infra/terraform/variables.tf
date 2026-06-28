variable "org_id" {
  type        = string
  description = "GCP organization 數字 ID（例：695375997648）"
}

variable "folder_name" {
  type    = string
  default = "low-code-rag-lab"
}

variable "billing_account" {
  type        = string
  description = "Billing account ID（XXXXXX-XXXXXX-XXXXXX）"
}

variable "quota_project" {
  type        = string
  description = "既有專案 ID，當 provider 的 quota/billing project（user_project_override 用）"
}

variable "region" {
  type    = string
  default = "asia-east1"
}
variable "zone" {
  type    = string
  default = "asia-east1-b"
}

variable "student_count" {
  type    = number
  default = 8
  validation {
    condition     = var.student_count >= 0 && var.student_count <= 8
    error_message = "student_count 需在 0–8 之間。"
  }
}

variable "machine_type_learner" {
  type    = string
  default = "e2-standard-4"
}
variable "machine_type_svc" {
  type    = string
  default = "e2-standard-8"
}

variable "ssh_user" {
  type    = string
  default = "lab"
}
variable "ssh_pubkey_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
variable "repo_url" {
  type    = string
  default = "https://github.com/osisdie/low-code-rag-lab.git"
}

variable "vertex_location" {
  type    = string
  default = "us-central1"
}
variable "litellm_master_key" {
  type      = string
  sensitive = true
}
variable "hf_token" {
  type      = string
  sensitive = true
}
variable "neo4j_password" {
  type      = string
  sensitive = true
}
variable "graphrag_key" {
  type    = string
  default = "lab-graphrag-secret"
}
variable "create_sa_key" {
  type        = bool
  default     = true
  description = "是否在各專案產生 SA JSON key（需 folder 已解除限制）"
}

variable "budget_amount" {
  type    = number
  default = 300
}

variable "create_budget" {
  type        = bool
  default     = false
  description = "建立預算告警（需 ADC 帳號有 billing.budgets.create；否則用 GCP Console 設）"
}
