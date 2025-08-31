locals {
  namespace = "kube-system"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

data "aws_iam_role" "agent_role" {
  name = "eks-workshop-ide-role"
}

resource "aws_iam_role_policy" "bedrock_access" {
  name = "bedrock-access"
  role = data.aws_iam_role.agent_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = "arn:aws:bedrock:*:*:foundation-model/*"
      }
    ]
  })
}


