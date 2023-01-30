package com.mooc.backend.dtos;

import org.hibernate.transform.ResultTransformer;

import java.util.*;

public class ProductDTOResultTransformer implements ResultTransformer {
    @Override
    public Object transformTuple(Object[] tuple, String[] aliases) {
        Map<String, Integer> aliasToIndexMap = aliasToIndexMap(aliases);
        ProductDTO productDTO = new ProductDTO(
                (Long) tuple[aliasToIndexMap.get("id")],
                (String) tuple[aliasToIndexMap.get("name")],
                (String) tuple[aliasToIndexMap.get("description")],
                (Integer) tuple[aliasToIndexMap.get("price")],
                new HashSet<>(Arrays.asList(
                        new CategoryDTO(
                                (String) tuple[aliasToIndexMap.get("c_code")],
                                (String) tuple[aliasToIndexMap.get("c_name")]
                        )
                )),
                new HashSet<>(Arrays.asList(
                        (String) tuple[aliasToIndexMap.get("pi_image_url")]
                ))
        );
        return productDTO;
    }

    @Override
    public List transformList(List resultList) {
        return resultList;
    }

    private Map<String, Integer> aliasToIndexMap(String[] aliases) {
        Map<String, Integer> aliasToIndexMap = new LinkedHashMap<>();

        for (int i = 0; i < aliases.length; i++) {
            aliasToIndexMap.put(
                    aliases[i].toLowerCase(Locale.ROOT),
                    i
            );
        }

        return aliasToIndexMap;
    }
}
