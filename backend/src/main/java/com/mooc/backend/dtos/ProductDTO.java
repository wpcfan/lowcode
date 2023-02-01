package com.mooc.backend.dtos;


import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.projections.ProductImageInfo;
import com.mooc.backend.projections.ProductInfo;
import lombok.Builder;
import lombok.Value;

import java.util.Set;
import java.util.stream.Collectors;

@Value
@Builder
public class ProductDTO {
    private Long id;
    private String name;
    private String description;
    private Integer price;
    private Set<CategoryProjectionDTO> categories;
    private Set<String> images;

    public static ProductDTO from(ProductInfo product) {
        return ProductDTO.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .categories(product.getCategories().stream()
                        .map(CategoryProjectionDTO::from)
                        .collect(Collectors.toSet()))
                .images(product.getImages().stream()
                        .map(ProductImageInfo::getImageUrl)
                        .collect(Collectors.toSet()))
                .build();
    }

    public static ProductDTO from(Product product) {
        return ProductDTO.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .categories(product.getCategories().stream()
                        .map(CategoryProjectionDTO::from)
                        .collect(Collectors.toSet()))
                .images(product.getImages().stream()
                        .map(ProductImage::getImageUrl)
                        .collect(Collectors.toSet()))
                .build();
    }
}
