package com.mooc.backend.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "mooc_products")
public class Product extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String sku;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @ManyToMany
    @JoinTable(
            name = "mooc_product_categories",
            joinColumns = @JoinColumn(name = "product_id", referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "category_id", referencedColumnName = "id")
    )
    @ToString.Exclude
    private Set<Category> categories = new HashSet<>();

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    private Set<ProductImage> images = new HashSet<>();

    public static ProductBuilder builder() {
        return new ProductBuilder();
    }

    public void addCategory(Category category) {
        categories.add(category);
        category.getProducts().add(this);
    }

    public void removeCategory(Category category) {
        categories.remove(category);
        category.getProducts().remove(this);
    }

    public void addImage(ProductImage image) {
        images.add(image);
        image.setProduct(this);
    }

    public void removeImage(ProductImage image) {
        images.remove(image);
        image.setProduct(null);
    }

    /**
     * 在存储前将价格转换为两位小数
     * `@PrePersist` 在保存前执行
     * `@PreUpdate` 在更新前执行
     */
    @PrePersist
    @PreUpdate
    public void pricePrecisionConversion() {
        price.setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Product other = (Product) obj;
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

    public static class ProductBuilder {
        private String sku;
        private String name;
        private String description;
        private BigDecimal price;
        private Set<Category> categories = new HashSet<>();
        private Set<ProductImage> images = new HashSet<>();

        public ProductBuilder sku(String sku) {
            this.sku = sku;
            return this;
        }

        public ProductBuilder name(String name) {
            this.name = name;
            return this;
        }

        public ProductBuilder description(String description) {
            this.description = description;
            return this;
        }

        public ProductBuilder price(BigDecimal price) {
            this.price = price;
            return this;
        }

        public ProductBuilder categories(Set<Category> categories) {
            this.categories = categories;
            return this;
        }

        public ProductBuilder images(Set<ProductImage> images) {
            this.images = images;
            return this;
        }

        public Product build() {
            Product product = new Product();
            product.setSku(sku);
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setCategories(categories);
            product.setImages(images);
            return product;
        }
    }

}