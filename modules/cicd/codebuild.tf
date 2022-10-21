module "build_project" {
  source                = "SPHTech-Platform/codebuild/aws"
  version               = "~> 1.1.0"
  name                  = var.project_name
  description           = var.project_description
  environment_variables = var.build_environment_variables
  buildspec             = "${var.buildspec_path}/buildspec.yml"
  create_service_role   = false
  service_role_name     = aws_iam_role.codebuild_role.name
  service_role_arn      = aws_iam_role.codebuild_role.arn
  privileged_mode       = true

  artifacts = {
    type = "CODEPIPELINE"
  }
}
