package com.mooc.backend.config.converters;

import com.mooc.backend.enumerations.PageStatus;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;

@Configuration
public class PageStatusConverter implements Converter<String, PageStatus> {
    @Override
    public PageStatus convert(String source) {
        return PageStatus.fromValue(source);
    }
}
