package com.mooc.backend.dtos;

import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Set;
import java.util.stream.Collectors;


public record ProductAdminDTO(Long id, String sku, String name, String description, BigDecimal originalPrice, BigDecimal price, Set<CategoryDTO> categories,
                              Set<ProductImage> images) implements Serializable {
    @Serial
    private static final long serialVersionUID = -1;

    public static ProductAdminDTO fromEntity(Product product) {
        return new ProductAdminDTO(
                product.getId(),
                product.getSku(),
                product.getName(),
                product.getDescription(),
                product.getOriginalPrice(),
                product.getPrice(),
                product.getCategories().stream()
                        .map(CategoryDTO::fromEntity)
                        .collect(Collectors.toSet()),
                product.getImages()
        );
    }

    public Product toEntity() {
        var product = Product.builder()
                .sku(sku())
                .name(name())
                .description(description())
                .originalPrice(originalPrice())
                .price(price())
                .build();
        images().forEach(image -> {
            var productImage = ProductImage.builder()
                    .product(product)
                    .imageUrl(image.getImageUrl())
                    .build();
            product.addImage(productImage);
        });
        categories().forEach(category -> {
            var categoryEntity = category.toEntity();
            product.addCategory(categoryEntity);
        });
        return product;
    }
}
