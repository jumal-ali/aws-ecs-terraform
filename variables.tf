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

variable "container-image" {
  type        = string
  description = "Container Image e.g. dhimmat/node-web-app"
}

variable "container-tag" {
  type        = string
  description = "Container Tag e.g. latest"
}

variable "container-port" {
  type        = number
  description = "Container Port e.g. 8080"
}

variable "container-mem" {
  type        = number
  description = "Container Memory e.g. 512"
}

variable "container-cpu" {
  type        = number
  description = "Container CPU e.g. 256"
}