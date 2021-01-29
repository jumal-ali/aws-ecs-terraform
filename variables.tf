variable "aws-region" {
  type        = string
  description = "aws region .e.g eu-west-1"
}

variable "project-name" {
  type        = string
  description = "Project Name"
}

variable "env" {
  type        = string
  description = "The environment in which to deploy the resources to. e.g. dev"
}

variable "vpc-cidr" {
  type        = string
  description = "CIDR e.g. 10.0.0.0/16"
}

variable "azs" {
  type        = list(any)
  description = "List of AZs e.g. [\"eu-west-1a\", \"eu-west-1b\", \"eu-west-1c\"]"
}

variable "private_subnets" {
  type        = list(any)
  description = "List of Private Subnets e.g. [\"10.0.1.0/24\", \"10.0.2.0/24\", \"10.0.3.0/24\"]"
}

variable "public_subnets" {
  type        = list(any)
  description = "List of Public Subnets e.g. [\"10.0.101.0/24\", \"10.0.102.0/24\", \"10.0.103.0/24\"]"
}

variable "ssh-public-key" {
  type        = string
  description = "Your public SSH Key, required to access the new resources via Bastion"
  sensitive   = true
}

variable "create-bastion" {
  type        = bool
  description = "Should a bastion be created? true or false"
  default     = false
}

variable "containers" {
  type = list(object({
    image                = string
    tag                  = string
    container-port       = number
    host-port            = number
    cpu                  = number
    memory               = number
    app-name             = string
    healthcheck-commands = list(string)
  }))

  description = <<-DESCRIPTION
                    Please provide a List of Container Objects with the following format:
                    [
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
DESCRIPTION
}
