package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockRecord;
import com.mooc.backend.dtos.CreateOrUpdatePageRecord;
import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.stream.LongStream;

@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;

    public Optional<PageEntity> updatePage(Long id, CreateOrUpdatePageRecord page) {
        return pageEntityRepository.findById(id)
                .map(pageEntity -> {
                    pageEntity.setConfig(page.config());
                    pageEntity.setPageType(page.pageType());
                    pageEntity.setPlatform(page.platform());
                    return pageEntity;
                });
    }


    public Optional<PageBlockEntity> updateBlock(Long blockId, CreateOrUpdatePageBlockRecord block) {
        return pageBlockEntityRepository.findById(blockId)
                .map(pageBlockEntity -> {
                    pageBlockEntity.setConfig(block.config());
                    pageBlockEntity.setSort(block.sort());
                    pageBlockEntity.setTitle(block.title());
                    pageBlockEntity.setType(block.type());
                    return pageBlockEntityRepository.save(pageBlockEntity);
                });
    }
}
