package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonValue;

public enum PageStatus {
    Draft("Draft"),
    Published("Published"),
    Archived("Archived");

    private final String value;

    PageStatus(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    public static PageStatus fromValue(String value) {
        for (PageStatus pageStatus : PageStatus.values()) {
            if (pageStatus.value.equals(value)) {
                return pageStatus;
            }
        }
        throw new IllegalArgumentException("Invalid PageStatus value: " + value);
    }
}
