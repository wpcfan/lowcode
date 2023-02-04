package com.mooc.backend.config.converters;

import com.mooc.backend.enumerations.PageType;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;

@Configuration
public class PageTypeConverter implements Converter<String, PageType> {

    @Override
    public PageType convert(String source) {
        return PageType.fromValue(source);
    }
}
