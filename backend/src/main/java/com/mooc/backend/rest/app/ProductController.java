package com.mooc.backend.rest.app;

import java.util.List;
import java.util.Locale;

import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mooc.backend.dtos.PageWrapper;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.dtos.SliceWrapper;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.services.ProductQueryService;

import io.swagger.v3.oas.annotations.tags.Tag;

@Tag(name = "商品查询", description = "根据条件查询商品")
@RestController
@RequestMapping(value = "/api/v1/app/products")
public class ProductController {
    private final ProductQueryService productService;

    public ProductController(ProductQueryService productQueryService) {
        this.productService = productQueryService;
    }

    @GetMapping("/by-example")
    public PageWrapper<ProductDTO> findPageableByExample(
            @RequestParam(required = false) String keyword,
            @ParameterObject Pageable pageable) {
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
        var result = productService.findPageableByExample(example, pageable).map(ProductDTO::fromEntity);
        return new PageWrapper<>(pageable.getPageNumber(), pageable.getPageSize(), result.getTotalPages(),
                result.getTotalElements(), result.getContent());
    }

    /**
     * 根据商品 ID 查询商品
     * @param id 商品 ID
     * @param locale 请求的区域
     * @return 商品列表
     */
    @GetMapping("/by-category/{id}")
    public List<ProductDTO> findAllByCategory(@PathVariable Long id, Locale locale) {
        return productService.findPageableByCategory(id)
                .stream()
                .map(ProductDTO::fromEntity)
                .map(product -> product.withLocale(locale)) // 为每个商品设置 Locale
                .toList();
    }

    @GetMapping("/by-category/{id}/page")
    public SliceWrapper<ProductDTO> findPageableByCategoriesId(
            @PathVariable(value = "id") Long id,
            @PageableDefault(page = 0, size = 20, sort = "id", direction = Sort.Direction.DESC) @ParameterObject Pageable pageable) {
        var result = productService.findPageableByCategoriesId(id, pageable).map(ProductDTO::fromProjection);

        return new SliceWrapper<>(result.getNumber(), result.getSize(), result.hasNext(), result.getContent());
    }
}
