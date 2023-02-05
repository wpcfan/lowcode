package com.mooc.backend.dtos;

import java.util.List;

public record SliceWrapper<T>(
        int page, int size, boolean hasNext, List<T> data) {

}
