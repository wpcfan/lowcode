package com.mooc.backend.rest.app;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageQueryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/v1/app/pages")
public class PageController {

    final PageQueryService pageQueryService;

    @GetMapping("/{id}")
    public PageDTO findById(@PathVariable Long id) {
        return pageQueryService.findById(id)
                .map(PageDTO::fromProjection)
                .orElseThrow(() -> new CustomException("Page not found", "Page with id " + id + " not found", HttpStatus.NOT_FOUND.value()));
    }
}
