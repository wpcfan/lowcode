package com.mooc.backend.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.enumerations.BlockDataType;
import com.mooc.backend.projections.CategoryInfo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@JsonDeserialize(as = CategoryDTO.class)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDTO implements BlockData {

    private static final long serialVersionUID = -1;
    private Long id;
    private String name;
    private String code;
    private Long parentId;

    @Builder.Default
    private Set<CategoryDTO> children = new HashSet<>();

    public static CategoryDTO fromProjection(CategoryInfo category) {
        return CategoryDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .code(category.getCode())
                .parentId(category.getParent() != null ? category.getParent().getId() : null)
                .children(category.getChildren().stream()
                        .map(CategoryDTO::fromProjection)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }

    public static CategoryDTO fromEntity(Category category) {
        return CategoryDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .code(category.getCode())
                .parentId(category.getParent() != null ? category.getParent().getId() : null)
                .children(category.getChildren().stream()
                        .map(CategoryDTO::fromEntity)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }

    public Category toEntity() {
        var category = Category.builder()
                .name(getName())
                .code(getCode())
                .build();
        Optional.ofNullable(getChildren()).orElse(new HashSet<>()).forEach(child -> category.addChild(child.toEntity()));
        return category;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Category;
    }
}
