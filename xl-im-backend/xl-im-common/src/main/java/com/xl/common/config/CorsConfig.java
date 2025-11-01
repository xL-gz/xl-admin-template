package com.xl.common.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

/**
 * CORS跨域配置
 * 允许前端跨域访问后端API
 * 配置从 application-{profile}.yml 中读取
 */
@Slf4j
@Configuration
public class CorsConfig {
    
    @Bean
    @ConfigurationProperties(prefix = "cors")
    public CorsProperties corsProperties() {
        return new CorsProperties();
    }
    
    @Bean
    public CorsFilter corsFilter(CorsProperties corsProperties) {
        log.info("初始化CORS配置: {}", corsProperties);
        
        CorsConfiguration config = new CorsConfiguration();
        
        // 从配置文件读取允许的源
        // 注意：Spring Boot 2.4+ 中，当 allowCredentials=true 时，必须使用 addAllowedOriginPattern
        // 而不是 addAllowedOrigin
        List<String> allowedOrigins = corsProperties.getAllowedOrigins();
        if (allowedOrigins != null && !allowedOrigins.isEmpty()) {
            allowedOrigins.forEach(config::addAllowedOriginPattern);
        }
        
        // 从配置文件读取允许的方法
        List<String> allowedMethods = corsProperties.getAllowedMethods();
        if (allowedMethods != null && !allowedMethods.isEmpty()) {
            allowedMethods.forEach(config::addAllowedMethod);
        } else {
            config.addAllowedMethod("*");
        }
        
        // 从配置文件读取允许的请求头
        String allowedHeaders = corsProperties.getAllowedHeaders();
        if (allowedHeaders != null) {
            config.addAllowedHeader(allowedHeaders);
        } else {
            config.addAllowedHeader("*");
        }
        
        // 是否允许携带Cookie
        config.setAllowCredentials(corsProperties.isAllowCredentials());
        
        // 预检请求的有效期（秒）
        config.setMaxAge(corsProperties.getMaxAge());
        
        // 注册CORS配置
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        
        return new CorsFilter(source);
    }
    
    /**
     * CORS配置属性类
     */
    public static class CorsProperties {
        private List<String> allowedOrigins;
        private List<String> allowedMethods;
        private String allowedHeaders = "*";
        private boolean allowCredentials = true;
        private Long maxAge = 3600L;
        
        public List<String> getAllowedOrigins() {
            return allowedOrigins;
        }
        
        public void setAllowedOrigins(List<String> allowedOrigins) {
            this.allowedOrigins = allowedOrigins;
        }
        
        public List<String> getAllowedMethods() {
            return allowedMethods;
        }
        
        public void setAllowedMethods(List<String> allowedMethods) {
            this.allowedMethods = allowedMethods;
        }
        
        public String getAllowedHeaders() {
            return allowedHeaders;
        }
        
        public void setAllowedHeaders(String allowedHeaders) {
            this.allowedHeaders = allowedHeaders;
        }
        
        public boolean isAllowCredentials() {
            return allowCredentials;
        }
        
        public void setAllowCredentials(boolean allowCredentials) {
            this.allowCredentials = allowCredentials;
        }
        
        public Long getMaxAge() {
            return maxAge;
        }
        
        public void setMaxAge(Long maxAge) {
            this.maxAge = maxAge;
        }
        
        @Override
        public String toString() {
            return "CorsProperties{" +
                    "allowedOrigins=" + allowedOrigins +
                    ", allowedMethods=" + allowedMethods +
                    ", allowedHeaders='" + allowedHeaders + '\'' +
                    ", allowCredentials=" + allowCredentials +
                    ", maxAge=" + maxAge +
                    '}';
        }
    }
}

