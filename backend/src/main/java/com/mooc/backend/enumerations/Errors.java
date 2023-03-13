package com.mooc.backend.enumerations;

public enum Errors {
    ConstraintViolationException(40001),
    DataNotFoundException(40002),
    DataAlreadyExistsException(40003),
    FileUploadException(40010),
    FileDeleteException(40011),
    ;

    private final int code;

    Errors(int code) {
        this.code = code;
    }

    public int code() {
        return code;
    }
}
