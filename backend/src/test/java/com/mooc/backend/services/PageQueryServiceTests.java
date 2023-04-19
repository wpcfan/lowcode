package com.mooc.backend.services;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageLayoutRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ExtendWith(SpringExtension.class)
public class PageQueryServiceTests {
    @MockBean
    private PageLayoutRepository pageLayoutRepository;

    @Test
    void testFindPublished() {
        var platform = Platform.App;
        var pageType = PageType.Home;

        var page1 = PageLayout.builder()
                .id(1L)
                .title("Page 1")
                .pageType(pageType)
                .platform(platform)
                .build();

        var page2 = PageLayout.builder()
                .id(2L)
                .title("Page 2")
                .pageType(pageType)
                .platform(platform)
                .build();

        Mockito
                .when(pageLayoutRepository.streamPublishedPage(
                                Mockito.any(LocalDateTime.class),
                                Mockito.any(Platform.class),
                                Mockito.any(PageType.class)
                        )
                )
                .thenReturn(Stream.of(page1, page2));

        var pageQueryService = new PageQueryService(pageLayoutRepository);
        var result = pageQueryService.findPublished(platform, pageType);

        assertEquals(1L, result.get().getId());
    }
}
