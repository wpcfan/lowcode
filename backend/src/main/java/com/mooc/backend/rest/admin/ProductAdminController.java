package com.mooc.backend.rest.admin;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mooc.backend.dtos.CreateOrUpdateProductRecord;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.ProductAdminService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@Tag(name = "商品管理", description = "添加、修改、删除商品，以及给商品添加类目，删除类目")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/products")
public class ProductAdminController {
    private final ProductAdminService productAdminService;

    @Operation(summary = "添加商品")
    @PostMapping()
    public ProductDTO createProduct(@RequestBody CreateOrUpdateProductRecord product) {
        return ProductDTO.fromEntity(productAdminService.createProduct(product));
    }

    @Operation(summary = "修改商品")
    @PutMapping("/{id}")
    public ProductDTO updateProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            CreateOrUpdateProductRecord product) {
        return productAdminService.updateProduct(id, product)
                .map(ProductDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Product not found", "Product " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "给商品添加类目")
    @PutMapping("/{id}/category/{categoryId}")
    public ProductDTO addCategoryToProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @Parameter(description = "类目 id", name = "categoryId") @PathVariable Long categoryId) {
        return productAdminService.addCategoryToProduct(id, categoryId)
                .map(ProductDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Product not found", "Product " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除商品的类目")
    @DeleteMapping("/{id}/category/{categoryId}")
    public ProductDTO removeCategoryFromProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @Parameter(description = "类目 id", name = "categoryId") @PathVariable("categoryId") Long categoryId) {
        return productAdminService.removeCategoryFromProduct(id, categoryId)
                .map(ProductDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Product not found", "Product " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除商品")
    @DeleteMapping("/{id}")
    public void deleteProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id) {
        productAdminService.deleteProduct(id);
    }
}
