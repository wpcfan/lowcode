package com.mooc.backend.specifications;

import com.mooc.backend.entities.Category;
import jakarta.persistence.criteria.*;
import org.springframework.data.jpa.domain.Specification;

public class CategorySpecification implements Specification<Category> {
    final String nameContaining;

    public CategorySpecification(String nameContaining) {
        this.nameContaining = nameContaining;
    }

    @Override
    public Predicate toPredicate(Root<Category> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
        root.fetch("children", JoinType.LEFT);
        return criteriaBuilder.like(root.get("name"), "%" + nameContaining + "%");
    }
}
