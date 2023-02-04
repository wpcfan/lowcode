package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.projections.PageEntityInfo;
import lombok.Builder;
import lombok.Value;

import java.util.HashSet;
import java.util.Set;

@Value
@Builder
public class PageDTO {
    private Long id;
    private Platform platform;
    private PageType pageType;
    private PageConfig config;
    @Builder.Default
    private Set<PageBlockDTO> blocks = new HashSet<>();

    public static PageDTO fromProjection(PageEntityInfo page) {
        return PageDTO.builder()
                .id(page.getId())
                .platform(page.getPlatform())
                .pageType(page.getPageType())
                .config(page.getConfig())
                .blocks(page.getPageBlocks().stream()
                        .map(PageBlockDTO::fromProjection)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }

    public static PageDTO fromEntity(PageEntity page) {
        return PageDTO.builder()
                .id(page.getId())
                .platform(page.getPlatform())
                .pageType(page.getPageType())
                .config(page.getConfig())
                .blocks(page.getPageBlocks().stream()
                        .map(PageBlockDTO::fromEntity)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }

    public PageEntity toEntity() {
        var pageEntity = PageEntity.builder()
                .platform(getPlatform())
                .pageType(getPageType())
                .config(getConfig())
                .build();
        getBlocks().forEach(block -> pageEntity.addPageBlock(block.toEntity()));
        return pageEntity;
    }
}
