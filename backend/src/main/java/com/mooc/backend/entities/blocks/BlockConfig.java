package com.mooc.backend.entities.blocks;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.*;

@Schema(description = "区块配置")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BlockConfig {
    private static final String HEX_COLOR_PATTERN
            = "^#(?:(?:[\\da-f]{3}){1,2}|(?:[\\da-f]{4}){1,2})$";

    @Schema(description = "水平内边距", example = "12.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double horizontalPadding;
    @Schema(description = "垂直内边距", example = "12.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double verticalPadding;
    @Schema(description = "水平间距", example = "4.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double horizontalSpacing;
    @Schema(description = "垂直间距", example = "4.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double verticalSpacing;
    @Schema(description = "区块宽度", example = "376.0")
    @NotNull
    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockWidth;
    @Schema(description = "区块高度", example = "94.0")
    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockHeight;
    @Schema(description = "区块背景颜色", example = "#ffffff")
    @Pattern(regexp = HEX_COLOR_PATTERN)
    private String backgroundColor;
    @Schema(description = "区块边框颜色", example = "#000000")
    @Pattern(regexp = HEX_COLOR_PATTERN)
    private String borderColor;
    @Schema(description = "区块边框宽度", example = "1.0")
    @DecimalMin("0.0")
    @DecimalMax("10.0")
    private Double borderWidth;
}
