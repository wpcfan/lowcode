package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.*;
import com.mooc.backend.services.PageCreateService;
import com.mooc.backend.services.PageDeleteService;
import com.mooc.backend.services.PageUpdateService;
import lombok.RequiredArgsConstructor;
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
                .orElseThrow();
    }

    @DeleteMapping("/{id}")
    public void deletePage(@PathVariable Long id) {
        pageDeleteService.deletePage(id);
    }

    @PostMapping("/{id}/blocks")
    public PageBlockDTO addBlock(@PathVariable Long id, @RequestBody CreateOrUpdatePageBlockRecord block) {
        return pageCreateService.addBlockToPage(id, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow();
    }

    @PutMapping("/blocks/{blockId}")
    public PageBlockDTO updateBlock(@PathVariable Long blockId, @RequestBody CreateOrUpdatePageBlockRecord block) {
        return pageUpdateService.updateBlock(blockId, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow();
    }

    @DeleteMapping("/blocks/{blockId}")
    public void deleteBlock(@PathVariable Long blockId) {
        pageDeleteService.deleteBlock(blockId);
    }

    @PostMapping("/{blockId}/data")
    public PageBlockDataDTO addData(@PathVariable Long blockId, @RequestBody CreateOrUpdatePageBlockDataRecord data) {
        return pageCreateService.addDataToBlock(blockId, data)
                .map(PageBlockDataDTO::fromEntity)
                .orElseThrow();
    }

    @PutMapping("/data/{dataId}")
    public PageBlockDataDTO updateData(@PathVariable Long dataId, @RequestBody CreateOrUpdatePageBlockDataRecord data) {
        return pageUpdateService.updateData(dataId, data)
                .map(PageBlockDataDTO::fromEntity)
                .orElseThrow();
    }

    @DeleteMapping("/data/{dataId}")
    public void deleteData(@PathVariable Long dataId) {
        pageDeleteService.deleteData(dataId);
    }
}
