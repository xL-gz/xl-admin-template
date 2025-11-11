package com.xl.common.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

/**
 * Web MVC配置类
 * 配置静态资源映射
 */
@Slf4j
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Value("${file.upload.path:./uploads}")
    private String uploadPath;
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 处理上传文件的访问路径
        // 将 /uploads/** 映射到实际的文件存储路径
        
        // 获取绝对路径
        String absolutePath = getAbsolutePath(uploadPath);
        
        log.info("配置静态资源映射: /uploads/** -> {}", absolutePath);
        
        // 添加资源处理器
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absolutePath + File.separator);
    }
    
    /**
     * 获取绝对路径
     */
    private String getAbsolutePath(String path) {
        if (path == null || path.isEmpty()) {
            path = "./uploads";
        }
        
        // 如果已经是绝对路径，直接返回
        File file = new File(path);
        if (file.isAbsolute()) {
            return file.getAbsolutePath();
        }
        
        // 如果是相对路径，转换为绝对路径
        String baseDir = System.getProperty("user.dir");
        File absoluteFile = new File(baseDir, path);
        
        // 确保目录存在
        if (!absoluteFile.exists()) {
            absoluteFile.mkdirs();
        }
        
        return absoluteFile.getAbsolutePath();
    }
}

