package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.entities.Product;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonDeserialize(as = ProductData.class)
public class ProductData implements BlockData {
    private Integer sort;
    private Product data;
}
