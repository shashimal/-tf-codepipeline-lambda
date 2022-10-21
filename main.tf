module "codepipeline" {
  source = "./modules/cicd"
#
  account = "793209430381"
  aws_env = "dev"


  application_name = "Lambda-Demo"
  artifact_bucket_id = aws_s3_bucket.artifacts_bucket.id
  artifact_bucket_name = aws_s3_bucket.artifacts_bucket.bucket

  repository_name = "shashimal/lambda-canary-deployment"
  branch_name = "main"
  codestar_connection = "arn:aws:codestar-connections:us-east-1:793209430381:connection/4fc878df-93f1-45ef-89c8-3279b53b6ba4"

  pipeline_name = "codepipeline-lambda-demo"
  project_name = "codepipeline-lambda-demo"
  buildspec_path = "."
  privileged_mode = true

  build_environment_variables = [
    { name = "artifact_bucket", value = aws_s3_bucket.artifacts_bucket.bucket, type = "PLAINTEXT" },
  ]

}

resource "aws_s3_bucket" "artifacts_bucket" {
}