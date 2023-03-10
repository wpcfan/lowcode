package com.mooc.backend.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@EnableCaching
@Configuration
public class CacheConfig {
    @ConditionalOnProperty(name = "spring.cache.type", havingValue = "simple")
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("page");
    }
}
