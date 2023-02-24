package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.*;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageCreateService;
import com.mooc.backend.services.PageDeleteService;
import com.mooc.backend.services.PageQueryService;
import com.mooc.backend.services.PageUpdateService;
import com.mooc.backend.specifications.PageFilter;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Tag(name = "页面管理", description = "添加、修改、删除、查询页面，发布页面，撤销发布页面，添加区块，删除区块，修改区块，添加区块数据，删除区块数据，修改区块数据")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/pages")
public class PageAdminController {
    private final PageCreateService pageCreateService;
    private final PageUpdateService pageUpdateService;
    private final PageDeleteService pageDeleteService;
    private final PageQueryService pageQueryService;

    @Operation(summary = "查询页面", description = "根据页面标题、平台、页面类型、状态、启用日期、截止日期查询页面", tags = {"页面管理"})
    @GetMapping()
    public PageWrapper<PageDTO> getPages(
            @Parameter(description = "页面标题", name = "title") @RequestParam(required = false) String title,
            @Parameter(description = "平台", name = "platform") @RequestParam(required = false) Platform platform,
            @Parameter(description = "页面类型", name = "pageType") @RequestParam(required = false) PageType pageType,
            @Parameter(description = "状态", name = "status") @RequestParam(required = false) PageStatus status,
            @Parameter(description = "启用日期从", name = "startDateFrom") @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate startDateFrom,
            @Parameter(description = "启用日期至", name = "startDateTo") @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate startDateTo,
            @Parameter(description = "截止日期从", name = "endDateFrom") @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate endDateFrom,
            @Parameter(description = "截止日期至", name = "endDateTo") @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate endDateTo,
            @ParameterObject Pageable pageable) {
        var pageFilter = new PageFilter(
                title,
                platform,
                pageType,
                status,
                startDateFrom != null ? startDateFrom.atStartOfDay() : null,
                startDateTo != null ? startDateTo.atStartOfDay() : null,
                endDateFrom != null ? endDateFrom.atStartOfDay() : null,
                endDateTo != null ? endDateTo.atStartOfDay() : null);
        var result = pageQueryService.findSpec(pageFilter, pageable)
                .map(PageDTO::fromEntity);
        return new PageWrapper<>(result.getNumber(), result.getSize(), result.getTotalPages(),
                result.getTotalElements(),
                result.getContent());
    }

    @Operation(summary = "添加页面")
    @PostMapping()
    public PageDTO createPage(@Valid @RequestBody CreateOrUpdatePageDTO page) {
        if (pageQueryService.existsByTitle(page.title()))
            throw new CustomException("页面标题已存在", "PageAdminController#createPage", HttpStatus.BAD_REQUEST.value());
        return PageDTO.fromEntity(pageCreateService.createPage(page));
    }

    @Operation(summary = "修改页面")
    @PutMapping("/{id}")
    public PageDTO updatePage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageDTO page) {
        return pageUpdateService.updatePage(id, page)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要修改的数据不存在", "PageAdminController#updatePage",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除页面")
    @DeleteMapping("/{id}")
    public void deletePage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        pageDeleteService.deletePage(id);
    }

    @Operation(summary = "发布页面")
    @PatchMapping("/{id}/publish")
    public PageDTO publishPage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody PublishPageDTO publishPageDTO) {
        return pageUpdateService.publishPage(id, publishPageDTO)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要发布的页面不存在", "PageAdminController#publishPage",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "取消发布页面")
    @PatchMapping("/{id}/draft")
    public PageDTO draftPage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        return pageUpdateService.draftPage(id)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要取消发布的页面不存在", "PageAdminController#draftPage",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "添加页面区块")
    @PostMapping("/{id}/blocks")
    public PageBlockDTO addBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @RequestBody CreateOrUpdatePageBlockDTO block) {
        return pageCreateService.addBlockToPage(id, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要添加的页面区块不存在", "PageAdminController#addBlock",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "修改页面区块")
    @PutMapping("/blocks/{blockId}")
    public PageBlockDTO updateBlock(
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable("blockId") Long blockId,
            @RequestBody CreateOrUpdatePageBlockDTO block) {
        return pageUpdateService.updateBlock(blockId, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要修改的页面区块不存在", "PageAdminController#updateBlock",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除页面区块")
    @DeleteMapping("/blocks/{blockId}")
    public void deleteBlock(
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable("blockId") Long blockId) {
        pageDeleteService.deleteBlock(blockId);
    }

    @Operation(summary = "添加页面区块数据")
    @PostMapping("/{blockId}/data")
    public PageBlockDataDTO addData(
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable("blockId") Long blockId,
            @RequestBody CreateOrUpdatePageBlockDataDTO data) {
        return pageCreateService.addDataToBlock(blockId, data)
                .map(PageBlockDataDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要添加的页面区块数据不存在", "PageAdminController#addData",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "修改页面区块数据")
    @PutMapping("/data/{dataId}")
    public PageBlockDataDTO updateData(
            @Parameter(description = "页面区块数据 id", name = "dataId") @PathVariable Long dataId,
            @RequestBody CreateOrUpdatePageBlockDataDTO data) {
        return pageUpdateService.updateData(dataId, data)
                .map(PageBlockDataDTO::fromEntity)
                .orElseThrow(() -> new CustomException("要修改的页面区块数据不存在", "PageAdminController#updateData",
                        HttpStatus.NOT_FOUND.value()));
    }

    @Operation(summary = "删除页面区块数据")
    @DeleteMapping("/data/{dataId}")
    public void deleteData(
            @Parameter(description = "页面区块数据 id", name = "dataId") @PathVariable Long dataId) {
        pageDeleteService.deleteData(dataId);
    }
}
