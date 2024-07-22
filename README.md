# Read.me

# TypeScript Project CI/CD with AWS CodeArtifact and GitHub Actions

Welcome to the **TypeScript Project CI/CD with AWS CodeArtifact** repository! This project demonstrates how to set up a CI/CD pipeline for a TypeScript project using **AWS CodeArtifact**, **GitHub Actions**, and **Terraform**.

## Table of Contents

1. [Introduction](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
2. [Features](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
3. [Setup Instructions](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
4. [Project Structure](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
5. [Configuration Files](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
6. [CI/CD Pipeline](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
7. [AWS Integration](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
8. [Additional Resources](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
9. [Contributing](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)
10. [License](https://www.notion.so/Read-me-fff5896d8a474e818d2bb2b8a2e911a6?pvs=21)

## Introduction

This repository provides a guide to automating the build and deployment of a TypeScript package using **GitHub Actions** and **AWS CodeArtifact**. By leveraging **infrastructure as code** with **Terraform**, you can create and manage your AWS resources, and set up a robust CI/CD pipeline to streamline your development workflow.

## Features

- **CI/CD**: Continuous integration and continuous deployment using **GitHub Actions**.
- **AWS CodeArtifact**: Manage your npm packages with AWS CodeArtifact.
- **Infrastructure as Code**: Use **Terraform** for provisioning and managing AWS resources.
- **TypeScript**: Set up and configure a TypeScript project.
- **Secure**: Use GitHub Secrets to manage sensitive information.

## Setup Instructions

### Prerequisites

- **Node.js** and **npm**
- **Terraform**
- **AWS CLI** configured with appropriate permissions

### Clone the Repository

```bash
bashCopy code
git clone https://github.com/yourusername/typescript-codeartifact-ci.git
cd typescript-codeartifact-ci

```

### Install Dependencies

```bash
bashCopy code
npm install

```

### Configure AWS CLI

```bash
bashCopy code
aws configure

```

### Set Up Terraform

```bash
bashCopy code
terraform init
terraform apply

```

## Project Structure

```
plaintextCopy code
my-typescript-package/
├── src/
│   └── index.ts
├── package.json
├── tsconfig.json
├── .npmrc
└── README.md

```

## Configuration Files

### `package.json`

Ensure your `package.json` includes the necessary scripts and dependencies for TypeScript:

```json
jsonCopy code
{
  "name": "my-typescript-package",
  "version": "1.0.0",
  "description": "A sample TypeScript NPM package",
  "main": "lib/index.js",
  "types": "lib/index.d.ts",
  "scripts": {
    "build": "tsc",
    "prepublishOnly": "npm run build",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Your Name",
  "license": "MIT",
  "devDependencies": {
    "typescript": "^4.0.0"
  }
}

```

### `tsconfig.json`

Configure TypeScript with the following settings:

```json
jsonCopy code
{
  "compilerOptions": {
    "outDir": "./lib",
    "rootDir": "./src",
    "target": "ES5",
    "module": "commonjs",
    "declaration": true,
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true},
  "include": ["src/**/*"]
}

```

### `.npmrc`

Configure npm to use the public registry by default and AWS CodeArtifact for scoped packages:

```
plaintextCopy code
# Use the public npm registry for all packages by default
registry=https://registry.npmjs.org/

# Use AWS CodeArtifact for your scoped packages
@lib.setup:registry=https://aws_codeartifact_pipeline-171538455264.d.codeartifact.us-east-2.amazonaws.com/npm/lib.setup/
//aws_codeartifact_pipeline-171538455264.d.codeartifact.us-east-2.amazonaws.com/npm/lib.setup/:always-auth=true
//aws_codeartifact_pipeline-171538455264.d.codeartifact.us-east-2.amazonaws.com/npm/lib.setup/:_authToken=${CODEARTIFACT_AUTH_TOKEN}

```

## CI/CD Pipeline

The GitHub Actions workflow automates the build and deployment process. Key steps include:

1. **Checkout Repository**: Use `actions/checkout@v2`.
2. **Set up Node.js**: Use `actions/setup-node@v3` with Node.js version `20.14.0`.
3. **Configure AWS Credentials**: Use `aws-actions/configure-aws-credentials@v1`.
4. **Get CodeArtifact Auth Token**: Run AWS CLI command to get the token.
5. **Create Custom `.npmrc`**: Configure npm to use CodeArtifact.
6. **Install Dependencies**: Use npm to install dependencies.
7. **Run Tests**: Execute tests.
8. **Build the Project**: Compile TypeScript code.
9. **Publish to CodeArtifact**: Publish the package if all steps succeed.

## AWS Integration

### Terraform Configuration

This configuration sets up the AWS CodeArtifact domain and repository:

```
hclCopy code
provider "aws" {
  region = "us-east-2"
}

resource "aws_codeartifact_domain" "aws_codeartifact_pipeline_domain" {
  domain = "aws_codeartifact_pipeline"
}

resource "aws_codeartifact_repository" "aws_codeartifact_pipeline_repo" {
  repository = "aws_codeartifact_pipeline"
  domain     = aws_codeartifact_domain.aws_codeartifact_pipeline_domain.domain
}

output "domain_name" {
  value = aws_codeartifact_domain.aws_codeartifact_pipeline_domain.domain
}

output "repository_name" {
  value = aws_codeartifact_repository.aws_codeartifact_pipeline_repo.repository
}

output "repository_endpoint" {
  value = aws_codeartifact_repository.aws_codeartifact_pipeline_repo.repository_endpoint
}

```

### AWS CLI Commands

### Get Authorization Token

```bash
bashCopy code
aws codeartifact get-authorization-token --domain aws_codeartifact_pipeline --domain-owner <AWS_ACCOUNT_ID> --query authorizationToken --output text

```

### Configure npm

```bash
bashCopy code
aws codeartifact login --tool npm --domain aws_codeartifact_pipeline --domain-owner <AWS_ACCOUNT_ID> --repository aws_codeartifact_pipeline

```

## Additional Resources

- **AWS EC2**: Consider using AWS EC2 instances to host your applications.
- **GitHub Actions Documentation**: [GitHub Actions](https://docs.github.com/en/actions)
- **Terraform Documentation**: Terraform
- **AWS CodeArtifact Documentation**: [AWS CodeArtifact](https://docs.aws.amazon.com/codeartifact/latest/ug/welcome.html)

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.