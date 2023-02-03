package com.mooc.backend.entities;

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
    private Integer horizontalPadding;
    // 垂直内边距
    private Integer verticalPadding;
    // 水平间距
    private Integer horizontalSpacing;
    // 垂直间距
    private Integer verticalSpacing;
    // 基准屏幕宽度
    private Integer baselineScreenWidth;
    // 基准屏幕高度
    private Integer baselineScreenHeight;
    // 基准字体大小
    private Integer baselineFontSize;
}
