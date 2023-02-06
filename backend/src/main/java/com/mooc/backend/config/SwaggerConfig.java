package com.mooc.backend.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI springShopOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("低代码平台 API 文档")
                        .description("这个 API 文档提供了后台管理和前端 APP 所需的接口")
                        .termsOfService("")
                        .license(new License().name("Apache").url(""))
                        .version("0.0.1"));
    }
}
