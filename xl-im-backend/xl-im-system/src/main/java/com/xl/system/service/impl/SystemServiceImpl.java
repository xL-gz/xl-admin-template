package com.xl.system.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xl.system.dto.SystemDTO;
import com.xl.system.entity.Menu;
import com.xl.system.entity.System;
import com.xl.system.mapper.MenuMapper;
import com.xl.system.mapper.SystemMapper;
import com.xl.system.service.SystemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 应用系统Service实现类
 */
@Service
public class SystemServiceImpl extends ServiceImpl<SystemMapper, System> implements SystemService {
    
    @Autowired
    private MenuMapper menuMapper;
    
    @Override
    public List<SystemDTO> getSystemList(String keyword, Integer enabledMark) {
        LambdaQueryWrapper<System> wrapper = new LambdaQueryWrapper<>();
        
        // 关键字搜索（系统名称或编码）
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like(System::getFullName, keyword)
                             .or()
                             .like(System::getEnCode, keyword));
        }
        
        // 启用状态过滤
        if (enabledMark != null) {
            wrapper.eq(System::getEnabledMark, enabledMark);
        }
        
        // 按排序码排序
        wrapper.orderByAsc(System::getSortCode);
        
        List<System> systems = this.list(wrapper);
        
        // 转换为DTO
        return systems.stream()
                     .map(system -> BeanUtil.copyProperties(system, SystemDTO.class))
                     .collect(Collectors.toList());
    }
    
    @Override
    public SystemDTO getSystemById(String id) {
        System system = this.getById(id);
        if (system == null) {
            return null;
        }
        return BeanUtil.copyProperties(system, SystemDTO.class);
    }
    
    @Override
    public String createSystem(SystemDTO dto) {
        System system = BeanUtil.copyProperties(dto, System.class);
        
        // 生成ID
        if (StrUtil.isBlank(system.getId())) {
            system.setId(IdUtil.fastSimpleUUID());
        }
        
        // 设置默认值
        if (system.getSortCode() == null) {
            system.setSortCode(0);
        }
        if (system.getEnabledMark() == null) {
            system.setEnabledMark(1);
        }
        if (system.getIsMain() == null) {
            system.setIsMain(0);
        }
        
        this.save(system);
        return system.getId();
    }
    
    @Override
    public boolean updateSystem(String id, SystemDTO dto) {
        System system = BeanUtil.copyProperties(dto, System.class);
        system.setId(id);
        return this.updateById(system);
    }
    
    @Override
    public boolean deleteSystem(String id) {
        // 检查是否有菜单关联
        LambdaQueryWrapper<Menu> menuWrapper = new LambdaQueryWrapper<>();
        menuWrapper.eq(Menu::getSystemId, id);
        long menuCount = menuMapper.selectCount(menuWrapper);
        
        if (menuCount > 0) {
            throw new RuntimeException("该应用系统下还有菜单，无法删除");
        }
        
        return this.removeById(id);
    }
    
    @Override
    public List<String> getUserSystemIds(Long userId) {
        // 查询用户有权限的菜单
        List<Menu> menus = menuMapper.selectMenuListByUserId(userId);
        
        // 提取唯一的systemId
        return menus.stream()
                   .map(Menu::getSystemId)
                   .filter(StrUtil::isNotBlank)
                   .distinct()
                   .collect(Collectors.toList());
    }
}

