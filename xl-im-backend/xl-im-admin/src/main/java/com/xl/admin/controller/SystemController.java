package com.xl.admin.controller;

import com.xl.common.result.Result;
import com.xl.system.dto.SystemDTO;
import com.xl.system.service.SystemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 应用系统管理Controller
 */
@RestController
@RequestMapping("/api/system/System")
public class SystemController {
    
    @Autowired
    private SystemService systemService;
    
    /**
     * 获取应用系统列表
     * @param keyword 关键字
     * @param enabledMark 启用状态
     * @return 系统列表
     */
    @GetMapping
    public Result<List<SystemDTO>> getSystemList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer enabledMark) {
        List<SystemDTO> list = systemService.getSystemList(keyword, enabledMark);
        return Result.success(list);
    }
    
    /**
     * 根据ID获取应用系统
     * @param id 系统ID
     * @return 系统详情
     */
    @GetMapping("/{id}")
    public Result<SystemDTO> getSystemById(@PathVariable String id) {
        SystemDTO dto = systemService.getSystemById(id);
        if (dto == null) {
            return Result.error("应用系统不存在");
        }
        return Result.success(dto);
    }
    
    /**
     * 创建应用系统
     * @param dto 系统DTO
     * @return 系统ID
     */
    @PostMapping
    public Result<String> createSystem(@RequestBody SystemDTO dto) {
        String id = systemService.createSystem(dto);
        return Result.success(id, "创建成功");
    }
    
    /**
     * 更新应用系统
     * @param id 系统ID
     * @param dto 系统DTO
     * @return 操作结果
     */
    @PutMapping("/{id}")
    public Result<Void> updateSystem(@PathVariable String id, @RequestBody SystemDTO dto) {
        boolean success = systemService.updateSystem(id, dto);
        return success ? Result.success("更新成功") : Result.error("更新失败");
    }
    
    /**
     * 删除应用系统
     * @param id 系统ID
     * @return 操作结果
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteSystem(@PathVariable String id) {
        try {
            boolean success = systemService.deleteSystem(id);
            return success ? Result.success("删除成功") : Result.error("删除失败");
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }
}

