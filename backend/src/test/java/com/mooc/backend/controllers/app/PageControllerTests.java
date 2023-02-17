package com.mooc.backend.controllers.app;

import com.mooc.backend.config.PageProperties;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.rest.app.PageController;
import com.mooc.backend.services.PageQueryService;
import com.mooc.backend.services.ProductQueryService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Optional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = PageController.class)
public class PageControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    PageQueryService pageQueryService;
    @MockBean
    ProductQueryService productQueryService;
    @Autowired
    PageProperties pageProperties;

    @Test
    void testFindPublished() throws Exception {
        var page = PageEntity.builder()
                .id(1L)
                .title("Page 1")
                .pageType(PageType.Home)
                .platform(Platform.App)
                .build();
        Mockito.when(pageQueryService.findPublished(Platform.App, PageType.Home))
                .thenReturn(Optional.of(page));
        // iPhone 13 Pro Max
        var uaString = "Mozilla/5.0 (iPhone14,3; U; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/19A346 Safari/602.1";
        mockMvc.perform(
                get("/api/v1/app/pages/published/{pageType}", PageType.Home)

                        .header("User-Agent", uaString) // 测试 User-Agent
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.title").value("Page 1"))
                .andExpect(jsonPath("$.pageType").value(PageType.Home.getValue()))
                .andExpect(jsonPath("$.platform").value(Platform.App.name()));
    }

    @Test
    void testFindPublishedNotFound() throws Exception {
        Mockito.when(pageQueryService.findPublished(Platform.App, PageType.Home))
                .thenReturn(Optional.empty());
        // Samsung Galaxy S22
        var uaString = "Mozilla/5.0 (Linux; Android 12; SM-S906N Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/80.0.3987.119 Mobile Safari/537.36";
        mockMvc.perform(
                get("/api/v1/app/pages/published/{pageType}", PageType.Home)

                        .header("User-Agent", uaString) // 测试 User-Agent
                )
                .andDo(result -> System.out.println(result.getResponse().getContentAsString()))
                .andExpect(jsonPath("$.type").exists())
                .andExpect(jsonPath("$.code").value(404))
                .andExpect(jsonPath("$.title").value("Page not found"));
    }
}
