package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.enumerations.BlockDataType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

@JsonDeserialize(as = ImageDTO.class)

public record ImageDTO(
        @Schema(description = "图片地址", example = "https://via.placeholder.com/100x100/image1") @NotNull String image,
        @Schema(description = "图片地址", example = "image1") @NotNull String title,
        @NotNull Link link
) implements BlockData {
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Image;
    }
}
