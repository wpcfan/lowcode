package com.mooc.backend.services;

import com.mooc.backend.dtos.PublishPageDTO;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;

@ExtendWith(SpringExtension.class)
public class PageUpdateServiceTests {
    @MockBean
    private PageLayoutRepository pageLayoutRepository;

    @MockBean
    private PageBlockRepository pageBlockRepository;

    @MockBean
    private PageBlockDataRepository pageBlockDataRepository;

    @MockBean
    private PageQueryService pageQueryService;

    @Test
    void testPublishPage() {
        var pageUpdateService = new PageUpdateService(pageQueryService, pageLayoutRepository, pageBlockRepository, pageBlockDataRepository);
        var now = LocalDateTime.now();
        var startTime = now.minusDays(1).with(LocalTime.MIN);
        var endTime = now.plusDays(1).with(LocalTime.MAX);
        var page = new PublishPageDTO(startTime, endTime);
        var entity = PageLayout.builder()
                .id(1L)
                .title("title")
                .status(PageStatus.Published)
                .pageType(PageType.Home)
                .platform(Platform.App)
                .build();
        Mockito.when(pageQueryService.findById(any(Long.class))).thenReturn(entity);
        Mockito.when(pageLayoutRepository.countPublishedTimeConflict(startTime, Platform.App, PageType.Home)).thenReturn(1);
        assertThrows(CustomException.class, () -> pageUpdateService.publishPage(1L, page));
    }
}
