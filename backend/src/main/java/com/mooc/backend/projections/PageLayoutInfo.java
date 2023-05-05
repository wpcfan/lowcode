package com.mooc.backend.projections;

import com.mooc.backend.entities.PageLayout;

/**
 * A Projection for the {@link PageLayout} entity
 */
public interface PageLayoutInfo {
    Long getId();

    String getTitle();
}