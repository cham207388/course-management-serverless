#!/bin/bash

set -euo pipefail

echo "🌍 Starting Full Local Deployment..."

# ───────────────────────────────────────────────
# 📦 Build Backend with Maven (Java 21)
# ───────────────────────────────────────────────
echo "🔨 Building Spring Boot backend..."
cd backend-ald
mvn clean package -DskipTests
cd ..

# ───────────────────────────────────────────────
# 🧱 Terraform Init + Plan + Apply
# ───────────────────────────────────────────────
echo "🌱 Deploying infrastructure with Terraform..."
cd terraform
terraform init --upgrade
terraform validate
terraform destroy -auto-approve
