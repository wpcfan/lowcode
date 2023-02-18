package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * 用于将 BigDecimal 类型的价格格式化为人民币
 * 例如：123.456 -> ￥123.46
 * 在类中的对应字段，使用 @JsonSerialize(using = BigDecimalSerializer.class) 注解
 */
public class BigDecimalSerializer extends JsonSerializer<BigDecimal> {

    @Override
    public void serialize(BigDecimal value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        var rounded = value.setScale(2, RoundingMode.HALF_UP);
        var locale = Locale.of("zh", "CN");
        NumberFormat format = NumberFormat.getCurrencyInstance(locale);
        gen.writeString(format.format(rounded));
    }
}
