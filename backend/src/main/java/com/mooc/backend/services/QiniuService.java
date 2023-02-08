package com.mooc.backend.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.dtos.FileDTO;
import com.mooc.backend.error.CustomException;
import com.qiniu.common.QiniuException;
import com.qiniu.storage.UploadManager;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;

@RequiredArgsConstructor
@Service
public class QiniuService {
    private final UploadManager uploadManager;
    private final com.qiniu.util.Auth auth;

    @Value("${qiniu.bucket}")
    private String bucket;

    @Value("${qiniu.domain}")
    private String domain;

    public FileDTO upload(byte[] uploadBytes, String key) {
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(uploadBytes);
        String upToken = auth.uploadToken(bucket);
        try {
            var mapper = new ObjectMapper();
            var response = uploadManager.put(byteInputStream, key, upToken, null, null);
            var putRet = mapper.readValue(response.bodyString(), com.qiniu.storage.model.DefaultPutRet.class);
            return new FileDTO(domain + "/" + putRet.key, putRet.hash);
        } catch (QiniuException | JsonProcessingException e) {
            e.printStackTrace();
            throw new CustomException("File Upload error", e.getMessage(), 500);
        }
    }
}
