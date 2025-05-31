// ✅ Centralized Cognito Config
export const cognitoConfig = {
  region: import.meta.env.VITE_COGNITO_REGION,
  userPoolId: import.meta.env.VITE_COGNITO_USER_POOL_ID,
  clientId: import.meta.env.VITE_COGNITO_CLIENT_ID,
  domain: import.meta.env.VITE_COGNITO_DOMAIN_URL,
  issuer: import.meta.env.VITE_COGNITO_ISSUER_URL,
};
