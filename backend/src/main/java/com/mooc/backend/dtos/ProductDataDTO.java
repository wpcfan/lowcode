package com.mooc.backend.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.enumerations.BlockDataType;
import com.mooc.backend.json.MathUtils;

import java.util.Set;
import java.util.stream.Collectors;

@JsonDeserialize(as = ProductDataDTO.class)
public record ProductDataDTO (
        Long id,
        String name,
        String description,
        String price,
        Set<CategoryDTO> categories,
        Set<String> images
) implements BlockData {
        @JsonProperty(access = JsonProperty.Access.READ_ONLY)
        @Override
        public BlockDataType getDataType() {
                return BlockDataType.Product;
        }

        public static ProductDataDTO fromEntity(com.mooc.backend.entities.Product product) {
                return new ProductDataDTO(
                        product.getId(),
                        product.getName(),
                        product.getDescription(),
                        MathUtils.formatPrice(product.getPrice()),
                        product.getCategories().stream().map(CategoryDTO::fromEntity).collect(Collectors.toSet()),
                        product.getImages().stream().map(ProductImage::getImageUrl).collect(Collectors.toSet())
                );
        }
}
