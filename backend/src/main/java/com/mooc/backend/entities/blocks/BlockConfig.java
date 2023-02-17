package com.mooc.backend.entities.blocks;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BlockConfig {
    @Min(0)
    @Max(100)
    private Double horizontalPadding;
    @Min(0)
    @Max(100)
    private Double verticalPadding;
    @Min(0)
    @Max(100)
    private Double horizontalSpacing;
    @Min(0)
    @Max(100)
    private Double verticalSpacing;

    private Double itemWidth;
    private Double itemHeight;
}
