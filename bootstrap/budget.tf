resource "azurerm_consumption_budget_resource_group" "this" {
  count             = var.create_budget ? 1 : 0 # can be switched off if the RG does not allow budgets
  name              = "budget-${var.project}"
  resource_group_id = data.azurerm_resource_group.this.id
  amount            = var.budget_amount
  time_grain        = "Monthly"

  time_period {
    start_date = var.budget_start_date
  }

  dynamic "notification" {
    for_each = {
      actual-50    = ["Actual", 50]
      actual-80    = ["Actual", 80]
      forecast-100 = ["Forecasted", 100]
    }
    content {
      enabled        = true
      operator       = "GreaterThan"
      threshold_type = notification.value[0]
      threshold      = notification.value[1]
      contact_emails = var.alert_emails
    }
  }
}
