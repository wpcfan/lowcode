package com.mooc.backend.projections;

import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;

import java.util.Set;

/**
 * A Projection for the {@link com.mooc.backend.entities.PageBlockEntity} entity
 */
public interface PageBlockEntityInfo {
    Long getId();

    String getTitle();

    BlockType getType();

    Integer getSort();

    BlockConfig getConfig();

    Set<PageBlockDataEntityInfo> getData();
}