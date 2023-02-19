package com.mooc.backend.dtos;

import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CreateOrUpdatePageDTO(
        @Schema(description = "布局标题", example = "首页布局") @NotBlank @Size(min = 2, max = 100) String title,
        @Schema(description = "平台", example = "App") @NotNull Platform platform,
        @Schema(description = "页面类型", example = "home") @NotNull PageType pageType,
        @NotNull @Valid PageConfig config) {

    public PageEntity toEntity() {
        return PageEntity.builder()
                .title(title)
                .platform(platform)
                .pageType(pageType)
                .config(config)
                .build();
    }
}
