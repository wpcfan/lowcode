package com.mooc.backend.services;

import com.mooc.backend.entities.Category;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.specifications.CategorySpecs;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<Category> findByNameLike(String name) {
        var specification = CategorySpecs.categorySpec.apply(name);
        return categoryRepository.findAll(specification);
    }
}
