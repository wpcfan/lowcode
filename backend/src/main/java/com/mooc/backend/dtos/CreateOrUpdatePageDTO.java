package com.mooc.backend.dtos;

import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public record CreateOrUpdatePageDTO(
        @NotNull @Length(min = 2, max = 100) String title,
        @NotNull Platform platform,
        @NotNull PageType pageType,
        @NotNull PageConfig config) {

    public PageEntity toEntity() {
        return PageEntity.builder()
                .title(title)
                .platform(platform)
                .pageType(pageType)
                .config(config)
                .build();
    }
}
