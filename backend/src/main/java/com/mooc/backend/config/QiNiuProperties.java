package com.mooc.backend.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "qiniu")
public class QiNiuProperties {
    private String accessKey;
    private String secretKey;
    private String bucket;
    private String domain;
}
