aws-region   = "eu-west-1"
project-name = "Awesome App"
env          = "dev"

vpc-cidr        = "10.0.0.0/16"
azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

containers = [
  {
    image                = "jumal/superawesome-web-app"
    tag                  = "latest"
    container-port       = 3000
    host-port            = 80
    cpu                  = 256
    memory               = 512
    app-name             = "web-app"
    healthcheck-commands = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
  }
]

