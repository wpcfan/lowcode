package com.mooc.backend.entities.blocks;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(as = ImageDTO.class)

public record ImageDTO(String image, String title, Link link) implements BlockData{
}
