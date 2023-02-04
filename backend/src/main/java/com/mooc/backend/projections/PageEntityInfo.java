package com.mooc.backend.projections;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

import java.time.LocalDateTime;
import java.util.Set;

/**
 * A Projection for the {@link com.mooc.backend.entities.PageEntity} entity
 */
public interface PageEntityInfo {
    Long getId();

    String getTitle();

    Platform getPlatform();

    PageType getPageType();

    PageConfig getConfig();

    Set<PageBlockEntityInfo> getPageBlocks();

    LocalDateTime getStartTime();

    LocalDateTime getEndTime();

    PageStatus getStatus();
}