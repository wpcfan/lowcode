package com.mooc.backend.dtos;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "FileDTO", description = "文件数据传输对象")
public record FileDTO(
        @Schema(description = "文件 URL", example = "https://example.com/123-abc-123") String url,
        @Schema(description = "文件唯一标识", example = "123-abc-123") String key) {
}
