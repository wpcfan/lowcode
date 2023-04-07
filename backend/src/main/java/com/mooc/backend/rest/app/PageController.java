package com.mooc.backend.rest.app;

import com.mooc.backend.config.PageProperties;
import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.enumerations.Errors;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageQueryService;
import com.mooc.backend.services.ProductQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;


@Tag(name = "页面", description = "获取页面信息")
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/v1/app/pages")
public class PageController {

    final PageQueryService pageQueryService;
    final ProductQueryService productQueryService;
    final PageProperties pageProperties;

    @Operation(summary = "根据 pageType 获取页面信息")
    @GetMapping("/published/{pageType}")
    public PageDTO findPublished(
            @Parameter(description = "页面类型", name = "pageType") @PathVariable PageType pageType,
            @Parameter(description = "平台类型", name = "platform") @RequestParam(defaultValue = "App") Platform platform) {
        return pageQueryService.findPublished(platform, pageType)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Page not found", "PageController#findPublished",
                        Errors.DataNotFoundException.code()));
    }
}
