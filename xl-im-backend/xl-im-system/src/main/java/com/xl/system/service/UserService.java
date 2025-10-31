package com.xl.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xl.system.entity.User;

/**
 * 用户服务接口
 */
public interface UserService extends IService<User> {
    
    /**
     * 根据用户名查询用户
     */
    User getByUsername(String username);
    
    /**
     * 用户登录
     */
    String login(String username, String password);
}

