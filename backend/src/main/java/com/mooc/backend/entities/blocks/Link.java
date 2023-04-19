package com.mooc.backend.entities.blocks;

import com.mooc.backend.enumerations.LinkType;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode
public class Link implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    @Schema(description = "链接类型")
    private LinkType type;
    @Schema(description = "链接值", example = "https://www.baidu.com")
    private String value;
}
