package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.dtos.ProductDTO;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonDeserialize(as = ProductData.class)
public class ProductData implements BlockData {
    private Integer sort;
    private ProductDTO product;
}
