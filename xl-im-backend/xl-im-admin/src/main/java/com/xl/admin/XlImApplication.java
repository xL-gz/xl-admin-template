package com.xl.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.Environment;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * XL即时通讯系统启动类
 */
@SpringBootApplication(scanBasePackages = "com.xl")
@MapperScan("com.xl.system.mapper")
public class XlImApplication {
    
    public static void main(String[] args) throws UnknownHostException {
        // 显式设置激活的profile
        SpringApplication app = new SpringApplication(XlImApplication.class);
        // 如果未指定profile，默认使用dev
        String activeProfile = System.getProperty("spring.profiles.active");
        if (activeProfile == null || activeProfile.isEmpty()) {
            activeProfile = System.getenv("SPRING_PROFILES_ACTIVE");
            if (activeProfile == null || activeProfile.isEmpty()) {
                activeProfile = "dev";
            }
        }
        app.setAdditionalProfiles(activeProfile);
        
        ConfigurableApplicationContext application = app.run(args);
        Environment env = application.getEnvironment();
        String ip = InetAddress.getLocalHost().getHostAddress();
        String port = env.getProperty("server.port");
        String path = env.getProperty("server.servlet.context-path", "");
        
        System.out.println("=================================");
        System.out.println("XL即时通讯系统启动成功！");
        System.out.println("访问地址: http://" + ip + ":" + port + path);
        System.out.println("=================================");
    }
}