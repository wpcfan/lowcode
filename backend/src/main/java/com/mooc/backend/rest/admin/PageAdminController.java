package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.*;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageCreateService;
import com.mooc.backend.services.PageDeleteService;
import com.mooc.backend.services.PageUpdateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/pages")
public class PageAdminController {
    private final PageCreateService pageCreateService;
    private final PageUpdateService pageUpdateService;
    private final PageDeleteService pageDeleteService;

    @PostMapping()
    public PageDTO createPage(@RequestBody CreateOrUpdatePageRecord page) {
        return PageDTO.fromEntity(pageCreateService.createPage(page));
    }

    @PutMapping("/{id}")
    public PageDTO updatePage(@PathVariable Long id, @RequestBody CreateOrUpdatePageRecord page) {
        return pageUpdateService.updatePage(id, page)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Page not found", "Page " + id + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @DeleteMapping("/{id}")
    public void deletePage(@PathVariable Long id) {
        pageDeleteService.deletePage(id);
    }

    @PostMapping("/{id}/blocks")
    public PageBlockDTO addBlock(@PathVariable Long id, @RequestBody CreateOrUpdatePageBlockRecord block) {
        return pageCreateService.addBlockToPage(id, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Page not found", "Page " + id + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @PutMapping("/blocks/{blockId}")
    public PageBlockDTO updateBlock(@PathVariable Long blockId, @RequestBody CreateOrUpdatePageBlockRecord block) {
        return pageUpdateService.updateBlock(blockId, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow(() -> new CustomException("PageBlock not found", "PageBlock " + blockId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @DeleteMapping("/blocks/{blockId}")
    public void deleteBlock(@PathVariable Long blockId) {
        pageDeleteService.deleteBlock(blockId);
    }

    @PostMapping("/{blockId}/data")
    public PageBlockDataDTO addData(@PathVariable Long blockId, @RequestBody CreateOrUpdatePageBlockDataRecord data) {
        return pageCreateService.addDataToBlock(blockId, data)
                .map(PageBlockDataDTO::fromEntity)
                .orElseThrow(() -> new CustomException("PageBlock not found", "PageBlock " + blockId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @PutMapping("/data/{dataId}")
    public PageBlockDataDTO updateData(@PathVariable Long dataId, @RequestBody CreateOrUpdatePageBlockDataRecord data) {
        return pageUpdateService.updateData(dataId, data)
                .map(PageBlockDataDTO::fromEntity)
                .orElseThrow(() -> new CustomException("PageBlockData not found", "PageBlockData " + dataId + " not found", HttpStatus.NOT_FOUND.value()));
    }

    @DeleteMapping("/data/{dataId}")
    public void deleteData(@PathVariable Long dataId) {
        pageDeleteService.deleteData(dataId);
    }
}
