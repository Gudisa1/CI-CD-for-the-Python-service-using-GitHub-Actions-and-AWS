# Counter-Service CI/CD Project

This project demonstrates the creation of a simple Python service called `counter-service` with a CI/CD pipeline that deploys the service to an AWS EC2 instance. The CI/CD process uses **GitHub Actions**, **Docker**, **Amazon ECR**, and **AWS EC2**, with code quality and vulnerability checks from **SonarCloud** and **Snyk**.

The project was designed to illustrate DevOps best practices for deploying a Python application using GitHub Actions for Continuous Integration (CI) and Continuous Deployment (CD). It is a practical exercise for building DevOps skills.

## Project Overview

### Features:
- A **Python** web service that tracks the number of POST requests and responds to GET requests with the current count.
- **Dockerized** Python app for portability and reproducibility.
- CI pipeline that:
  - Runs on every push to the development branch.
  - Builds and pushes the Docker image to **Amazon ECR**.
  - Performs code analysis with **SonarCloud** and vulnerability scanning with **Snyk**.
- CD pipeline that:
  - Pulls the Docker image from **Amazon ECR**.
  - Deploys and runs the image on an **AWS EC2** instance using **docker-compose**.

### Technologies Used:
- **GitHub Actions**: CI/CD automation
- **Docker**: Containerization
- **Amazon ECR**: Private Docker image registry
- **AWS EC2**: Hosting the service
- **SonarCloud**: Code quality and security analysis
- **Snyk**: Security vulnerability scanning

## Prerequisites

To run and deploy this project, ensure you have the following set up:

- **GitHub** account
- **AWS** account
- **SonarCloud** account
- **Snyk** account
- **AWS CLI** installed and configured on the EC2 instance
- **Docker** and **docker-compose** installed on your local machine and EC2 instance

## Project Setup

### 1. Create and Clone Repository
1. Create a GitHub repository for the project and clone it locally.

### 2. Develop the Python Web Service
1. Create the `counter-service.py` file:
   - Handles GET and POST requests.
   - Persists the counter in a file using Docker volume.
2. Test locally by running `python counter-service.py` and accessing `http://127.0.0.1:8080`.

### 3. Dockerize the Application
1. Create a `Dockerfile` and `docker-compose.yml` for the service.
2. Build the Docker image using:
   ```bash
   docker build -t counter-service-local:1.0.0 .
   ```
3. Test the Docker container locally:
   ```bash
   docker run -p 8080:8080 counter-service-local:1.0.0
   ```

### 4. Deploy to AWS EC2
1. Create an Ubuntu EC2 instance.
2. Install Docker and AWS CLI on the instance.
3. Log in to Amazon ECR using the AWS CLI:
   ```bash
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
   ```

### 5. Push Code to GitHub
1. Push your code to a new branch in GitHub.
2. Set up **GitHub Actions** for the CI pipeline.

### 6. Continuous Integration (CI)
The CI process performs the following:
- Creates a new release based on semantic versioning.
- Builds the Docker image and pushes it to Amazon ECR.
- Runs SonarCloud and Snyk scans for code quality and vulnerabilities.

### 7. Continuous Deployment (CD)
The CD process:
- Connects to the EC2 instance via SSH.
- Pulls the Docker image from ECR.
- Deploys and runs the service using **docker-compose**.

## Dockerfile Example

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY counter-service.py .

EXPOSE 8080

CMD ["gunicorn", "counter-service:app", "--bind", "0.0.0.0:8080"]
```

## GitHub Actions CI/CD Workflow

The `.github/workflows` directory contains the CI/CD workflow configuration files. The key steps are:
1. Checkout code.
2. Build Docker image.
3. Push Docker image to ECR.
4. Run SonarCloud and Snyk scans.
5. Deploy the image to EC2 via SSH.

### CI Example Workflow (CI.yml)

```yaml
name: Build and Push Docker image to AWS ECR

on:
  push:
    branches:
      - development

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Check out the repo
      uses: actions/checkout@v2

    - name: SonarCloud Scan
      uses: SonarSource/sonarcloud-github-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}

    - name: Build Docker image
      run: |
        docker build -t counter-service-local:1.0.0 .

    - name: Push Docker image to ECR
      run: |
        docker push <account-id>.dkr.ecr.<region>.amazonaws.com/counter-service:latest
```


