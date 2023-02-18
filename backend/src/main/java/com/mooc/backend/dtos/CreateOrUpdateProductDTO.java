package com.mooc.backend.dtos;

import com.mooc.backend.entities.Product;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

public record CreateOrUpdateProductDTO(
        @NotNull @Length(min = 2, max = 100) String name,
        @NotNull @Length(min = 10, max = 255) String description,
        @NotNull @DecimalMin("0.0") @DecimalMax("99999999.99") BigDecimal price) {
    public Product toEntity() {
        return Product.builder()
                .name(name())
                .description(description())
                .price(price())
                .build();
    }
}
