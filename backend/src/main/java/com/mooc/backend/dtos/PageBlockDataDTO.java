package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.projections.PageBlockDataInfo;
import lombok.Builder;
import lombok.Value;

import java.io.Serial;
import java.io.Serializable;

@Value
@Builder

public class PageBlockDataDTO implements Serializable, Comparable<PageBlockDataDTO> {
    @Serial
    private static final long serialVersionUID = -1;
    Long id;
    Integer sort;
    BlockData content;

    public static PageBlockDataDTO fromProjection(PageBlockDataInfo data) {
        return PageBlockDataDTO.builder()
                .id(data.getId())
                .sort(data.getSort())
                .content(data.getContent())
                .build();
    }

    public static PageBlockDataDTO fromEntity(PageBlockData data) {
        return PageBlockDataDTO.builder()
                .id(data.getId())
                .sort(data.getSort())
                .content(data.getContent())
                .build();
    }

    public PageBlockData toEntity() {
        return PageBlockData.builder()
                .sort(getSort())
                .content(getContent())
                .build();
    }

    @Override
    public int compareTo(PageBlockDataDTO o) {
        return getSort().compareTo(o.getSort());
    }
}
