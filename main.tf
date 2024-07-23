# main.tf
provider "aws" {
  region = "us-east-2"
}

resource "aws_codeartifact_domain" "domain" {
  domain = "domain"
}

resource "aws_codeartifact_repository" "repo" {
  repository = "repo"
  domain     = aws_codeartifact_domain.domain.domain
}

output "domain_name" {
  value = aws_codeartifact_domain.domain.domain
}

output "repository_name" {
  value = aws_codeartifact_repository.repo.repository
}

