package com.xl.admin.controller;

import com.xl.common.result.Result;
import com.xl.system.service.FileUploadService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 文件上传控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/file")
@RequiredArgsConstructor
public class FileController {
    
    private final FileUploadService fileUploadService;
    
    /**
     * 文件上传接口
     * 对应前端: /api/file/Uploader/{type}
     */
    @PostMapping("/Uploader/{type}")
    public Result<Map<String, Object>> uploadFile(
            @PathVariable String type,
            @RequestParam("file") MultipartFile file) {
        
        try {
            // 验证文件
            if (file == null || file.isEmpty()) {
                return Result.error("请选择要上传的文件");
            }
            
            // 验证文件大小（10MB）
            long maxSize = 10 * 1024 * 1024; // 10MB
            if (file.getSize() > maxSize) {
                return Result.error("文件大小不能超过10MB");
            }
            
            // 上传文件
            Map<String, Object> result = fileUploadService.uploadFile(file, type);
            
            return Result.success(result, "上传成功");
            
        } catch (Exception e) {
            log.error("文件上传失败", e);
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除文件接口
     */
    @DeleteMapping("/delete")
    public Result<String> deleteFile(@RequestParam String fileUrl) {
        try {
            boolean success = fileUploadService.deleteFile(fileUrl);
            if (success) {
                return Result.success("删除成功");
            } else {
                return Result.error("删除失败");
            }
        } catch (Exception e) {
            log.error("删除文件失败", e);
            return Result.error("删除失败: " + e.getMessage());
        }
    }
}

