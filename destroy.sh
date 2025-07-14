#!/bin/bash

set -euo pipefail

echo "🌍 Starting destruction..."

# ───────────────────────────────────────────────
# 📦 Build Backend with Maven (Java 21)
# ───────────────────────────────────────────────
echo "🔨 Building Spring Boot backend..."
cd backend-ald
mvn clean package -DskipTests
cd ..

# ───────────────────────────────────────────────
# 🧱 Terraform Destroy
# ───────────────────────────────────────────────
echo "🌱 Destroying infrastructure with Terraform..."
cd terraform
terraform init --upgrade
terraform validate
terraform destroy -auto-approve
cd ..

echo "✅ Destruction complete!"
