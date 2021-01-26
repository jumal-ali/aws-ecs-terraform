terraform {
  backend "s3" {
    bucket = "ja-terraform"
    key    = "ecs-infra/dev/terraform.tfstate"
    region = "eu-west-1"
    #    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}
