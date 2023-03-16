package com.mooc.backend.entities.blocks;

import com.mooc.backend.enumerations.LinkType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Link implements Serializable {
    private static final long serialVersionUID = 1L;
    @Schema(description = "链接类型")
    private LinkType type;
    @Schema(description = "链接值", example = "https://www.baidu.com")
    private String value;
}
