package com.mooc.backend.rest.app;

import com.mooc.backend.dtos.PageWrapper;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.dtos.SliceWrapper;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.services.ProductQueryService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "商品查询", description = "根据条件查询商品")
@RestController
@RequestMapping(value = "/api/v1/app/products")
public class ProductController {
    private final ProductQueryService productService;

    public ProductController(ProductQueryService productQueryService) {
        this.productService = productQueryService;
    }

    /**
     * 根据商品 ID 查询商品
     *
     * @param id 商品 ID
     * @return 商品列表
     */
    @GetMapping("/by-category/{id}")
    public List<ProductDTO> findAllByCategory(@PathVariable Long id) {
        return productService.findPageableByCategory(id)
                .stream()
                .map(ProductDTO::fromEntity)// 为每个商品设置 Locale
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
