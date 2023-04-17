package com.mooc.backend.controllers.app;

import com.mooc.backend.config.PageProperties;
import com.mooc.backend.rest.app.ImageController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = {ImageController.class})
public class ImageControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testGetImageByWidth() throws Exception {
        mockMvc.perform(get("/api/v1/image/{width}", 200))
                .andExpect(status().isOk())
                .andExpect(result -> {
                    var contentType = result.getResponse().getContentType();
                    assert contentType != null;
                    assert contentType.startsWith("image/png");
                    assert result.getResponse().getContentLength() > 0;
                });
    }
}
