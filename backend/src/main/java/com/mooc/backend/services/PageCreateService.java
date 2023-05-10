package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDataDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.Errors;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {

    private final PageQueryService pageQueryService;
    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;
    private final PageBlockDataRepository pageBlockDataRepository;

    public PageLayout createPage(CreateOrUpdatePageDTO page) {
        return pageLayoutRepository.save(page.toEntity());
    }

    public PageLayout addBlockToPage(Long pageId, CreateOrUpdatePageBlockDTO block) {
        var pageLayout = pageQueryService.findById(pageId);
        if (pageLayout.getStatus() != PageStatus.Draft) {
            throw new CustomException("只有草稿状态的页面才能添加区块", "PageCreateService#addBlockToPage", Errors.ConstraintViolationException.code());
        }
        if (block.type() == BlockType.Waterfall && pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId) > 0L) {
            throw new CustomException("瀑布流区块只能有一个", "PageCreateService#addBlockToPage", Errors.ConstraintViolationException.code());
        }
        var blockEntity = block.toEntity();
        blockEntity.setSort(pageLayout.getPageBlocks().size());
        pageLayout.addPageBlock(blockEntity);
        pageBlockRepository.save(blockEntity);
        return pageLayout;
    }

    public PageLayout insertBlockToPage(Long id, CreateOrUpdatePageBlockDTO insertPageBlockDTO) {
        var pageLayout = pageQueryService.findById(id);
        if (pageLayout.getStatus() != PageStatus.Draft) {
            throw new CustomException("只有草稿状态的页面才能插入区块", "PageCreateService#insertBlockToPage", Errors.ConstraintViolationException.code());
        }
        if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, id) > 0L) {
            throw new CustomException("瀑布流区块只能有一个", "PageCreateService#insertBlockToPage", Errors.ConstraintViolationException.code());
        }
        if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, id, insertPageBlockDTO.sort()) > 0) {
            throw new CustomException("瀑布流区块必须在最后", "PageCreateService#insertBlockToPage", Errors.ConstraintViolationException.code());
        }
        pageLayout.getPageBlocks().stream()
                .filter(pageBlockEntity -> pageBlockEntity.getSort() >= insertPageBlockDTO.sort())
                .forEach(pageBlockEntity -> pageBlockEntity.setSort(pageBlockEntity.getSort() + 1));
        var blockEntity = insertPageBlockDTO.toEntity();
        pageLayout.addPageBlock(blockEntity);
        return pageLayoutRepository.save(pageLayout);
    }

    public PageBlockData addDataToBlock(Long blockId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockRepository.findById(blockId)
                .map(blockEntity -> {
                    if (blockEntity.getType() == BlockType.Waterfall && blockEntity.getData().size() > 0) {
                        throw new CustomException("瀑布流区块只能有一个数据", "PageCreateService#addDataToBlock", Errors.ConstraintViolationException.code());
                    }
                    if (blockEntity.getType() == BlockType.ProductRow && blockEntity.getData().size() >= 2) {
                        throw new CustomException("产品行区块最多只能有2个数据", "PageCreateService#addDataToBlock", Errors.ConstraintViolationException.code());
                    }
                    var dataEntity = data.toEntity();
                    dataEntity.setSort(blockEntity.getData().size() + 1);
                    dataEntity.setPageBlock(blockEntity);
                    return pageBlockDataRepository.save(dataEntity);
                }).orElseThrow(() -> new CustomException("区块不存在", "PageCreateService#addDataToBlock", Errors.DataNotFoundException.code()));
    }

    public List<PageBlockData> addDataToBlockBatch(Long blockId, List<CreateOrUpdatePageBlockDataDTO> data) {
        return pageBlockRepository.findById(blockId)
                .map(blockEntity -> {
                    if (blockEntity.getType() == BlockType.Waterfall && blockEntity.getData().size() > 0) {
                        throw new CustomException("瀑布流区块只能有一个数据", "PageCreateService#addDataToBlockBatch", Errors.ConstraintViolationException.code());
                    }
                    var dataEntities = data.stream().map(CreateOrUpdatePageBlockDataDTO::toEntity).toList();
                    blockEntity.getData().clear();
                    blockEntity.getData().addAll(dataEntities);
                    pageBlockRepository.save(blockEntity);
                    return dataEntities;
                }).orElseThrow(() -> new CustomException("区块不存在", "PageCreateService#addDataToBlockBatch", Errors.DataNotFoundException.code()));
    }
}
