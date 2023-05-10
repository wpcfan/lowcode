package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.*;
import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.enumerations.Errors;
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
import lombok.extern.slf4j.Slf4j;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Slf4j
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
                startDateFrom != null ? startDateFrom.atTime(LocalTime.MIN) : null,
                startDateTo != null ? startDateTo.atTime(LocalTime.MAX) : null,
                endDateFrom != null ? endDateFrom.atTime(LocalTime.MIN) : null,
                endDateTo != null ? endDateTo.atTime(LocalTime.MAX) : null);
        var result = pageQueryService.findSpec(pageFilter, pageable)
                .map(PageDTO::fromEntity);
        return new PageWrapper<>(result.getNumber(), result.getSize(), result.getTotalPages(),
                result.getTotalElements(),
                result.getContent());
    }

    @Operation(summary = "根据 id 获取页面信息")
    @GetMapping("/{id}")
    public PageDTO findById(@Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        return PageDTO.fromEntity(pageQueryService.findById(id));
    }

    @Operation(summary = "添加页面")
    @PostMapping()
    public PageDTO createPage(@Valid @RequestBody CreateOrUpdatePageDTO page) {
        if (pageQueryService.existsByTitle(page.title()))
            throw new CustomException("页面标题已存在", "PageAdminController#createPage", Errors.DataAlreadyExistsException.code());
        return PageDTO.fromEntity(pageCreateService.createPage(page));
    }

    @Operation(summary = "修改页面")
    @PutMapping("/{id}")
    public PageDTO updatePage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageDTO page) {
        checkPageStatus(id);
        return PageDTO.fromEntity(pageUpdateService.updatePage(id, page));
    }

    @Operation(summary = "删除页面")
    @DeleteMapping("/{id}")
    public void deletePage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        checkPageStatus(id);
        pageDeleteService.deletePage(id);
    }

    @Operation(summary = "发布页面")
    @PatchMapping("/{id}/publish")
    public PageDTO publishPage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody PublishPageDTO publishPageDTO) {
        return PageDTO.fromEntity(pageUpdateService.publishPage(id, publishPageDTO));
    }

    @Operation(summary = "取消发布页面")
    @PatchMapping("/{id}/draft")
    public PageDTO draftPage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        return PageDTO.fromEntity(pageUpdateService.draftPage(id));
    }

    @Operation(summary = "添加页面区块")
    @PostMapping("/{id}/blocks")
    public PageDTO addBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageBlockDTO block) {
        checkPageStatus(id);
        return PageDTO.fromEntity(pageCreateService.addBlockToPage(id, block));
    }

    @Operation(summary = "插入页面区块")
    @PostMapping("/{id}/blocks/insert")
    public PageDTO insertBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageBlockDTO insertPageBlockDTO) {
        checkPageStatus(id);
        return PageDTO.fromEntity(pageCreateService.insertBlockToPage(id, insertPageBlockDTO));
    }

    @Operation(summary = "修改页面区块")
    @PutMapping("/{id}/blocks/{blockId}")
    public PageBlock updateBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @RequestBody CreateOrUpdatePageBlockDTO block) {
        log.debug("update block: id = {}, blockId = {}, block = {}", id, blockId, block);
        checkPageStatus(id);
        return pageUpdateService.updateBlock(blockId, block);
    }

    @Operation(summary = "删除页面区块")
    @DeleteMapping("/{id}/blocks/{blockId}")
    public void deleteBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId) {
        checkPageStatus(id);
        pageDeleteService.deleteBlock(id, blockId);
    }

    @Operation(summary = "移动页面区块")
    @PatchMapping("/{id}/blocks/{blockId}/move/{targetSort}")
    public PageDTO moveBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @Parameter(description = "目标排序", name = "targetSort") @PathVariable Integer targetSort
    ) {
        log.debug("move block: id = {}, blockId = {}, targetSort = {}", id, blockId, targetSort);
        checkPageStatus(id);
        return PageDTO.fromEntity(pageUpdateService.moveBlock(id, blockId, targetSort));
    }

    @Operation(summary = "批量添加页面区块数据")
    @PostMapping("/{id}/blocks/{blockId}/data/batch")
    public List<PageBlockData> addDataBatch(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @RequestBody List<CreateOrUpdatePageBlockDataDTO> data) {
        log.debug("add data: id = {}, blockId = {}, data = {}", id, blockId, data);
        checkPageStatus(id);
        return pageCreateService.addDataToBlockBatch(blockId, data);
    }

    @Operation(summary = "添加页面区块数据")
    @PostMapping("/{id}/blocks/{blockId}/data")
    public PageBlockData addData(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @RequestBody CreateOrUpdatePageBlockDataDTO data) {
        log.debug("add data: id = {}, blockId = {}, data = {}", id, blockId, data);
        checkPageStatus(id);
        return pageCreateService.addDataToBlock(blockId, data);
    }

    @Operation(summary = "修改页面区块数据")
    @PutMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public PageBlockData updateData(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @Parameter(description = "页面区块数据 id", name = "dataId") @PathVariable Long dataId,
            @RequestBody CreateOrUpdatePageBlockDataDTO data) {
        log.debug("update data: id = {}, blockId = {}, dataId = {}, data = {}", id, blockId, dataId, data);
        checkPageStatus(id);
        return pageUpdateService.updateData(dataId, data);
    }

    @Operation(summary = "删除页面区块数据")
    @DeleteMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public void deleteData(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @Parameter(description = "页面区块数据 id", name = "dataId") @PathVariable Long dataId) {
        log.debug("delete data: id = {}, blockId = {}, dataId = {}", id, blockId, dataId);
        checkPageStatus(id);
        pageDeleteService.deleteData(blockId, dataId);
    }

    private void checkPageStatus(Long pageId) {
        var pageEntity = pageQueryService.findById(pageId);
        if (pageEntity.getStatus() == PageStatus.Published) {
            throw new CustomException("页面已发布，不能对页面组成部分进行修改", "PageAdminController#checkPageStatus",
                    Errors.ConstraintViolationException.code());
        }
    }
}
