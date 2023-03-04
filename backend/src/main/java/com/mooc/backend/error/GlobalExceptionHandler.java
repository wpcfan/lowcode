package com.mooc.backend.error;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DefaultMessageSourceResolvable;
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

    // 从配置文件中读取 hostname
    @Value("${hostname}")
    private String hostname;

    /**
     * 处理自定义异常
     *
     * @param e       异常
     * @param request 请求
     * @return 错误信息
     */
    @ExceptionHandler(CustomException.class)
    public ProblemDetail handleRecordNotFoundException(CustomException e, WebRequest request) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(500), e.getLocalizedMessage());
        body.setType(URI.create(hostname + "/errors/" + e.getCode()));
        body.setTitle(e.getMessage());
        body.setDetail(e.getDetails());
        body.setProperty("hostname", hostname);
        body.setProperty("code", e.getCode());
        body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

    /**
     * 处理使用 jakarta.validation 注解的参数校验异常，
     *
     * @param e       异常
     * @param request 请求
     * @return 错误信息
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleMethodArgumentNotValidException(MethodArgumentNotValidException e, WebRequest request) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(400), e.getLocalizedMessage());

        body.setType(URI.create(hostname + "/errors/validation"));
        String title = e.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> fieldError.getField() + " " + fieldError.getDefaultMessage())
                .collect(Collectors.joining(", "));
        if (title.isEmpty()) {
            title = e.getBindingResult().getAllErrors().stream()
                    .map(DefaultMessageSourceResolvable::getDefaultMessage)
                    .collect(Collectors.joining(", "));
        }
        body.setTitle(title);
        body.setDetail(e.getMessage());
        body.setProperty("hostname", hostname);
        body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

    /**
     * 处理未捕获的异常
     *
     * @param e       异常
     * @param request 请求
     * @return 错误信息
     */
    @ExceptionHandler(Exception.class)
    public ProblemDetail handleException(Exception e, WebRequest request) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(500), e.getLocalizedMessage());
        body.setType(URI.create(hostname + "/errors/uncaught"));
        body.setTitle(messageSource.getMessage("error.uncaught", null, request.getLocale()));
        body.setDetail(e.getMessage());
        body.setProperty("hostname", hostname);
        body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

}
