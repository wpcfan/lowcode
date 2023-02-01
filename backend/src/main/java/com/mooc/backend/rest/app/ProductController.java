package com.mooc.backend.rest.app;

import com.mooc.backend.dtos.PageRecord;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.services.ProductService;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/api/v1/app/products")
public class ProductController {
    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/by-example")
    public PageRecord<ProductDTO> findPageableByExample(
            @RequestParam(required = false) String keyword,
            @ParameterObject Pageable pageable
    ) {
        Product productQuery = new Product();
        productQuery.setName(keyword);
        productQuery.setDescription(keyword);
        Category categoryQuery = new Category();
        categoryQuery.setName(keyword);
        productQuery.getCategories().add(categoryQuery);
        ExampleMatcher matcher = ExampleMatcher.matching()
                .withIgnoreCase("name", "description", "categories.name")
                .withMatcher("name", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains())
                .withMatcher("description", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains())
                .withMatcher("categories.name", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains());
        Example<Product> example = Example.of(productQuery, matcher);
        var result = productService.findPageableByExample(example, pageable);
        return new PageRecord<>(pageable.getPageNumber(), pageable.getPageSize(), result.getTotalPages(), result.getTotalElements(), result.getContent());
    }
    @GetMapping("/by-category/{id}")
    public List<ProductDTO> findAllByCategory(@PathVariable Long id) {
        return productService.findPageableByCategory(id);
    }

    @GetMapping("/by-category/{id}/page")
    public PageRecord<ProductDTO> findPageableByCategoriesId(
            @PathVariable Long id,
            @PageableDefault(page = 0, size = 20, sort = "id", direction = Sort.Direction.DESC) @ParameterObject Pageable pageable) {
        var result = productService.findPageableByCategoriesId(id, pageable);
        return new PageRecord<>(result.getNumber(), result.getSize(), result.getTotalPages(), result.getTotalElements(), result.getContent());
    }
}
