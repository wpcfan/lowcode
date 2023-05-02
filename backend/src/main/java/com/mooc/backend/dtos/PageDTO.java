package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import lombok.Builder;
import lombok.Getter;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.SortedSet;
import java.util.TreeSet;

@Getter
@Builder
public class PageDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = -1;
    private Long id;
    private String title;
    private Platform platform;
    private PageType pageType;
    private PageConfig config;
    @Builder.Default
    private SortedSet<PageBlock> blocks = new TreeSet<>();
    /**
     * 页面启用时间，只有在启用时间之后，且处于已发布状态下才会显示给用户
     */
    private LocalDateTime startTime;

    /**
     * 页面失效时间，只有在失效时间之前，且处于已发布状态下才会显示给用户
     */
    private LocalDateTime endTime;

    private PageStatus status;

    public static PageDTO fromEntity(PageLayout page) {
        return PageDTO.builder()
                .id(page.getId())
                .title(page.getTitle())
                .platform(page.getPlatform())
                .pageType(page.getPageType())
                .config(page.getConfig())
                .blocks(page.getPageBlocks())
                .startTime(page.getStartTime())
                .endTime(page.getEndTime())
                .status(page.getStatus())
                .build();
    }

    public PageLayout toEntity() {
        return PageLayout.builder()
                .title(getTitle())
                .platform(getPlatform())
                .pageType(getPageType())
                .config(getConfig())
                .pageBlocks(getBlocks())
                .build();
    }
}
