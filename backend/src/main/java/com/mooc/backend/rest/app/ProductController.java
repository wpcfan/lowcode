package com.mooc.backend.rest.app;

import com.mooc.backend.dtos.PageRecord;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.services.ProductService;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/api/v1/app/products")
public class ProductController {
    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/by-category/{id}")
    public List<ProductDTO> findAllByCategory(@PathVariable Long id) {
        return productService.findPageableByCategory(id);
    }

    @GetMapping("/by-category/{id}/page")
    public PageRecord<ProductDTO> findPageableByCategoriesId(@PathVariable Long id, Pageable pageable) {
        var result = productService.findPageableByCategoriesId(id, pageable);
        return new PageRecord<>(result.getNumber(), result.getSize(), result.getTotalPages(), result.getTotalElements(), result.getContent());
    }
}
