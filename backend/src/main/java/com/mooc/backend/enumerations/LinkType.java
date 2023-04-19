package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum LinkType {
    Url("url"),
    Route("route");

    private final String value;

    LinkType(String value) {
        this.value = value;
    }

    @JsonCreator
    public static LinkType fromValue(String value) {
        for (LinkType linkType : LinkType.values()) {
            if (linkType.value.equals(value)) {
                return linkType;
            }
        }
        throw new IllegalArgumentException("Invalid LinkType value: " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
