package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;

@ExtendWith(SpringExtension.class)
public class PageCreateServiceTests {
    @MockBean
    private PageLayoutRepository pageLayoutRepository;

    @MockBean
    private PageBlockRepository pageBlockRepository;

    @MockBean
    private PageBlockDataRepository pageBlockDataRepository;

    @MockBean
    private PageQueryService pageQueryService;

    @Test
    void testCreatePage() {
        var pageCreateService = new PageCreateService(pageQueryService, pageLayoutRepository, pageBlockRepository, pageBlockDataRepository);
        var page = new CreateOrUpdatePageDTO("Page 1", Platform.App, PageType.Home, PageConfig.builder().build());

        Mockito.when(pageLayoutRepository.save(any(PageLayout.class))).thenReturn(PageLayout.builder().id(1L).build());
        var result = pageCreateService.createPage(page);
        assertEquals(1L, result.getId());
    }
}
