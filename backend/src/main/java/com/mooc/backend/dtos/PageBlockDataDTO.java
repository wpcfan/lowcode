package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.blocks.BlockData;
import com.mooc.backend.projections.PageBlockDataEntityInfo;
import lombok.Builder;
import lombok.Value;

import java.io.Serializable;

@Value
@Builder

public class PageBlockDataDTO implements Serializable, Comparable<PageBlockDataDTO> {
    private static final long serialVersionUID = -1;
    private Long id;
    private Integer sort;
    private BlockData content;

    public static PageBlockDataDTO fromProjection(PageBlockDataEntityInfo data) {
        return PageBlockDataDTO.builder()
                .id(data.getId())
                .sort(data.getSort())
                .content(data.getContent())
                .build();
    }

    public static PageBlockDataDTO fromEntity(PageBlockDataEntity data) {
        return PageBlockDataDTO.builder()
                .id(data.getId())
                .sort(data.getSort())
                .content(data.getContent())
                .build();
    }

    public PageBlockDataEntity toEntity() {
        return PageBlockDataEntity.builder()
                .sort(getSort())
                .content(getContent())
                .build();
    }

    @Override
    public int compareTo(PageBlockDataDTO o) {
        return getSort().compareTo(o.getSort());
    }
}
