package com.mooc.backend.dtos;

import java.util.List;

public record PageRecord<T>(int page, int size, int totalPage, long totalSize, List<T> data) {
}
