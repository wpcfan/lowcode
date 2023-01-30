package com.mooc.backend.repositories;

import com.mooc.backend.dtos.ProductDTO;

import java.util.List;

public interface CustomProductRepository {
    List<ProductDTO> findProductDTOsByCategoriesId(Long id);
}
