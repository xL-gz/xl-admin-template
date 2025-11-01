package com.xl.system.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 文件上传服务接口
 */
public interface FileUploadService {
    
    /**
     * 上传文件
     * @param file 文件
     * @param fileType 文件类型（如：annexpic, annex等）
     * @return 上传结果，包含文件URL和路径信息
     */
    Map<String, Object> uploadFile(MultipartFile file, String fileType);
    
    /**
     * 删除文件
     * @param fileUrl 文件URL
     * @return 是否删除成功
     */
    boolean deleteFile(String fileUrl);
}

