terraform {
  required_version = ">= 0.11.3"
  backend          "s3"             {}
}

provider "aws" {
  version = "1.41.0"
  alias   = "remote"

  assume_role {
    role_arn = "${var.assume_role_arn}"
  }

  region = "${var.client_aws_region}"
}

resource "aws_ecr_repository" "main" {
  provider = "aws.remote"
  name     = "${var.name}"
}

resource "aws_ecr_repository_policy" "main" {
  provider   = "aws.remote"
  repository = "${var.name}"
  policy     = "${var.policy}"
  depends_on = ["aws_ecr_repository.main"]
}
