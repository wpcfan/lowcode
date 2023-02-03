package com.mooc.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class QiNiuConfig {
    @Bean
    public com.qiniu.util.Auth auth(QiNiuProperties qiNiuProperties) {
        return com.qiniu.util.Auth.create(qiNiuProperties.getAccessKey(), qiNiuProperties.getSecretKey());
    }

    @Bean
    public com.qiniu.storage.Configuration configuration() {
        com.qiniu.storage.Region region = new com.qiniu.storage.Region.Builder()
                .region("z0")
                .accUpHost("up.qiniup.com")
                .srcUpHost("upload.qiniup.com")
                .iovipHost("iovip.qiniuio.com")
                .rsHost("rs.qiniu.com")
                .rsfHost("rsf.qiniu.com")
                .apiHost("api.qiniu.com")
                .build();
        var cfg = new com.qiniu.storage.Configuration(region);
        cfg.useHttpsDomains = false;
        cfg.resumableUploadAPIVersion = com.qiniu.storage.Configuration.ResumableUploadAPIVersion.V2;
        return cfg;
    }

    @Bean
    public com.qiniu.storage.BucketManager bucketManager(com.qiniu.util.Auth auth, com.qiniu.storage.Configuration configuration) {
        return new com.qiniu.storage.BucketManager(auth, configuration);
    }

    @Bean
    public com.qiniu.storage.UploadManager uploadManager(com.qiniu.storage.Configuration configuration) {
        return new com.qiniu.storage.UploadManager(configuration);
    }
}
