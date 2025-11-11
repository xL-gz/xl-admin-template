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
            
            // 优先使用启用的OSS配置
            if (config != null && config.getOssStorageConfigs() != null) {
                SystemConfig.OssStorageConfig ossConfig = config.getOssStorageConfigs().stream()
                    .filter(c -> c.getEnabled() != null && c.getEnabled())
                    .min(Comparator.comparing(c -> c.getSortCode() != null ? c.getSortCode() : 0))
                    .orElse(null);
                
                if (ossConfig != null) {
                    return uploadToOss(file, fileType, ossConfig);
                }
            }
            
            // 其次使用启用的云服务器配置
            if (config != null && config.getCloudServerStorageConfigs() != null) {
                SystemConfig.CloudServerStorageConfig cloudConfig = config.getCloudServerStorageConfigs().stream()
                    .filter(c -> c.getEnabled() != null && c.getEnabled())
                    .min(Comparator.comparing(c -> c.getSortCode() != null ? c.getSortCode() : 0))
                    .orElse(null);
                
                if (cloudConfig != null) {
                    return uploadToCloudServer(file, fileType, cloudConfig);
                }
            }
            
            // 如果都没有配置，使用本地存储
            return uploadToLocal(file, fileType);
            
        } catch (Exception e) {
            log.error("文件上传失败", e);
            throw new RuntimeException("文件上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 上传文件到OSS（待实现）
     */
    private Map<String, Object> uploadToOss(
            MultipartFile file, 
            String fileType, 
            SystemConfig.OssStorageConfig config) throws IOException {
        
        // TODO: 实现OSS上传逻辑
        // 这里需要集成阿里云OSS SDK或其他OSS服务
        log.warn("OSS上传功能尚未实现，回退到本地存储");
        return uploadToLocal(file, fileType);
    }
    
    /**
     * 上传文件到云服务器
     */
    private Map<String, Object> uploadToCloudServer(
            MultipartFile file, 
            String fileType, 
            SystemConfig.CloudServerStorageConfig config) throws IOException {
        
        // 检查配置是否有效
        if (config == null) {
            log.warn("云服务器配置为空，回退到本地存储");
            return uploadToLocal(file, fileType);
        }
        
        String serverAddress = config.getServerAddress();
        String storagePath = config.getStoragePath();
        
        // 如果serverAddress为空且storagePath也为空，回退到本地存储
        if ((serverAddress == null || serverAddress.trim().isEmpty()) && 
            (storagePath == null || storagePath.trim().isEmpty())) {
            log.warn("云服务器配置无效（serverAddress和storagePath都为空），回退到本地存储");
            return uploadToLocal(file, fileType);
        }
        
        // 检测操作系统类型
        String osName = System.getProperty("os.name").toLowerCase();
        boolean isWindows = osName.contains("windows");
        
        // 如果serverAddress是HTTP/HTTPS地址，通过HTTP接口上传（适用于跨服务器上传）
        if (serverAddress != null && !serverAddress.trim().isEmpty() && 
            (serverAddress.startsWith("http://") || serverAddress.startsWith("https://"))) {
            // 通过HTTP接口上传到云服务器
            // 生成安全的临时文件名（UUID + 扩展名，避免中文问题）
            String tempFileName = generateSafeFileName(file.getOriginalFilename());
            Path tempPath = Paths.get(System.getProperty("java.io.tmpdir"), tempFileName);
            Files.write(tempPath, file.getBytes());
            
            try {
                String remotePath = uploadViaHttp(
                    tempPath.toFile(), 
                    serverAddress, 
                    storagePath,
                    config.getAccessKey()
                );
                
                // 检查云服务器返回的URL是否已经是完整URL
                String fileUrl;
                if (remotePath != null && (remotePath.startsWith("http://") || remotePath.startsWith("https://"))) {
                    // 如果已经是完整URL，直接使用
                    fileUrl = remotePath;
                    // 提取相对路径用于path字段
                    if (remotePath.contains("/uploads/")) {
                        remotePath = remotePath.substring(remotePath.indexOf("/uploads/") + "/uploads/".length());
                    }
                } else {
                    // 否则使用buildFileUrl构建
                    fileUrl = buildFileUrl(serverAddress, remotePath);
                }
                
                Map<String, Object> result = new HashMap<>();
                result.put("url", fileUrl);
                result.put("path", remotePath);
                result.put("fileName", file.getOriginalFilename());
                result.put("fileSize", file.getSize());
                result.put("storageType", "cloud");
                
                log.info("文件已通过HTTP上传到云服务器: {} -> {}", file.getOriginalFilename(), fileUrl);
                return result;
            } catch (Exception e) {
                log.error("通过HTTP上传到云服务器失败，回退到本地存储: {}", e.getMessage());
                return uploadToLocal(file, fileType);
            } finally {
                Files.deleteIfExists(tempPath);
            }
        }
        
        // 如果是在Windows环境且storagePath是Linux路径，回退到本地存储
        if (isWindows && storagePath != null && !storagePath.trim().isEmpty() && storagePath.startsWith("/")) {
            log.warn("Windows环境下无法使用Linux路径: {}，回退到本地存储", storagePath);
            return uploadToLocal(file, fileType);
        }
        
        // 1. 先保存到本地临时目录
        // 生成安全的临时文件名（UUID + 扩展名，避免中文问题）
        String tempFileName = generateSafeFileName(file.getOriginalFilename());
        Path tempPath = Paths.get(System.getProperty("java.io.tmpdir"), tempFileName);
        Files.write(tempPath, file.getBytes());
        
        try {
            // 2. 上传到云服务器（直接保存到本地路径，适用于应用部署在云服务器上的情况）
            String remotePath = uploadToRemoteServer(
                tempPath.toFile(), 
                serverAddress, 
                storagePath,
                config.getAccessKey()
            );
            
            // 3. 构建文件URL
            String fileUrl = buildFileUrl(serverAddress, remotePath);
            
            Map<String, Object> result = new HashMap<>();
            result.put("url", fileUrl);
            result.put("path", remotePath);
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
            result.put("storageType", "cloud");
            
            log.info("文件已上传到云服务器: {} -> {}", file.getOriginalFilename(), fileUrl);
            return result;
            
        } catch (Exception e) {
            log.error("上传到云服务器失败，回退到本地存储: {}", e.getMessage());
            // 如果云服务器上传失败，回退到本地存储
            return uploadToLocal(file, fileType);
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
        
        // 方式1: 如果serverAddress是HTTP/HTTPS地址，通过HTTP接口上传
        if (serverAddress != null && !serverAddress.trim().isEmpty() && 
            (serverAddress.startsWith("http://") || serverAddress.startsWith("https://"))) {
            return uploadViaHttp(file, serverAddress, storagePath, accessKey);
        }
        
        // 方式2: 如果serverAddress为空或不是HTTP地址，且storagePath不为空
        // 说明应用部署在云服务器上，直接保存到本地路径
        if (storagePath != null && !storagePath.trim().isEmpty()) {
            return saveToLocalPath(file, storagePath);
        }
        
        // 如果serverAddress不为空但不是HTTP地址，尝试作为本地路径
        if (serverAddress != null && !serverAddress.trim().isEmpty()) {
            return saveToLocalPath(file, serverAddress);
        }
        
        // 如果都为空，抛出异常
        throw new IOException("云服务器配置无效：serverAddress和storagePath都为空");
    }
    
    /**
     * 保存文件到本地路径（适用于应用部署在云服务器上的情况）
     */
    private String saveToLocalPath(File file, String basePath) throws IOException {
        // 从临时文件名中提取扩展名（临时文件名已经是UUID + 扩展名格式）
        String tempFileName = file.getName();
        String extension = getFileExtension(tempFileName);
        
        // 根据扩展名识别类型
        String category = getFileCategoryFromFileName(tempFileName);
        
        // 生成文件路径：按类型和日期分目录
        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        
        // 检测操作系统类型
        String osName = System.getProperty("os.name").toLowerCase();
        boolean isWindows = osName.contains("windows");
        
        // 处理路径：如果是相对路径，转换为绝对路径
        Path basePathObj;
        if (basePath.startsWith("/")) {
            // Linux绝对路径
            if (isWindows) {
                // 在Windows上，Linux路径无法直接使用，抛出异常让上层回退到本地存储
                throw new IOException("在Windows环境下无法使用Linux路径: " + basePath + "，请使用本地存储或配置Windows路径");
            }
            basePathObj = Paths.get(basePath);
        } else if (basePath.matches("^[A-Za-z]:.*")) {
            // Windows绝对路径
            basePathObj = Paths.get(basePath);
        } else {
            // 相对路径，转换为绝对路径
            basePathObj = Paths.get(System.getProperty("user.dir"), basePath);
        }
        
        Path targetDir = basePathObj.resolve(category).resolve(datePath);
        Files.createDirectories(targetDir);
        
        // 生成唯一文件名（UUID + 扩展名，避免中文问题）
        String uniqueFileName = UUID.randomUUID().toString() + (extension.isEmpty() ? "" : "." + extension);
        Path targetFile = targetDir.resolve(uniqueFileName);
        Files.copy(file.toPath(), targetFile);
        
        String relativePath = category + "/" + datePath + "/" + uniqueFileName;
        log.info("文件已保存到云服务器路径: {} -> {} (类型: {})", uniqueFileName, targetFile.toString(), category);
        
        return relativePath;
    }
    
    /**
     * 生成安全的文件名（UUID + 扩展名，不包含原始文件名，避免中文问题）
     */
    private String generateSafeFileName(String originalFilename) {
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        return UUID.randomUUID().toString() + extension;
    }
    
    /**
     * 从文件名中提取扩展名
     */
    private String getFileExtension(String fileName) {
        if (fileName != null && fileName.contains(".")) {
            return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        }
        return "";
    }
    
    /**
     * 根据文件名识别文件分类（用于临时文件）
     */
    private String getFileCategoryFromFileName(String fileName) {
        String extension = getFileExtension(fileName);
        
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
     * 注意：这种方式会调用云服务器的上传接口，云服务器会根据自己的配置决定存储位置
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
            
            org.springframework.http.HttpEntity<org.springframework.util.MultiValueMap<String, Object>> requestEntity = 
                new org.springframework.http.HttpEntity<>(body, headers);
            
            // 调用云服务器的上传接口（使用annexpic类型，与前端一致）
            String uploadUrl = serverAddress;
            if (!uploadUrl.endsWith("/")) {
                uploadUrl += "/";
            }
            uploadUrl += "api/file/Uploader/annexpic";
            
            log.info("通过HTTP上传文件到云服务器: {} -> {}", file.getName(), uploadUrl);
            
            org.springframework.http.ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                uploadUrl,
                org.springframework.http.HttpMethod.POST,
                requestEntity,
                new ParameterizedTypeReference<Map<String, Object>>() {}
            );
            
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Map<String, Object> responseBody = response.getBody();
                
                // 解析响应：Result格式 {code: 200, data: {url: "...", path: "..."}, msg: "..."}
                Integer code = (Integer) responseBody.get("code");
                if (code != null && code == 200) {
                    Map<String, Object> data = (Map<String, Object>) responseBody.get("data");
                    if (data != null) {
                        String filePath = (String) data.get("path");
                        String fileUrl = (String) data.get("url");
                        log.info("文件已通过HTTP上传到云服务器: {} -> {}", file.getName(), fileUrl);
                        
                        // 优先返回fileUrl（可能是完整URL或相对路径）
                        if (fileUrl != null && !fileUrl.isEmpty()) {
                            return fileUrl;
                        }
                        // 如果没有fileUrl，使用filePath
                        if (filePath != null && !filePath.isEmpty()) {
                            // 如果filePath包含/uploads/，去掉前缀返回相对路径
                            if (filePath.startsWith("/uploads/")) {
                                return filePath.substring("/uploads/".length());
                            }
                            return filePath;
                        }
                        return "";
                    }
                }
                throw new IOException("云服务器返回错误: " + responseBody.get("msg"));
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
        // 生成安全的文件名（UUID + 扩展名，避免中文问题）
        String fileName = generateSafeFileName(file.getOriginalFilename());
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
        if (filePath == null || filePath.isEmpty()) {
            return "";
        }
        
        // 如果filePath已经是完整URL，直接返回
        if (filePath.startsWith("http://") || filePath.startsWith("https://")) {
            return filePath;
        }
        
        // 如果serverAddress是HTTP/HTTPS地址，构建完整URL
        if (serverAddress != null && !serverAddress.isEmpty() && 
            (serverAddress.startsWith("http://") || serverAddress.startsWith("https://"))) {
            if (serverAddress.endsWith("/")) {
                serverAddress = serverAddress.substring(0, serverAddress.length() - 1);
            }
            
            // 处理filePath：去掉开头的斜杠，避免重复
            if (filePath.startsWith("/")) {
                filePath = filePath.substring(1);
            }
            
            // 如果filePath已经包含/uploads/，直接拼接
            if (filePath.startsWith("uploads/")) {
                return serverAddress + "/" + filePath;
            }
            
            // 否则添加/uploads/前缀
            return serverAddress + "/uploads/" + filePath;
        }
        
        // 如果没有配置服务器地址或不是HTTP地址，使用相对路径
        // 前端会根据apiUrl自动拼接完整URL
        if (filePath.startsWith("/")) {
            return filePath;
        }
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

