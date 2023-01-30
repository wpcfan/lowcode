package com.mooc.backend.repositories;

import com.mooc.backend.entities.Product;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long>, CustomProductRepository {

    @EntityGraph(attributePaths = {"categories", "images"})
    List<Product> findByCategoriesId(Long id);
}