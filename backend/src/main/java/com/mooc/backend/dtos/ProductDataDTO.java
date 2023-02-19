package com.mooc.backend.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.enumerations.BlockDataType;

import java.util.Set;

@JsonDeserialize(as = ProductDataDTO.class)
public record ProductDataDTO (
        Long id,
        String name,
        String description,
        String price,
        Set<CategoryDTO> categories,
        Set<String> images
) implements BlockData {
        @JsonProperty(access = JsonProperty.Access.READ_ONLY)
        @Override
        public BlockDataType getDataType() {
                return BlockDataType.Product;
        }
}
