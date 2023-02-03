package com.mooc.backend.projections;

import com.mooc.backend.entities.blocks.BlockData;

/**
 * A Projection for the {@link com.mooc.backend.entities.PageBlockDataEntity} entity
 */
public interface PageBlockDataEntityInfo {
    Long getId();

    Integer getSort();

    BlockData getContent();

}