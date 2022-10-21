variable "account" {
  type        = string
  description = "AWS account"
}

variable "aws_env" {
  description = "Environment the resource is being provisioned for"
  type        = string
}


variable "pipeline_name" {
  type        = string
  description = "Name of the pipeline"
}
variable "pipeline_role_arn" {
  type        = string
  description = "A service role Amazon Resource Name (ARN) that grants AWS CodePipeline permission to make calls to AWS services on your behalf. If the value is not provided, default role will be created."
  default     = ""
}

variable "artifact_bucket_name" {
  type        = string
  description = "Name of the codepipeline artifact bucket name "
}

variable "artifact_bucket_id" {
  type        = string
  description = "Artifact bucket id "
}

#Source
variable "codestar_connection" {
  type        = string
  description = "CodeStarSourceConnection for Bitbucket, GitHub, GitHub Enterprise Server actions"
  default     = ""
}
variable "repository_name" {
  type        = string
  description = "Source repository name"
}
variable "branch_name" {
  type        = string
  description = "Branch of the source repository"
}
variable "source_repository_type" {
  type        = string
  description = "Type of the source repository provider "
  default     = "github"
}

#CodeBuild
variable "project_name" {
  type        = string
  description = "Codebuild project name"
}

variable "project_description" {
  type        = string
  description = "Codebuild project description"
  default     = ""
}

variable "build_service_role_arn" {
  type        = string
  description = "A service role Amazon Resource Name (ARN) that grants AWS CodeBuild permission to make calls to AWS services on your behalf. If the value is not provided, default role will be created."
  default     = ""
}

variable "artifact_type" {
  type        = string
  description = "Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3"
  default     = "CODEPIPELINE"
}

variable "compute_type" {
  type        = string
  description = "Information about the compute resources the build project"
  default     = "BUILD_GENERAL1_MEDIUM"
}

variable "image" {
  type        = string
  description = "Docker image to use for this build project"
  default     = "aws/codebuild/standard:2.0"
}

variable "environment_type" {
  type        = string
  description = "Type of build environment to use for related build"
  default     = "LINUX_CONTAINER"
}

variable "source_type" {
  type        = string
  description = "Type of repository that contains the source code to be built"
  default     = "CODEPIPELINE"
}

variable "build_environment_variables" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "Environment variables"
  default     = []
}

variable "privileged_mode" {
  type        = bool
  description = "Whether to enable running the Docker daemon inside a Docker container."
  default     = true
}

variable "credentials_type" {
  type        = string
  description = "Type of credentials AWS CodeBuild uses to pull images in your build"
  default     = "CODEBUILD"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}

#CodeDeploy
variable "application_name" {
  type        = string
  description = "CodeDeploy application name"
}

variable "deploy_service_role_arn" {
  type        = string
  description = "A service role Amazon Resource Name (ARN) that grants AWS CodeDeploy permission to make calls to AWS services on your behalf. If the value is not provided, default role will be created."
  default     = ""
}

variable "termination_wait_time_in_minutes" {
  type        = string
  description = "The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment"
  default     = 60
}

#ECS Blue/Green deployment
#variable "ecs_cluster_name" {
#  type        = string
#  description = "ECS cluster name"
#}
#
#variable "ecs_service_name" {
#  type        = string
#  description = "ECS service name"
#}
#
#variable "alb_prod_listener_arn" {
#  type        = string
#  description = "ALB prod listener"
#}
#
#variable "alb_test_listener_arn" {
#  type        = string
#  description = "ALB test listener"
#}
#
#variable "alb_target_group_one" {
#  type        = string
#  description = "Primary target group"
#}
#
#variable "alb_target_group_second" {
#  type        = string
#  description = "Replacement target group"
#}

#Approval Stage
variable "approval_required" {
  type        = bool
  description = "When pipeline requires a approval stage, approval_required must be set to true "
  default     = false
}

variable "approval_sns_topic_arn" {
  type        = string
  description = "SNS topic arn for sending approval stage notification. If the arn is not provided, default SNS topic will be created"
  default     = ""
}
variable "approval_custom_data" {
  type        = string
  description = "Any custom message for describing the approval stage"
  default     = "Need approval for production deployment"
}

variable "approval_external_entity_link" {
  type        = string
  description = "Any external link. For example , this will be the link to verify your application changes"
  default     = ""
}

variable "buildspec_path" {
  type        = string
  description = "Path of the buildspec.yml file"
  default     = "./buildspec.yml"
}
