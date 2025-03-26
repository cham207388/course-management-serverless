# Course Management

- [Course Management](#course-management)
  - [Backend](#backend)
  - [Frontend](#frontend)
  - [DevOps](#devops)
    - [Terraform](#terraform)
    - [GitHub Actions](#github-actions)


Course management allows users to management the courses they want to enroll in.

## Backend

The backend is written in Java and Spring boot 3 using aws serverless springboot3 archetype.

This is then transform as serverless using

- AWS Lambda
- Api Gateway
- DynamoDB
- Route53
- Certificate Manager

[backend](./backend-ald/README.md)

## Frontend

A React project created using vite

[README.md](./web-s3/README.md)

## DevOps

### Terraform

I use terraform to create all the following AWS services except Certificates and Route53 domain

- Cloudfront
- S3
- Api Gateway
- Lambda
- DynamoDB

### GitHub Actions

There are two workflows

- main
  - builds the frontend
  - builds the backend
  - deploys the application
- destroy
  - destroys the infrastructure