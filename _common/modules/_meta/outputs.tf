output "webs" {
  value       = var.environment == "production" ? concat(var.web_domains, var.pb_web_domains) : var.pb_web_domains
  description = "Web domains"
}
