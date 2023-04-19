package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum PageType {
    Home("home"),
    About("about"),
    Category("category");

    private final String value;

    PageType(String value) {
        this.value = value;
    }

    @JsonCreator
    public static PageType fromValue(String value) {
        for (PageType pageType : PageType.values()) {
            if (pageType.value.equals(value)) {
                return pageType;
            }
        }
        throw new IllegalArgumentException("Invalid PageType value: " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
