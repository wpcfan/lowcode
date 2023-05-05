package com.mooc.backend.services;

import com.mooc.backend.entities.Product;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.List;
import java.util.stream.Stream;

@Service
@RequiredArgsConstructor
public class ProductQueryService {
    private final ProductRepository productRepository;

    public List<Product> findPageableByCategory(Long id) {
        return productRepository.findPageableByCategoriesId(id);
    }

    public Slice<Product> findPageableByCategoriesId(Long id, Pageable pageable) {
        return productRepository.findPageableByCategoriesId(id, pageable);
    }

    public Page<Product> findPageableByExample(Example<Product> product, Pageable pageable) {
        return productRepository.findAll(product, pageable);
    }

    @Transactional(readOnly = true)
    public Stream<Product> findByIds(Collection<Long> ids) {
        return productRepository.findByIdIn(ids);
    }
}
