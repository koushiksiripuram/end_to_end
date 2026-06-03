# End-to-End DevOps Automation for Ghost CMS

A production-style DevOps project demonstrating Infrastructure as Code (IaC), CI/CD automation, containerized deployment, HTTPS configuration, monitoring, and alerting on AWS.

## Project Overview

This project automates the complete lifecycle of a Ghost CMS application from source code commit to production deployment.

The solution uses Terraform to provision infrastructure, Jenkins to orchestrate CI/CD workflows, Docker to containerize services, Nginx as a reverse proxy, and AWS CloudWatch with SNS for operational monitoring and alerting.

The objective is to create a reproducible, automated deployment platform that minimizes manual intervention and follows modern DevOps practices.

---

## Architecture

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Webhook
    │
    ▼
Jenkins Pipeline
    │
    ├── Build Docker Image
    ├── Push Image to Docker Hub
    ├── Terraform Plan
    ├── Terraform Apply
    └── Deploy to EC2
               │
               ▼
        AWS EC2 Instance
               │
     ┌─────────┼─────────┐
     ▼         ▼         ▼
   Nginx     Ghost     MySQL
     │
     ▼
Let's Encrypt SSL

CloudWatch ───► SNS ───► Email Alerts
```
--
---

## Features

* Infrastructure as Code using Terraform
* Automated CI/CD using Jenkins
* Dockerized application deployment
* Docker Hub image registry integration
* Nginx reverse proxy configuration
* HTTPS using Let's Encrypt certificates
* Persistent application and database storage
* Automated EC2 provisioning
* CloudWatch monitoring
* SNS email notifications
* Terraform remote state management
* Automated health verification

---

## Repository Structure

```text
.
├── app/
│   ├── Dockerfile
│
├── docker/
│   ├── docker-compose.yaml
│   ├── nginx/
│   │   └── nginx.conf
│
├── terraform/
│   ├── backend.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── ec2.tf
│   ├── security_group.tf
│   ├── cloudwatch.tf
│   ├── sns.tf
│   └── outputs.tf
│
├── jenkins/
│   └── Jenkinsfile
│
├── docs/
│
└── README.md
```

---

## Prerequisites

Before deployment, ensure the following are available:

* AWS Account
* Docker
* Terraform
* Jenkins
* AWS CLI
* Docker Hub Account
* GitHub Repository
* Domain Name or DuckDNS Domain

---

## Configure AWS

```bash
aws configure
```

---

## Initialize Terraform

```bash
cd terraform

terraform init

terraform plan

terraform apply
```

---

## Build Docker Image

```bash
docker build \
-f app/Dockerfile \
-t koushiksiripuram/ghost-app:latest .
```

---

## Push Docker Image

```bash
docker login

docker push koushiksiripuram/ghost-app:latest
```

---

## Jenkins Configuration

Configure the following environment variables inside Jenkins:

```text
EC2_HOST=<elastic-ip>
S3_BUCKET=<bucket-name>
```

Configure Docker Hub credentials:

```text
Credential ID:
dockerhub-creds
```

---

## Deployment Process

1. Push code to GitHub.
2. GitHub triggers Jenkins through a webhook.
3. Jenkins builds a new Docker image.
4. Jenkins pushes the image to Docker Hub.
5. Terraform validates infrastructure state.
6. Terraform provisions or updates AWS resources.
7. Jenkins downloads deployment artifacts from S3.
8. Jenkins connects to EC2 through SSH.
9. Docker Compose pulls the latest image.
10. Containers are recreated.
11. Health checks validate deployment success.

---

## Monitoring and Alerting

CloudWatch alarms monitor:

* EC2 Status Checks
* High CPU Utilization

SNS subscriptions send email notifications whenever alarms are triggered.

---

## Data Persistence

Application content and database data are preserved using Docker volumes.

```text
ghost_data
mysql_data
```

SSL certificates are backed up to Amazon S3 and restored during deployment.

---

## Troubleshooting

### Check Running Containers

```bash
docker ps
```

### View Ghost Logs

```bash
docker logs ghost-app
```

### View Nginx Logs

```bash
docker logs ghost-nginx
```

### Verify Application

```bash
curl -Ik https://ghostapp.duckdns.org
```

### Verify Terraform State

```bash
terraform state list
```

---

## Challenges Solved

* Docker networking issues causing 502 Bad Gateway errors
* SSL certificate persistence across instance recreation
* Jenkins integration with Docker daemon
* Terraform remote state locking
* Dynamic infrastructure provisioning
* Persistent storage management
* Automated container deployment
* CloudWatch and SNS integration


---

## Author

Koushik Siripuram

Cloud | DevOps | AWS | Docker | Terraform | Jenkins
