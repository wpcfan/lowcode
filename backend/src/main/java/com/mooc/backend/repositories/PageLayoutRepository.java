package com.mooc.backend.repositories;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.stream.Stream;

import org.springframework.data.jpa.repository.*;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.projections.PageLayoutInfo;

public interface PageLayoutRepository extends JpaRepository<PageLayout, Long>, JpaSpecificationExecutor<PageLayout> {
    @EntityGraph(attributePaths = { "pageBlocks", "pageBlocks.data" })
    Optional<PageLayout> findById(Long id);

    @Query("select p.id as id, p.title as title from PageLayout p where p.id = ?1")
    Optional<PageLayoutInfo> findProjectionById(Long id);

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
            select p from PageLayout p
            where p.status = com.mooc.backend.enumerations.PageStatus.Published
            and p.startTime is not null and p.endTime is not null
            and p.startTime < ?1 and p.endTime > ?1
            and p.platform = ?2
            and p.pageType = ?3
            """)
    Stream<PageLayout> streamPublishedPage(LocalDateTime currentTime, Platform platform, PageType pageType);

    /**
     * 计算指定时间、平台、页面类型的页面数量
     * 用于判断是否存在时间冲突的页面布局
     * 
     * @param time
     * @param platform
     * @param pageType
     * @return
     */
    @Query("""
            select count(p) from PageLayout p
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
            update PageLayout p
            set p.status = com.mooc.backend.enumerations.PageStatus.Archived
            where p.status = com.mooc.backend.enumerations.PageStatus.Published
            and p.startTime is not null and p.endTime is not null
            and p.endTime < ?1
            """)
    int updatePageStatusToArchived(LocalDateTime currentTime);

    int countByTitle(String title);
}