package com.xl.common.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

/**
 * MongoDB配置类
 */
@Configuration
@EnableMongoRepositories(basePackages = "com.xl.system.repository")
public class MongoConfig {
    
}