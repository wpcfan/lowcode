package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

public record CreateOrUpdatePageDTO(
        String title,
        Platform platform,
        PageType pageType,
        PageConfig config) {

    public PageEntity toEntity() {
        return PageEntity.builder()
                .title(title)
                .platform(platform)
                .pageType(pageType)
                .config(config)
                .build();
    }
}
