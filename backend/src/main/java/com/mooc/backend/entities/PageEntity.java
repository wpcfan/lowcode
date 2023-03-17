package com.mooc.backend.entities;

import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Type;

import java.time.LocalDateTime;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * 页面实体
 * <p>
 * 一个页面可以包含多个页面区块
 * 一个页面区块可以包含多个页面区块数据
 * 一个页面区块数据可以包含多个数据项
 * </p>
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Cacheable
@Entity
@Table(name = "mooc_pages")
public class PageEntity extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Platform platform;

    @Enumerated(EnumType.STRING)
    @Column(name = "page_type", nullable = false)
    private PageType pageType;

    /**
     * cascade = CascadeType.ALL 表示级联保存，删除，更新，刷新，合并等操作
     * orphanRemoval = true 表示级联删除
     * mappedBy = "page" 表示由 PageBlockEntity 中的 page 属性来维护关联关系
     * CascadeType 有以下几种：
     * CascadeType.PERSIST：级联新建，即保存一个父对象，同时保存子对象
     * CascadeType.REMOVE：级联删除，即删除一个父对象，同时删除子对象。它的删除是指将数据库中的数据删除，而不是将关联关系去除。
     * CascadeType.REFRESH：级联刷新，即重新查询数据库中的数据
     * CascadeType.MERGE：级联更新，即更新一个父对象，同时更新子对象
     * CascadeType.DETACH：级联脱管，即把一个对象从持久化状态变成游离状态。当一个对象被游离状态时，它就不会再跟持久化上下文中的对象保持同步了。
     * CascadeType.ALL：包含以上所有操作
     * <p>
     * CascadeType.REMOVE 和 orphanRemoval = true 的区别：
     * CascadeType.REMOVE 是指删除父对象的时候，同时删除子对象，但是子对象仍然存在于数据库中，只是没有了父对象的关联关系。
     * orphanRemoval = true 是指删除父对象的时候，同时删除子对象，而且子对象也会从数据库中删除。
     * <p>
     */

    @OneToMany(mappedBy = "page", cascade = {CascadeType.ALL}, orphanRemoval = true)
    @ToString.Exclude
    @Builder.Default
    private SortedSet<PageBlockEntity> pageBlocks = new TreeSet<>();

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    private PageConfig config;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time")
    private LocalDateTime startTime;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_time")
    private LocalDateTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private PageStatus status = PageStatus.Draft;

    /**
     * 添加一个页面区块
     * 这个方式是 JPA 中常见的双向关联的添加方式，我们会在集合添加子元素的同时，将子元素的父元素设置为当前元素
     *
     * @param pageBlockEntity
     */
    public void addPageBlock(PageBlockEntity pageBlockEntity) {
        pageBlocks.add(pageBlockEntity);
        pageBlockEntity.setPage(this);
    }

    /**
     * 删除一个页面区块
     * 这个方式是 JPA 中常见的双向关联的删除方式，我们会在集合删除子元素的同时，将子元素的父元素设置为 null
     *
     * @param pageBlockEntity
     */
    public void removePageBlock(PageBlockEntity pageBlockEntity) {
        pageBlocks.remove(pageBlockEntity);
        pageBlockEntity.setPage(null);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        PageEntity other = (PageEntity) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
