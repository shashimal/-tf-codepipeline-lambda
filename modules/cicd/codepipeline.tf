locals {
  source_repository_types = {
    github = {
      provider      = "CodeStarSourceConnection"
      configuration = {
        ConnectionArn    = var.codestar_connection
        FullRepositoryId = var.repository_name
        BranchName       = var.branch_name
      }

    }
    codecommit = {
      provider      = "CodeCommit"
      configuration = {
        RepositoryName = var.repository_name
        BranchName     = var.branch_name
      }
    }
  }

  source_repository_config = lookup(local.source_repository_types, var.source_repository_type, "")
}

resource "aws_codepipeline" "pipeline" {
  name     = var.pipeline_name
  role_arn = var.pipeline_role_arn != "" ? var.pipeline_role_arn : aws_iam_role.codepipeline_role.arn

  #checkov:skip=CKV_AWS_219:Ensure Code Pipeline Artifact store is using a KMS CMK
  artifact_store {
    location = var.artifact_bucket_name
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "AWS"
      provider         = local.source_repository_config["provider"]
      version          = "1"
      output_artifacts = ["SourceArti"]
      configuration    = local.source_repository_config["configuration"]
    }
  }
  stage {
    name = "Build"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArti"]
      output_artifacts = ["BuildArti"]
      configuration    = {
        ProjectName = module.build_project.name
      }
    }
  }
  dynamic "stage" {
    for_each = var.approval_required ? [1] : []
    content {
      name = "Approve"
      action {
        name          = "Approval"
        category      = "Approval"
        owner         = "AWS"
        provider      = "Manual"
        version       = "1"
        configuration = {
          NotificationArn    = var.approval_sns_topic_arn
          CustomData         = var.approval_custom_data
          ExternalEntityLink = var.approval_external_entity_link
        }
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name      = "CreateChangeSet"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "CloudFormation"
      input_artifacts = ["BuildArti"]
      version   = 1
      run_order = 1
      role_arn = aws_iam_role.codepipeline_role.arn

      configuration = {
        ActionMode     = "CHANGE_SET_REPLACE"
        Capabilities   = "CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND"
        OutputFileName = "ChangeSetOutput.json"
        StackName      = "Lambda-Deployment"
        TemplatePath   = "BuildArti::outputtemplate.yml"
        ChangeSetName  = "StagedChangeSet"
        RoleArn        = aws_iam_role.codepipeline_role.arn
      }
    }

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["BuildArti"]
      version         = 1
      run_order       = 2

      configuration = {
        ActionMode     = "CHANGE_SET_EXECUTE"
        Capabilities   = "CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND"
        OutputFileName = "ChangeSetExecuteOutput.json"
        ChangeSetName  = "StagedChangeSet"
        StackName      = "Lambda-Deployment"
      }
    }
  }

}
