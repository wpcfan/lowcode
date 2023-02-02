package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonValue;

public enum BlockType {
    PinnedHeader("pinned_header"),
    Slider("slider"),
    ImageRow("image_row"),
    ProductRow("product_row"),
    Waterfall("waterfall");

    private String value;

    BlockType(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
