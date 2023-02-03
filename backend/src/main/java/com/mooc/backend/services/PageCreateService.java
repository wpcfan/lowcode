package com.mooc.backend.services;

import com.mooc.backend.dtos.*;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.repositories.PageBlockDataEntityRepository;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {

    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;
    private final PageBlockDataEntityRepository pageBlockDataEntityRepository;
    public PageEntity createPage(CreateOrUpdatePageRecord page) {
        var pageEntity = pageEntityRepository.save(page.toEntity());
        return pageEntity;
    }

    public Optional<PageBlockEntity> addBlockToPage(Long pageId, CreateOrUpdatePageBlockRecord block) {
        return pageEntityRepository.findById(pageId)
                .map(pageEntity -> {
                    var blockEntity = block.toEntity();
                    pageBlockEntityRepository.save(blockEntity);
                    pageEntity.addPageBlock(blockEntity);
                    pageEntityRepository.save(pageEntity);
                    return blockEntity;
                });
    }

    public PageBlockDataEntity addDataToBlock(Long blockId, PageBlockDataDTO dataDTO) {
        var blockEntity = pageBlockEntityRepository.findById(blockId).orElseThrow();
        var dataEntity = dataDTO.toEntity();
        dataEntity.setPageBlock(blockEntity);
        return pageBlockDataEntityRepository.save(dataEntity);
    }
}
