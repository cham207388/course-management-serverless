package com.abc.serverless.security;

import org.springframework.stereotype.Service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class SecurityService {

    public String extractUsernameFromToken(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring("Bearer ".length());
            DecodedJWT jwt = JWT.decode(token);

            // Standard claim from Cognito
            return jwt.getClaim("email").asString();
        }
        return "anonymous";
    }
}
