package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.projections.PageEntityInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

public interface PageEntityRepository extends JpaRepository<PageEntity, Long>, JpaSpecificationExecutor<PageEntity> {

    @Query("select p from PageEntity p left join fetch p.pageBlocks pb left join fetch pb.data where p.id = ?1")
    Optional<PageEntityInfo> findProjectionById(Long id);

    List<PageEntityInfo> findAllByStartTimeBeforeAndEndTimeAfter(Long startTime, Long endTime);

    Page<PageEntityInfo> findAllByStatus(PageStatus status, Pageable pageable);

    @Query("select p from PageEntity p" +
            " where p.status = com.mooc.backend.enumerations.PageStatus.Published" +
            " and p.startTime < ?1 and p.endTime > ?1" +
            " and p.platform = ?2" +
            " and p.pageType = ?3")
    Stream<PageEntity> findPublishedPage(LocalDateTime currentTime, Platform platform, PageType pageType);

    @Modifying
    @Query("update PageEntity p set p.status = com.mooc.backend.enumerations.PageStatus.Draft" +
            " where p.status = com.mooc.backend.enumerations.PageStatus.Published" +
            " and p.startTime < ?1 and p.endTime > ?1" +
            " and p.platform = ?2" +
            " and p.pageType = ?3")
    int updatePageStatusToDraft(LocalDateTime currentTime, Platform platform, PageType pageType);
}