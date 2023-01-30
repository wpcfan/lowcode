package com.mooc.backend.services;

import com.mooc.backend.dtos.CategoryDTO;
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
                                .map(c -> new CategoryDTO(c.getId(), c.getName()))
                                .collect(Collectors.toSet()),
                        p.getImages().stream()
                                .map(ProductImage::getImageUrl)
                                .collect(Collectors.toSet())
                ))
                .toList();
    }
}
