from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import Lambda
from diagrams.aws.network import APIGateway, CloudFront, Route53
from diagrams.aws.database import Dynamodb
from diagrams.aws.security import Cognito, ACM
from diagrams.aws.storage import S3
from diagrams.onprem.client import Users

with Diagram(
    "📘 Course Management System (AWS Serverless)",
    show=False,
    filename="course-architecture",
    outformat="png",
    direction="LR"
):

    # 💡 Trick to force user to the left using a dummy cluster
    with Cluster("👤 User"):
        user = Users("User\n(browser)")

    # ----- Frontend -----
    with Cluster("Frontend\n(course.alhagiebaicham.com)"):
        dns_frontend = Route53("Route53\nA Record")
        cdn = CloudFront("CloudFront\nCDN")
        frontend = S3("React (Vite) App")

        dns_frontend >> cdn >> frontend

    # ----- Backend -----
    with Cluster("Backend\n(coursebe.alhagiebaicham.com)"):
        dns_backend = Route53("Route53\nA Record")
        api_gateway = APIGateway("API Gateway\n(Cognito Auth)")
        lambda_fn = Lambda("Spring Boot Lambda")
        db = Dynamodb("DynamoDB\nCourse Table")
        cert = ACM("ACM TLS\nus-east-1")
        cognito = Cognito("Cognito User Pool\nHosted UI + JWT")

        # Domain + TLS setup
        dns_backend >> api_gateway
        api_gateway >> cert

        # Cognito Auth
        api_gateway >> Edge(label="4. Validate JWT") >> cognito
        cognito >> Edge(label="5. AuthZ Success", style="dashed") >> api_gateway

        # Lambda & DB
        api_gateway >> Edge(label="6. Authorized Request") >> lambda_fn
        lambda_fn >> Edge(label="7. Course Data") >> db
        db >> Edge(label="8. DB Response", style="dashed") >> lambda_fn
        lambda_fn >> Edge(label="9. Lambda Response", style="dashed") >> api_gateway
        api_gateway >> Edge(label="10. 200 OK", style="dashed") >> user

    # ----- End-to-End User Flow -----
    user >> Edge(label="1. GET HTML/JS") >> dns_frontend
    frontend >> Edge(label="2. Return SPA", style="dashed") >> user
    user >> Edge(label="3. Bearer Token in Header") >> api_gateway