#CodePipeline IAM

resource "aws_iam_role" "codepipeline_role" {
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust_policy.json
  name               = "${var.project_name}-codepipeline-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSLambdaExecute"
  ]
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy_document.json
  role   = aws_iam_role.codepipeline_role.id
}

#CodeBuild IAM

resource "aws_iam_role" "codebuild_role" {
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_policy.json
  name               = "${var.project_name}-codebuild-role"

}

resource "aws_iam_role_policy" "codebuild_iam_policy" {
  name   = "${var.project_name}-permisson-policy"
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
  role   = aws_iam_role.codebuild_role.id
}

#CodeDeploy IAM
data "aws_iam_policy_document" "codedeploy_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  assume_role_policy = data.aws_iam_policy_document.codedeploy_trust_policy.json
  name               = "${var.application_name}-codedeploy-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda",
    "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  ]
}

resource "aws_iam_role" "codepipeline_cloudformation_role" {
  assume_role_policy = data.aws_iam_policy_document.cloudformation_trust_policy.json
  name               = "${var.project_name}-codepipeline-cloudformation-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSLambdaExecute"
  ]
}
resource "aws_iam_role_policy" "codepipeline_cloudformation_policy" {
  name   = "codepipeline-cloudformation-policy"
  policy = data.aws_iam_policy_document.cloudformation_policy_document.json
  role   = aws_iam_role.codepipeline_cloudformation_role.id
}