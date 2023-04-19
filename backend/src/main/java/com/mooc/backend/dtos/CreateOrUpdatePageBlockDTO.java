package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record CreateOrUpdatePageBlockDTO(
        @Schema(description = "区块标题", example = "直降促销活动区块") @NotBlank String title,
        @Schema(description = "区块类型", example = "image_row") @NotNull BlockType type,
        @Schema(description = "区块排序", example = "1") @NotNull @Positive Integer sort,
        @NotNull @Valid BlockConfig config) {
    public PageBlock toEntity() {
        return PageBlock.builder()
                .title(title)
                .type(type)
                .sort(sort)
                .config(config)
                .build();
    }
}
