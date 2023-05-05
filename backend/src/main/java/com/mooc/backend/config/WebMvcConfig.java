package com.mooc.backend.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.validation.beanvalidation.MethodValidationPostProcessor;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;
import java.util.Locale;

/**
 * Web MVC 配置
 * <p>
 *     该类用于配置 Spring MVC 的一些参数。
 *     例如，配置分页参数、配置国际化资源文件、配置跨域等。
 * <p>
 */
@RequiredArgsConstructor
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private final PageProperties pageProperties;

    /**
     * 全局配置分页参数
     *
     * @return PageableHandlerMethodArgumentResolver
     */
    @Bean
    public PageableHandlerMethodArgumentResolver pageableResolver() {
        PageableHandlerMethodArgumentResolver resolver = new PageableHandlerMethodArgumentResolver();
        resolver.setFallbackPageable(PageRequest.of(
                pageProperties.getDefaultPageNumber(),
                pageProperties.getDefaultPageSize(),
                Sort.by(
                        pageProperties.getDefaultSortDirection(),
                        pageProperties.getDefaultSortField()
                )));
        return resolver;
    }

    /**
     * 配置分页参数
     * @param resolvers 参数解析器
     */
    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(pageableResolver());
    }

    /**
     * 配置跨域
     * @param registry 跨域注册
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                // 是否允许发送Cookie信息，如果设置为 true，allowedOrigins 不能设置为 *，否则会报错
//                .allowCredentials(false)
                .maxAge(3600);
    }

    /**
     * 开启方法级别的校验，可以在方法上使用 jakarta.validation 的注解
     * @return MethodValidationPostProcessor
     */
    @Bean
    public MethodValidationPostProcessor methodValidationPostProcessor() {
        return new MethodValidationPostProcessor();
    }

    /**
     * 配置国际化资源文件
     * @return MessageSource
     */
    @Bean
    public MessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasename("messages");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setDefaultLocale(Locale.ENGLISH);
        return messageSource;
    }
}
