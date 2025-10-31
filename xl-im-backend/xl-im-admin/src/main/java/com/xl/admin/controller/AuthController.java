package com.xl.admin.controller;

import cn.dev33.satoken.annotation.SaIgnore;
import com.xl.common.result.Result;
import com.xl.system.dto.MenuDTO;
import com.xl.system.entity.User;
import com.xl.system.service.MenuService;
import com.xl.system.service.SystemService;
import com.xl.system.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final UserService userService;
    private final MenuService menuService;
    private final SystemService systemService;
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    @SaIgnore
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> loginData) {
        String username = loginData.get("username");
        String password = loginData.get("password");
        
        String token = userService.login(username, password);
        
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        
        return Result.success(data, "登录成功");
    }
    
    /**
     * 用户登出
     */
    @PostMapping("/logout")
    public Result<String> logout() {
        // Sa-Token会自动处理登出
        return Result.success("登出成功");
    }
    
    /**
     * 获取当前用户信息（包含菜单和权限）
     */
    @GetMapping("/userInfo")
    @SaIgnore
    public Result<Map<String, Object>> getUserInfo() {
        // 这里简化处理，实际应该从token中获取用户ID
        Long userId = 1L;  // TODO: 从token中获取实际用户ID
        
        // 获取用户信息
        User user = userService.getById(userId);
        
        // 获取用户菜单列表
        List<MenuDTO> menuList = menuService.selectMenuTreeByUserId(userId);
        
        // 获取用户有权限的应用系统ID列表
        List<String> systemIds = systemService.getUserSystemIds(userId);
        
        // 构建用户信息（包含systemIds）
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("userId", user.getId());
        userInfo.put("username", user.getUsername());
        userInfo.put("nickname", user.getNickname());
        userInfo.put("email", user.getEmail());
        userInfo.put("phone", user.getPhone());
        userInfo.put("avatar", user.getAvatar());
        userInfo.put("systemIds", systemIds);  // ← 重要：返回用户有权限的应用系统ID列表
        
        // 构建返回数据
        Map<String, Object> data = new HashMap<>();
        data.put("userInfo", userInfo);
        data.put("menuList", menuList);
        data.put("permissionList", new java.util.ArrayList<>());  // 权限列表（暂时为空）
        data.put("sysConfigInfo", new HashMap<>());  // 系统配置（暂时为空）
        
        return Result.success(data);
    }
    
    /**
     * 获取用户菜单
     */
    @GetMapping("/menus")
    @SaIgnore
    public Result<List<MenuDTO>> getUserMenus(@RequestParam(required = false) Long userId) {
        // 如果没有传入userId，默认使用1（管理员）
        Long targetUserId = userId != null ? userId : 1L;
        List<MenuDTO> menus = menuService.selectMenuTreeByUserId(targetUserId);
        return Result.success(menus);
    }
    
    /**
     * 更新密码消息
     * 前端调用此接口来更新密码相关消息提示
     */
    @PostMapping("/updatePasswordMessage")
    @SaIgnore
    public Result<String> updatePasswordMessage() {
        // 这个接口主要用于通知后端用户已收到密码修改提示
        // 可以在这里实现相关业务逻辑，比如记录日志等
        return Result.success("success", "操作成功");
    }
}
