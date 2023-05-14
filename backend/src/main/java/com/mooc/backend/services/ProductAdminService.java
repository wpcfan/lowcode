package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdateProductDTO;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 产品管理服务
 */
@RequiredArgsConstructor
@Transactional
@Service
public class ProductAdminService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    /**
     * 创建产品
     * @param product 产品
     * @return 产品
     */
    public Product createProduct(CreateOrUpdateProductDTO product) {
        return productRepository.save(product.toEntity());
    }

    /**
     * 更新产品
     * @param id 产品ID
     * @param product 产品
     * @return 产品
     */
    public Product updateProduct(Long id, CreateOrUpdateProductDTO product) {
        return productRepository.findById(id)
                .map(p -> {
                    p.setName(product.name());
                    p.setDescription(product.description());
                    p.setPrice(product.price());
                    return productRepository.save(p);
                })
                .orElseThrow(() -> new CustomException("未找到产品", "ProductAdminService#updateProduct", 404));
    }

    /**
     * 删除产品
     * @param id 产品ID
     */
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    /**
     * 为产品添加分类
     * @param id 产品ID
     * @param categoryId 分类ID
     * @return 产品
     */
    public Product addCategoryToProduct(Long id, Long categoryId) {
        return productRepository.findById(id)
                .flatMap(p -> categoryRepository.findById(categoryId)
                        .map(c -> {
                            p.addCategory(c);
                            return productRepository.save(p);
                        }))
                .orElseThrow(() -> new CustomException("未找到产品", "ProductAdminService#addCategoryToProduct", 404));
    }

    /**
     * 删除产品分类
     * @param id 产品ID
     * @param categoryId 分类ID
     * @return 产品
     */
    public Product removeCategoryFromProduct(Long id, Long categoryId) {
        return productRepository.findById(id)
                .flatMap(p -> categoryRepository.findById(categoryId)
                        .map(c -> {
                            p.removeCategory(c);
                            return productRepository.save(p);
                        }))
                .orElseThrow(() -> new CustomException("未找到产品", "ProductAdminService#removeCategoryFromProduct", 404));
    }

    /**
     * 添加产品图片
     * @param id 产品ID
     * @param imageUrl 图片URL
     * @return 产品
     */
    public Product addImageToProduct(Long id, String imageUrl) {
        return productRepository.findById(id)
                .map(p -> {
                    var imageEntity = ProductImage.builder()
                            .imageUrl(imageUrl)
                            .build();
                    p.addImage(imageEntity);
                    return productRepository.save(p);
                })
                .orElseThrow(() -> new CustomException("未找到产品", "ProductAdminService#addImageToProduct", 404));
    }

    /**
     * 删除产品图片
     * @param id 产品ID
     * @param imageId 图片ID
     * @return 产品
     */
    public Product removeImageFromProduct(Long id, Long imageId) {
        return productRepository.findById(id)
                .flatMap(p -> p.getImages().stream()
                        .filter(img -> img.getId().equals(imageId))
                        .findFirst()
                        .map(img -> {
                            p.removeImage(img);
                            return productRepository.save(p);
                        }))
                .orElseThrow(() -> new CustomException("未找到产品", "ProductAdminService#removeImageFromProduct", 404));
    }
}
