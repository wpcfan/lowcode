package com.mooc.backend.services;

import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Transactional
@RequiredArgsConstructor
@Service
public class PageDeleteService {

    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;

    public void deletePage(Long pageId) {
        pageEntityRepository.deleteById(pageId);
    }

    public void deleteBlock(Long pageId, Long blockId) {
        pageEntityRepository
                .findById(pageId)
                .ifPresent(page -> {
                    page.getPageBlocks().removeIf(block -> block.getId().equals(blockId));
                    pageEntityRepository.save(page);
                });
    }

    public void deleteData(Long blockId, Long dataId) {
        pageBlockEntityRepository
                .findById(blockId)
                .ifPresent(block -> {
                    block.getData().removeIf(data -> data.getId().equals(dataId));
                    pageBlockEntityRepository.save(block);
                });
    }
}
