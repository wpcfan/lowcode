package com.mooc.backend.services;

import java.util.List;

import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import com.mooc.backend.entities.Product;
import com.mooc.backend.projections.ProductInfo;
import com.mooc.backend.repositories.ProductRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductQueryService {
    private final ProductRepository productRepository;

    public List<Product> findPageableByCategory(Long id) {
        return productRepository.findByCategoriesId(id);
    }

    public Slice<ProductInfo> findPageableByCategoriesId(Long id, Pageable pageable) {
        return productRepository.findPageableByCategoriesId(id, pageable);
    }

    public Page<Product> findPageableByExample(Example<Product> product, Pageable pageable) {
        return productRepository.findAll(product, pageable);
    }
}
