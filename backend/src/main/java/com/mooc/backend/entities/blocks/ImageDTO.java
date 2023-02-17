package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.enumerations.BlockDataType;

@JsonDeserialize(as = ImageDTO.class)

public record ImageDTO(String image, String title, Link link) implements BlockData {
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Image;
    }
}
