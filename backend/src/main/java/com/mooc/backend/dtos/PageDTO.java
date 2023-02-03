package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageConfig;
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

    public static PageDTO from(PageEntityInfo pageDTO) {
        return PageDTO.builder()
                .id(pageDTO.getId())
                .platform(pageDTO.getPlatform())
                .pageType(pageDTO.getPageType())
                .config(pageDTO.getConfig())
                .blocks(pageDTO.getBlocks().stream()
                        .map(PageBlockDTO::from)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }
}
