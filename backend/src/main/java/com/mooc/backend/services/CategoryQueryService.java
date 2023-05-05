package com.mooc.backend.services;

import com.mooc.backend.dtos.CategoryRecord;
import com.mooc.backend.entities.Category;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.specifications.CategorySpecs;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryQueryService {
    private final CategoryRepository categoryRepository;

    public CategoryQueryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    /**
     * 获得类目列表
     *
     * @return 带子类目的列表
     */
    public List<Category> findAll() {
        return categoryRepository.findAll(Category.class);
    }

    /**
     * 直接使用 DTO
     *
     * @return 带子类目的列表
     */
    public List<CategoryRecord> findAllDTOs() {
        return categoryRepository.findAllCategoryPlainDTOs();
    }

    public List<Category> findByNameLike(String name) {
        var specification = CategorySpecs.categorySpec.apply(name);
        return categoryRepository.findAll(specification);
    }
}
