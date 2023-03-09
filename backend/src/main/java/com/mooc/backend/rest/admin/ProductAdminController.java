package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.*;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.ProductAdminService;
import com.mooc.backend.services.ProductQueryService;
import com.mooc.backend.services.QiniuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Stream;

@Tag(name = "商品管理", description = "添加、修改、删除商品，以及给商品添加类目，删除类目")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/products")
public class ProductAdminController {
    private final ProductQueryService productQueryService;
    private final ProductAdminService productAdminService;
    private final QiniuService qiniuService;

    @Operation(summary = "添加商品")
    @PostMapping()
    public ProductAdminDTO createProduct(@Valid @RequestBody CreateOrUpdateProductDTO product) {
        return ProductAdminDTO.fromEntity(productAdminService.createProduct(product));
    }

    @Operation(summary = "修改商品")
    @PutMapping("/{id}")
    public ProductAdminDTO updateProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdateProductDTO product) {
        return ProductAdminDTO.fromEntity(productAdminService.updateProduct(id, product));
    }

    @Operation(summary = "给商品添加类目")
    @PutMapping("/{id}/category/{categoryId}")
    public ProductAdminDTO addCategoryToProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @Parameter(description = "类目 id", name = "categoryId") @PathVariable Long categoryId) {
        return ProductAdminDTO.fromEntity(productAdminService.addCategoryToProduct(id, categoryId));
    }

    @Operation(summary = "删除商品的类目")
    @DeleteMapping("/{id}/category/{categoryId}")
    public ProductAdminDTO removeCategoryFromProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @Parameter(description = "类目 id", name = "categoryId") @PathVariable("categoryId") Long categoryId) {
        return ProductAdminDTO.fromEntity(productAdminService.removeCategoryFromProduct(id, categoryId));
    }

    @Operation(summary = "删除商品")
    @DeleteMapping("/{id}")
    public void deleteProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id) {
        productAdminService.deleteProduct(id);
    }

    @Operation(summary = "添加商品图片")
    @PostMapping(value = "/{id}/images", consumes = "multipart/form-data")
    public ProductAdminDTO addImageToProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @RequestParam("file") MultipartFile file) {
        try {
            var result = qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
            return ProductAdminDTO.fromEntity(productAdminService.addImageToProduct(id, result.url()));
        } catch (IOException e) {
            throw new CustomException("File Upload error", e.getMessage(), 500);
        }
    }

    @Operation(summary = "删除商品图片")
    @DeleteMapping("/{id}/images/{imageId}")
    public ProductAdminDTO removeImageFromProduct(
            @Parameter(description = "商品 id", name = "id") @PathVariable Long id,
            @Parameter(description = "图片 id", name = "imageId") @PathVariable Long imageId) {
        return ProductAdminDTO.fromEntity(productAdminService.removeImageFromProduct(id, imageId));
    }

    @GetMapping("/by-example")
    public PageWrapper<ProductDTO> findPageableByExample(
            @RequestParam(required = false) String keyword,
            @ParameterObject Pageable pageable) {
        Product productQuery = new Product();
        productQuery.setSku(keyword);
        productQuery.setName(keyword);
        productQuery.setDescription(keyword);
        Category categoryQuery = new Category();
        categoryQuery.setName(keyword);
        productQuery.getCategories().add(categoryQuery);
        ExampleMatcher matcher = ExampleMatcher.matchingAny()
                .withIgnoreCase("sku", "name", "description", "categories.name")
                .withMatcher("sku", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains())
                .withMatcher("name", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains())
                .withMatcher("description", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains())
                .withMatcher("categories.name", ExampleMatcher.GenericPropertyMatchers.ignoreCase().contains());
        Example<Product> example = Example.of(productQuery, matcher);
        var result = productQueryService.findPageableByExample(example, pageable).map(ProductDTO::fromEntity);
        return new PageWrapper<>(pageable.getPageNumber(), pageable.getPageSize(), result.getTotalPages(),
                result.getTotalElements(), result.getContent());
    }

    @GetMapping("/by-category/{id}/page")
    public SliceWrapper<ProductDTO> findPageableByCategoriesId(
            @PathVariable(value = "id") Long id,
            @PageableDefault(page = 0, size = 20, sort = "id", direction = Sort.Direction.DESC) @ParameterObject Pageable pageable) {
        var result = productQueryService.findPageableByCategoriesId(id, pageable).map(ProductDTO::fromProjection);

        return new SliceWrapper<>(result.getNumber(), result.getSize(), result.hasNext(), result.getContent());
    }

    @Operation(summary = "根据一组 Id 查询商品", responses = {
            @ApiResponse(responseCode = "200", description = "成功", content = @Content(array = @ArraySchema(schema = @Schema(implementation = ProductDTO.class))))
    })
    @PostMapping("/by-ids")
    public Stream<ProductDTO> findByIds(@RequestBody Set<Long> ids) {
        return productQueryService.findByIds(ids).map(ProductDTO::fromEntity);
    }
}
