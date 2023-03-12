package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.CreateOrUpdateCategoryDTO;
import com.mooc.backend.enumerations.CategoryRepresentation;
import com.mooc.backend.services.CategoryAdminService;
import com.mooc.backend.services.CategoryQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
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

    @Operation(summary = "获取所有类目")
    @GetMapping()
    public List<CategoryDTO> findAll(
           @Schema(description = "类目的展示形式, \nBASIC - 所有类目平铺，不含子类目嵌套\nWITH_CHILDREN - 所有类目都返回，且每个类目嵌套子类目信息\nROOT_ONLY - 只返回根节点列表，但每个节点都嵌套子类目信息",
                   allowableValues = {"BASIC", "WITH_CHILDREN", "ROOT_ONLY"},
                   defaultValue = "BASIC"
           )
           @RequestParam(required = false, defaultValue = "BASIC") CategoryRepresentation categoryRepresentation) {
        if (categoryRepresentation == CategoryRepresentation.WITH_CHILDREN) {
            return categoryQueryService.findAll()
                    .stream()
                    .map(CategoryDTO::fromProjection)
                    .toList();
        } else if (categoryRepresentation == CategoryRepresentation.ROOT_ONLY) {
            return categoryQueryService.findAll()
                    .stream()
                    .filter(category -> category.getParent() == null)
                    .map(CategoryDTO::fromProjection)
                    .toList();
        }
        return categoryQueryService.findAllDTOs()
                .stream().map(record -> CategoryDTO.builder()
                        .id(record.id())
                        .code(record.code())
                        .name(record.name())
                        .parentId(record.parentId())
                        .build())
                .toList();
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
        return CategoryDTO.fromEntity(categoryAdminService.updateCategory(id, category));
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
        return CategoryDTO.fromEntity(categoryAdminService.setCategoryParent(id, parentId));
    }

    @Operation(summary = "删除类目的父类目")
    @DeleteMapping("/{id}/parent")
    public CategoryDTO removeCategoryParent(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id) {
        return CategoryDTO.fromEntity(categoryAdminService.removeCategoryParent(id));
    }

    @Operation(summary = "给类目添加子类目")
    @PostMapping("/{id}/child/{childId}")
    public CategoryDTO addCategoryChild(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "子类目 id", name = "childId") @PathVariable(value = "childId") Long childId) {
        return CategoryDTO.fromEntity(categoryAdminService.addCategoryChild(id, childId));
    }

    @Operation(summary = "删除类目的子类目")
    @DeleteMapping("/{id}/child/{childId}")
    public CategoryDTO removeCategoryChild(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "子类目 id", name = "childId") @PathVariable(value = "childId") Long childId) {
        return CategoryDTO.fromEntity(categoryAdminService.removeCategoryChild(id, childId));
    }

    @Operation(summary = "给类目添加商品")
    @PostMapping("/{id}/product/{productId}")
    public CategoryDTO addProductToCategory(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "商品 id", name = "productId") @PathVariable("productId") Long productId) {
        return CategoryDTO.fromEntity(categoryAdminService.addProductToCategory(id, productId));
    }

    @Operation(summary = "删除类目的商品")
    @DeleteMapping("/{id}/product/{productId}")
    public CategoryDTO removeProductFromCategory(
            @Parameter(description = "类目 id", name = "id") @PathVariable Long id,
            @Parameter(description = "商品 id", name = "productId") @PathVariable("productId") Long productId) {
        return CategoryDTO.fromEntity(categoryAdminService.removeProductFromCategory(id, productId));
    }
}
