package com.mooc.backend.projections;

/**
 * A Projection for the {@link com.mooc.backend.entities.ProductImage} entity
 */
public interface ProductImageInfo {
    Long getId();

    String getImageUrl();
}