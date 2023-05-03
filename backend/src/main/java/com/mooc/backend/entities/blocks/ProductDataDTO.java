package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.enumerations.BlockDataType;
import com.mooc.backend.json.MathUtils;

import java.io.Serial;
import java.util.Set;
import java.util.stream.Collectors;

@JsonDeserialize(as = ProductDataDTO.class)
public record ProductDataDTO(
        Long id,
        String sku,
        String name,
        String description,
        String originalPrice,
        String price,
        Set<CategoryDTO> categories,
        Set<String> images
) implements BlockData {
    @Serial
    private static final long serialVersionUID = -1;

    public static ProductDataDTO fromEntity(Product product) {
        return new ProductDataDTO(
                product.getId(),
                product.getSku(),
                product.getName(),
                product.getDescription(),
                MathUtils.formatPrice(product.getOriginalPrice()),
                MathUtils.formatPrice(product.getPrice()),
                product.getCategories().stream().map(CategoryDTO::fromEntity).collect(Collectors.toSet()),
                product.getImages().stream().map(ProductImage::getImageUrl).collect(Collectors.toSet())
        );
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Product;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ProductDataDTO other = (ProductDataDTO) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
