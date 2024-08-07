terraform {
  required_version = ">= 0.14.0"
  backend "remote" {
    organization = "aoraki"
    workspaces {
      name = "horse"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.36.0"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.39.2"
    }
  }
}


resource "digitalocean_app" "app" {
  spec {
    name   = "horse-prod-site-syd"
    region = "syd"

    domain {
      name = "matt.horse"
      type = "PRIMARY"
    }

    static_site {
      name = "static"

      environment_slug = "html"
      source_dir       = "public"

      github {
        branch = "main"
        repo   = "crookm/horse"

        deploy_on_push = true
      }
    }
  }
}
