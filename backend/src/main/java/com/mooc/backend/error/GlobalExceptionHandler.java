package com.mooc.backend.error;

import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

@RestControllerAdvice
@RequiredArgsConstructor
public class GlobalExceptionHandler {

    private final MessageSource messageSource;

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleException(Exception ex, WebRequest request) {
        HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;
        String errorMessage = messageSource.getMessage("error.internal.server", null, request.getLocale());
//        String message = ex.getMessage();
        String path = request.getDescription(false);

        ApiErrorResponse errorResponse = new ApiErrorResponse(status, errorMessage, path);

        return new ResponseEntity<>(errorResponse, status);
    }
}
