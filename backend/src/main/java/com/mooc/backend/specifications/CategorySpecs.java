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

    /**
     * 基于 Spring Data 中的 Specification 查询所有代码或名字中包含指定字符串的分类
     * 应该不区分大小写，所以需要对数据库字段和查询字符串统一进行小写的转换
     * @param nameOrCodeContaining 要查询的分类名或代码
     * @return 一个返回 Specification 的函数
     */
    public static Function<String, Specification<Category>> categoryNameOrCodeContainingSpec  = (nameOrCodeContaining) -> (root, query, builder) -> {
        root.fetch("children", JoinType.LEFT);
        return builder.or(
                builder.like(builder.lower(root.get("name")), "%" + nameOrCodeContaining.toLowerCase() + "%"),
                builder.like(builder.lower(root.get("code")), "%" + nameOrCodeContaining.toLowerCase() + "%"));
    };
}
