package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.enumerations.BlockType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface PageBlockRepository extends JpaRepository<PageBlock, Long> {
    long countByTypeAndPageId(BlockType blockType, Long pageId);

    long countByTypeAndPageIdAndSortGreaterThanEqual(BlockType blockType, Long pageId, int sort);

    /**
     * 更新指定页面下，指定排序值之后的所有块的排序值
     * 需要了解的知识点：
     * <p><pre>@Modifying(flushAutomatically = true, clearAutomatically = true)</pre> 是一个注解
     * 用于标记需要修改数据的方法。其中，flushAutomatically 和 clearAutomatically 是两个可选参数，
     * 它们的作用如下：</p>
     * <ul>
     *     <li>
     *          flushAutomatically: 当设置为 true 时，表示在执行修改操作<b>之前<b/>，会先将持久化上下文中的所有修改同步到数据库中。
     *          这样可以确保修改操作的数据是最新的，但也会增加数据库的负担。
     *          如果设置为 false，则不会自动同步，需要手动调用 flush() 方法。
     *     </li>
     *     <li>
     *          clearAutomatically: 当设置为 true 时，表示在执行修改操作<b>之后</b>，会清空持久化上下文中的所有缓存对象。
     *          这样可以避免缓存对象的状态与数据库不一致，但也会增加数据库的负担。
     *          如果设置为 false，则不会自动清空，需要手动调用 clear() 方法。
     *     </li>
     * </ul>
     * @param id
     * @param sort
     * @return
     */
    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("update PageBlock p set p.sort = p.sort + 1 where p.page.id = ?1 and p.sort >= ?2")
    int updateSortByPageIdAndSortGreaterThanEqual(Long id, Integer sort);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("update PageBlock p set p.sort = p.sort - 1 where p.page.id = ?1 and p.sort <= ?2")
    int updateSortByPageIdAndSortLessThanEqual(Long pageId, Integer sort);
}