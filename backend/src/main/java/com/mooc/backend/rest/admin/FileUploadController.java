package com.mooc.backend.rest.admin;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mooc.backend.dtos.FileDTO;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.QiniuService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@Tag(name = "文件上传", description = "上传一个或多个文件")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin")
public class FileUploadController {

    private final QiniuService qiniuService;

    @Operation(summary = "上传一个文件")
    @PostMapping(value = "/file", consumes = "multipart/form-data")
    public FileDTO upload(@RequestParam("file") MultipartFile file) {
        try {
            return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
        } catch (IOException e) {
            throw new CustomException("File Upload error", e.getMessage(), 500);
        }
    }

    @Operation(summary = "上传多个文件")
    @PostMapping(value = "/files", consumes = "multipart/form-data")
    public List<FileDTO> uploadFiles(@RequestParam("files") List<? extends MultipartFile> files) {
        return files.stream().map(file -> {
            try {
                return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
            } catch (IOException e) {
                throw new CustomException("File Upload error", e.getMessage(), 500);
            }
        }).toList();
    }
}
