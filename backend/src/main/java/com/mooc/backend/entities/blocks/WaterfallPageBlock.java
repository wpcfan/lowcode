package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.enumerations.BlockType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonDeserialize(as = WaterfallPageBlock.class)
public class WaterfallPageBlock implements PageBlock {
    private String id;
    private String title;
    @Builder.Default
    private BlockType type = BlockType.Waterfall;
    private Integer sort;
    private Double aspectRatio;
    private List<ProductData> data;
}
