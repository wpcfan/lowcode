package com.mooc.backend.dtos;

import com.mooc.backend.entities.Category;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "创建类目时以 JSON 格式传递的数据")
public record CreateOrUpdateCategoryDTO(
        @Schema(description = "类目名称", example = "Mathematics") @NotBlank String name,
        @Schema(description = "类目代码", example = "code_math") @NotBlank String code) {
    public Category toEntity() {
        return Category.builder()
                .name(name)
                .code(code)
                .build();
    }
}
