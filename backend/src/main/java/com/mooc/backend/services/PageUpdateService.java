package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.dtos.PublishPageDTO;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.Errors;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;

/**
 * 页面更新服务：更新页面布局、区块、区块数据
 * @since 1.0
 * @see PageQueryService
 * @see PageLayoutRepository
 * @see PageBlockRepository
 * @see PageBlockDataRepository
 * @see CreateOrUpdatePageDTO
 * @see CreateOrUpdatePageBlockDTO
 * @see CreateOrUpdatePageBlockDataDTO
 */
@Slf4j
@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageQueryService pageQueryService;
    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;
    private final PageBlockDataRepository pageBlockDataRepository;

    /**
     * 更新页面布局
     * @param id 页面ID
     * @param page 页面信息
     * @return 页面布局
     */
    public PageLayout updatePage(Long id, CreateOrUpdatePageDTO page) {
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

    /**
     * 发布（上架）区块：将区块状态设置为已发布
     * @param id 区块ID
     * @param page 区块信息
     * @return 区块信息
     */
    public PageLayout publishPage(Long id, PublishPageDTO page) {
        var pageEntity = pageQueryService.findById(id);
        // 设置为当天的零点
        var startTime = page.startTime().with(LocalTime.MIN);
        // 设置为当天的23:59:59.999999999
        var endTime = page.endTime().with(LocalTime.MAX);
        if (pageLayoutRepository.countPublishedTimeConflict(startTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
            throw new CustomException("开始时间和已有数据冲突", "PageUpdateService#publishPage", Errors.ConstraintViolationException.code());
        }
        if (pageLayoutRepository.countPublishedTimeConflict(endTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
            throw new CustomException("结束时间和已有数据冲突", "PageUpdateService#publishPage", Errors.ConstraintViolationException.code());
        }
        pageEntity.setStatus(PageStatus.Published);
        pageEntity.setStartTime(startTime);
        pageEntity.setEndTime(endTime);
        return pageLayoutRepository.save(pageEntity);
    }

    /**
     * 下架页面：将页面状态设置为草稿
     * @param id 页面ID
     * @return 页面布局
     */
    public PageLayout draftPage(Long id) {
        var pageEntity = pageQueryService.findById(id);
        pageEntity.setStatus(PageStatus.Draft);
        pageEntity.setStartTime(null);
        pageEntity.setEndTime(null);
        return pageLayoutRepository.save(pageEntity);
    }

    /**
     * 更新区块
     * @param blockId 区块ID
     * @param block 区块数据
     * @return 区块
     */
    public PageBlock updateBlock(Long blockId, CreateOrUpdatePageBlockDTO block) {
        return pageBlockRepository.findById(blockId)
                .map(pageBlockEntity -> {
                    pageBlockEntity.setConfig(block.config());
                    pageBlockEntity.setSort(block.sort());
                    pageBlockEntity.setTitle(block.title());
                    pageBlockEntity.setType(block.type());
                    return pageBlockRepository.save(pageBlockEntity);
                }).orElseThrow(() -> new CustomException("未找到对应的区块", "PageUpdateService#updateBlock", Errors.DataNotFoundException.code()));
    }

    /**
     * 移动区块: 将区块移动到目标位置
     * 1. 如果目标位置和当前位置相同, 抛出异常
     * 2. 如果目标位置在当前位置的后面, 将当前位置到目标位置之间的区块的排序值减一
     * 3. 如果目标位置在当前位置的前面, 将当前位置到目标位置之间的区块的排序值加一
     * @param pageId 页面ID
     * @param blockId 区块ID
     * @param targetSort 目标位置
     * @return 页面布局
     */
    public PageLayout moveBlock(Long pageId, Long blockId, Integer targetSort) {
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
        return pageLayoutRepository.save(pageEntity);
    }

    /**
     * 更新区块数据
     * @param dataId 数据ID
     * @param data 数据
     * @return 区块数据
     */
    public PageBlockData updateData(Long dataId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockDataRepository.findById(dataId)
                .map(dataEntity -> {
                    dataEntity.setSort(data.sort());
                    dataEntity.setContent(data.content());
                    return pageBlockDataRepository.save(dataEntity);
                }).orElseThrow(() -> new CustomException("未找到对应的数据", "PageUpdateService#updateData", Errors.FileDeleteException.code()));
    }
}
