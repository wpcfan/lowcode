package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.CategoryRecord;
import com.mooc.backend.services.CategoryQueryService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/api/v1/admin/categories")
public class CategoryAdminController {
    private final CategoryQueryService categoryQueryService;

    public CategoryAdminController(CategoryQueryService categoryQueryService) {
        this.categoryQueryService = categoryQueryService;
    }

    @GetMapping()
    public List<CategoryDTO> findAll() {
        return categoryQueryService.findAll()
                .stream()
                .map(CategoryDTO::fromProjection)
                .toList();
    }


    @GetMapping("/dto")
    public List<CategoryRecord> findAllDTOs() {
        return categoryQueryService.findAllDTOs();
    }
}
