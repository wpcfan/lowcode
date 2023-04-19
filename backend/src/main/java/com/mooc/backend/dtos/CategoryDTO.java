package com.mooc.backend.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.enumerations.BlockDataType;
import com.mooc.backend.projections.CategoryInfo;
import lombok.*;

import java.io.Serial;
import java.util.*;

@JsonDeserialize(as = CategoryDTO.class)
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDTO implements BlockData, Comparable<CategoryDTO> {

    @Serial
    private static final long serialVersionUID = -1;
    private Long id;
    private String name;
    private String code;
    private Long parentId;

    @Builder.Default
    private SortedSet<CategoryDTO> children = new TreeSet<>();

    public static CategoryDTO fromProjection(CategoryInfo category) {
        return CategoryDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .code(category.getCode())
                .parentId(category.getParent() != null ? category.getParent().getId() : null)
                .children(category.getChildren().stream()
                        .map(CategoryDTO::fromProjection)
                        .collect(TreeSet::new, Set::add, Set::addAll))
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
                        .collect(TreeSet::new, Set::add, Set::addAll))
                .build();
    }

    public Category toEntity() {
        var category = Category.builder()
                .name(getName())
                .code(getCode())
                .build();
        Optional.ofNullable(getChildren()).orElse(new TreeSet<>()).forEach(child -> category.addChild(child.toEntity()));
        return category;
    }

    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Category;
    }

    @Override
    public int compareTo(CategoryDTO o) {
        return this.getName().compareTo(o.getName());
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        CategoryDTO other = (CategoryDTO) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
