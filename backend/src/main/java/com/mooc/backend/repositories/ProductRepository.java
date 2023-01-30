package com.mooc.backend.repositories;

import com.mooc.backend.entities.Product;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByCategoriesId(Long id);
}