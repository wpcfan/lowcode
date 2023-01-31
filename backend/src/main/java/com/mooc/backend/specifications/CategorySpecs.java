package com.mooc.backend.specifications;

import com.mooc.backend.entities.Category;
import jakarta.persistence.criteria.JoinType;
import org.springframework.data.jpa.domain.Specification;

import java.util.function.Function;

public class CategorySpecs {
    public static Function<String, Specification<Category>> categorySpec = (nameContaining) -> (root, query, builder) -> {
        root.fetch("children", JoinType.LEFT);
        return builder.like(root.get("name"), "%" + nameContaining + "%");
    };
}
