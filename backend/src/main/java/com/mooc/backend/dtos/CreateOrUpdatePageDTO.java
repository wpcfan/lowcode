package com.mooc.backend.dtos;

import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public record CreateOrUpdatePageDTO(
        @Schema(description = "布局标题", example = "首页布局") @NotBlank @Length(min = 2, max = 100) String title,
        @Schema(description = "平台") @NotNull Platform platform,
        @Schema(description = "页面类型") @NotNull PageType pageType,
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
