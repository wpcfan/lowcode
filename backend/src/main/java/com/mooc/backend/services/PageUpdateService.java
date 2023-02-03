package com.mooc.backend.services;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageEntityRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageEntityRepository pageEntityRepository;

    public PageEntity updatePage(Long id, PageDTO pageDTO) {
        var pageEntity = pageEntityRepository.findById(id).orElseThrow();
        pageEntity.setPageType(pageDTO.getPageType());
        pageEntity.setPlatform(pageDTO.getPlatform());
        pageEntity.setConfig(pageDTO.getConfig());
        return pageEntity;
    }

    public PageEntity updatePageConfig(Long id, PageConfig pageConfig) {
        var pageEntity = pageEntityRepository.findById(id).orElseThrow();
        pageEntity.setConfig(pageConfig);
        return pageEntity;
    }

    public PageEntity updatePageType(Long id, PageType pageType) {
        var pageEntity = pageEntityRepository.findById(id).orElseThrow();
        pageEntity.setPageType(pageType);
        return pageEntity;
    }

    public PageEntity updatePagePlatform(Long id, Platform platform) {
        var pageEntity = pageEntityRepository.findById(id).orElseThrow();
        pageEntity.setPlatform(platform);
        return pageEntity;
    }

}
