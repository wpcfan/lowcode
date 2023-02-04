package com.mooc.backend.config.converters;

import com.mooc.backend.enumerations.BlockType;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;

@Configuration
public class BlockTypeConverter implements Converter<String, BlockType> {

    @Override
    public BlockType convert(String source) {
        return BlockType.fromValue(source);
    }
}
