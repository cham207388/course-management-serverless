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
terraform plan 
terraform apply --auto-approve

# ───────────────────────────────────────────────
# 📤 Extract Outputs to Variables
# ───────────────────────────────────────────────
echo "📦 Extracting Terraform outputs..."
BUCKET_NAME=$(terraform output -raw frontend_bucket)
CLOUDFRONT_DIST_ID=$(terraform output -raw cloudfront_distribution_id)
COGNITO_USER_POOL_ID=$(terraform output -raw cognito_user_pool_id)
COGNITO_CLIENT_ID=$(terraform output -raw cognito_user_pool_client_id)
COGNITO_REGION=$(terraform output -raw aws_region)
COGNITO_DOMAIN_URL=$(terraform output -raw cognito_domain_url)
COGNITO_ISSUER_URL=$(terraform output -raw cognito_authorizer_issuer_url)
API_URL="$(terraform output -raw course_backend_url)/api/v2"
cd ..

# ───────────────────────────────────────────────
# ⚙️ Inject to React App .env
# ───────────────────────────────────────────────
echo "📄 Injecting environment variables into frontend .env..."
cat <<EOF > web-s3/.env
VITE_COGNITO_USER_POOL_ID=$COGNITO_USER_POOL_ID
VITE_COGNITO_CLIENT_ID=$COGNITO_CLIENT_ID
VITE_COGNITO_REGION=$COGNITO_REGION
VITE_COGNITO_DOMAIN_URL=$COGNITO_DOMAIN_URL
VITE_COGNITO_ISSUER_URL=$COGNITO_ISSUER_URL
VITE_API_URL=$API_URL
EOF

cat web-s3/.env

# ───────────────────────────────────────────────
# 🧪 Install & Build Frontend
# ───────────────────────────────────────────────
echo "⚙️ Building React frontend with Vite..."
cd web-s3
npm install
npm run build
cd ..

# ───────────────────────────────────────────────
# ☁️ Upload Frontend to S3
# ───────────────────────────────────────────────
echo "☁️ Uploading frontend to S3: $BUCKET_NAME"
aws s3 sync web-s3/dist s3://$BUCKET_NAME --delete

# ───────────────────────────────────────────────
# 🚀 Invalidate CloudFront Cache
# ───────────────────────────────────────────────
echo "🧹 Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
  --distribution-id $CLOUDFRONT_DIST_ID \
  --paths "/*"

echo "✅ Deployment complete!"