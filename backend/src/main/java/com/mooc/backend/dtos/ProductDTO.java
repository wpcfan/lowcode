package com.mooc.backend.dtos;

import java.util.Set;

public record ProductDTO(Long id, String name, String description, Integer price, Set<CategoryProjectionDTO> categories, Set<String> images) {
}
