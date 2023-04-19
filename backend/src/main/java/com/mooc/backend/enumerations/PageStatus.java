package com.mooc.backend.enumerations;

public enum PageStatus {
    Draft("草稿"),
    Published("发布"),
    Archived("归档");

    private final String value;

    PageStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
