package com.mooc.backend.enumerations;

public enum PageStatus {
    Draft("草稿"),
    Published("发布"),
    Archived("归档");

    // 如果不加 @JsonValue 注解，那么在序列化时，会使用枚举的名称，而不是 value 字段的值
    private final String value;

    PageStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
