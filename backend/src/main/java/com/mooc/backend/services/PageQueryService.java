package com.mooc.backend.services;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.repositories.PageEntityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class PageQueryService {

    private final PageEntityRepository pageEntityRepository;
    public PageDTO findById(Long id) {
        return pageEntityRepository.findProjectionById(id)
                .map(PageDTO::from)
                .orElseThrow(() -> new RuntimeException("Page not found"));
    }
}
