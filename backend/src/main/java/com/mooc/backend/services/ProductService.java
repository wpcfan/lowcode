package com.mooc.backend.services;

import com.mooc.backend.dtos.CategoryProjectionDTO;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.repositories.ProductRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductService {
    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Transactional(readOnly = true)
    public List<ProductDTO> findAllByCategory(Long id) {
        return productRepository.findByCategoriesId(id).stream()
                .map(p -> new ProductDTO(
                        p.getId(),
                        p.getName(),
                        p.getDescription(),
                        p.getPrice(),
                        p.getCategories().stream()
                                .map(c -> CategoryProjectionDTO
                                        .builder()
                                        .id(c.getId())
                                        .name(c.getName())
                                        .code(c.getCode())
                                        .parentId(c.getParent().getId())
                                        .children(c.getChildren().stream()
                                                .map(cc -> CategoryProjectionDTO
                                                        .builder()
                                                        .id(cc.getId())
                                                        .name(cc.getName())
                                                        .code(cc.getCode())
                                                        .parentId(cc.getParent().getId())
                                                        .build())
                                                .collect(Collectors.toSet()))
                                        .build())
                                .collect(Collectors.toSet()),
                        p.getImages().stream()
                                .map(ProductImage::getImageUrl)
                                .collect(Collectors.toSet())
                ))
                .toList();
    }
}
