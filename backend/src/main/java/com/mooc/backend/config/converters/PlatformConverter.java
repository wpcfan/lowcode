package com.mooc.backend.config.converters;

import com.mooc.backend.enumerations.Platform;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;

@Configuration
public class PlatformConverter implements Converter<String, Platform> {
    @Override
    public Platform convert(String source) {
        return Platform.fromValue(source);
    }
}
