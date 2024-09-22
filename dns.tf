data "cloudflare_zone" "personal_zone" {
  name = var.cloudflare_personal_zone
}

resource "cloudflare_record" "personal_domain" {
  count   = (terraform.workspace == "prod") ? 1 : 0
  zone_id = data.cloudflare_zone.personal_zone.id
  type    = "A"
  proxied = true
  content = var.public_ipv4
  name    = var.public_domain
  comment = "Terraform managed."
}

resource "cloudflare_record" "blog_domain" {
  count   = (terraform.workspace == "prod") ? 1 : 0
  zone_id = data.cloudflare_zone.personal_zone.id
  type    = "AAAA"
  proxied = true
  content = var.public_ipv6
  name    = "blog"
  comment = "Terraform managed."
}

resource "cloudflare_record" "n8n_domain" {
  count   = (terraform.workspace == "prod") ? 1 : 0
  zone_id = data.cloudflare_zone.personal_zone.id
  type    = "CNAME"
  proxied = true
  content = "@"
  name    = "n8n"
  comment = "Terraform managed."
}
