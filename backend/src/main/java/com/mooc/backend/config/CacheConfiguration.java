package com.mooc.backend.config;

import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.redisson.spring.cache.CacheConfig;
import org.redisson.spring.cache.RedissonSpringCacheManager;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@ConditionalOnProperty(name = "spring.cache.type", havingValue = "redis")
@EnableCaching
@Configuration
public class CacheConfiguration {

    @Bean(destroyMethod="shutdown")
    RedissonClient redisson() throws IOException {
        Config config = Config.fromYAML(CacheConfiguration.class.getClassLoader().getResource("redisson.yml"));
        return Redisson.create(config);
    }

    @Bean
    CacheManager cacheManager(RedissonClient redissonClient) {
        Map<String, CacheConfig> config = new HashMap<String, CacheConfig>();

        // create "testMap" cache with ttl = 24 minutes and maxIdleTime = 12 minutes
        config.put("testMap", new CacheConfig(24*60*1000, 12*60*1000));
        return new RedissonSpringCacheManager(redissonClient, config);
    }
}
