package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.CategoryRecord;
import com.mooc.backend.dtos.CreateOrUpdateCategoryDTO;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.CategoryAdminService;
import com.mooc.backend.services.CategoryQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "类目管理", description = "添加、修改、删除类目，以及给类目添加父类目，删除父类目")
@RestController
@RequestMapping(value = "/api/v1/admin/categories")
public class CategoryAdminController {
    private final CategoryQueryService categoryQueryService;
    private final CategoryAdminService categoryAdminService;

    public CategoryAdminController(CategoryQueryService categoryQueryService,
                                   CategoryAdminService categoryAdminService) {
        this.categoryQueryService = categoryQueryService;
        this.categoryAdminService = categoryAdminService;
    }

    @Operation(summary = "获取所有类目 - DTO 形式")
    @GetMapping()
    public List<CategoryDTO> findAll() {
        return categoryQueryService.findAll()
                .stream()
                .map(CategoryDTO::fromProjection)
                .toList();
    }

    @Operation(summary = "获取所有类目 - Record 形式")
    @GetMapping("/dto")
    public List<CategoryRecord> findAllDTOs() {
        return categoryQueryService.findAllDTOs();
    }

    @Operation(summary = "添加类目")
    @PostMapping()
    public CategoryDTO createCategory(
            @RequestBody CreateOrUpdateCategoryDTO category) {
        return CategoryDTO.fromEntity(categoryAdminService.createCategory(category));
    }

    @Operation(summary = "更新类目")
    @PutMapping("/{id}")
    public CategoryDTO updateCategory(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @RequestBody CreateOrUpdateCategoryDTO category) {
        return categoryAdminService.updateCategory(id, category)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found", "Category " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除类目")
    @DeleteMapping("/{id}")
    public void deleteCategory(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id) {
        categoryAdminService.deleteCategory(id);
    }

    @Operation(summary = "给类目添加父类目")
    @PostMapping("/{id}/parent/{parentId}")
    public CategoryDTO setCategoryParent(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "父类目 id", name = "parentId") @PathVariable(value = "parentId") Long parentId) {
        return categoryAdminService.setCategoryParent(id, parentId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found",
                        "Category " + id + " not found or parent + " + parentId + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除类目的父类目")
    @DeleteMapping("/{id}/parent")
    public CategoryDTO removeCategoryParent(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id) {
        return categoryAdminService.removeCategoryParent(id)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found",
                        "Category " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "给类目添加子类目")
    @PostMapping("/{id}/child/{childId}")
    public CategoryDTO addCategoryChild(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "子类目 id", name = "childId") @PathVariable(value = "childId") Long childId) {
        return categoryAdminService.addCategoryChild(id, childId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found",
                        "Category " + id + " not found or child + " + childId + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除类目的子类目")
    @DeleteMapping("/{id}/child/{childId}")
    public CategoryDTO removeCategoryChild(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "子类目 id", name = "childId") @PathVariable(value = "childId") Long childId) {
        return categoryAdminService.removeCategoryChild(id, childId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found",
                        "Category " + id + " not found or child + " + childId + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "给类目添加商品")
    @PostMapping("/{id}/product/{productId}")
    public CategoryDTO addProductToCategory(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "商品 id", name = "productId") @PathVariable("productId") Long productId) {
        return categoryAdminService.addProductToCategory(id, productId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found",
                        "Category " + id + " not found or product + " + productId + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除类目的商品")
    @DeleteMapping("/{id}/product/{productId}")
    public CategoryDTO removeProductFromCategory(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "商品 id", name = "productId") @PathVariable("productId") Long productId) {
        return categoryAdminService.removeProductFromCategory(id, productId)
                .map(CategoryDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Category not found",
                        "Category " + id + " not found or product + " + productId + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }
}
