package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;

public record CreateOrUpdatePageBlockRecord(String title, BlockType type, Integer sort, BlockConfig config) {
    public PageBlockEntity toEntity() {
        return PageBlockEntity.builder()
                .title(title)
                .type(type)
                .sort(sort)
                .config(config)
                .build();
    }
}
