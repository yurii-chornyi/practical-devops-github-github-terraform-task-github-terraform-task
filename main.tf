provider "github" {
  token = var.github_token
  owner = "yurii-chornyi"
}

resource "github_repository" "repo" {
  name        = "your-repository-name"
  description = "Repository configured with Terraform"
  private     = true
  auto_init   = true
}

resource "github_repository_collaborator" "softservedata" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push" 
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_repository_branch_protection" "main" {
  repository = github_repository.repo.name
  branch     = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews               = true
    required_approving_review_count     = 1 
  }
  enforce_admins = true
}

resource "github_repository_branch_protection" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews               = true
    required_approving_review_count     = 2 
  }
  enforce_admins = true
}

resource "github_codeowners" "main_codeowner" {
  repository = github_repository.repo.name
  codeowners = [ "* @softservedata" ]
}
