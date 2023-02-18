package com.mooc.backend.entities.blocks;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BlockConfig {
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double horizontalPadding;
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double verticalPadding;
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double horizontalSpacing;
    @DecimalMin("0.00")
    @DecimalMax("100.00")
    private Double verticalSpacing;

    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockWidth;

    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockHeight;

    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double itemWidth;

    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double itemHeight;
}
