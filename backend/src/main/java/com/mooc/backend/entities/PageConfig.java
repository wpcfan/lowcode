package com.mooc.backend.entities;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PageConfig {
    private Integer horizontalPadding;
    private Integer horizontalSpacing;
    private Integer verticalSpacing;
    private Integer baselineScreenWidth;
    private Integer baselineScreenHeight;
    private Integer baselineFontSize;
}
