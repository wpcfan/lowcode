package com.mooc.backend.controllers.admin;

import com.mooc.backend.config.PageProperties;
import com.mooc.backend.dtos.FileDTO;
import com.mooc.backend.rest.admin.FileController;
import com.mooc.backend.services.QiniuService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;

@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = {FileController.class})
public class FileControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private QiniuService qiniuService;

    @Test
    public void testUpload() throws Exception {
        // 构造一个 MultiPart 文件
        MockMultipartFile jsonFile = new MockMultipartFile("test.json", "", "application/json", "{\"key1\": \"value1\"}".getBytes());
        var fileDto = new FileDTO("https://www.example.com/test.json", "test.json");
        // 模拟 QiniuService 的 upload 方法，不管传入什么参数，都返回 fileDto
        when(qiniuService.upload(any(), any())).thenReturn(fileDto);
        // 使用 MockMvc 发起文件上传请求
        mockMvc.perform(multipart("/api/v1/admin/file")
                        .file("file", jsonFile.getBytes())
                        .characterEncoding("UTF-8")
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.url").value(fileDto.url()))
                .andExpect(jsonPath("$.key").value(fileDto.key()));
    }
}
