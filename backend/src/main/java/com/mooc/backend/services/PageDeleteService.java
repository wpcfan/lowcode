package com.mooc.backend.services;

import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 删除页面服务
 */
@Transactional
@RequiredArgsConstructor
@Service
public class PageDeleteService {

    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;

    /**
     * 删除页面
     * @param pageId 页面ID
     */
    public void deletePage(Long pageId) {
        pageLayoutRepository.deleteById(pageId);
    }

    /**
     * 删除区块
     * @param pageId 页面ID
     * @param blockId 区块ID
     */
    public void deleteBlock(Long pageId, Long blockId) {
        pageLayoutRepository
                .findById(pageId)
                .ifPresent(page -> {
                    page.getPageBlocks().removeIf(block -> block.getId().equals(blockId));
                    pageLayoutRepository.save(page);
                });
    }

    /**
     * 删除区块数据
     * @param blockId 区块ID
     * @param dataId 区块数据ID
     */
    public void deleteData(Long blockId, Long dataId) {
        pageBlockRepository
                .findById(blockId)
                .ifPresent(block -> {
                    block.getData().removeIf(data -> data.getId().equals(dataId));
                    pageBlockRepository.save(block);
                });
    }
}
