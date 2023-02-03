package com.mooc.backend.dtos;

import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.projections.PageBlockDataEntityInfo;
import lombok.Builder;
import lombok.Value;

@Value
@Builder

public class PageBlockDataDTO {
    private Long id;
    private Integer sort;
    private BlockData content;

    public static PageBlockDataDTO from(PageBlockDataEntityInfo pageBlockData) {
        return PageBlockDataDTO.builder()
                .id(pageBlockData.getId())
                .sort(pageBlockData.getSort())
                .content(pageBlockData.getContent())
                .build();
    }
}
