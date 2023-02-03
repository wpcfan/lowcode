package com.mooc.backend.dtos;

import com.mooc.backend.entities.Category;

public record CreateOrUpdateCategoryRecord(String name, String code) {
    public Category toEntity() {
        return Category.builder()
                .name(name)
                .code(code)
                .build();
    }
}
