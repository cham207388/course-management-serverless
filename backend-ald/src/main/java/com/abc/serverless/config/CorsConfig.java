// package com.abc.serverless.config;

// import java.util.List;

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.web.cors.CorsConfiguration;
// import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
// import org.springframework.web.filter.CorsFilter;

// @Configuration
// public class CorsConfig {

//     private static final List<String> ALLOWED_ORIGINS = List.of(
//             "http://localhost:5173",
//             "https://course.alhagiebaicham.com"
//     );

//     @Bean
//     public CorsFilter corsFilter() {
//         CorsConfiguration config = new CorsConfiguration();
//         config.setAllowCredentials(true);
//         config.setAllowedOrigins(ALLOWED_ORIGINS);
//         config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
//         config.setAllowedHeaders(List.of("Authorization", "Content-Type", "X-Amz-Date",
//                 "X-Api-Key", "X-Amz-Security-Token"));
//         config.setExposedHeaders(List.of("Authorization", "Content-Type"));
//         config.setMaxAge(3600L); // Cache preflight response for 1 hour

//         UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//         source.registerCorsConfiguration("/**", config);

//         return new CorsFilter(source);
//     }
// }
