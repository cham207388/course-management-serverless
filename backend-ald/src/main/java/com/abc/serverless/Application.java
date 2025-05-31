package com.abc.serverless;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

import com.abc.serverless.controller.PingController;

import jakarta.annotation.PostConstruct;


@SpringBootApplication
@Import({ PingController.class })
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
    
    @PostConstruct
    public void init() {
    System.out.println("Application started post construct");
    }
}