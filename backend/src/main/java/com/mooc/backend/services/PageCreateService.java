package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;

@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {

    private final PageQueryService pageQueryService;
    private final PageEntityRepository pageEntityRepository;
    private final PageBlockEntityRepository pageBlockEntityRepository;

    public PageEntity createPage(CreateOrUpdatePageDTO page) {
        var pageEntity = pageEntityRepository.save(page.toEntity());
        return pageEntity;
    }

    public PageEntity addBlockToPage(Long pageId, CreateOrUpdatePageBlockDTO block) {
        var pageEntity = pageQueryService.findById(pageId);
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
        return pageEntityRepository.save(pageEntity);
    }

    public PageEntity insertBlockToPage(Long id, CreateOrUpdatePageBlockDTO insertPageBlockDTO) {
        var pageEntity = pageQueryService.findById(id);
        if (pageEntity.getStatus() != PageStatus.Draft) {
            throw new CustomException("只有草稿状态的页面才能插入区块", "PageCreateService#insertBlockToPage", 400);
        }
        if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockEntityRepository.countByTypeAndPageId(BlockType.Waterfall, id) > 0L) {
            throw new CustomException("瀑布流区块只能有一个", "PageCreateService#insertBlockToPage", 400);
        }
        if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockEntityRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, id, insertPageBlockDTO.sort()) > 0) {
            throw new CustomException("瀑布流区块必须在最后", "PageCreateService#insertBlockToPage", 400);
        }
        pageEntity.getPageBlocks().stream()
                .filter(pageBlockEntity -> pageBlockEntity.getSort() >= insertPageBlockDTO.sort())
                .forEach(pageBlockEntity -> pageBlockEntity.setSort(pageBlockEntity.getSort() + 1));
        var blockEntity = insertPageBlockDTO.toEntity();
        pageEntity.addPageBlock(blockEntity);
        var savedPageEntity = pageEntityRepository.save(pageEntity);
        return savedPageEntity;
    }

    public PageBlockDataEntity addDataToBlock(Long blockId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockEntityRepository.findById(blockId)
                .map(blockEntity -> {
                    if (blockEntity.getType() == BlockType.Waterfall && blockEntity.getData().size() > 0) {
                        throw new CustomException("瀑布流区块只能有一个数据", "PageCreateService#addDataToBlock", 400);
                    }
                    var dataEntity = data.toEntity();
                    blockEntity.addData(dataEntity);
                    pageBlockEntityRepository.save(blockEntity);
                    return dataEntity;
                }).orElseThrow(() -> new CustomException("区块不存在", "PageCreateService#addDataToBlock", 404));
    }

    public List<PageBlockDataEntity> addDataToBlockBatch(Long blockId, List<CreateOrUpdatePageBlockDataDTO> data) {
        return pageBlockEntityRepository.findById(blockId)
                .map(blockEntity -> {
                    if (blockEntity.getType() == BlockType.Waterfall && blockEntity.getData().size() > 0) {
                        throw new CustomException("瀑布流区块只能有一个数据", "PageCreateService#addDataToBlockBatch", 400);
                    }
                    var dataEntities = data.stream().map(CreateOrUpdatePageBlockDataDTO::toEntity).toList();
                    blockEntity.getData().clear();
                    blockEntity.getData().addAll(dataEntities);
                    pageBlockEntityRepository.save(blockEntity);
                    return dataEntities;
                }).orElseThrow(() -> new CustomException("区块不存在", "PageCreateService#addDataToBlockBatch", 404));
    }
}
