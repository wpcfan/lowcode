package com.mooc.backend.services;

import com.mooc.backend.entities.Product;
import com.mooc.backend.projections.ProductInfo;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductQueryService {
    private final ProductRepository productRepository;

    public List<Product> findPageableByCategory(Long id) {
        return productRepository.findByCategoriesId(id);
    }

    public Page<ProductInfo> findPageableByCategoriesId(Long id, Pageable pageable) {
        return productRepository.findPageableByCategoriesId(id, pageable);
    }

    public Page<Product> findPageableByExample(Example<Product> product, Pageable pageable) {
        return productRepository.findAll(product, pageable);
    }
}
