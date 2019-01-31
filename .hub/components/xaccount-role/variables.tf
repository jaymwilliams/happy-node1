variable "assume_role_arn" {
  type        = "string"
  description = "ARN of the role to assume"
  default     = ""
}

variable "external_id" {
  type        = "string"
  description = "External ID to assume role with"
  default     = ""
}

variable "target_aws_access_key" {
  type = "string"
}

variable "target_aws_secret_key" {
  type = "string"
}

variable "target_aws_session_token" {
  type    = "string"
  default = ""
}

variable "name" {
  type = "string"
}

variable "policy" {
  type        = "string"
  description = "Default cross account role policy"

  default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*",
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

variable "client_aws_region" {
  type        = "string"
  description = "External account region"
  default     = "us-east-2"
}
