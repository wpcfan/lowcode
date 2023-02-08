package com.mooc.backend.dtos;

import com.mooc.backend.entities.Product;

public record CreateOrUpdateProductDTO(String name, String description, Integer price) {
    public Product toEntity() {
        return Product.builder()
                .name(name())
                .description(description())
                .price(price())
                .build();
    }
}
