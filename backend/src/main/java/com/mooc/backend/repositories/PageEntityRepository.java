package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.projections.PageEntityInfo;
import org.springframework.data.jpa.repository.*;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.stream.Stream;

public interface PageEntityRepository extends JpaRepository<PageEntity, Long>, JpaSpecificationExecutor<PageEntity> {
    @EntityGraph(attributePaths = {"pageBlocks", "pageBlocks.data"})
    Optional<PageEntity> findById(Long id);

    @Query("select p from PageEntity p left join fetch p.pageBlocks pb left join fetch pb.data where p.id = ?1")
    Optional<PageEntityInfo> findProjectionById(Long id);

    /**
     * 查询所有满足条件的页面
     * 条件为：
     * 1. 当前时间在开始时间和结束时间之间
     * 2. 平台为指定平台
     * 3. 页面类型为指定页面类型
     * 4. 状态为已发布
     * <p>
     * 使用 Stream 返回，避免一次性查询所有数据，但使用的是延迟加载，
     * 所以在使用时需要使用 try-with-resources 语句，或者手动关闭
     *
     * @param currentTime 当前时间
     * @param platform    平台
     * @param pageType    页面类型
     * @return 页面列表
     */
    @Query("""
    select p from PageEntity p
    where p.status = com.mooc.backend.enumerations.PageStatus.Published
    and p.startTime is not null and p.endTime is not null
    and p.startTime < ?1 and p.endTime > ?1
    and p.platform = ?2
    and p.pageType = ?3
    """)
    Stream<PageEntity> streamPublishedPage(LocalDateTime currentTime, Platform platform, PageType pageType);

    @Query("""
    select count(p) from PageEntity p
    where p.status = com.mooc.backend.enumerations.PageStatus.Published
    and p.startTime is not null and p.endTime is not null
    and p.startTime < ?1 and p.endTime > ?1
    and p.platform = ?2
    and p.pageType = ?3
    """)
    int countPublishedTimeConflict(LocalDateTime time, Platform platform, PageType pageType);

    /**
     * 修改所有已过期的页面状态为 Archived
     * <p>
     * 注意 Spring Data JPA 中使用 `@Modifying` 注解来标记需要修改的方法
     *
     * @param currentTime 当前时间
     * @return 修改的记录数
     */
    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("""
    update PageEntity p
    set p.status = com.mooc.backend.enumerations.PageStatus.Archived
    where p.status = com.mooc.backend.enumerations.PageStatus.Published
    and p.startTime is not null and p.endTime is not null
    and p.endTime < ?1
    """)
    int updatePageStatusToArchived(LocalDateTime currentTime);

    int countByTitle(String title);
}