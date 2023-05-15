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

    /**
     * 根据 ID 查询产品
     * @param id 产品 ID
     * @param pageable 分页条件
     * @return 产品的分页数据
     */
    public Slice<Product> findPageableByCategoriesId(Long id, Pageable pageable) {
        return productRepository.findPageableByCategoriesId(id, pageable);
    }

    /**
     * 根据 Example 查询产品
     * @param product 产品 Example
     * @return 产品
     */
    public Page<Product> findPageableByExample(Example<Product> product, Pageable pageable) {
        return productRepository.findAll(product, pageable);
    }

    /**
     * 根据一组 ID 查询产品集合
     * @param ids ID 集合
     * @return  产品集合
     */
    @Transactional(readOnly = true)
    public Stream<Product> findByIds(Collection<Long> ids) {
        return productRepository.findByIdIn(ids);
    }
}
