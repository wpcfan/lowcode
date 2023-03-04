package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdateCategoryDTO;
import com.mooc.backend.entities.Category;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional
@RequiredArgsConstructor
@Service
public class CategoryAdminService {

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;

    public Category createCategory(CreateOrUpdateCategoryDTO category) {
        return categoryRepository.save(category.toEntity());
    }

    public Category updateCategory(Long id, CreateOrUpdateCategoryDTO category) {
        return categoryRepository.findById(id)
                .map(c -> {
                    c.setCode(category.code());
                    c.setName(category.name());
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#updateCategory", 404));
    }

    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }

    public Category setCategoryParent(Long id, Long parentId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var parent = categoryRepository.findById(parentId).orElseThrow();
                    c.setParent(parent);
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#setCategoryParent", 404));
    }

    public Category addCategoryChild(Long id, Long childId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var child = categoryRepository.findById(childId).orElseThrow();
                    c.addChild(child);
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#addCategoryChild", 404));
    }

    public Category removeCategoryChild(Long id, Long childId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var child = categoryRepository.findById(childId).orElseThrow();
                    c.removeChild(child);
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#removeCategoryChild", 404));
    }

    public Category addProductToCategory(Long id, Long productId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var product = productRepository.findById(productId).orElseThrow();
                    c.addProduct(product);
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#addProductToCategory", 404));
    }

    public Category removeProductFromCategory(Long id, Long productId) {
        return categoryRepository.findById(id)
                .map(c -> {
                    var product = productRepository.findById(productId).orElseThrow();
                    c.removeProduct(product);
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#removeProductFromCategory", 404));
    }

    public Category removeCategoryParent(Long id) {
        return categoryRepository.findById(id)
                .map(c -> {
                    c.setParent(null);
                    return categoryRepository.save(c);
                }).orElseThrow(() -> new CustomException("未找到该分类", "CategoryAdminService#removeCategoryParent", 404));
    }
}
