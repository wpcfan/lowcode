package com.mooc.backend.validators;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.constraintvalidation.SupportedValidationTarget;
import jakarta.validation.constraintvalidation.ValidationTarget;

import java.time.LocalDateTime;

@SupportedValidationTarget(ValidationTarget.ANNOTATED_ELEMENT)
public class DateRangeValidator implements ConstraintValidator<ValidateDateRange, Object[]> {
    @Override
    public boolean isValid(Object[] value, ConstraintValidatorContext context) {
        if (value.length != 2) {
            return false;
        }
//        if (!(value[0] instanceof LocalDateTime) || !(value[1] instanceof LocalDateTime)) {
//            return false;
//        }
//        LocalDateTime start = (LocalDateTime) value[0];
//        LocalDateTime end = (LocalDateTime) value[1];
        /// 下面的写法是 Java 10 之后的写法，更简洁
        if (!(value[0] instanceof LocalDateTime start) || !(value[1] instanceof LocalDateTime end)) {
            return false;
        }
        return start.isBefore(end);
    }
}
