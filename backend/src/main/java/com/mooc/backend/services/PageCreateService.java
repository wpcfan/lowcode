package com.mooc.backend.services;

import com.mooc.backend.dtos.PageBlockDTO;
import com.mooc.backend.dtos.PageBlockDataDTO;
import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.repositories.PageBlockDataEntityRepository;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {

    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;
    private final PageBlockDataEntityRepository pageBlockDataEntityRepository;
    public PageEntity createPage(PageDTO pageDTO) {
        var pageEntity = pageEntityRepository.save(pageDTO.toEntity());
        return pageEntity;
    }

    public PageBlockEntity addBlockToPage(Long pageId, PageBlockDTO blockDTO) {
        var pageEntity = pageEntityRepository.findById(pageId).orElseThrow();
        var blockEntity = blockDTO.toEntity();
        blockEntity.setPage(pageEntity);
        return pageBlockEntityRepository.save(blockEntity);
    }

    public PageBlockDataEntity addDataToBlock(Long blockId, PageBlockDataDTO dataDTO) {
        var blockEntity = pageBlockEntityRepository.findById(blockId).orElseThrow();
        var dataEntity = dataDTO.toEntity();
        dataEntity.setPageBlock(blockEntity);
        return pageBlockDataEntityRepository.save(dataEntity);
    }
}
