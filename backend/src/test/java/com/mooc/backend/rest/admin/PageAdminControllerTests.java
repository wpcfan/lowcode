package com.mooc.backend.rest.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.config.PageProperties;
import com.mooc.backend.dtos.CreateOrUpdatePageBlockDTO;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.Errors;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageCreateService;
import com.mooc.backend.services.PageDeleteService;
import com.mooc.backend.services.PageQueryService;
import com.mooc.backend.services.PageUpdateService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = PageAdminController.class)
public class PageAdminControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private PageCreateService pageCreateService;

    @MockBean
    private PageUpdateService pageUpdateService;

    @MockBean
    private PageDeleteService pageDeleteService;

    @MockBean
    private PageQueryService pageQueryService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void testAddBlockWhenPageLayoutNotFound() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);
        when(pageQueryService.findById(pageId)).thenThrow(new CustomException("页面不存在", "PageQueryService#findById", Errors.DataNotFoundException.code()));
        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().is5xxServerError())
                .andExpect(jsonPath("$.code").value(Errors.DataNotFoundException.code()));
    }

    @Test
    public void testAddBlockWhenPagePublished() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);

        // 设置页面状态为已发布
        var page = new PageLayout();
        page.setId(pageId);
        page.setStatus(PageStatus.Published);
        when(pageQueryService.findById(pageId)).thenReturn(page);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().is5xxServerError())
                .andExpect(jsonPath("$.code").value(Errors.ConstraintViolationException.code()));
    }

    @Test
    public void testAddBlockWithInvalidRequest() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var block = new CreateOrUpdatePageBlockDTO("title", null, null, null);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.type").value("http://localhost:8080/errors/validation"));
    }

    @Test
    public void testAddBlockWithValidRequest() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);

        // 设置依赖服务正常返回
        var page = new PageLayout();
        page.setId(pageId);
        page.setStatus(PageStatus.Draft);
        when(pageQueryService.findById(pageId)).thenReturn(page);
        when(pageCreateService.addBlockToPage(pageId, block)).thenReturn(page);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(pageId));
    }

    @Test
    public void testInsertBlockWhenPageNotFound() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);
        when(pageQueryService.findById(pageId)).thenThrow(new CustomException("页面不存在", "PageQueryService#findById", Errors.DataNotFoundException.code()));
        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks/insert", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().is5xxServerError())
                .andExpect(jsonPath("$.code").value(Errors.DataNotFoundException.code()));
    }

    @Test
    public void testInsertBlockWhenPagePublished() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);

        // 设置页面状态为已发布
        var page = new PageLayout();
        page.setId(pageId);
        page.setStatus(PageStatus.Published);
        when(pageQueryService.findById(pageId)).thenReturn(page);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks/insert", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().is5xxServerError())
                .andExpect(jsonPath("$.code").value(Errors.ConstraintViolationException.code()));
    }

    @Test
    public void testInsertBlockWithInvalidRequest() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var block = new CreateOrUpdatePageBlockDTO("title", null, null, null);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks/insert", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.type").value("http://localhost:8080/errors/validation"));
    }

    @Test
    public void testInsertBlockWithValidRequest() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);

        // 设置依赖服务正常返回
        var page = new PageLayout();
        page.setId(pageId);
        page.setStatus(PageStatus.Draft);
        when(pageQueryService.findById(pageId)).thenReturn(page);
        when(pageCreateService.insertBlockToPage(pageId, block)).thenReturn(page);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks/insert", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(pageId));
    }
}
