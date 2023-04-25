package com.mooc.backend.rest.admin;

import com.mooc.backend.config.PageProperties;
import com.mooc.backend.dtos.FileDTO;
import com.mooc.backend.services.QiniuService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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

    @Test
    public void testListFiles() throws Exception {
        // 模拟 QiniuService 的 listFiles 方法，不管传入什么参数，都返回一个空的 List
        when(qiniuService.listFiles()).thenReturn(List.of());
        mockMvc.perform(get("/api/v1/admin/files"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$").isEmpty());
        // 模拟 QiniuService 的 listFiles 方法，不管传入什么参数，都返回一个包含两个元素的 List
        when(qiniuService.listFiles()).thenReturn(List.of(
                new FileDTO("https://www.example.com/test1.json", "test1.json"),
                new FileDTO("https://www.example.com/test2.json", "test2.json")
        ));
        mockMvc.perform(get("/api/v1/admin/files"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$").isNotEmpty())
                .andExpect(jsonPath("$[0].url").value("https://www.example.com/test1.json"))
                .andExpect(jsonPath("$[0].key").value("test1.json"))
                .andExpect(jsonPath("$[1].url").value("https://www.example.com/test2.json"))
                .andExpect(jsonPath("$[1].key").value("test2.json"));
    }

    @Test
    public void testDeleteFile() throws Exception {
        // 对于 void 方法，可以使用 doNothing().when().method() 的方式来模拟
        doNothing().when(qiniuService).deleteFile("test.json");
        mockMvc.perform(delete("/api/v1/admin/files/test.json"))
                .andExpect(status().isOk());
    }
}
