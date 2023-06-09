package com.mooc.backend.dtos;

import com.mooc.backend.validators.ValidateDateRange;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

@ValidateDateRange({"startTime", "endTime"})
public record PublishPageDTO(
        @Schema(description = "开始时间") @NotNull LocalDateTime startTime,
        @Schema(description = "结束时间") @NotNull @Future LocalDateTime endTime) {
}
