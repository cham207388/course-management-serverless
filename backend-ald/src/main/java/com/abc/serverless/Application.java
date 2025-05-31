package com.abc.serverless;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

import com.abc.serverless.controller.PingController;
import com.abc.serverless.config.CorsConfig;

import jakarta.annotation.PostConstruct;


@SpringBootApplication
// We use direct @Import instead of @ComponentScan to speed up cold starts
// @ComponentScan(basePackages = "com.abc.serverless.controller")
@Import({ PingController.class, CorsConfig.class })
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
    
    @PostConstruct
    public void init() {
    System.out.println("Application started post construct");
    }
}