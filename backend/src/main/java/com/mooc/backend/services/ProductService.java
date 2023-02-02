package com.mooc.backend.services;

import com.mooc.backend.dtos.CategoryProjectionDTO;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.repositories.ProductRepository;
lombimport lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    @Transactional(readOnly = true)
    public List<ProductDTO> findPageableByCategory(Long id) {
        return productRepository.findByCategoriesId(id).stream()
                .map(product -> ProductDTO.builder()
                        .id(product.getId())
                        .name(product.getName())
                        .description(product.getDescription())
                        .price(product.getPrice())
                        .categories(product.getCategories().stream()
                                .map(category -> CategoryProjectionDTO.builder()
                                        .id(category.getId())
                                        .name(category.getName())
                                        .code(category.getCode())
                                        .parentId(category.getParent() != null ? category.getParent().getId() : null)
                                        .build())
                                .collect(Collectors.toSet()))
                        .images(product.getImages().stream()
                                .map(ProductImage::getImageUrl)
                                .collect(Collectors.toSet()))
                        .build()
                ).toList();
    }

    public Page<ProductDTO> findPageableByCategoriesId(Long id, Pageable pageable) {
        return productRepository.findPageableByCategoriesId(id, pageable).map(ProductDTO::from);
    }

    public Page<ProductDTO> findPageableByExample(Example<Product> product, Pageable pageable) {
        return productRepository.findAll(product, pageable).map(ProductDTO::from);
    }
}
