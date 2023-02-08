package com.mooc.backend.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;
import java.util.Locale;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private static final int DEFAULT_PAGE_SIZE = 10;

    private static final int DEFAULT_PAGE_NUMBER = 0;

    private static final String DEFAULT_SORT_FIELD = "id";

    private static final Sort.Direction DEFAULT_SORT_DIRECTION = Sort.Direction.DESC;

    /**
     * 全局配置分页参数
     *
     * @return PageableHandlerMethodArgumentResolver
     */
    @Bean
    public PageableHandlerMethodArgumentResolver pageableResolver() {
        PageableHandlerMethodArgumentResolver resolver = new PageableHandlerMethodArgumentResolver();
        resolver.setFallbackPageable(PageRequest.of(DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE, Sort.by(DEFAULT_SORT_DIRECTION, DEFAULT_SORT_FIELD)));
        return resolver;
    }

    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasename("messages");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setDefaultLocale(Locale.ENGLISH);
        return messageSource;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(pageableResolver());
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
//                .allowCredentials(true) // 是否允许发送Cookie信息，如果设置为 true，allowedOrigins 不能设置为 *，否则会报错
                .maxAge(3600);
    }
}
