package com.mooc.backend.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "mooc_product_images")
public class ProductImage extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;

    public static ProductImageBuilder builder() {
        return new ProductImageBuilder();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ProductImage other = (ProductImage) obj;
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

    public static class ProductImageBuilder {
        private Long id;
        private String imageUrl;
        private Product product;

        public ProductImageBuilder id(Long id) {
            this.id = id;
            return this;
        }

        public ProductImageBuilder imageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
            return this;
        }

        public ProductImageBuilder product(Product product) {
            this.product = product;
            return this;
        }

        public ProductImage build() {
            ProductImage productImage = new ProductImage();
            productImage.setId(id);
            productImage.setImageUrl(imageUrl);
            productImage.setProduct(product);
            return productImage;
        }
    }
}