package com.mooc.backend.error;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Schema(name = "CustomException", description = "自定义异常")
@Getter
@RequiredArgsConstructor
public class CustomException extends RuntimeException {
    private final String message;
    private final String details;
    private final Integer code;
}
