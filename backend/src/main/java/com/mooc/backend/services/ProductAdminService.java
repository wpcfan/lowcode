package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdateProductRecord;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Transactional
@Service
public class ProductAdminService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    public Product createProduct(CreateOrUpdateProductRecord product) {
        return productRepository.save(product.toEntity());
    }

    public Optional<Product> updateProduct(Long id, CreateOrUpdateProductRecord product) {
        return productRepository.findById(id)
                .map(p -> {
                    p.setName(product.name());
                    p.setDescription(product.description());
                    p.setPrice(product.price());
                    return productRepository.save(p);
                });
    }

    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    public Optional<Product> addCategoryToProduct(Long id, Long categoryId) {
        return productRepository.findById(id)
                .flatMap(p -> categoryRepository.findById(categoryId)
                        .map(c -> {
                            p.addCategory(c);
                            return productRepository.save(p);
                        }));
    }

    public Optional<Product> removeCategoryFromProduct(Long id, Long categoryId) {
        return productRepository.findById(id)
                .flatMap(p -> categoryRepository.findById(categoryId)
                        .map(c -> {
                            p.removeCategory(c);
                            return productRepository.save(p);
                        }));
    }

    public Optional<Product> addImageToProduct(Long id, String imageUrl) {
        return productRepository.findById(id)
                .map(p -> {
                    var imageEntity = ProductImage.builder()
                            .imageUrl(imageUrl)
                            .build();
                    p.addImage(imageEntity);
                    return productRepository.save(p);
                });
    }

    public Optional<Product> removeImageFromProduct(Long id, Long imageId) {
        return productRepository.findById(id)
                .flatMap(p -> p.getImages().stream()
                        .filter(img -> img.getId().equals(imageId))
                        .findFirst()
                        .map(img -> {
                            p.removeImage(img);
                            return productRepository.save(p);
                        }));
    }
}
