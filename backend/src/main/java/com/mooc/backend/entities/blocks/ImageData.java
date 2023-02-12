package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@JsonDeserialize(as = ImageData.class)
public class ImageData implements BlockData {
    private Integer sort;

    private ImageDTO data;
}
