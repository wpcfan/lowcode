package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.FileRecord;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.QiniuService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin")
public class FileUploadController {

    private final QiniuService qiniuService;
    @PostMapping(value = "/file", consumes = "multipart/form-data")
    public FileRecord upload(@RequestParam("file") MultipartFile file) {
        try {
            return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
        } catch (IOException e) {
            throw new CustomException("File Upload error", e.getMessage(), 500);
        }
    }

    @PostMapping(value = "/files", consumes = "multipart/form-data")
    public List<FileRecord> uploadFiles(@RequestParam("files") List<? extends MultipartFile> files) {
        return files.stream().map(file -> {
            try {
                return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
            } catch (IOException e) {
                throw new CustomException("File Upload error", e.getMessage(), 500);
            }
        }).toList();
    }
}
