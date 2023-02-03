package com.mooc.backend.entities.blocks;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BlockConfig {
    private Integer horizontalPadding;
    private Integer verticalPadding;
    private Integer horizontalSpacing;
    private Integer verticalSpacing;

    private Double aspectRatio;
}
