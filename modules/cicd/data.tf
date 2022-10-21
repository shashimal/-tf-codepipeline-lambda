data "aws_iam_policy_document" "codepipeline_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com","cloudformation.amazonaws.com"]
    }
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "codepipeline_policy_document" {
  #checkov:skip=CKV_AWS_107:Ensure IAM policies does not allow credentials exposure
  #checkov:skip=CKV_AWS_109:Ensure IAM policies does not allow permissions management / resource exposure without constraints
  #checkov:skip=CKV_AWS_110:Ensure IAM policies does not allow privilege escalation
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  statement {
    sid       = "SidToPassRole"
    actions   = ["iam:PassRole"]
    resources = ["*"]
    effect    = "Allow"
    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    sid = "SidToCodecommit"
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToCodeStarConnections"
    actions = [
      "codestar-connections:UseConnection",
      "codestar-connections:GetConnection"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToCodeBuild"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToCodeDeploy"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToLambda"
    actions = [
      "lambda:InvokeFunction",
      "lambda:ListFunctions"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToEcr"
    actions = [
      "ecr:DescribeImages"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToOther"
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "sns:*",
      "ecs:*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "SidToS3"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_id}",
      "arn:aws:s3:::${var.artifact_bucket_id}/*"
    ]
    effect = "Allow"
    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [var.account]
    }
  }

  statement {
    sid = "SidToCloudFormation"
    actions = [
      "apigateway:*",
      "codedeploy:*",
      "lambda:*",
      "cloudformation:CreateChangeSet",
      "iam:GetRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PutRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "cloudformation:DescribeStacks",
      "cloudformation:DescribeChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:ExecuteChangeSet"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codebuild_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "codebuild_policy_document" {
  #checkov:skip=CKV_AWS_108:Ensure IAM policies does not allow data exfiltration
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints
  statement {
    sid    = "CloudWatchLogsPolicy"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "CodeCommitPolicy"
    effect = "Allow"
    actions = [
      "codecommit:GitPull"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "S3GetObjectPolicy"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_id}",
      "arn:aws:s3:::${var.artifact_bucket_id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [var.account]
    }
  }

  statement {
    sid    = "S3PutObjectPolicy"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_id}",
      "arn:aws:s3:::${var.artifact_bucket_id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [var.account]
    }
  }

  statement {
    sid    = "ECRPolicy"
    effect = "Allow"
    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:TagResource",
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "S3BucketIdentity"
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_id}",
      "arn:aws:s3:::${var.artifact_bucket_id}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [var.account]
    }
  }

  statement {
    sid    = "SecretMangerPolicy"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:ap-southeast-1:${var.account}:secret:*"
    ]
  }
}

data "aws_iam_policy_document" "cloudformation_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudformation_policy_document" {
  statement {
    sid = "SidToCloudFormation"
    actions = [
      "apigateway:*",
      "codedeploy:*",
      "lambda:*",
      "cloudformation:CreateChangeSet",
      "iam:GetRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PutRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "cloudformation:DescribeStacks",
      "cloudformation:DescribeChangeSet"
    ]
    resources = ["*"]
  }
}

