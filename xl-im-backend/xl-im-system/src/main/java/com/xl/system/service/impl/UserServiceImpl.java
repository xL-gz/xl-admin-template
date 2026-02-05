package com.xl.system.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xl.system.entity.User;
import com.xl.system.mapper.UserMapper;
import com.xl.system.service.UserService;
import org.springframework.stereotype.Service;

/**
 * 用户服务实现
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
    
    @Override
    public User getByUsername(String username) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        return this.getOne(wrapper);
    }
    
    @Override
    public String login(String username, String password) {
        User user = getByUsername(username);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        if (user.getStatus() == 0) {
            throw new RuntimeException("用户已被禁用");
        }
        
        // 临时调试：打印密码信息
        System.out.println("输入密码: " + password);
        System.out.println("数据库密码: " + user.getPassword());
        System.out.println("密码是否以$2a$开头: " + user.getPassword().startsWith("$2a$"));
        
        // 检查密码格式，如果是BCrypt格式则使用BCrypt验证，否则使用MD5
        if (user.getPassword().startsWith("$2a$") || user.getPassword().startsWith("$2b$") || user.getPassword().startsWith("$2y$")) {
            // BCrypt格式
            boolean isValid = BCrypt.checkpw(password, user.getPassword());
            System.out.println("BCrypt验证结果: " + isValid);
            if (!isValid) {
                throw new RuntimeException("密码错误");
            }
        } else {
            // MD5格式（兼容旧数据）
            String md5Password = cn.hutool.crypto.digest.DigestUtil.md5Hex(password);
            System.out.println("MD5验证 - 输入密码MD5: " + md5Password);
            if (!md5Password.equals(user.getPassword())) {
                throw new RuntimeException("密码错误");
            }
        }
        
        // 登录
        StpUtil.login(user.getId());
        
        return StpUtil.getTokenValue();
    }
}






