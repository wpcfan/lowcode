package com.mooc.backend.controllers.app;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.rest.app.PageController;
import com.mooc.backend.services.PageQueryService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Optional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@WebMvcTest(controllers = PageController.class)
public class PageControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    PageQueryService pageQueryService;

    @Test
    void testFindPublished() throws Exception {
        var page = PageEntity.builder()
                .id(1L)
                .title("Page 1")
                .pageType(PageType.Home)
                .platform(Platform.iOS)
                .build();
        Mockito.when(pageQueryService.findPublished(Platform.iOS, PageType.Home))
                .thenReturn(Optional.of(page));
        var uaString = "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3";
        mockMvc.perform(
                get("/api/v1/app/pages/published/{pageType}", PageType.Home)

                        .header("User-Agent", uaString) // 测试 User-Agent
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.title").value("Page 1"))
                .andExpect(jsonPath("$.pageType").value(PageType.Home.getValue()))
                .andExpect(jsonPath("$.platform").value(Platform.iOS.name()));
    }
}
