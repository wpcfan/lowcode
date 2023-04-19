package com.mooc.backend.projections;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;

import java.util.Set;

/**
 * A Projection for the {@link PageBlock} entity
 */
public interface PageBlockInfo {
    Long getId();

    String getTitle();

    BlockType getType();

    Integer getSort();

    BlockConfig getConfig();

    Set<PageBlockDataInfo> getData();
}