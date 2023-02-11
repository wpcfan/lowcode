package com.mooc.backend.dtos;

import com.mooc.backend.entities.Product;

import java.math.BigDecimal;

public record CreateOrUpdateProductDTO(String name, String description, BigDecimal price) {
    public Product toEntity() {
        return Product.builder()
                .name(name())
                .description(description())
                .price(price())
                .build();
    }
}
