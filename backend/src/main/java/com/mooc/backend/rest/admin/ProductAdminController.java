package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CreateOrUpdateProductRecord;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.services.ProductAdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/products")
public class ProductAdminController {
    private final ProductAdminService productAdminService;

    @PostMapping()
    public ProductDTO createProduct(@RequestBody CreateOrUpdateProductRecord product) {
        return productAdminService.createProduct(product)
                .map(ProductDTO::fromEntity)
                .orElseThrow();
    }

    @PutMapping("/{id}")
    public ProductDTO updateProduct(@PathVariable Long id, CreateOrUpdateProductRecord product) {
        return productAdminService.updateProduct(id, product)
                .map(ProductDTO::fromEntity)
                .orElseThrow();
    }

    @PutMapping("/{id}/category/{categoryId}")
    public ProductDTO addCategoryToProduct(@PathVariable Long id, @PathVariable Long categoryId) {
        return productAdminService.addCategoryToProduct(id, categoryId)
                .map(ProductDTO::fromEntity)
                .orElseThrow();
    }

    @DeleteMapping("/{id}/category/{categoryId}")
    public ProductDTO removeCategoryFromProduct(@PathVariable Long id, @PathVariable Long categoryId) {
        return productAdminService.removeCategoryFromProduct(id, categoryId)
                .map(ProductDTO::fromEntity)
                .orElseThrow();
    }

    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        productAdminService.deleteProduct(id);
    }
}
