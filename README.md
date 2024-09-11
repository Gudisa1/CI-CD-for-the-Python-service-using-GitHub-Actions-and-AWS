
# Build and Push Docker Image to AWS ECR

This project automates the process of building a Docker image from the current repository, scanning it for vulnerabilities, pushing it to Amazon Elastic Container Registry (ECR), and deploying it to an Amazon EC2 instance using GitHub Actions.

## Table of Contents

- [Overview](#overview)
- [Workflow Features](#workflow-features)
- [Pre-requisites](#pre-requisites)
- [Setting up GitHub Secrets](#setting-up-github-secrets)
- [How It Works](#how-it-works)
  - [SonarCloud Scan](#sonarcloud-scan)
  - [Versioning](#versioning)
  - [Docker Image Build and Push](#docker-image-build-and-push)
  - [Snyk Security Scan](#snyk-security-scan)
  - [EC2 Deployment](#ec2-deployment)
- [Usage](#usage)
- [License](#license)

## Overview

This project focuses on a CI/CD pipeline using GitHub Actions for building, testing, scanning, and deploying Docker containers. The pipeline includes quality checks like SonarCloud and Snyk for static code and vulnerability scans, ensuring high code standards before deployment.

Key steps include:
- Building a Docker image.
- Pushing the image to AWS ECR.
- Deploying the Docker container on an EC2 instance.

## Workflow Features

1. **Automated Docker Image Build**: Automatically builds the Docker image whenever there’s a push to the `development` branch.
2. **SonarCloud Code Quality Check**: Ensures the codebase passes quality gates before the image build.
3. **Version Tagging**: Dynamically determines the next version based on existing tags and increments the patch version.
4. **Docker Vulnerability Scan**: Uses Snyk to check for high-severity vulnerabilities in the Docker image.
5. **Automated Deployment**: Deploys the Docker image to an EC2 instance via SSH, utilizing Docker Compose.

## Pre-requisites

- An AWS account with access to ECR and EC2.
- Docker installed on the EC2 instance.
- GitHub repository with the appropriate AWS credentials stored as secrets.

## Setting up GitHub Secrets

You need to add the following secrets to your GitHub repository to allow the GitHub Actions workflow to access AWS and other services:

- `AWS_ACCESS_KEY_ID`: Your AWS access key.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
- `SONAR_TOKEN`: SonarCloud authentication token.
- `SYNC_TOKEN`: Snyk API token for Docker image scanning.
- `GITHUB_TOKEN`: Automatically provided by GitHub, but needs to be referenced.
- `EC2_PEM_KEY`: Your EC2 private key to SSH into the instance.
- `EC2_HOST`: The EC2 public IP address or domain name.
- `EC2_USER`: The EC2 instance username (usually `ubuntu` for Ubuntu AMIs).

## How It Works

### SonarCloud Scan

This step scans the code for bugs, code smells, and security vulnerabilities using SonarCloud. The scan connects to a pre-configured SonarCloud account and stops the workflow if any issues are detected.

### Versioning

The workflow determines the next version of the application by analyzing existing tags in the repository. It follows the SemVer convention (e.g., v1.0.1). If no tags exist, it starts with `v0.0.0` and increments the patch version.

### Docker Image Build and Push

The Docker image is built from the repository’s Dockerfile. The built image is then tagged with the new version and pushed to the configured AWS ECR repository.

### Snyk Security Scan

Before pushing the Docker image to ECR, it’s scanned for vulnerabilities using Snyk. The scan will halt the workflow if any high-severity vulnerabilities are detected.

### EC2 Deployment

The Docker image is deployed on an EC2 instance using Docker Compose. The workflow logs into the EC2 instance via SSH, pulls the Docker image from ECR, and runs the container using `docker-compose.yml`.

## Usage

### Triggering the Workflow

To trigger the workflow:
1. Make sure to push your changes to the `development` branch. The GitHub Actions workflow will automatically start, building and deploying the Docker image.
2. Monitor the Actions tab in your GitHub repository for progress and logs.

### Updating the Workflow

If you need to change the deployment or add new environment variables:
1. Update the GitHub Actions YAML file (`.github/workflows/docker-build-push.yml`).
2. Commit and push the changes to trigger the updated workflow.

