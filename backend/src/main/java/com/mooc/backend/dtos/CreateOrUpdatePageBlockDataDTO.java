package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.blocks.BlockData;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record CreateOrUpdatePageBlockDataDTO(
        @Schema(description = "数据排序", example = "1") @NotNull @Positive Integer sort,
        @NotNull @Valid BlockData content) {
    public PageBlockData toEntity() {
        return PageBlockData.builder()
                .sort(sort)
                .content(content)
                .build();
    }
}
