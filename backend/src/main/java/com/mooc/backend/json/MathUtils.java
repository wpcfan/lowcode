package com.mooc.backend.json;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.Locale;

public class MathUtils {

    public static String formatPrice(BigDecimal price) {
        if (price == null) {
            return null;
        }
        var rounded = price.setScale(2, RoundingMode.HALF_UP);
        var locale = Locale.of("zh", "CN");
        NumberFormat format = NumberFormat.getCurrencyInstance(locale);
        return format.format(rounded);
    }
}
