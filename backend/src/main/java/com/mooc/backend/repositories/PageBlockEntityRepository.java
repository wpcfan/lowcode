package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.enumerations.BlockType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PageBlockEntityRepository extends JpaRepository<PageBlockEntity, Long> {
    long countByTypeAndPageId(BlockType blockType, Long pageId);

    long countByTypeAndPageIdAndSortGreaterThanEqual(BlockType blockType, Long pageId, int sort);
}