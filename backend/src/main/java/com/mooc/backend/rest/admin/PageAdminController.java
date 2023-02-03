package com.mooc.backend.rest.admin;

import com.mooc.backend.dtos.CreateOrUpdatePageBlockRecord;
import com.mooc.backend.dtos.CreateOrUpdatePageRecord;
import com.mooc.backend.dtos.PageBlockDTO;
import com.mooc.backend.dtos.PageDTO;
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

    @PutMapping("/{id}/blocks/{blockId}")
    public PageBlockDTO updateBlock(@PathVariable Long id, @PathVariable Long blockId, @RequestBody CreateOrUpdatePageBlockRecord block) {
        return pageUpdateService.updateBlock(blockId, block)
                .map(PageBlockDTO::fromEntity)
                .orElseThrow();
    }

    @DeleteMapping("/{id}/blocks/{blockId}")
    public void deleteBlock(@PathVariable Long id, @PathVariable Long blockId) {
        pageDeleteService.deleteBlock(blockId);
    }

}
