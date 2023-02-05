package com.mooc.backend.repositories;

import com.mooc.backend.entities.Product;
import com.mooc.backend.projections.ProductInfo;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.stream.Stream;

public interface ProductRepository extends JpaRepository<Product, Long>, CustomProductRepository {

    /**
     * 获取指定类目下的所有商品
     * EntityGraph 注解是查询时，同时也查询出 categories 和 images，用于解决 N+1 问题
     *
     * @param id 类目 ID
     * @return 指定类目下的所有商品
     */
    @EntityGraph(attributePaths = {"categories", "images"})
    List<Product> findByCategoriesId(Long id);

    List<Product> findByNameLikeOrderByIdDesc(String name);

    Stream<Product> streamByNameLikeIgnoreCaseAndCategoriesCode(String name, String code);

    @EntityGraph(attributePaths = {"categories", "images"})
    Slice<ProductInfo> findPageableByCategoriesId(Long id, Pageable pageable);
}