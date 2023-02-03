package com.mooc.backend.rest.app;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.services.PageQueryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/v1/app/pages")
public class PageController {

    final PageQueryService pageQueryService;

    @GetMapping("/{id}")
    public PageDTO findById(Long id) {
        return pageQueryService.findById(id);
    }
}
