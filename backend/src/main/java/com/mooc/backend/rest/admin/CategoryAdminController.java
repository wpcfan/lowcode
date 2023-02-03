package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.CategoryRecord;
import com.mooc.backend.dtos.CreateOrUpdateCategoryRecord;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.CategoryAdminService;
import com.mooc.backend.services.CategoryQueryService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/api/v1/admin/categories")
public class CategoryAdminController {
    private final CategoryQueryService categoryQueryService;
    private final CategoryAdminService categoryAdminService;

    public CategoryAdminController(CategoryQueryService categoryQueryService, CategoryAdminService categoryAdminService) {
        this.categoryQueryService = categoryQueryService;
        this.categoryAdminService = categoryAdminService;
    }

    @GetMapping()
    public List<CategoryDTO> findAll() {
        return categoryQueryService.findAll()
                .stream()
                .map(CategoryDTO::fromProjection)
                .toList();
    }


    @GetMapping("/dto")
    public List<CategoryRecord> findAllDTOs() {
        return categoryQueryService.findAllDTOs();
    }

    @PostMapping()
    public CategoryDTO createCategory(@RequestBody CreateOrUpdateCategoryRecord category) {
        return CategoryDTO.fromEntity(categoryAdminService.createCategory(category));
    }

    @PutMapping("/{id}")
    public CategoryDTO updateCategory(@PathVariable Long id, @RequestBody CreateOrUpdateCategoryRecord category) {
        return categoryAdminService.updateCategory(id, category)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @DeleteMapping("/{id}")
    public void deleteCategory(@PathVariable Long id) {
        categoryAdminService.deleteCategory(id);
    }

    @PatchMapping("/{id}/parent/{parentId}")
    public CategoryDTO setCategoryParent(@PathVariable Long id, @PathVariable Long parentId) {
        return categoryAdminService.setCategoryParent(id, parentId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found or parent + " + parentId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @PatchMapping("/{id}/child/{childId}")
    public CategoryDTO addCategoryChild(@PathVariable Long id, @PathVariable Long childId) {
        return categoryAdminService.addCategoryChild(id, childId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found or child + " + childId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @DeleteMapping("/{id}/child/{childId}")
    public CategoryDTO removeCategoryChild(@PathVariable Long id, @PathVariable Long childId) {
        return categoryAdminService.removeCategoryChild(id, childId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found or child + " + childId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @PatchMapping("/{id}/product/{productId}")
    public CategoryDTO addProductToCategory(@PathVariable Long id, @PathVariable Long productId) {
        return categoryAdminService.addProductToCategory(id, productId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found or product + " + productId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @DeleteMapping("/{id}/product/{productId}")
    public CategoryDTO removeProductFromCategory(@PathVariable Long id, @PathVariable Long productId) {
        return categoryAdminService.removeProductFromCategory(id, productId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found or product + " + productId + " not found", HttpStatus.NOT_FOUND.value()));
    }
}
