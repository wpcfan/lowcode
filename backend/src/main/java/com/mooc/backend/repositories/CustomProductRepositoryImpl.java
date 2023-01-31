package com.mooc.backend.repositories;

import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.ProductDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.hibernate.query.Query;

import java.util.*;

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
                .unwrap(Query.class)
                .setTupleTransformer(((tuple, aliases) -> {
                    Map<String, Integer> aliasToIndexMap = Arrays.stream(aliases)
                            .collect(HashMap::new, (map, alias) -> map.put(alias.toLowerCase(Locale.ROOT), map.size()), Map::putAll);
                    return new ProductDTO(
                            (Long) tuple[aliasToIndexMap.get("id")],
                            (String) tuple[aliasToIndexMap.get("name")],
                            (String) tuple[aliasToIndexMap.get("description")],
                            (Integer) tuple[aliasToIndexMap.get("price")],
                            new HashSet<>(Collections.singletonList(new CategoryDTO(
                                    (String) tuple[aliasToIndexMap.get("c_code")],
                                    (String) tuple[aliasToIndexMap.get("c_name")]
                            ))),
                            new HashSet<>(Collections.singletonList((String) tuple[aliasToIndexMap.get("pi_image_url")]))
                    );
                }))
                .getResultList();
    }
}
