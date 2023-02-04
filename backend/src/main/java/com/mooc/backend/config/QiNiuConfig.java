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
        var cfg = new com.qiniu.storage.Configuration(com.qiniu.storage.Region.autoRegion());
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
