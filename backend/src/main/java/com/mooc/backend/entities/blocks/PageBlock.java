package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.json.PageBlockDeserializer;

@JsonDeserialize(using = PageBlockDeserializer.class)
public interface PageBlock {
    Double getAspectRatio();

    String getId();

    String getTitle();

    BlockType getType();

    Integer getSort();

    Object getData();
}
