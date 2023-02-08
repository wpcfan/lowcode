package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.dtos.PublishPageDTO;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataEntityRepository;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;
    private final PageBlockDataEntityRepository pageBlockDataEntityRepository;

    public Optional<PageEntity> updatePage(Long id, CreateOrUpdatePageDTO page) {
        return pageEntityRepository.findById(id)
                .map(pageEntity -> {
                    pageEntity.setTitle(page.title());
                    pageEntity.setConfig(page.config());
                    pageEntity.setPageType(page.pageType());
                    pageEntity.setPlatform(page.platform());
                    return pageEntity;
                });
    }

    public Optional<PageEntity> publishPage(Long id, PublishPageDTO page) {
        return pageEntityRepository.findById(id)
                .map(pageEntity -> {
                    if (pageEntityRepository.countPublishedTimeConflict(page.startTime(), pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
                        throw new CustomException("时间冲突", "开始时间和已有数据冲突", HttpStatus.BAD_REQUEST.value());
                    }
                    if (pageEntityRepository.countPublishedTimeConflict(page.endTime(), pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
                        throw new CustomException("时间冲突", "结束时间和已有数据冲突", HttpStatus.BAD_REQUEST.value());
                    }
                    pageEntity.setStatus(PageStatus.Published);
                    pageEntity.setStartTime(page.startTime());
                    pageEntity.setEndTime(page.endTime());
                    return pageEntityRepository.save(pageEntity);
                });
    }

    public Optional<PageEntity> draftPage(Long id) {
        return pageEntityRepository.findById(id)
                .map(pageEntity -> {
                    pageEntity.setStatus(PageStatus.Draft);
                    pageEntity.setStartTime(null);
                    pageEntity.setEndTime(null);
                    return pageEntityRepository.save(pageEntity);
                });
    }

    public Optional<PageBlockEntity> updateBlock(Long blockId, CreateOrUpdatePageBlockDTO block) {
        return pageBlockEntityRepository.findById(blockId)
                .map(pageBlockEntity -> {
                    pageBlockEntity.setConfig(block.config());
                    pageBlockEntity.setSort(block.sort());
                    pageBlockEntity.setTitle(block.title());
                    pageBlockEntity.setType(block.type());
                    return pageBlockEntityRepository.save(pageBlockEntity);
                });
    }

    public Optional<PageBlockDataEntity> updateData(Long dataId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockDataEntityRepository.findById(dataId)
                .map(pageBlockDataEntity -> {
                    pageBlockDataEntity.setSort(data.sort());
                    pageBlockDataEntity.setContent(data.content());
                    return pageBlockDataEntityRepository.save(pageBlockDataEntity);
                });
    }
}
