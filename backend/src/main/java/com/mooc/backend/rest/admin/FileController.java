package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.FileDTO;
import com.mooc.backend.enumerations.Errors;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.QiniuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Tag(name = "文件上传", description = "上传一个或多个文件")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin")
public class FileController {

    private final QiniuService qiniuService;

    @Operation(summary = "上传一个文件")
    @PostMapping(value = "/file", consumes = "multipart/form-data")
    public FileDTO upload(@RequestParam("file") MultipartFile file) {
        try {
            return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
        } catch (IOException e) {
            throw new CustomException("File Upload error", e.getMessage(), Errors.FileUploadException.code());
        }
    }

    @Operation(summary = "上传多个文件")
    @PostMapping(value = "/files", consumes = "multipart/form-data")
    public List<FileDTO> uploadFiles(@RequestParam("files") List<? extends MultipartFile> files) {
        return files.stream().map(file -> {
            try {
                return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
            } catch (IOException e) {
                throw new CustomException("File Upload error", e.getMessage(), Errors.FileUploadException.code());
            }
        }).toList();
    }

    @Operation(summary = "文件列表")
    @GetMapping("/files")
    public List<FileDTO> listFiles() {
        return qiniuService.listFiles();
    }

    @Operation(summary = "删除文件")
    @DeleteMapping("/files/{key}")
    public void deleteFile(@PathVariable String key) {
        qiniuService.deleteFile(key);
    }

    @Operation(summary = "删除多个文件")
    @PutMapping("/files")
    public void deleteFiles(@RequestBody List<String> keys) {
        qiniuService.deleteFiles(keys);
    }
}
