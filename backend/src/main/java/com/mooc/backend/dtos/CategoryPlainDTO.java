package com.mooc.backend.dtos;

import com.mooc.backend.entities.Category;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@Data
@Builder
@AllArgsConstructor
public class CategoryPlainDTO {
    public CategoryPlainDTO(Long id, String name, String code, Category parent, Set<Category> children) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.parentId = Optional.ofNullable(parent).map(Category::getId).orElse(null);
        this.children = children.stream().map(CategoryPlainDTO::convert).collect(HashSet::new, Set::add, Set::addAll);
    }

    private Long id;
    private String name;
    private String code;
    private Long parentId;

    @Builder.Default
    private Set<CategoryPlainDTO> children = new HashSet<>();

    public static CategoryPlainDTO convert(Category category) {
        return CategoryPlainDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .code(category.getCode())
                .parentId(category.getParent() != null ? category.getParent().getId() : null)
                .children(category.getChildren().stream()
                        .map(CategoryPlainDTO::convert)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }
}
