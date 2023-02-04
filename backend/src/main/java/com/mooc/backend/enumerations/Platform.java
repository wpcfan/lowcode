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

    public static Platform fromValue(String value) {
        for (Platform platform : Platform.values()) {
            if (platform.value.equals(value)) {
                return platform;
            }
        }
        throw new IllegalArgumentException("Invalid Platform value: " + value);
    }
}
