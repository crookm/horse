resource "cloudflare_zone" "zone" {
  account_id = "1166a05f119cbc98936aee10d7375626"
  zone       = "matt.horse"

  paused = false

  plan = "free"
  type = "full"
}

resource "cloudflare_zone_dnssec" "dnssec" {
  zone_id = cloudflare_zone.zone.id
}

resource "cloudflare_zone_settings_override" "settings" {
  zone_id = cloudflare_zone.zone.id
  settings {
    brotli = "on"

    security_level = "low"
    browser_check  = "off"
    challenge_ttl  = 2700

    min_tls_version          = "1.2"
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    opportunistic_encryption = "on"

    rocket_loader = "on"
    early_hints   = "on"
    zero_rtt      = "on"

    minify {
      css  = "on"
      js   = "on"
      html = "on"
    }

    security_header {
      enabled = true

      include_subdomains = true
      max_age            = 31536000
      nosniff            = true
      preload            = true
    }
  }
}


# ---
# DNS
# ---
resource "cloudflare_record" "app" {
  zone_id = cloudflare_zone.zone.id
  type    = "CNAME"

  name  = "@"
  value = replace(digitalocean_app.app.default_ingress, "https://", "")
  ttl   = 1 # automatic

  proxied = true
  comment = "tf managed: digitalocean horse app"
}
