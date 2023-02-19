package com.mooc.backend.entities.blocks;

import com.mooc.backend.enumerations.LinkType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Link {
    @Schema(description = "链接类型")
    private LinkType type;
    @Schema(description = "链接值", example = "https://www.baidu.com")
    private String value;
}
