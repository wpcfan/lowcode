package com.mooc.backend.config.resolvers;

import org.springframework.core.MethodParameter;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import java.lang.reflect.Method;

public class ExampleResolver implements HandlerMethodArgumentResolver {

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return Example.class.isAssignableFrom(parameter.getParameterType());
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
        Class<?> domainType = parameter.getParameterType().getTypeParameters()[0].getClass();
        ExampleMatcher matcher = ExampleMatcher.matching()
                .withIgnorePaths("id");
        try {
            Object example = domainType.newInstance();
            webRequest.getParameterMap().forEach((k, v) -> {
                try {
                    Method method = domainType.getMethod("set" + k.substring(0, 1).toUpperCase() + k.substring(1), String.class);
                    method.invoke(example, v[0]);
                } catch (Exception e) {
                    // ignore
                }
            });
            return Example.of(example, matcher);
        } catch (Exception e) {
            return null;
        }
    }
}

