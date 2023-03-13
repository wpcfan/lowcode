package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.dtos.PublishPageDTO;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.Errors;
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

import java.time.LocalTime;

@Slf4j
@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageQueryService pageQueryService;
    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;
    private final PageBlockDataEntityRepository pageBlockDataEntityRepository;

    public PageEntity updatePage(Long id, CreateOrUpdatePageDTO page) {
        var pageEntity = pageQueryService.findById(id);
        if (pageEntity.getStatus() == PageStatus.Published) {
            throw new CustomException("已发布的页面不允许修改", "PageUpdateService#updatePage", Errors.ConstraintViolationException.code());
        }
        pageEntity.setTitle(page.title());
        pageEntity.setConfig(page.config());
        pageEntity.setPageType(page.pageType());
        pageEntity.setPlatform(page.platform());
        return pageEntity;
    }

    public PageEntity publishPage(Long id, PublishPageDTO page) {
        var pageEntity = pageQueryService.findById(id);
        // 设置为当天的零点
        var startTime = page.startTime().with(LocalTime.MIN);
        // 设置为当天的23:59:59.999999999
        var endTime = page.endTime().with(LocalTime.MAX);
        if (pageEntityRepository.countPublishedTimeConflict(startTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
            throw new CustomException("开始时间和已有数据冲突", "PageUpdateService#publishPage", Errors.ConstraintViolationException.code());
        }
        if (pageEntityRepository.countPublishedTimeConflict(endTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
            throw new CustomException("结束时间和已有数据冲突", "PageUpdateService#publishPage", Errors.ConstraintViolationException.code());
        }
        pageEntity.setStatus(PageStatus.Published);
        pageEntity.setStartTime(startTime);
        pageEntity.setEndTime(endTime);
        return pageEntityRepository.save(pageEntity);
    }

    public PageEntity draftPage(Long id) {
        var pageEntity = pageQueryService.findById(id);
        pageEntity.setStatus(PageStatus.Draft);
        pageEntity.setStartTime(null);
        pageEntity.setEndTime(null);
        return pageEntityRepository.save(pageEntity);
    }

    public PageBlockEntity updateBlock(Long blockId, CreateOrUpdatePageBlockDTO block) {
        return pageBlockEntityRepository.findById(blockId)
                .map(pageBlockEntity -> {
                    pageBlockEntity.setConfig(block.config());
                    pageBlockEntity.setSort(block.sort());
                    pageBlockEntity.setTitle(block.title());
                    pageBlockEntity.setType(block.type());
                    return pageBlockEntityRepository.save(pageBlockEntity);
                }).orElseThrow(() -> new CustomException("未找到对应的区块", "PageUpdateService#updateBlock", Errors.DataNotFoundException.code()));
    }

    public PageEntity moveBlock(Long pageId, Long blockId, Integer targetSort) {
        var pageEntity = pageQueryService.findById(pageId);
        var blockEntity = pageEntity.getPageBlocks().stream()
                .filter(pageBlockEntity -> pageBlockEntity.getId().equals(blockId))
                .findFirst()
                .orElseThrow(() -> new CustomException("未找到对应的区块", "PageUpdateService#moveBlock", Errors.DataNotFoundException.code()));
        var sort = blockEntity.getSort();
        if (sort.equals(targetSort)) {
            throw new CustomException("目标位置和当前位置相同", "PageUpdateService#moveBlock", Errors.ConstraintViolationException.code());
        }
        if (sort < targetSort) {
            pageEntity.getPageBlocks().stream()
                    .filter(pageBlockEntity -> pageBlockEntity.getSort() > sort && pageBlockEntity.getSort() <= targetSort)
                    .forEach(pageBlockEntity -> pageBlockEntity.setSort(pageBlockEntity.getSort() - 1));
        } else {
            pageEntity.getPageBlocks().stream()
                    .filter(pageBlockEntity -> pageBlockEntity.getSort() < sort && pageBlockEntity.getSort() >= targetSort)
                    .forEach(pageBlockEntity -> pageBlockEntity.setSort(pageBlockEntity.getSort() + 1));
        }
        blockEntity.setSort(targetSort);
        return pageEntityRepository.save(pageEntity);
    }

    public PageBlockDataEntity updateData(Long dataId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockDataEntityRepository.findById(dataId)
                .map(dataEntity -> {
                    dataEntity.setSort(data.sort());
                    dataEntity.setContent(data.content());
                    return pageBlockDataEntityRepository.save(dataEntity);
                }).orElseThrow(() -> new CustomException("未找到对应的数据", "PageUpdateService#updateData", Errors.FileDeleteException.code()));
    }
}
