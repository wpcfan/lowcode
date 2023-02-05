package com.mooc.backend.rest.app;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageQueryService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@Tag(name = "页面", description = "获取页面信息")
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/v1/app/pages")
public class PageController {

    final PageQueryService pageQueryService;

    @Operation(summary = "根据 id 获取页面信息")
    @GetMapping("/{id}")
    public PageDTO findById(@Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        return pageQueryService.findById(id)
                .map(PageDTO::fromProjection)
                .orElseThrow(() -> new CustomException("Page not found", "Page with id " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }
}
