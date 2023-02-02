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
@JsonDeserialize(as = ImageRowPageBlock.class)
public class ImageRowPageBlock implements PageBlock {
    private String id;
    private String title;
    @Builder.Default
    private BlockType type = BlockType.ImageRow;
    private Integer sort;
    private List<ImageData> data;

}
