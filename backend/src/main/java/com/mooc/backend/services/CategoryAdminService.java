package com.mooc.backend.services;

import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mooc.backend.dtos.CreateOrUpdateCategoryRecord;
import com.mooc.backend.entities.Category;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductRepository;

import lombok.RequiredArgsConstructor;

@Transactional
@RequiredArgsConstructor
@Service
public class CategoryAdminService {

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;

    public Category createCategory(CreateOrUpdateCategoryRecord category) {
        return categoryRepository.save(category.toEntity());
    }

    public Optional<Category> updateCategory(Long id, CreateOrUpdateCategoryRecord category) {
        return categoryRepository.findById(id)
                .map(c -> {
                    c.setCode(category.code());
                    c.setName(category.name());
                    return categoryRepository.save(c);
                });
    }

    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }

    public Optional<Category> setCategoryParent(Long id, Long parentId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var parent = categoryRepository.findById(parentId).orElseThrow();
                    c.setParent(parent);
                    return categoryRepository.save(c);
                });
    }

    public Optional<Category> addCategoryChild(Long id, Long childId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var child = categoryRepository.findById(childId).orElseThrow();
                    c.addChild(child);
                    return categoryRepository.save(c);
                });
    }

    public Optional<Category> removeCategoryChild(Long id, Long childId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var child = categoryRepository.findById(childId).orElseThrow();
                    c.removeChild(child);
                    return categoryRepository.save(c);
                });
    }

    public Optional<Category> addProductToCategory(Long id, Long productId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var product = productRepository.findById(productId).orElseThrow();
                    c.addProduct(product);
                    return categoryRepository.save(c);
                });
    }

    public Optional<Category> removeProductFromCategory(Long id, Long productId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var product = productRepository.findById(productId).orElseThrow();
                    c.removeProduct(product);
                    return categoryRepository.save(c);
                });
    }

    public Optional<Category> removeCategoryParent(Long id) {
        return categoryRepository.findById(id)
                .map(c -> {
                    c.setParent(null);
                    return categoryRepository.save(c);
                });
    }
}
