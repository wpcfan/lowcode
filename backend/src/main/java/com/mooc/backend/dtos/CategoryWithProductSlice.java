package com.mooc.backend.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.enumerations.BlockDataType;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@JsonDeserialize(as = CategoryWithProductSlice.class)
@Getter
@Setter
@Builder
public class CategoryWithProductSlice implements BlockData {
    private Long id;
    private String name;
    private String code;
    private Long parentId;
    @Builder.Default
    private Set<CategoryDTO> children = new HashSet<>();
    private SliceWrapper<ProductDTO> productSlice;

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Category;
    }
}
