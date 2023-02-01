package com.mooc.backend.projections;

import java.util.Set;

/**
 * A Projection for the {@link com.mooc.backend.entities.Category} entity
 */
public interface CategoryInfo {
    Long getId();

    String getCode();

    String getName();

    CategoryInfo getParent();

    Set<CategoryInfo> getChildren();
}