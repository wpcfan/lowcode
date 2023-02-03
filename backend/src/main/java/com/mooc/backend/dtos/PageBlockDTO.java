package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlockEntity;
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

    public static PageBlockDTO fromProjection(PageBlockEntityInfo block) {
        return PageBlockDTO.builder()
                .id(block.getId())
                .title(block.getTitle())
                .type(block.getType())
                .sort(block.getSort())
                .config(block.getConfig())
                .data(block.getData().stream()
                        .map(PageBlockDataDTO::fromProjection)
                        .collect(HashSet::new, Set::add, Set::addAll)
                )
                .build();
    }

    public static PageBlockDTO fromEntity(PageBlockEntity block) {
        return PageBlockDTO.builder()
                .id(block.getId())
                .title(block.getTitle())
                .type(block.getType())
                .sort(block.getSort())
                .config(block.getConfig())
                .data(block.getData().stream()
                        .map(PageBlockDataDTO::fromEntity)
                        .collect(HashSet::new, Set::add, Set::addAll)
                )
                .build();
    }

    public PageBlockEntity toEntity() {
        var pageBlockEntity = PageBlockEntity.builder()
                .title(getTitle())
                .type(getType())
                .sort(getSort())
                .config(getConfig())
                .build();
        getData().forEach(data -> pageBlockEntity.addData(data.toEntity()));
        return pageBlockEntity;
    }
}
