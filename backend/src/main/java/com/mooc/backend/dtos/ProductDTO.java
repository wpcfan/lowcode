package com.mooc.backend.dtos;


import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.json.BigDecimalSerializer;
import com.mooc.backend.projections.ProductImageInfo;
import com.mooc.backend.projections.ProductInfo;
import lombok.Builder;
import lombok.Value;
import lombok.With;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 产品数据传输对象
 * 使用 @With 注解，可以在不修改原对象的情况下，创建一个新的对象
 * 使用 @Value 注解，可以自动创建一个不可变的对象
 * 使用 @Builder 注解，可以自动创建一个 Builder 对象
 */
@With
@Value
@Builder
public class ProductDTO implements Serializable {
    private static final long serialVersionUID = -1;
    private Long id;
    private String sku;
    private String name;
    private String description;
    @JsonSerialize(using = BigDecimalSerializer.class)
    private BigDecimal originalPrice;
    @JsonSerialize(using = BigDecimalSerializer.class)
    private BigDecimal price;
    private Set<CategoryDTO> categories;
    private Set<String> images;

    public static ProductDTO fromProjection(ProductInfo product) {
        return ProductDTO.builder()
                .id(product.getId())
                .sku(product.getSku())
                .name(product.getName())
                .description(product.getDescription())
                .originalPrice(product.getOriginalPrice())
                .price(product.getPrice())
                .categories(product.getCategories().stream()
                        .map(CategoryDTO::fromProjection)
                        .collect(Collectors.toSet()))
                .images(product.getImages().stream()
                        .map(ProductImageInfo::getImageUrl)
                        .collect(Collectors.toSet()))
                .build();
    }

    public static ProductDTO fromEntity(Product product) {
        return ProductDTO.builder()
                .id(product.getId())
                .sku(product.getSku())
                .name(product.getName())
                .description(product.getDescription())
                .originalPrice(product.getOriginalPrice())
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
                .sku(getSku())
                .name(getName())
                .description(getDescription())
                .originalPrice(getOriginalPrice())
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
