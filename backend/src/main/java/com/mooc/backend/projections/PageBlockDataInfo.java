package com.mooc.backend.projections;

import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.blocks.BlockData;

/**
 * A Projection for the {@link PageBlockData} entity
 */
public interface PageBlockDataInfo {
    Long getId();

    Integer getSort();

    BlockData getContent();

}