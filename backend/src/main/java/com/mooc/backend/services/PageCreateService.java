package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
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

    public PageEntity createPage(CreateOrUpdatePageDTO page) {
        var pageEntity = pageEntityRepository.save(page.toEntity());
        return pageEntity;
    }

    public Optional<PageBlockEntity> addBlockToPage(Long pageId, CreateOrUpdatePageBlockDTO block) {
        return pageEntityRepository.findById(pageId)
                .map(pageEntity -> {
                    if (pageEntity.getStatus() != PageStatus.Draft) {
                        throw new CustomException("只有草稿状态的页面才能添加区块", "PageCreateService#addBlockToPage", 400);
                    }
                    if (block.type() == BlockType.Waterfall && pageBlockEntityRepository.countByTypeAndPageId(BlockType.Waterfall, pageId) > 0L) {
                        throw new CustomException("瀑布流区块只能有一个", "PageCreateService#addBlockToPage", 400);
                    }
                    if (block.type() == BlockType.Waterfall && pageBlockEntityRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, pageId, block.sort()) > 0) {
                        throw new CustomException("瀑布流区块必须在最后", "PageCreateService#addBlockToPage", 400);
                    }
                    var blockEntity = block.toEntity();
                    pageBlockEntityRepository.save(blockEntity);
                    pageEntity.addPageBlock(blockEntity);
                    pageEntityRepository.save(pageEntity);
                    return blockEntity;
                });
    }

    public Optional<PageBlockEntity> insertBlockToPage(Long id, CreateOrUpdatePageBlockDTO insertPageBlockDTO) {
        return pageEntityRepository.findById(id)
                .map(pageEntity -> {
                    if (pageEntity.getStatus() != PageStatus.Draft) {
                        throw new CustomException("只有草稿状态的页面才能插入区块", "PageCreateService#insertBlockToPage", 400);
                    }
                    if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockEntityRepository.countByTypeAndPageId(BlockType.Waterfall, id) > 0L) {
                        throw new CustomException("瀑布流区块只能有一个", "PageCreateService#insertBlockToPage", 400);
                    }
                    if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockEntityRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, id, insertPageBlockDTO.sort()) > 0) {
                        throw new CustomException("瀑布流区块必须在最后", "PageCreateService#insertBlockToPage", 400);
                    }
                    var blockEntity = insertPageBlockDTO.toEntity();
                    pageBlockEntityRepository.save(blockEntity);
                    pageBlockEntityRepository.updateSortByPageIdAndSortGreaterThanEqual(id, insertPageBlockDTO.sort());
                    blockEntity.setSort(insertPageBlockDTO.sort());
                    pageEntity.addPageBlock(blockEntity);
                    pageEntityRepository.save(pageEntity);
                    return blockEntity;
                });
    }

    public Optional<PageBlockDataEntity> addDataToBlock(Long blockId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockEntityRepository.findById(blockId)
                .map(blockEntity -> {
                    if (blockEntity.getPage().getStatus() != PageStatus.Draft) {
                        throw new CustomException("只有草稿状态的页面才能添加区块数据", "PageCreateService#addDataToBlock", 400);
                    }
                    if (blockEntity.getType() == BlockType.Waterfall && blockEntity.getData().size() > 0) {
                        throw new CustomException("瀑布流区块只能有一个数据", "PageCreateService#addDataToBlock", 400);
                    }
                    var dataEntity = data.toEntity();
                    blockEntity.addData(dataEntity);
                    pageBlockEntityRepository.save(blockEntity);
                    return dataEntity;
                });
    }
}
