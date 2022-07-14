# webhot for github
resource "aws_codestarconnections_connection" "gitwebhook" {
  name          = "gitwebhook"
  provider_type = "GitHub"
}



# code for pipeine
resource "aws_codepipeline" "reactCodePipeline" {
  name = "reactCodePipeline"
  role_arn = aws_iam_role.codepipeline_role2.arn

  artifact_store {
    location = "my-terraform-first-bucket2"
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = var.resource_tag_name
      category = var.category
      owner = var.owner
      provider = "GitHub"
      version = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        OAuthToken = ${{ secrets.GITHUB_TOKEN }}
        Owner = var.github_owner
        Repo = var.github_repo
        Branch = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.reactbuild.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "S3"
      input_artifacts = ["BuildArtifact"]
      version = "1"

      configuration = {
      BucketName    = "my-terraform-first-bucket2"
      Extract = "true"  
    }
    }
  }
}

