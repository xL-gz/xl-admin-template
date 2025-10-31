package com.xl.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xl.system.dto.SystemDTO;
import com.xl.system.entity.System;

import java.util.List;

/**
 * 应用系统Service接口
 */
public interface SystemService extends IService<System> {
    
    /**
     * 获取应用系统列表
     * @param keyword 关键字
     * @param enabledMark 启用状态
     * @return 系统列表
     */
    List<SystemDTO> getSystemList(String keyword, Integer enabledMark);
    
    /**
     * 根据ID获取应用系统
     * @param id 系统ID
     * @return 系统DTO
     */
    SystemDTO getSystemById(String id);
    
    /**
     * 创建应用系统
     * @param dto 系统DTO
     * @return 系统ID
     */
    String createSystem(SystemDTO dto);
    
    /**
     * 更新应用系统
     * @param id 系统ID
     * @param dto 系统DTO
     * @return 是否成功
     */
    boolean updateSystem(String id, SystemDTO dto);
    
    /**
     * 删除应用系统
     * @param id 系统ID
     * @return 是否成功
     */
    boolean deleteSystem(String id);
    
    /**
     * 获取用户有权限的应用系统ID列表
     * @param userId 用户ID
     * @return 系统ID列表
     */
    List<String> getUserSystemIds(Long userId);
}

