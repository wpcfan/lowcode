package com.mooc.backend.entities.blocks;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;

/**
 * 页面配置
 * 包括页面的水平间距、垂直间距、水平内边距、垂直内边距、基准屏幕宽度、基准屏幕高度、基准字体大小
 */
@Schema(description = "页面配置")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PageConfig {
    // 水平内边距
    @Schema(description = "水平内边距", example = "0.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double horizontalPadding;
    // 垂直内边距
    @Schema(description = "垂直内边距", example = "0.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double verticalPadding;
    // 基准屏幕宽度 points 或者 dip
    @Schema(description = "基准屏幕宽度", example = "400.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("1200.00")
    private Double baselineScreenWidth;
}
