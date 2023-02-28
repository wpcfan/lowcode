package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * 用于将 BigDecimal 类型的价格格式化为人民币
 * 例如：123.456 -> ￥123.46
 * 在类中的对应字段，使用 @JsonSerialize(using = BigDecimalSerializer.class) 注解
 */
public class BigDecimalSerializer extends JsonSerializer<BigDecimal> {

    @Override
    public void serialize(BigDecimal value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        gen.writeString(MathUtils.formatPrice(value));
    }
}
