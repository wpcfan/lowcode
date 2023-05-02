package com.mooc.backend.projections;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

import java.time.LocalDateTime;
import java.util.Set;

/**
 * A Projection for the {@link PageLayout} entity
 */
public interface PageLayoutInfo {
    Long getId();

    String getTitle();

    Platform getPlatform();

    PageType getPageType();

    PageConfig getConfig();

    Set<PageBlock> getPageBlocks();

    LocalDateTime getStartTime();

    LocalDateTime getEndTime();

    PageStatus getStatus();
}