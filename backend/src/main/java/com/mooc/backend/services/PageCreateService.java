package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
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

    public PageEntity createPage(CreateOrUpdatePageDTO page) {
        var pageEntity = pageEntityRepository.save(page.toEntity());
        return pageEntity;
    }

    public Optional<PageBlockEntity> addBlockToPage(Long pageId, CreateOrUpdatePageBlockDTO block) {
        return pageEntityRepository.findById(pageId)
                .map(pageEntity -> {
                    var blockEntity = block.toEntity();
                    pageBlockEntityRepository.save(blockEntity);
                    pageEntity.addPageBlock(blockEntity);
                    pageEntityRepository.save(pageEntity);
                    return blockEntity;
                });
    }

    public Optional<PageBlockDataEntity> addDataToBlock(Long blockId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockEntityRepository.findById(blockId)
                .map(blockEntity -> {
                    var dataEntity = data.toEntity();
                    pageBlockDataEntityRepository.save(dataEntity);
                    blockEntity.addData(dataEntity);
                    pageBlockEntityRepository.save(blockEntity);
                    return dataEntity;
                });
    }
}
