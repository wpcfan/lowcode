package com.mooc.backend.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.dtos.FileDTO;
import com.mooc.backend.error.CustomException;
import com.qiniu.common.QiniuException;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.FileInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
public class QiniuService {
    private final UploadManager uploadManager;
    private final BucketManager bucketManager;
    private final com.qiniu.util.Auth auth;

    @Value("${qiniu.bucket}")
    private String bucket;

    @Value("${qiniu.domain}")
    private String domain;

    /**
     * 上传文件
     *
     * @param uploadBytes 文件字节数组
     * @param key         文件名
     * @return 文件信息
     */
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

    /**
     * 列出空间文件列表
     *
     * @return 文件列表
     */
    public List<FileInfo> listFiles() {
        //文件名前缀
        String prefix = "";
        //每次迭代的长度限制，最大1000，推荐值 1000
        int limit = 1000;
        //指定目录分隔符，列出所有公共前缀（模拟列出目录效果）。缺省值为空字符串
        String delimiter = "";
        //列举空间文件列表
        BucketManager.FileListIterator fileListIterator = bucketManager.createFileListIterator(bucket, prefix, limit, delimiter);
        List<FileInfo> list = new ArrayList<>();
        while (fileListIterator.hasNext()) {
            //处理获取的file list结果
            FileInfo[] items = fileListIterator.next();
            for (FileInfo item : items) {
                if (!item.mimeType.startsWith("image")) {
                    continue;
                }
                list.add(item);
            }
        }
        return list;
    }

    /**
     * 删除文件
     *
     * @param key 文件名
     */
    public void deleteFile(String key) {
        try {
            bucketManager.delete(bucket, key);
        } catch (QiniuException e) {
            e.printStackTrace();
            throw new CustomException("File Delete error", e.getMessage(), 500);
        }
    }
}
