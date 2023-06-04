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
      version = "4.7.1"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.27.1"
    }
  }
}


resource "digitalocean_app" "app" {
  spec {
    name   = "matthorse"
    region = "syd"

    domain {
      name = "matt.horse"
      type = "PRIMARY"
    }

    static_site {
      name = "static"

      github {
        branch = "main"
        repo   = "crookm/horse"

        deploy_on_push = true
      }
    }
  }
}
