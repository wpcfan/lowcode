package com.mooc.backend.services;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.projections.PageEntityInfo;
import com.mooc.backend.repositories.PageEntityRepository;
import com.mooc.backend.specifications.PageFilter;
import com.mooc.backend.specifications.PageSpecs;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class PageQueryService {

    private final PageEntityRepository pageEntityRepository;

    public Optional<PageEntityInfo> findById(Long id) {
        return pageEntityRepository.findProjectionById(id);
    }

    public List<PageEntity> findSpec(PageFilter filter) {
        var specification = PageSpecs.pageSpec.apply(filter);
        return pageEntityRepository.findAll(specification);
    }
}
