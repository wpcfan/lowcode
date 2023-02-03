package com.mooc.backend.dtos;

import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.projections.PageBlockEntityInfo;
import lombok.Builder;
import lombok.Value;

import java.util.HashSet;
import java.util.Set;

@Value
@Builder
public class PageBlockDTO {
    private Long id;
    private String title;
    private BlockType type;
    private Integer sort;
    private BlockConfig config;
    private Set<PageBlockDataDTO> data;

    public static PageBlockDTO from(PageBlockEntityInfo pageBlock) {
        return PageBlockDTO.builder()
                .id(pageBlock.getId())
                .title(pageBlock.getTitle())
                .type(pageBlock.getType())
                .sort(pageBlock.getSort())
                .config(pageBlock.getConfig())
                .data(pageBlock.getData().stream()
                        .map(PageBlockDataDTO::from)
                        .collect(HashSet::new, Set::add, Set::addAll)
                )
                .build();
    }
}
