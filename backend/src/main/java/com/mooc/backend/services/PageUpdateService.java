package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataRecord;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockRecord;
import com.mooc.backend.dtos.CreateOrUpdatePageRecord;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.repositories.PageBlockDataEntityRepository;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;
    private final PageBlockDataEntityRepository pageBlockDataEntityRepository;

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

    public Optional<PageBlockDataEntity> updateData(Long dataId, CreateOrUpdatePageBlockDataRecord data) {
        return pageBlockDataEntityRepository.findById(dataId)
                .map(pageBlockDataEntity -> {
                    pageBlockDataEntity.setSort(data.sort());
                    pageBlockDataEntity.setContent(data.content());
                    return pageBlockDataEntityRepository.save(pageBlockDataEntity);
                });
    }
}
