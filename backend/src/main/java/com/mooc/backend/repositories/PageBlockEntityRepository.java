package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.enumerations.BlockType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface PageBlockEntityRepository extends JpaRepository<PageBlockEntity, Long> {
    long countByTypeAndPageId(BlockType blockType, Long pageId);

    long countByTypeAndPageIdAndSortGreaterThanEqual(BlockType blockType, Long pageId, int sort);

    @Modifying
    @Query("update PageBlockEntity p set p.sort = p.sort + 1 where p.page.id = ?1 and p.sort >= ?2")
    int updateSortByPageIdAndSortGreaterThanEqual(Long id, Integer sort);

    @Modifying
    @Query("update PageBlockEntity p set p.sort = p.sort + 1 where p.page.id = ?1 and p.sort <= ?2")
    int updateSortByPageIdAndSortLessThanEqual(Long pageId, Integer sort);
}