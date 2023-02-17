package com.mooc.backend.specifications;

import com.mooc.backend.entities.PageEntity;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

public class PageSpecs {
    /**
     * 用于构造动态查询条件
     * 1. 通过 PageFilter 对象获取查询条件
     * 2. 通过 builder 构造查询条件
     * 3. 通过 query 构造最终的查询语句
     * 4. 返回查询语句
     * <p>
     * 通过 Function 接口，将 PageFilter 对象转换为 Specification 对象
     * 通过 Specification 对象，可以构造动态查询条件
     */
    public static Function<PageFilter, Specification<PageEntity>> pageSpec = (filter) -> (root, query, builder) -> {
        // root: 代表查询的实体类
        // query: 查询语句
        // builder: 构造查询条件的工具
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
        // 使用 builder.and() 方法，将所有的查询条件组合起来
        // 使用 query.where() 方法，将组合好的查询条件设置到查询语句中
        return query.where(builder.and(predicates.toArray(new Predicate[0])))
                .orderBy(builder.desc(root.get("id")))
                .getRestriction();
    };
}
