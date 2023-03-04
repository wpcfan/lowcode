package com.mooc.backend.services;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataEntityRepository;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

@Transactional
@RequiredArgsConstructor
@Service
public class PageDeleteService {

    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;
    private final PageBlockDataEntityRepository pageBlockDataEntityRepository;

    @CacheEvict(cacheNames = "pageCache", key = "#pageId")
    public void deletePage(Long pageId) {
        pageEntityRepository.deleteById(pageId);
    }

    @CacheEvict(cacheNames = "pageCache", key = "#pageId")
    public void deleteBlock(Long pageId, Long blockId) {
        pageEntityRepository
                .findById(pageId)
                .flatMap(page -> page.getPageBlocks().stream().filter(b -> b.getId().equals(blockId)).findFirst())
                .ifPresent(block -> {
            pageBlockEntityRepository.deleteById(blockId);
        });
    }

    @CacheEvict(cacheNames = "pageCache", key = "#pageId")
    public void deleteData(Long blockId, Long dataId) {
        pageBlockEntityRepository
                .findById(blockId)
                .flatMap(block -> block.getData().stream().filter(d -> d.getId().equals(dataId)).findFirst())
                .ifPresent(data -> {
            pageBlockDataEntityRepository.deleteById(dataId);
        });
    }
}
