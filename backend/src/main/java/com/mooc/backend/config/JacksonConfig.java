package com.mooc.backend.config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

/**
 * Jackson 配置
 */
@Configuration
public class JacksonConfig {

    @Bean
    public Jackson2ObjectMapperBuilder jacksonBuilder() {
        Jackson2ObjectMapperBuilder builder = new Jackson2ObjectMapperBuilder();
        builder.serializationInclusion(JsonInclude.Include.NON_NULL); // 序列化时忽略值为 null 的属性
        builder.featuresToDisable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);// 禁用序列化日期为时间戳
        builder.failOnUnknownProperties(false); // 反序列化时忽略未知的属性
        builder.simpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 设置日期格式
        builder.modules(new JavaTimeModule()); // 支持 Java 8 中的日期/时间 API
        return builder;
    }

}
