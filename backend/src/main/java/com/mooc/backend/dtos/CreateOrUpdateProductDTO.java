package com.mooc.backend.dtos;

import com.mooc.backend.entities.Product;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;

public record CreateOrUpdateProductDTO(
        @Schema(description = "产品标题", example = "Android Studio开发实战：从零基础到App上线(第3版)（移动开发丛书）") @NotBlank @Length(min = 2, max = 100) String name,
        @Schema(description = "产品描述", example = "Android经典畅销书全面升级更新，持续保持同类书畅销榜前列，一线企业内训首推、Android程序员热捧。") @NotBlank @Length(min = 10, max = 255) String description,
        @Schema(description = "价格", example = "148.80") @NotNull @PositiveOrZero @DecimalMax("99999999.99") BigDecimal price) {
    public Product toEntity() {
        return Product.builder()
                .name(name())
                .description(description())
                .price(price())
                .build();
    }
}
