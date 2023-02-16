package com.mooc.backend.error;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import java.net.URI;
import java.util.Optional;
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
        body.setDetail(ex.getDetails());
        body.setProperty("hostname", hostname);
        body.setProperty("code", ex.getCode());
        body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleMethodArgumentNotValidException(MethodArgumentNotValidException e, WebRequest request) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(400), e.getLocalizedMessage());

        body.setType(URI.create(hostname + "/errors/validation"));
        body.setTitle(e.getMessage());
        String details = e.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> fieldError.getField() + " " + fieldError.getDefaultMessage())
                .collect(Collectors.joining(", "));
        body.setDetail(details);
        body.setProperty("hostname", hostname);
        body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

    @ExceptionHandler(Exception.class)
    public ProblemDetail handleException(Exception ex, WebRequest request) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(500), ex.getLocalizedMessage());
        body.setType(URI.create(hostname + "/errors/uncaught"));
        body.setTitle(messageSource.getMessage("error.uncaught", null, request.getLocale()));
        body.setProperty("hostname", hostname);
        body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

}
