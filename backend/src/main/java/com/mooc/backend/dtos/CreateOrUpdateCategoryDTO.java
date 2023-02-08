package com.mooc.backend.dtos;

import com.mooc.backend.entities.Category;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "创建类目时以 JSON 格式传递的数据")
public record CreateOrUpdateCategoryDTO(
        @Schema(description = "类目名称", example = "category1") String name,
        @Schema(description = "类目代码", example = "code_1") String code) {
    public Category toEntity() {
        return Category.builder()
                .name(name)
                .code(code)
                .build();
    }
}
