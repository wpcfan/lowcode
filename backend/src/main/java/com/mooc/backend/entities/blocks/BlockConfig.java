package com.mooc.backend.entities.blocks;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Schema(description = "区块配置")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BlockConfig {
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
    @NotNull
    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockHeight;
}
