package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdateProductRecord;
import com.mooc.backend.entities.Product;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Transactional
@Service
public class ProductAdminService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    public Optional<Product> createProduct(CreateOrUpdateProductRecord product) {
        return Optional.of(productRepository.save(product.toEntity()));
    }

    public Optional<Product> updateProduct(Long id, CreateOrUpdateProductRecord product) {
        return productRepository.findById(id)
                .map(p -> {
                    p.setName(product.name());
                    p.setDescription(product.description());
                    p.setPrice(product.price());
                    return p;
                });
    }

    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    public Optional<Product> addCategoryToProduct(Long id, Long categoryId) {
        return productRepository.findById(id)
                .map(p -> {
                    var category = categoryRepository.findById(categoryId).orElseThrow();
                    p.addCategory(category);
                    return p;
                });
    }

    public Optional<Product> removeCategoryFromProduct(Long id, Long categoryId) {
        return productRepository.findById(id)
                .map(p -> {
                    var category = categoryRepository.findById(categoryId).orElseThrow();
                    p.removeCategory(category);
                    return p;
                });
    }

}
