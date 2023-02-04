package com.mooc.backend.specifications;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

import java.time.LocalDateTime;

public record PageFilter(
        String title,
        Platform platform,
        PageType pageType,
        PageStatus status,
        LocalDateTime startDateFrom,
        LocalDateTime startDateTo,
        LocalDateTime endDateFrom,
        LocalDateTime endDateTo) {
}
