package com.abc.serverless.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {

private static final List<String> ALLOWED_ORIGINS = List.of("https://course.alhagiebaicham.com", "http://localhost:5173", "http://localhost:5174");

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.setAllowedOrigins(ALLOWED_ORIGINS);
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(List.of(
            "Authorization",
            "Content-Type",
            "X-Amz-Date",
            "X-Api-Key",
            "X-Amz-Security-Token",
            "Accept",
            "Origin",
            "X-Requested-With"
        ));
        config.setExposedHeaders(List.of(
            "Authorization",
            "Content-Type",
            "Access-Control-Allow-Origin",
            "Access-Control-Allow-Credentials"
        ));
        config.setMaxAge(7200L); // Cache preflight response for 2 hours

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}

// NOTE: For AWS API Gateway, CORS headers must be set at the gateway level for preflight and error responses.
// This config is still useful for local/dev and Lambda-invoked requests.
