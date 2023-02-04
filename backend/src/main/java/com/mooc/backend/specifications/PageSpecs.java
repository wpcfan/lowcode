package com.mooc.backend.specifications;

import com.mooc.backend.entities.PageEntity;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

public class PageSpecs {
    public static Function<PageFilter, Specification<PageEntity>> pageSpec = (PageFilter filter) -> (root, query, builder) -> {
        List<Predicate> predicates = new ArrayList<>();
        if (filter.title() != null) {
            predicates.add(builder.like(root.get("title"), "%" + filter.title().toLowerCase() + "%"));
        }
        if (filter.platform() != null) {
            predicates.add(builder.equal(root.get("platform"), filter.platform()));
        }
        if (filter.pageType() != null) {
            predicates.add(builder.equal(root.get("pageType"), filter.pageType()));
        }
        if (filter.status() != null) {
            predicates.add(builder.equal(root.get("status"), filter.status()));
        }
        if (filter.startDateFrom() != null) {
            predicates.add(builder.greaterThanOrEqualTo(root.get("startTime"), filter.startDateFrom()));
        }
        if (filter.startDateTo() != null) {
            predicates.add(builder.lessThanOrEqualTo(root.get("startTime"), filter.startDateTo()));
        }
        if (filter.endDateFrom() != null) {
            predicates.add(builder.greaterThanOrEqualTo(root.get("endTime"), filter.endDateFrom()));
        }
        if (filter.endDateTo() != null) {
            predicates.add(builder.lessThanOrEqualTo(root.get("endTime"), filter.endDateTo()));
        }
        return query.where(builder.and(predicates.toArray(new Predicate[0])))
                .orderBy(builder.desc(root.get("id")))
                .getRestriction();
    };
}
