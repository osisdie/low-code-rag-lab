# 預算告警，涵蓋 folder 下所有教學專案（shared + learners）。
# 在 50/80/100% 門檻通知；搭配每日自動關機保護 $300 credit。
resource "google_billing_budget" "lab" {
  billing_account = var.billing_account
  display_name    = "low-code-rag-lab budget"

  budget_filter {
    projects = concat(
      ["projects/${module.shared.project_id}"],
      [for k, m in module.learner : "projects/${m.project_id}"]
    )
  }
  amount {
    specified_amount {
      currency_code = "USD"
      units         = tostring(var.budget_amount)
    }
  }
  threshold_rules { threshold_percent = 0.5 }
  threshold_rules { threshold_percent = 0.8 }
  threshold_rules { threshold_percent = 1.0 }
}
