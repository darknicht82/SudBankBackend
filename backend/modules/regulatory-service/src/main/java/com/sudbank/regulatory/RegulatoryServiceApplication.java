package com.sudbank.regulatory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class RegulatoryServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(RegulatoryServiceApplication.class, args);
    }
} 