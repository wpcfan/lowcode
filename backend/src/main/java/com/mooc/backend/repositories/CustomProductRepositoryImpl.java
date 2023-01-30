package com.mooc.backend.repositories;

import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.dtos.ProductDTOResultTransformer;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

public class CustomProductRepositoryImpl implements CustomProductRepository{

    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    @Override
    public List<ProductDTO> findProductDTOsByCategoriesId(Long id) {
        return entityManager.createNativeQuery(
                        """
                        SELECT
                            p.id AS id,
                            p.name AS name,
                            p.description as description,
                            p.price AS price,
                            c.code AS c_code,
                            c.name AS c_name,
                            pi.image_url AS pi_image_url
                        FROM
                            mooc_products p
                        LEFT JOIN
                            mooc_product_categories pc
                        ON
                            p.id = pc.product_id
                        LEFT JOIN
                            mooc_categories c
                        ON
                            pc.category_id = c.id
                        LEFT JOIN
                            mooc_product_images pi
                        ON
                            p.id = pi.product_id
                        WHERE
                            c.id = :id
                        """)
                .setParameter("id", id)
                .unwrap(org.hibernate.query.Query.class)
                .setResultTransformer(new ProductDTOResultTransformer())
                .getResultList();
    }
}
