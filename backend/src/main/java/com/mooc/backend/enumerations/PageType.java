package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonValue;

public enum PageType {
    Home("home"),
    About("about"),
    Category("category");

    private final String value;

    PageType(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
