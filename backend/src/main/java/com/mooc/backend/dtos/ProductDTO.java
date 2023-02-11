package com.mooc.backend.dtos;


import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.projections.ProductImageInfo;
import com.mooc.backend.projections.ProductInfo;
import lombok.Builder;
import lombok.Value;

import java.math.BigDecimal;
import java.util.Set;
import java.util.stream.Collectors;

@Value
@Builder
public class ProductDTO {
    private Long id;
    private String name;
    private String description;
    private BigDecimal price;
    private Set<CategoryDTO> categories;
    private Set<String> images;

    public static ProductDTO fromProjection(ProductInfo product) {
        return ProductDTO.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .categories(product.getCategories().stream()
                        .map(CategoryDTO::fromProjection)
                        .collect(Collectors.toSet()))
                .images(product.getImages().stream()
                        .map(ProductImageInfo::imageUrl)
                        .collect(Collectors.toSet()))
                .build();
    }

    public static ProductDTO fromEntity(Product product) {
        return ProductDTO.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .categories(product.getCategories().stream()
                        .map(CategoryDTO::fromEntity)
                        .collect(Collectors.toSet()))
                .images(product.getImages().stream()
                        .map(ProductImage::getImageUrl)
                        .collect(Collectors.toSet()))
                .build();
    }

    public Product toEntity() {
        var product = Product.builder()
                .name(getName())
                .description(getDescription())
                .price(getPrice())
                .build();
        getImages().forEach(image -> {
            var productImage = new ProductImage();
            productImage.setImageUrl(image);
            product.addImage(productImage);
        });
        getCategories().forEach(category -> product.addCategory(category.toEntity()));
        return product;
    }
}
