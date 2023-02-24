package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
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

import java.time.LocalDateTime;
import java.time.LocalTime;
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
                    if (pageEntity.getStatus() == PageStatus.Published) {
                        throw new CustomException("已发布的页面不允许修改", "PageUpdateService#updatePage", HttpStatus.BAD_REQUEST.value());
                    }
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
                    // 设置为当天的零点
                    var startTime = page.startTime().with(LocalTime.MIN);
                    // 设置为当天的23:59:59.999999999
                    var endTime = page.endTime().with(LocalTime.MAX);
                    if (pageEntityRepository.countPublishedTimeConflict(startTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
                        throw new CustomException("开始时间和已有数据冲突", "PageUpdateService#publishPage", HttpStatus.BAD_REQUEST.value());
                    }
                    if (pageEntityRepository.countPublishedTimeConflict(endTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
                        throw new CustomException("结束时间和已有数据冲突", "PageUpdateService#publishPage", HttpStatus.BAD_REQUEST.value());
                    }
                    pageEntity.setStatus(PageStatus.Published);
                    pageEntity.setStartTime(startTime);
                    pageEntity.setEndTime(endTime);
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
