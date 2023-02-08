package com.mooc.backend.services;

import com.mooc.backend.dtos.PublishPageDTO;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataEntityRepository;
import com.mooc.backend.repositories.PageBlockEntityRepository;
import com.mooc.backend.repositories.PageEntityRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertThrows;

@ExtendWith(SpringExtension.class)
public class PageUpdateServiceTests {
    @MockBean
    private PageEntityRepository pageEntityRepository;

    @MockBean
    private PageBlockEntityRepository pageBlockEntityRepository;

    @MockBean
    private PageBlockDataEntityRepository pageBlockDataEntityRepository;

    @Test
    void testPublishPage() {
        var pageUpdateService = new PageUpdateService(pageEntityRepository, pageBlockEntityRepository, pageBlockDataEntityRepository);
        var now = LocalDateTime.now();
        var startTime = now.minusDays(1);
        var endTime = now.plusDays(1);
        var page = new PublishPageDTO(startTime, endTime);
        var entity = PageEntity.builder()
                .id(1L)
                .title("title")
                .status(PageStatus.Published)
                .pageType(PageType.Home)
                .platform(Platform.App)
                .build();
        Mockito.when(pageEntityRepository.findById(1L)).thenReturn(Optional.of(entity));
        Mockito.when(pageEntityRepository.countPublishedTimeConflict(startTime, Platform.App, PageType.Home)).thenReturn(1);
        assertThrows(CustomException.class, () -> pageUpdateService.publishPage(1L, page));
    }
}
