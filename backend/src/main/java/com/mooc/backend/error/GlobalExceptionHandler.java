package com.mooc.backend.error;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.net.URI;
import java.util.stream.Collectors;

@RestControllerAdvice
@RequiredArgsConstructor
public class GlobalExceptionHandler {

    private final MessageSource messageSource;

    @Value("${hostname}")
    private String hostname;

    @ExceptionHandler(CustomException.class)
    public ProblemDetail handleRecordNotFoundException(CustomException ex, WebRequest request) {

        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(500), ex.getLocalizedMessage());
        body.setType(URI.create(hostname + "/errors/" + ex.getCode()));
        body.setTitle(ex.getMessage());
        body.setProperty("hostname", hostname);
        body.setProperty("code", ex.getCode());
        body.setProperty("details", ex.getDetails());

        return body;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleMethodArgumentNotValidException(MethodArgumentNotValidException e, WebRequest request) {
        String details = e.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> fieldError.getField() + " " + fieldError.getDefaultMessage())
                .collect(Collectors.joining(", "));
        String errorMessage = messageSource.getMessage("error.argument.invalid", null, request.getLocale());
        String path = request.getDescription(false);
        ApiErrorResponse errorResponse = new ApiErrorResponse(HttpStatus.BAD_REQUEST, errorMessage, path, details);
        return new ResponseEntity<>(errorResponse, HttpStatus.BAD_REQUEST);
    }

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
