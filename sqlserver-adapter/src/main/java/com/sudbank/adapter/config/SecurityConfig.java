package com.sudbank.adapter.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeRequests()
                // Endpoints públicos (sin autenticación)
                .antMatchers("/actuator/**").permitAll()
                .antMatchers("/api/regulatory/health").permitAll()
                .antMatchers("/api/regulatory/l08/**").permitAll()
                // Todos los demás endpoints requieren autenticación
                .anyRequest().authenticated()
            .and()
            .httpBasic()
            .and()
            .cors();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
} 