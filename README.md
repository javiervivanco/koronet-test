# Koronet Web Server Project

## Table of Contents
- [Project Structure](#project-structure)
- [Overview](#overview)
  - [Makefile](#makefile)
  - [Docker Compose](#docker-compose)
  - [Jenkins Pipeline](#jenkins-pipeline)
  - [Terraform Configuration](#terraform-configuration)
  - [Kubernetes Configurations](#kubernetes-configurations)
  - [Web Server](#web-server)
  - [Monitoring Setup](#monitoring-setup)
- [Setup and Deployment](#setup-and-deployment)
  - [Prerequisites](#prerequisites)
  - [Building and Running Locally](#building-and-running-locally)

## Project Structure

```
.
├── docker-compose.yml
├── infra
│   ├── arch
│   ├── aws
│   ├── Jenkinsfile
│   └── k8s
│       ├── base
│       └── overlays
│           ├── dev
│           ├── prod
│           └── stg
├── Makefile
├── README.md
└── webserver
    ├── Dockerfile
    └── test
```

## Overview

### Makefile

The `Makefile` includes commands to streamline Docker operations within the development environment. Key targets include:

- `shell`: Start an interactive shell session inside a Docker container.
- `build`: Build Docker images specified in `docker-compose.yml`.
- `start`: Start the services defined in `docker-compose.yml`.

### Docker Compose

The `docker-compose.yml` defines a multi-service setup with three primary services: `webserver`, `db`, and `redis`. It includes a custom network (`koronet`) and persistent volumes for data storage.

### Jenkins Pipeline

The Jenkins pipeline script automates the process of building, testing, pushing, and deploying a Dockerized web server application. It includes stages for:

- Checking out the latest code.
- Building the Docker image.
- Running tests.
- Pushing the image to Docker Hub.
- Deploying to Kubernetes.

### Terraform Configuration

The Terraform configuration manages an AWS EKS cluster, including:

- Infrastructure setup (`main.tf`, `net.tf`, `eks.tf`)
- IAM roles and policies (`version.tf`)
- Outputs for cluster interaction (`out.tf`)
- Variables for configuration (`vars.tf`)

### Kubernetes Configurations

Kubernetes YAML files for deployment, service, ingress, and configuration management are included under the `infra/k8s` directory. These files define:

- Deployments and services for webserver and Redis.
- Ingress for managing external access.
- ConfigMaps for environment-specific configurations.
- Kustomize files for environment overlays (`dev`, `prod`, `stg`).

### Web Server

The web server provides two main routes:

- The root route (`/`) serves an HTML page displaying a greeting and visit counts, incrementing counters in PostgreSQL and Redis.
- The `/visits` route returns a JSON object with the current visit counts without incrementing them.

To access the web server, open your browser and navigate to `http://localhost:8000`.

### Monitoring Setup

The project includes a monitoring architecture with Prometheus and Grafana. Refer to `infra/arch/monitoring.puml` for the architecture diagram and follow the respective setup instructions for Prometheus and Grafana.

![monitorin](http://www.plantuml.com/plantuml/png/LT3FQi9040Rm-pp5uDqNwA4OpH-XQAKjz11wc2IZXYRPCBEHGl7TkunnfNlyVTzCXgpKa_Yfxs2a-fjEZ8kNgM8PsBFYfflKiopm5p2yM4d6iMjhygqRyE0QdGlsoa-ky9tbmlA5f9WyaZTkMZLS6rx1UEyQnkndTEBdcGqy-l-Jz9OSnFNippofQNRJGkX80ndbS8KowLWyxeATvla2ofGlhwFY1rDlj0L8SBbynWoVx6FAYc6xjBN2sf8q9BjPDh5hTz-BQMIxEdfcdiS5Toc2s7aAkS4sG4fwhXn9er14t3lV7kU_hR3YePdwxWy0)


## Setup and Deployment

### Prerequisites

Before you start, make sure you have the following tools installed:

- Docker
- Docker Compose
- Kubernetes CLI (`kubectl`)
- AWS CLI
- Terraform
- Jenkins

### Building and Running Locally

1. Build the Docker images:
   ```sh
   docker-compose build
   ```

2. Start the services:
   ```sh
   docker-compose up
   ```

Alternatively, you can use the `Makefile`:

3. Start the services using Makefile:
   ```sh
   make start
   ```

Now, your web server should be running and accessible at `http://localhost:8000`.
