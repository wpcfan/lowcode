package com.mooc.backend.services;

import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Transactional
@RequiredArgsConstructor
@Service
public class PageDeleteService {

    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;

    public void deletePage(Long pageId) {
        pageLayoutRepository.deleteById(pageId);
    }

    public void deleteBlock(Long pageId, Long blockId) {
        pageLayoutRepository
                .findById(pageId)
                .ifPresent(page -> {
                    page.getPageBlocks().removeIf(block -> block.getId().equals(blockId));
                    pageLayoutRepository.save(page);
                });
    }

    public void deleteData(Long blockId, Long dataId) {
        pageBlockRepository
                .findById(blockId)
                .ifPresent(block -> {
                    block.getData().removeIf(data -> data.getId().equals(dataId));
                    pageBlockRepository.save(block);
                });
    }
}
