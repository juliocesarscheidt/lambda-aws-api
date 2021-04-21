terraform {
  backend "s3" {
    bucket = "blackdevs-aws"
    key    = "terraform/lambda-api/state.tfstate"
    region = "sa-east-1"
  }
}
