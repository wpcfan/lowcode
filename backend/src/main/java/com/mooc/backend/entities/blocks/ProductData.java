package com.mooc.backend.entities.blocks;

import com.mooc.backend.dtos.ProductDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductData {
    private int sort;
    private ProductDTO product;
}
