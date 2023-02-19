package com.mooc.backend.validators;

import jakarta.validation.Constraint;
import jakarta.validation.ConstraintTarget;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {DateRangeValidator.class})
@Repeatable(ValidateDateRange.List.class)
public @interface ValidateDateRange {
    String message() default "start time must be before end time";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};

    ConstraintTarget validationAppliesTo() default ConstraintTarget.IMPLICIT;

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @interface List {
        ValidateDateRange[] value();
    }
}
