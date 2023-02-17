package com.mooc.backend.config.converters;

import com.mooc.backend.enumerations.LinkType;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;

@Configuration
public class LinkTypeConverter implements Converter<String, LinkType> {

    @Override
    public LinkType convert(String source) {
        return LinkType.fromValue(source);
    }
}
