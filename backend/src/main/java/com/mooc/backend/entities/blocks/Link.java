package com.mooc.backend.entities.blocks;

import com.mooc.backend.enumerations.LinkType;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Link {
    private LinkType type;
    private String value;
}
