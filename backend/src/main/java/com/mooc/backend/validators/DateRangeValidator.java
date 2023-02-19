package com.mooc.backend.validators;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.constraintvalidation.SupportedValidationTarget;
import jakarta.validation.constraintvalidation.ValidationTarget;
import org.springframework.expression.spel.standard.SpelExpressionParser;

import java.time.LocalDateTime;

@SupportedValidationTarget(ValidationTarget.ANNOTATED_ELEMENT)
public class DateRangeValidator implements ConstraintValidator<ValidateDateRange, Object> {
    private static final SpelExpressionParser PARSER = new SpelExpressionParser();
    private String[] fields;

    @Override
    public void initialize(ValidateDateRange constraintAnnotation) {
        this.fields = constraintAnnotation.value();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext context) {
        if (fields.length != 2) {
            throw new IllegalArgumentException("Invalid number of fields");
        }
        LocalDateTime start = (LocalDateTime) PARSER.parseExpression(fields[0]).getValue(value);
        LocalDateTime end = (LocalDateTime) PARSER.parseExpression(fields[1]).getValue(value);
        if (start == null || end == null) {
            return true;
        }
        return start.isBefore(end);
    }
}
