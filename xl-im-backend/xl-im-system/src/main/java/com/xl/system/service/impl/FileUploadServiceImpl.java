package com.xl.system.service.impl;

import com.xl.system.entity.SystemConfig;
import com.xl.system.service.FileUploadService;
import com.xl.system.service.SystemConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.core.ParameterizedTypeReference;

/**
 * 文件上传服务实现类
 */
@Slf4j
@Service
public class FileUploadServiceImpl implements FileUploadService {
    
    @Autowired
    private SystemConfigService systemConfigService;
    
    @Value("${server.port:20250}")
    private String serverPort;
    
    @Value("${file.upload.path:./uploads}")
    private String defaultUploadPath;
    
    @Override
    public Map<String, Object> uploadFile(MultipartFile file, String fileType) {
        try {
            // 获取系统配置
            SystemConfig config = getSystemConfig();
            
            // 优先使用启用的云服务器配置
            if (config != null && config.getCloudServerStorageConfigs() != null) {
                SystemConfig.CloudServerStorageConfig cloudConfig = config.getCloudServerStorageConfigs().stream()
                    .filter(c -> c.getEnabled() != null && c.getEnabled())
                    .min(Comparator.comparing(c -> c.getSortCode() != null ? c.getSortCode() : 0))
                    .orElse(null);
                
                if (cloudConfig != null) {
                    return uploadToCloudServer(file, fileType, cloudConfig);
                }
            }
            
            // 如果没有云服务器配置，使用本地存储
            return uploadToLocal(file, fileType);
            
        } catch (Exception e) {
            log.error("文件上传失败", e);
            throw new RuntimeException("文件上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 上传文件到云服务器
     */
    private Map<String, Object> uploadToCloudServer(
            MultipartFile file, 
            String fileType, 
            SystemConfig.CloudServerStorageConfig config) throws IOException {
        
        // 1. 先保存到本地临时目录
        String tempFileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path tempPath = Paths.get(System.getProperty("java.io.tmpdir"), tempFileName);
        Files.write(tempPath, file.getBytes());
        
        try {
            // 2. 上传到云服务器
            String remotePath = uploadToRemoteServer(
                tempPath.toFile(), 
                config.getServerAddress(), 
                config.getStoragePath(),
                config.getAccessKey()
            );
            
            // 3. 构建文件URL
            String fileUrl = buildFileUrl(config.getServerAddress(), remotePath);
            
            Map<String, Object> result = new HashMap<>();
            result.put("url", fileUrl);
            result.put("path", remotePath);
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
            result.put("storageType", "cloud");
            
            return result;
            
        } finally {
            // 删除临时文件
            Files.deleteIfExists(tempPath);
        }
    }
    
    /**
     * 上传文件到远程服务器
     * 支持两种方式：
     * 1. 直接保存到云服务器本地路径（如果应用部署在云服务器上）
     * 2. 通过HTTP接口上传到云服务器
     * 3. 通过SFTP上传（需要添加JSch依赖）
     */
    private String uploadToRemoteServer(
            File file, 
            String serverAddress, 
            String storagePath,
            String accessKey) throws IOException {
        
        // 方式1: 如果serverAddress是本地路径（如 /var/www/uploads）
        // 或者后端应用就部署在这台云服务器上，直接保存到本地
        if (serverAddress == null || serverAddress.trim().isEmpty() || 
            !serverAddress.startsWith("http://") && !serverAddress.startsWith("https://")) {
            // 当作本地路径处理
            return saveToLocalPath(file, serverAddress != null ? serverAddress : storagePath);
        }
        
        // 方式2: 通过HTTP接口上传
        return uploadViaHttp(file, serverAddress, storagePath, accessKey);
    }
    
    /**
     * 保存文件到本地路径（适用于应用部署在云服务器上的情况）
     */
    private String saveToLocalPath(File file, String basePath) throws IOException {
        String fullFileName = file.getName();
        String fileName = fullFileName.contains("_") ? fullFileName.substring(fullFileName.indexOf("_") + 1) : fullFileName;
        
        // 根据文件名识别类型
        String category = getFileCategoryFromFileName(fileName);
        
        // 生成文件路径：按类型和日期分目录
        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        
        // 确保basePath是绝对路径
        Path targetDir = Paths.get(basePath, category, datePath);
        Files.createDirectories(targetDir);
        
        Path targetFile = targetDir.resolve(fileName);
        Files.copy(file.toPath(), targetFile);
        
        String relativePath = category + "/" + datePath + "/" + fileName;
        log.info("文件已保存到云服务器: {} -> {} (类型: {})", fileName, targetFile.toString(), category);
        
        return relativePath;
    }
    
    /**
     * 根据文件名识别文件分类（用于临时文件）
     */
    private String getFileCategoryFromFileName(String fileName) {
        String extension = "";
        if (fileName.contains(".")) {
            extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        }
        
        String[] imageExtensions = {"jpg", "jpeg", "png", "gif", "bmp", "webp", "svg", "ico"};
        String[] videoExtensions = {"mp4", "avi", "mov", "wmv", "flv", "mkv", "rmvb", "3gp", "m4v", "webm"};
        String[] audioExtensions = {"mp3", "wav", "wma", "ogg", "aac", "flac", "m4a"};
        String[] documentExtensions = {"pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "rtf", "odt", "ods"};
        
        for (String ext : imageExtensions) {
            if (extension.equals(ext)) return "image";
        }
        for (String ext : videoExtensions) {
            if (extension.equals(ext)) return "video";
        }
        for (String ext : audioExtensions) {
            if (extension.equals(ext)) return "audio";
        }
        for (String ext : documentExtensions) {
            if (extension.equals(ext)) return "document";
        }
        
        return "other";
    }
    
    /**
     * 通过HTTP接口上传文件到云服务器
     */
    private String uploadViaHttp(
            File file, 
            String serverAddress, 
            String storagePath,
            String accessKey) throws IOException {
        
        try {
            // 使用RestTemplate上传文件
            org.springframework.web.client.RestTemplate restTemplate = new org.springframework.web.client.RestTemplate();
            
            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            headers.setContentType(org.springframework.http.MediaType.MULTIPART_FORM_DATA);
            
            // 如果有访问密钥，添加到请求头
            if (accessKey != null && !accessKey.isEmpty()) {
                headers.set("Authorization", "Bearer " + accessKey);
            }
            
            // 构建请求体
            org.springframework.util.LinkedMultiValueMap<String, Object> body = 
                new org.springframework.util.LinkedMultiValueMap<>();
            body.add("file", new org.springframework.core.io.FileSystemResource(file));
            body.add("path", storagePath);
            
            org.springframework.http.HttpEntity<org.springframework.util.MultiValueMap<String, Object>> requestEntity = 
                new org.springframework.http.HttpEntity<>(body, headers);
            
            // 调用云服务器的上传接口
            String uploadUrl = serverAddress;
            if (!uploadUrl.endsWith("/")) {
                uploadUrl += "/";
            }
            uploadUrl += "api/upload";
            
            org.springframework.http.ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                uploadUrl,
                org.springframework.http.HttpMethod.POST,
                requestEntity,
                new ParameterizedTypeReference<Map<String, Object>>() {}
            );
            
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Map<String, Object> responseBody = response.getBody();
                String filePath = (String) responseBody.get("path");
                log.info("文件已上传到云服务器: {} -> {}", file.getName(), filePath);
                return filePath != null ? filePath : storagePath + "/" + file.getName();
            } else {
                throw new IOException("上传到云服务器失败: " + response.getStatusCode());
            }
            
        } catch (Exception e) {
            log.error("通过HTTP上传文件到云服务器失败", e);
            throw new IOException("上传到云服务器失败: " + e.getMessage());
        }
    }
    
    /**
     * 上传文件到本地服务器
     */
    private Map<String, Object> uploadToLocal(MultipartFile file, String fileType) throws IOException {
        // 识别文件类型（图片、视频、文档等）
        String category = getFileCategory(file);
        
        // 生成文件路径：按类型和日期分目录
        // 格式：uploads/{类型}/{日期}/{文件名}
        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        String relativePath = category + "/" + datePath + "/" + fileName;
        
        // 完整路径
        String fullPath = defaultUploadPath + "/" + relativePath;
        Path uploadPath = Paths.get(fullPath);
        
        // 创建目录
        Files.createDirectories(uploadPath.getParent());
        
        // 保存文件
        Files.write(uploadPath, file.getBytes());
        
        // 构建文件URL（根据实际情况调整）
        String fileUrl = "/uploads/" + relativePath;
        
        Map<String, Object> result = new HashMap<>();
        result.put("url", fileUrl);
        result.put("path", relativePath);
        result.put("fileName", file.getOriginalFilename());
        result.put("fileSize", file.getSize());
        result.put("storageType", "local");
        result.put("category", category);
        
        log.info("文件上传成功: {} -> {} (类型: {})", file.getOriginalFilename(), fullPath, category);
        
        return result;
    }
    
    /**
     * 根据文件类型和扩展名识别文件分类
     * @param file 上传的文件
     * @return 文件分类：image(图片)、video(视频)、audio(音频)、document(文档)、other(其他)
     */
    private String getFileCategory(MultipartFile file) {
        String contentType = file.getContentType();
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();
        }
        
        // 根据MIME类型判断
        if (contentType != null) {
            if (contentType.startsWith("image/")) {
                return "image";
            } else if (contentType.startsWith("video/")) {
                return "video";
            } else if (contentType.startsWith("audio/")) {
                return "audio";
            } else if (contentType.contains("pdf") || 
                      contentType.contains("word") || 
                      contentType.contains("excel") || 
                      contentType.contains("powerpoint") ||
                      contentType.contains("text") ||
                      contentType.contains("document")) {
                return "document";
            }
        }
        
        // 根据扩展名判断（作为补充）
        String[] imageExtensions = {"jpg", "jpeg", "png", "gif", "bmp", "webp", "svg", "ico"};
        String[] videoExtensions = {"mp4", "avi", "mov", "wmv", "flv", "mkv", "rmvb", "3gp", "m4v", "webm"};
        String[] audioExtensions = {"mp3", "wav", "wma", "ogg", "aac", "flac", "m4a"};
        String[] documentExtensions = {"pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt", "rtf", "odt", "ods"};
        
        for (String ext : imageExtensions) {
            if (extension.equals(ext)) {
                return "image";
            }
        }
        for (String ext : videoExtensions) {
            if (extension.equals(ext)) {
                return "video";
            }
        }
        for (String ext : audioExtensions) {
            if (extension.equals(ext)) {
                return "audio";
            }
        }
        for (String ext : documentExtensions) {
            if (extension.equals(ext)) {
                return "document";
            }
        }
        
        // 如果都不匹配，使用fileType参数（前端传入的）或默认other
        return "other";
    }
    
    /**
     * 构建文件访问URL
     */
    private String buildFileUrl(String serverAddress, String filePath) {
        if (serverAddress == null || serverAddress.isEmpty()) {
            // 如果没有配置服务器地址，使用相对路径
            return "/uploads/" + filePath;
        }
        
        // 如果serverAddress是HTTP/HTTPS地址，构建完整URL
        if (serverAddress.startsWith("http://") || serverAddress.startsWith("https://")) {
            if (serverAddress.endsWith("/")) {
                serverAddress = serverAddress.substring(0, serverAddress.length() - 1);
            }
            if (filePath.startsWith("/")) {
                filePath = filePath.substring(1);
            }
            return serverAddress + "/uploads/" + filePath;
        }
        
        // 其他情况使用相对路径
        return "/uploads/" + filePath;
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
    
    @Override
    public boolean deleteFile(String fileUrl) {
        try {
            // 根据URL判断存储类型并删除
            if (fileUrl.startsWith("http://") || fileUrl.startsWith("https://")) {
                // 云服务器文件，需要调用远程删除接口
                log.info("删除云服务器文件: {}", fileUrl);
                // TODO: 实现远程删除逻辑
                return true;
            } else {
                // 本地文件
                String filePath = defaultUploadPath + fileUrl.replace("/uploads/", "/");
                Path path = Paths.get(filePath);
                return Files.deleteIfExists(path);
            }
        } catch (Exception e) {
            log.error("删除文件失败: {}", fileUrl, e);
            return false;
        }
    }
}

