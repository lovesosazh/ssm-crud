package com.lovesosa.commons;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.Map;

/**
 * @author lovesosa
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class R<T> {

    private int code;
    private String message;
    private Map<String, T> items = new HashMap<>();


    public static R success() {
        R r = new R();
        r.setCode(100);
        r.setMessage("处理成功！");
        return r;
    }

    public static R fail() {
        R r = new R();
        r.setCode(200);
        r.setMessage("处理失败！");
        return r;
    }


    public R data(String msg,T t) {
        this.getItems().put(msg, t);
        return this;
    }
}
