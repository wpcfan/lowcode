package com.mooc.backend.error;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class CustomException extends RuntimeException {
    private final String message;
    private final String details;
    private final Integer code;
}
