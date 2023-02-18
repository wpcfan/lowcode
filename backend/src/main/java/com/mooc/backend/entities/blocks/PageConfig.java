package com.mooc.backend.entities.blocks;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import lombok.*;

/**
 * 页面配置
 * 包括页面的水平间距、垂直间距、水平内边距、垂直内边距、基准屏幕宽度、基准屏幕高度、基准字体大小
 */
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PageConfig {
    // 水平内边距
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double horizontalPadding;
    // 垂直内边距
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double verticalPadding;
    // 水平间距
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double horizontalSpacing;
    // 垂直间距
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double verticalSpacing;
    // 基准屏幕宽度
    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double baselineScreenWidth;
    // 基准屏幕高度
    @DecimalMin("300")
    @DecimalMax("3000.00")
    private Double baselineScreenHeight;
    // 基准字体大小
    @DecimalMin("12.00")
    @DecimalMax("100.00")
    private Double baselineFontSize;
}
