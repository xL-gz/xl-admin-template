package com.xl.admin.controller;

import cn.dev33.satoken.stp.StpUtil;
import com.xl.system.entity.SystemConfig;
import com.xl.system.service.SystemConfigService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.List;

/**
 * 文件访问控制器
 * 处理 /uploads/** 路径的文件访问请求
 * 
 * 权限说明：
 * - 需要用户登录才能访问文件
 * - 已登录用户可以访问所有上传的文件
 */
@Slf4j
@RestController
@RequiredArgsConstructor
public class FileAccessController {
    
    @Value("${file.upload.path:./uploads}")
    private String defaultUploadPath;
    
    private final SystemConfigService systemConfigService;
    
    /**
     * 文件访问接口
     * 处理 /uploads/** 路径的文件访问请求
     * 
     * 权限控制：需要登录才能访问
     * 支持从URL参数或请求头中获取token
     */
    @GetMapping("/uploads/**")
    public ResponseEntity<Resource> getFile(HttpServletRequest request) {
        // 权限验证：检查用户是否登录
        // 支持从URL参数（token）或请求头（Authorization）中获取token
        try {
            // 优先从URL参数中获取token（用于图片标签的src请求）
            String tokenFromParam = request.getParameter("token");
            String token = null;
            
            if (tokenFromParam != null && !tokenFromParam.isEmpty()) {
                // 从URL参数获取token
                token = tokenFromParam;
            } else {
                // 从请求头获取token
                String authHeader = request.getHeader("Authorization");
                if (authHeader != null && !authHeader.isEmpty()) {
                    token = authHeader;
                }
            }
            
            // 验证token是否有效
            if (token == null || token.isEmpty()) {
                log.warn("未提供token，拒绝访问文件: {}", request.getRequestURI());
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
            
            // 通过token获取登录用户ID，如果token无效会抛出异常
            Object loginId = StpUtil.getLoginIdByToken(token);
            if (loginId == null) {
                log.warn("token无效，拒绝访问文件: {}", request.getRequestURI());
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
            
            // 获取当前登录用户ID（用于日志记录）
            Long userId = Long.parseLong(loginId.toString());
            log.debug("用户 {} 请求访问文件", userId);
            
        } catch (Exception e) {
            // token验证失败，返回401未授权
            log.warn("token验证失败，拒绝访问文件: {}，错误: {}", request.getRequestURI(), e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        try {
            // 从请求路径中提取文件路径
            // 例如：/uploads/image/2025/11/11/xxx.png
            String requestURI = request.getRequestURI();
            String filePath = requestURI.substring("/uploads/".length());
            
            if (filePath == null || filePath.isEmpty()) {
                log.warn("文件路径为空");
                return ResponseEntity.notFound().build();
            }
            
            // 构建完整文件路径
            // 策略：优先从本地路径查找，如果不存在再尝试云服务器路径
            Path fullPath = null;
            File file = null;
            
            // 1. 先尝试从默认路径查找（本地存储）
            fullPath = Paths.get(defaultUploadPath, filePath);
            file = fullPath.toFile();
            
            // 2. 如果本地文件不存在，尝试从云服务器存储路径查找
            if (!file.exists() || !file.isFile()) {
                // 从系统配置中获取启用的云服务器存储路径
                SystemConfig config = getSystemConfig();
                if (config != null && config.getCloudServerStorageConfigs() != null) {
                    SystemConfig.CloudServerStorageConfig cloudConfig = config.getCloudServerStorageConfigs().stream()
                        .filter(c -> c.getEnabled() != null && c.getEnabled())
                        .min(Comparator.comparing(c -> c.getSortCode() != null ? c.getSortCode() : 0))
                        .orElse(null);
                    
                    if (cloudConfig != null && cloudConfig.getStoragePath() != null && !cloudConfig.getStoragePath().isEmpty()) {
                        try {
                            // 尝试使用云服务器存储路径
                            fullPath = Paths.get(cloudConfig.getStoragePath(), filePath);
                            file = fullPath.toFile();
                            
                            // 如果云服务器路径也不存在，记录日志但继续尝试
                            if (!file.exists() || !file.isFile()) {
                                log.debug("云服务器路径文件不存在: {}", fullPath);
                                // 回退到本地路径
                                fullPath = Paths.get(defaultUploadPath, filePath);
                                file = fullPath.toFile();
                            }
                        } catch (Exception e) {
                            // 如果云服务器路径访问失败（如Windows环境下的Linux路径），回退到本地路径
                            log.debug("无法访问云服务器路径: {}, 回退到本地路径", cloudConfig.getStoragePath());
                            fullPath = Paths.get(defaultUploadPath, filePath);
                            file = fullPath.toFile();
                        }
                    }
                }
            }
            
            if (!file.exists() || !file.isFile()) {
                log.warn("文件不存在: {}", fullPath);
                return ResponseEntity.notFound().build();
            }
            
            Resource resource = new FileSystemResource(file);
            
            // 确定Content-Type
            String contentType = Files.probeContentType(fullPath);
            if (contentType == null) {
                // 根据文件扩展名判断
                String fileName = file.getName().toLowerCase();
                if (fileName.endsWith(".png")) {
                    contentType = "image/png";
                } else if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
                    contentType = "image/jpeg";
                } else if (fileName.endsWith(".gif")) {
                    contentType = "image/gif";
                } else if (fileName.endsWith(".webp")) {
                    contentType = "image/webp";
                } else if (fileName.endsWith(".pdf")) {
                    contentType = "application/pdf";
                } else {
                    contentType = "application/octet-stream";
                }
            }
            
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + file.getName() + "\"")
                    .body(resource);
                    
        } catch (Exception e) {
            log.error("读取文件失败", e);
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * 获取系统配置
     */
    private SystemConfig getSystemConfig() {
        try {
            List<SystemConfig> configs = systemConfigService.getAll();
            if (configs != null && !configs.isEmpty()) {
                return configs.get(0);
            }
        } catch (Exception e) {
            log.warn("获取系统配置失败", e);
        }
        return null;
    }
    
    /* ============================================
     * 其他权限方案（可选实现）
     * ============================================
     */
    
    /**
     * 方案2：权限验证（需要特定权限才能访问）
     * 
     * 使用方式：在 getFile 方法中添加以下代码
     * 
     * // 检查用户是否有文件访问权限
     * if (!StpUtil.hasPermission("file:view")) {
     *     log.warn("用户 {} 没有文件访问权限", StpUtil.getLoginIdAsLong());
     *     return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
     * }
     * 
     * 需要在权限系统中配置权限编码：file:view
     */
    
    /**
     * 方案3：文件所有者验证（只能访问自己上传的文件）
     * 
     * 实现步骤：
     * 1. 修改文件上传服务，在上传时记录上传者ID到文件元数据或数据库
     * 2. 在文件访问时，检查当前用户是否是文件的上传者
     * 
     * 示例代码：
     * 
     * // 从文件路径或数据库中获取文件的上传者ID
     * Long uploaderId = getFileUploaderId(filePath);
     * Long currentUserId = StpUtil.getLoginIdAsLong();
     * 
     * // 检查是否是文件所有者或管理员
     * if (!uploaderId.equals(currentUserId) && !StpUtil.hasRole("admin")) {
     *     log.warn("用户 {} 尝试访问非自己上传的文件: {}", currentUserId, filePath);
     *     return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
     * }
     */
    
    /**
     * 方案4：混合方案（公共文件可访问，私有文件需要权限）
     * 
     * 实现思路：
     * 1. 根据文件路径或类型判断是否为公共文件
     * 2. 公共文件（如系统图标）：登录即可访问
     * 3. 私有文件（如用户上传）：需要文件所有者或特定权限
     * 
     * 示例代码：
     * 
     * // 判断是否为公共文件（例如：系统配置相关的图片）
     * boolean isPublicFile = filePath.startsWith("image/system/") || 
     *                        filePath.startsWith("image/config/");
     * 
     * if (!isPublicFile) {
     *     // 私有文件需要验证所有者或权限
     *     Long uploaderId = getFileUploaderId(filePath);
     *     Long currentUserId = StpUtil.getLoginIdAsLong();
     *     
     *     if (!uploaderId.equals(currentUserId) && !StpUtil.hasPermission("file:view:all")) {
     *         return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
     *     }
     * }
     */
}

