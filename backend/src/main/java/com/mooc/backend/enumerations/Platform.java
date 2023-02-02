package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonValue;

public enum Platform {
    iOS("iOS"),
    Android("Android"),
    Web("Web");

    private final String value;

    Platform(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
