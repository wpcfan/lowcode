package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CategoryProjectionDTO;
import com.mooc.backend.dtos.CategoryPlainDTO;
import com.mooc.backend.services.CategoryService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/api/v1/admin/categories")
public class CategoryAdminController {
    private final CategoryService categoryService;

    public CategoryAdminController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping()
    public List<CategoryProjectionDTO> findAll() {
        return categoryService.findAll();
    }


    @GetMapping("/dto")
    public List<CategoryPlainDTO> findAllDTOs() {
        return categoryService.findAllDTOs();
    }
}
