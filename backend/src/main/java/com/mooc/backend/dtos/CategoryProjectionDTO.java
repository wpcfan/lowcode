package com.mooc.backend.dtos;

import com.mooc.backend.projections.CategoryInfo;
import lombok.Builder;
import lombok.Data;
import lombok.Value;

import java.util.HashSet;
import java.util.Set;

@Value
@Builder
public class CategoryProjectionDTO {

    private Long id;
    private String name;
    private String code;
    private Long parentId;
    @Builder.Default
    private Set<CategoryProjectionDTO> children = new HashSet<>();

    public static CategoryProjectionDTO from(CategoryInfo category) {
        return CategoryProjectionDTO.builder()
                .id(category.getId())
                .name(category.getName())
                .code(category.getCode())
                .parentId(category.getParent() != null ? category.getParent().getId() : null)
                .children(category.getChildren().stream()
                        .map(CategoryProjectionDTO::from)
                        .collect(HashSet::new, Set::add, Set::addAll))
                .build();
    }
}
