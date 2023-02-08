package com.mooc.backend.projections;

/**
 * A Projection for the {@link com.mooc.backend.entities.ProductImage} entity
 */
public record ProductImageInfo (
    Long id,
    String imageUrl
){
}