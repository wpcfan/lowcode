package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;

@ExtendWith(SpringExtension.class)
public class PageCreateServiceTests {
    @Mock
    private PageLayoutRepository pageLayoutRepository;

    @Mock
    private PageBlockRepository pageBlockRepository;

    @Mock
    private PageBlockDataRepository pageBlockDataRepository;

    @Mock
    private PageQueryService pageQueryService;

    @InjectMocks
    private PageCreateService pageCreateService;

    @Test
    void createPage_shouldCreatePage() {
        var page = new CreateOrUpdatePageDTO("Page 1", Platform.App, PageType.Home, PageConfig.builder().build());

        Mockito.when(pageLayoutRepository.save(any(PageLayout.class))).thenReturn(PageLayout.builder().id(1L).build());
        var result = pageCreateService.createPage(page);
        assertEquals(1L, result.getId());
    }

    @Test
    void addBlockToPage_shouldThrowException_whenPageStatusIsNotDraft() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, null, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Published);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.addBlockToPage(pageId, block));
    }

    @Test
    void addBlockToPage_shouldThrowException_whenWaterfallBlockAlreadyExists() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, null, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(1L);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.addBlockToPage(pageId, block));
    }

    @Test
    void addBlockToPage_shouldAddBlockToPage_whenAllConditionsAreMet() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, 0, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(0L);
        Mockito.when(pageBlockRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, pageId, block.sort())).thenReturn(0L);
        Mockito.when(pageBlockRepository.save(any(PageBlock.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        PageLayout result = pageCreateService.addBlockToPage(pageId, block);

        // Assert
        assertEquals(pageLayout, result);
        assertEquals(1, result.getPageBlocks().size());
        assertEquals(block.type(), result.getPageBlocks().first().getType());
        assertEquals(block.sort(), result.getPageBlocks().first().getSort());
    }

    @Test
    void insertBlockToPage_shouldThrowException_whenPageStatusIsNotDraft() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, null, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Published);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.insertBlockToPage(pageId, block));
    }

    @Test
    void insertBlockToPage_shouldThrowException_whenWaterfallBlockAlreadyExists() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, null, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(1L);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.insertBlockToPage(pageId, block));
    }

    @Test
    void insertBlockToPage_shouldThrowException_whenWaterfallBlockSortIsNotLast() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, 0, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(0L);
        Mockito.when(pageBlockRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, pageId, block.sort())).thenReturn(1L);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.insertBlockToPage(pageId, block));
    }

    @Test
    void insertBlockToPage_shouldInsertBlockToPage_whenAllConditionsAreMet() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, 1, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        PageBlock pageBlockEntity1 = new PageBlock();
        pageBlockEntity1.setSort(0);
        PageBlock pageBlockEntity2 = new PageBlock();
        pageBlockEntity2.setSort(1);
        pageLayout.addPageBlock(pageBlockEntity1);
        pageLayout.addPageBlock(pageBlockEntity2);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(0L);
        Mockito.when(pageBlockRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, pageId, block.sort())).thenReturn(0L);
        Mockito.when(pageLayoutRepository.save(any(PageLayout.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        PageLayout result = pageCreateService.insertBlockToPage(pageId, block);

        // Assert
        assertEquals(pageLayout, result);
        assertEquals(3, result.getPageBlocks().size());
        assertEquals(block.type(), result.getPageBlocks().stream().skip(1).findFirst().get().getType());
        assertEquals(block.sort(), result.getPageBlocks().stream().skip(1).findFirst().get().getSort());
        assertEquals(2, result.getPageBlocks().stream().skip(2).findFirst().get().getSort());
    }
}
