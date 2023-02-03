package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@JsonDeserialize(as = ImageData.class)
public class ImageData implements BlockData {
    private Integer sort;
    private String image;
    private Link link;
    private String title;
}
