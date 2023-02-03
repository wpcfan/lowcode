package com.mooc.backend.services;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.projections.PageEntityInfo;
import com.mooc.backend.repositories.PageEntityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.parsing.Problem;
import org.springframework.stereotype.Service;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class PageQueryService {

    private final PageEntityRepository pageEntityRepository;
    public Optional<PageEntityInfo> findById(Long id) {
        return pageEntityRepository.findProjectionById(id);
    }
}
