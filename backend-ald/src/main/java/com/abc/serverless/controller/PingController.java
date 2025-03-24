package com.abc.serverless.controller;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;


@RestController
@EnableWebMvc
public class PingController {
    @GetMapping(path = "/ping")
    public Map<String, String> ping() {
        Map<String, String> ping = new HashMap<>();
        ping.put("pong", "Hello, World!");
        return ping;
    }

    @GetMapping("/checking")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("API is running at " + Instant.now());
    }
}
