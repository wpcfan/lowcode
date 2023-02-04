package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.blocks.BlockData;

public record CreateOrUpdatePageBlockDataRecord(Integer sort, BlockData content) {
    public PageBlockDataEntity toEntity() {
        return PageBlockDataEntity.builder()
                .sort(sort)
                .content(content)
                .build();
    }
}
