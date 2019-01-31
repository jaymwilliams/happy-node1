variable "client_aws_region" {
  type        = "string"
  description = "External account region"
  default     = "us-east-2"
}

variable "assume_role_arn" {
  type        = "string"
  description = "ARN of the role to assume, if not set ECR is provisioned in the current account"
  default     = ""
}

variable "name" {
  type        = "string"
  description = "name of the registry"
}

variable "policy" {
  type        = "string"
  description = "default ECR policy"

  default = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}
