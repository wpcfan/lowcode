package com.mooc.backend.entities.blocks;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImageData {
    private String image;
    private Link link;
    private Integer sort;
    private String title;
}
