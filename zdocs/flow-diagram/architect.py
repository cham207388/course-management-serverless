from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import Lambda
from diagrams.aws.network import APIGateway, CloudFront, Route53
from diagrams.aws.database import Dynamodb
from diagrams.aws.security import Cognito, ACM
from diagrams.aws.storage import S3
from diagrams.onprem.client import Users

with Diagram("🏫 Course Management System (AWS Serverless)", show=False, filename="course-architecture", outformat="png", direction="LR"):
    
    user = Users("👤 User")

    with Cluster("🌐 Frontend (course.alhagiebaicham.com)"):
        dns_frontend = Route53("Route53 A Record")
        cdn = CloudFront("CloudFront CDN")
        frontend = S3("React (Vite) App")

        dns_frontend >> cdn >> frontend
        user >> Edge(label="1. GET HTML/JS") >> cdn
        frontend >> Edge(style="dashed", label="2. Return SPA") >> user

    with Cluster("☁️ Backend (coursebe.alhagiebaicham.com)"):
        dns_backend = Route53("Route53 A Record")
        cert = ACM("ACM TLS\n(us-east-1)")
        cognito = Cognito("Cognito User Pool\nHosted UI + JWT")
        gateway = APIGateway("API Gateway\n(Cognito Auth)")
        lambda_fn = Lambda("Spring Boot Lambda")
        db = Dynamodb("DynamoDB\nCourse Table")

        # Route53 & TLS
        dns_backend >> gateway
        gateway >> cert

        # Cognito Token Validation (JWT)
        user >> Edge(label="3. Bearer Token in Header") >> gateway
        gateway >> Edge(label="4. Validate JWT") >> cognito
        cognito >> Edge(style="dashed", label="5. AuthZ Success") >> gateway

        # Lambda processing
        gateway >> Edge(label="6. Authorized Request") >> lambda_fn
        lambda_fn >> db
        db >> Edge(style="dashed", label="7. Course Data") >> lambda_fn
        lambda_fn >> Edge(style="dashed", label="8. JSON Response") >> gateway
        gateway >> Edge(style="dashed", label="9. 200 OK") >> user