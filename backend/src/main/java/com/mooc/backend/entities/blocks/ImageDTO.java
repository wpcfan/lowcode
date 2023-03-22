package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.enumerations.BlockDataType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.util.Objects;

@JsonDeserialize(as = ImageDTO.class)

public record ImageDTO(
        @Schema(description = "图片地址", example = "http://localhost:8080/api/images/100/100/image1") @NotNull String image,
        @Schema(description = "图片地址", example = "image1") @NotNull String title,
        @NotNull Link link
) implements BlockData {
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    @Override
    public BlockDataType getDataType() {
        return BlockDataType.Image;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        ImageDTO imageDTO = (ImageDTO) o;

        if (!Objects.equals(image, imageDTO.image)) return false;
        if (!Objects.equals(title, imageDTO.title)) return false;
        return Objects.equals(link, imageDTO.link);
    }

    @Override
    public int hashCode() {
        int result = image != null ? image.hashCode() : 0;
        result = 31 * result + (title != null ? title.hashCode() : 0);
        result = 31 * result + (link != null ? link.hashCode() : 0);
        return result;
    }
}
