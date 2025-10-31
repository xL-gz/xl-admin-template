package com.xl.common.result;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 统一返回结果
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Result<T> {
    
    private Integer code;
    
    @JsonProperty("msg")  // 强制使用 msg 作为 JSON 字段名
    private String msg;  // 修改为 msg 以匹配前端
    private T data;
    
    // 为了兼容性，保留 message 字段的 getter 和 setter（不参与 JSON 序列化）
    @com.fasterxml.jackson.annotation.JsonIgnore
    public String getMessage() {
        return msg;
    }
    
    public void setMessage(String message) {
        this.msg = message;
    }
    
    public static <T> Result<T> success() {
        return new Result<>(200, "操作成功", null);
    }
    
    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }
    
    public static <T> Result<T> success(T data, String message) {
        return new Result<>(200, message, data);
    }
    
    public static <T> Result<T> success(String message) {
        return new Result<>(200, message, null);
    }
    
    public static <T> Result<T> error() {
        return new Result<>(500, "操作失败", null);
    }
    
    public static <T> Result<T> error(String message) {
        return new Result<>(500, message, null);
    }
    
    public static <T> Result<T> error(Integer code, String message) {
        return new Result<>(code, message, null);
    }
}






