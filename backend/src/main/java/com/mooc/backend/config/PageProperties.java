package com.mooc.backend.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.Sort;

@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "page")
public class PageProperties {
    int defaultPageSize = 10;

    int defaultPageNumber = 0;

    String defaultSortField = "id";

    Sort.Direction defaultSortDirection = Sort.Direction.DESC;
}
