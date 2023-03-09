package com.mooc.backend.advices;

import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Consumer;
import java.util.stream.Stream;

@RestControllerAdvice
public class StreamingResponseBodyHandler implements ResponseBodyAdvice<Object> {
    private final ExecutorService executorService = Executors.newFixedThreadPool(10);
    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return returnType.getParameterType().equals(Stream.class);
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType,
                                  Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request,
                                  ServerHttpResponse response) {
        if (body instanceof Stream<?> stream) {
            response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
            response.getHeaders().set("Transfer-Encoding", "chunked");
            StreamingResponseBody responseBody = outputStream -> stream.forEach(chunkedOutput(o -> {
                try {
                    outputStream.write(o.toString().getBytes());
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }));
            return responseBody;
        }
        return body;
    }

    private <T> Consumer<T> chunkedOutput(Consumer<T> output) {
        return t -> {
            try {
                executorService.submit(() -> output.accept(t));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        };
    }

}
