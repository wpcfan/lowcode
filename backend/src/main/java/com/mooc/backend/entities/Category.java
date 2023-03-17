package com.mooc.backend.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "mooc_categories")
public class Category extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String code;

    @Column(nullable = false)
    private String name;

    @ManyToOne
    // @JoinColumn 这个注解是用来指定外键的
    // 如果不指定，会默认使用外键名为：实体名_主键名
    // @JoinColumn(name = "parent_id")
    private Category parent;

    @OneToMany(mappedBy = "parent")
    @ToString.Exclude
    private Set<Category> children = new HashSet<>();

    @ManyToMany(mappedBy = "categories")
    @ToString.Exclude
    private Set<Product> products = new HashSet<>();

    public static CategoryBuilder builder() {
        return new CategoryBuilder();
    }

    public void addChild(Category child) {
        children.add(child);
        child.setParent(this);
    }

    public void removeChild(Category child) {
        children.remove(child);
        child.setParent(null);
    }

    public void addProduct(Product product) {
        products.add(product);
        product.getCategories().add(this);
    }

    public void removeProduct(Product product) {
        products.remove(product);
        product.getCategories().remove(this);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Category other = (Category) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    public static class CategoryBuilder {
        private Long id;
        private String code;
        private String name;
        private Category parent;
        private Set<Category> children = new HashSet<>();
        private Set<Product> products = new HashSet<>();

        public CategoryBuilder id(Long id) {
            this.id = id;
            return this;
        }

        public CategoryBuilder code(String code) {
            this.code = code;
            return this;
        }

        public CategoryBuilder name(String name) {
            this.name = name;
            return this;
        }

        public CategoryBuilder parent(Category parent) {
            this.parent = parent;
            return this;
        }

        public CategoryBuilder children(Set<Category> children) {
            this.children = children;
            return this;
        }

        public CategoryBuilder products(Set<Product> products) {
            this.products = products;
            return this;
        }

        public Category build() {
            Category category = new Category();
            category.setId(id);
            category.setCode(code);
            category.setName(name);
            category.setParent(parent);
            category.setChildren(children);
            category.setProducts(products);
            return category;
        }
    }
}