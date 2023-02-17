package com.mooc.backend.dtos;

import com.mooc.backend.entities.Category;
import com.mooc.backend.projections.CategoryInfo;
import lombok.Builder;
import lombok.Value;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@Value
@Builder
public class CategoryDTO {

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
}
