resource "shoreline_notebook" "airflow_scheduler_outage" {
  name       = "airflow_scheduler_outage"
  data       = file("${path.module}/data/airflow_scheduler_outage.json")
  depends_on = [shoreline_action.invoke_resource_monitoring,shoreline_action.invoke_airflow_restart]
}

resource "shoreline_file" "resource_monitoring" {
  name             = "resource_monitoring"
  input_file       = "${path.module}/data/resource_monitoring.sh"
  md5              = filemd5("${path.module}/data/resource_monitoring.sh")
  description      = "Resource constraints, such as insufficient memory or processing power for the Airflow scheduler to function properly."
  destination_path = "/agent/scripts/resource_monitoring.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "airflow_restart" {
  name             = "airflow_restart"
  input_file       = "${path.module}/data/airflow_restart.sh"
  md5              = filemd5("${path.module}/data/airflow_restart.sh")
  description      = "Restart the Airflow scheduler to see if it resolves the issue."
  destination_path = "/agent/scripts/airflow_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_resource_monitoring" {
  name        = "invoke_resource_monitoring"
  description = "Resource constraints, such as insufficient memory or processing power for the Airflow scheduler to function properly."
  command     = "`chmod +x /agent/scripts/resource_monitoring.sh && /agent/scripts/resource_monitoring.sh`"
  params      = []
  file_deps   = ["resource_monitoring"]
  enabled     = true
  depends_on  = [shoreline_file.resource_monitoring]
}

resource "shoreline_action" "invoke_airflow_restart" {
  name        = "invoke_airflow_restart"
  description = "Restart the Airflow scheduler to see if it resolves the issue."
  command     = "`chmod +x /agent/scripts/airflow_restart.sh && /agent/scripts/airflow_restart.sh`"
  params      = []
  file_deps   = ["airflow_restart"]
  enabled     = true
  depends_on  = [shoreline_file.airflow_restart]
}

