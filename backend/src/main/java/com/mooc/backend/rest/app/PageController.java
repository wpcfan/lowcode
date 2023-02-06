package com.mooc.backend.rest.app;

import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageQueryService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import ua_parser.Client;
import ua_parser.Parser;


@Tag(name = "页面", description = "获取页面信息")
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/v1/app/pages")
public class PageController {

    final PageQueryService pageQueryService;

    @Operation(summary = "根据 id 获取页面信息")
    @GetMapping("/published/{pageType}")
    public PageDTO findPublished(
            @Parameter(description = "页面类型", name = "pageType") @PathVariable PageType pageType,
            @Parameter(description = "User-Agent", in = ParameterIn.HEADER) @RequestHeader("User-Agent") String uaString) {
        Parser uaParser = new Parser();
        Client c = uaParser.parse(uaString);
        var os = c.os.family;
        var platform = os.equals("Android") ? Platform.Android : os.equals("iOS") ? Platform.iOS : Platform.Web;
        return pageQueryService.findPublished(platform, pageType)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Page not found", "No published page found",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "根据 id 获取页面信息")
    @GetMapping("/{id}")
    public PageDTO findById(@Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        return pageQueryService.findById(id)
                .map(PageDTO::fromProjection)
                .orElseThrow(() -> new CustomException("Page not found", "Page with id " + id + " not found",
                        HttpStatus.NOT_FOUND.value()));
    }
}
