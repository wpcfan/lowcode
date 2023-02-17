package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonValue;

public enum BlockDataType {
    Category("category"),
    Product("product"),
    Image("image");

    private final String value;

    BlockDataType(String value) {
        this.value = value;
    }

    public static BlockDataType fromValue(String value) {
        for (BlockDataType blockDataType : BlockDataType.values()) {
            if (blockDataType.value.equals(value)) {
                return blockDataType;
            }
        }
        throw new IllegalArgumentException("Invalid BlockDataType value: " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
