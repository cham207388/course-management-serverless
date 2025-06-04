locals {
  frontend_domain  = "${var.frontend_subdomain}.${var.domain_name}"
  api_domain       = "${var.api_subdomain}.${var.domain_name}"
  sanitized_domain = replace(var.domain_name, ".", "-")
}