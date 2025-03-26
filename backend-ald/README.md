# Serverless Spring Boot 3 + AWS (Lambda, API Gateway, DynamoDB, Terraform Custom Domain)

- [Serverless Spring Boot 3 + AWS (Lambda, API Gateway, DynamoDB, Terraform Custom Domain)](#serverless-spring-boot-3--aws-lambda-api-gateway-dynamodb-terraform-custom-domain)
  - [Summary of Components](#summary-of-components)
  - [Step-by-Step Architecture and Dependency Flow](#step-by-step-architecture-and-dependency-flow)
    - [1️⃣ Spring Boot Application Setup](#1️⃣-spring-boot-application-setup)
      - [Project Structure](#project-structure)
      - [Dependencies:](#dependencies)
      - [Api Endpoints](#api-endpoints)
    - [2️⃣ Lambda Configuration (Terraform)](#2️⃣-lambda-configuration-terraform)
      - [✅ Lambda uses:](#-lambda-uses)
    - [3️⃣ API Gateway (Terraform)](#3️⃣-api-gateway-terraform)
    - [4️⃣ DynamoDB Table (Terraform)](#4️⃣-dynamodb-table-terraform)
    - [5️⃣ IAM Role for Lambda (Terraform)](#5️⃣-iam-role-for-lambda-terraform)
    - [6️⃣ ACM Certificate (Manual or Terraform)](#6️⃣-acm-certificate-manual-or-terraform)
    - [7️⃣ Route53 + Custom Domain Mapping](#7️⃣-route53--custom-domain-mapping)


A serverless RESTful API using Spring Boot 3, deployed to AWS Lambda behind API Gateway, storing data in DynamoDB, documented via Swagger, and exposed with a custom domain through Route 53 + ACM. All infrastructure is provisioned with Terraform.

## Summary of Components

| Component   | Purpose                                                                |
|-------------|------------------------------------------------------------------------|
| Spring Boot | REST API using Controllers, DTOs, and Service classes                  |
| AWS Lambda  | Hosts the application packaged as a ZIP from Maven build               |
| API Gateway | Acts as a frontend proxy for Lambda (ANY /{proxy+} integration)        |
| DynamoDB    | Serverless NoSQL database to persist Course data                       |
| Terraform   | Infrastructure as code for API Gateway, Lambda, DynamoDB, Route53, etc |
| ACM (Cert)  | SSL Certificate for dev.your.domain.com                                |
| Route 53    | DNS Zone hosting dev.your.domain.com as custom domain                  |


## Step-by-Step Architecture and Dependency Flow

### 1️⃣ Spring Boot Application Setup

| Task                                                      | Description                                                                                                                                                                                                                                                     |
|-----------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Generate Project using mvn archetype                      | ```mvn archetype:generate -DarchetypeGroupId=com.amazonaws.serverless.archetypes -DarchetypeArtifactId=aws-serverless-springboot3-archetype -DarchetypeVersion=2.1.2 -DgroupId=com.abc.serverless -DartifactId=backend-ald -Dversion=1.0.0 -DinteractiveMode=false``` |
| Create Controller, DTO, Service                           | Your app manages a Course with id, name, price fields                                                                                                                                                                                                           |
| Use DynamoDB Enhanced Client                              | You manually inject DynamoDbTable<Course> and manage data                                                                                                                                                                                                       |
| Enable Swagger UI                                         | springdoc-openapi renders docs at /swagger-ui                                                                                                                                                                                                                   |
| Package as ZIP for Lambda                                 | mvn clean package with maven-assembly-plugin or maven-shade-plugin to create:                                                                                                                                                                                   |
| target/spring-boot-lambda-1.0-SNAPSHOT-lambda-package.zip | lambda source                                                                                                                                                                                                                                                   |

#### Project Structure

```text
spring-boot-lambda/
├── src/
│   ├── assembly/
│   ├── main/
│       └── java/
│       └── resources/
│   ├── test/
├── target/
│   └── spring-boot-lambda-1.0-SNAPSHOT-lambda-package.zip 👈 Lambda zip
├── terraform/
│   ├── lambda.tf
│   ├── api-gateway.tf
│   ├── iam-permissions.tf
│   ├── dynamo-db.tf
│   └── route53.tf
├── pom.xml
└── README.md
└── Notes.md
```

#### Dependencies:
- Spring Boot → builds app logic → generates Lambda ZIP
- Swagger UI → embedded as static assets → served from Lambda
- Lambda uses the ZIP to execute API logic
- Terraform for IaC
- GitHub action for CI/CD

#### Api Endpoints

| Method | Path          | Description            |
|--------|---------------|------------------------|
| GET    | /courses      | List all courses       |
| GET    | /courses/{id} | Get course by ID       |
| POST   | /courses      | Add new course         |
| PUT    | /courses/{id} | Update existing course |
| DELETE | /courses/{id} | Delete course          |


### 2️⃣ Lambda Configuration (Terraform)

[Lambda Config](./terraform/lambda.tf)

#### ✅ Lambda uses:

- Your packaged Spring Boot zip
-  Role with DynamoDB + CloudWatch access

### 3️⃣ API Gateway (Terraform)

[Api Gateway](./terraform/api-gateway.tf)

| Task                            | Description                         |
|---------------------------------|-------------------------------------|
| Create REST API                 | aws_api_gateway_rest_api.course_api |
| Create {proxy+} resource        | Enables routing of all requests     |
| ANY method + Lambda proxy       | Forwards request to Lambda          |
| Create stage dev                | Maps the deployment                 |
| Deployment triggers on zip hash | Ensures redeploy on code change     |

- API Gateway → Proxies to Lambda
- Swagger UI is served as static content through API Gateway
- Stage name is dev
- Terraform can output base URL if needed

### 4️⃣ DynamoDB Table (Terraform)

[DynamoDB Table](./terraform/dynamodb.tf)

| Attribute | Type   | Key Type      |
|-----------|--------|---------------|
| id        | String | Partition Key |
| name      | String | Attribute     |
| price     | Number | Attribute     |

- Lambda can access DynamoDB via IAM
- @DynamoDbPartitionKey on getId() enables Enhanced Client mapping

### 5️⃣ IAM Role for Lambda (Terraform)

[IAM Config](./terraform/iam-permissions.tf)

- Least privilege policy for DynamoDB access
- CloudWatch logging enabled

### 6️⃣ ACM Certificate (Manual or Terraform)

ACM cert must be in us-east-1, even if your API is in another region.

[ACM in us-east-1](./terraform/acm.tf)

| Step                              | Description                                               |
|-----------------------------------|-----------------------------------------------------------|
| Request ACM cert in us-east-1     | Required for API Gateway custom domain                    |
| Use dev.your.domain.com as SAN    | Validates via Route53                                     |
| Once issued, use ARN in Terraform | acm_arn variable is passed to aws_api_gateway_domain_name |

### 7️⃣ Route53 + Custom Domain Mapping

[Route53](./terraform/route53.tf)

| Task                                     | Description                                     |
|------------------------------------------|-------------------------------------------------|
| Create aws_api_gateway_domain_name       | With your custom domain and cert                |
| Create aws_api_gateway_base_path_mapping | Links your REST API stage (dev) to domain       |
| Create aws_route53_record A alias        | Points to API Gateway's CloudFront distribution |

- [access your app](https://dev.your.domain.com/courses)
- [Swagger at](https://dev.your.domain.com/swagger-ui)