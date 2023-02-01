package com.mooc.backend.error;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiErrorResponse {
    private final HttpStatus status;
    private final String error;
    private final String message;
    private final String path;
    private final String timestamp;

    public ApiErrorResponse(HttpStatus status, String message, String path) {
        this.status = status;
        this.error = status.getReasonPhrase();
        this.message = message;
        this.path = path;
        this.timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
}
