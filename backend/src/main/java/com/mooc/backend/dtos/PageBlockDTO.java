package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.projections.PageBlockInfo;
import lombok.Builder;
import lombok.Value;

import java.io.Serial;
import java.io.Serializable;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

@Value
@Builder
public class PageBlockDTO implements Serializable, Comparable<PageBlockDTO> {
    @Serial
    private static final long serialVersionUID = -1;
    Long id;
    String title;
    BlockType type;
    Integer sort;
    BlockConfig config;
    SortedSet<PageBlockDataDTO> data;

    public static PageBlockDTO fromProjection(PageBlockInfo block) {
        return PageBlockDTO.builder()
                .id(block.getId())
                .title(block.getTitle())
                .type(block.getType())
                .sort(block.getSort())
                .config(block.getConfig())
                .data(block.getData().stream()
                        .map(PageBlockDataDTO::fromProjection)
                        .collect(TreeSet::new, Set::add, Set::addAll)
                )
                .build();
    }

    public static PageBlockDTO fromEntity(PageBlock block) {
        return PageBlockDTO.builder()
                .id(block.getId())
                .title(block.getTitle())
                .type(block.getType())
                .sort(block.getSort())
                .config(block.getConfig())
                .data(block.getData().stream()
                        .map(PageBlockDataDTO::fromEntity)
                        .collect(TreeSet::new, Set::add, Set::addAll)
                )
                .build();
    }

    public PageBlock toEntity() {
        var pageBlockEntity = PageBlock.builder()
                .title(getTitle())
                .type(getType())
                .sort(getSort())
                .config(getConfig())
                .build();
        getData().forEach(data -> pageBlockEntity.addData(data.toEntity()));
        return pageBlockEntity;
    }

    @Override
    public int compareTo(PageBlockDTO o) {
        return getSort().compareTo(o.getSort());
    }
}
