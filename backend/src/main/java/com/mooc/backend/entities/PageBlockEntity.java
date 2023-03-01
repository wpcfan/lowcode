package com.mooc.backend.entities;

import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.SortComparator;
import org.hibernate.annotations.Type;

import java.util.*;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlockEntity implements Comparator<PageBlockEntity>, Comparable<PageBlockEntity> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "title", nullable = false)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private BlockType type;

    @Column(name = "sort", nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(name = "config", nullable = false, columnDefinition = "json")
    @ToString.Exclude
    private BlockConfig config;

    @ManyToOne
    @JoinColumn(name = "page_id")
    private PageEntity page;

    @SortComparator(PageBlockDataEntity.class)
    @OneToMany(mappedBy = "pageBlock", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @Builder.Default
    private SortedSet<PageBlockDataEntity> data = new TreeSet<>();

    public void addData(PageBlockDataEntity pageBlockDataEntity) {
        data.add(pageBlockDataEntity);
        pageBlockDataEntity.setPageBlock(this);
    }

    public void removeData(PageBlockDataEntity pageBlockDataEntity) {
        data.remove(pageBlockDataEntity);
        pageBlockDataEntity.setPageBlock(null);
    }

    public int compare(PageBlockEntity a, PageBlockEntity b) {
        return a.getSort() - b.getSort();
    }

    @Override
    public int compareTo(PageBlockEntity o) {
        return this.getSort() - o.getSort();
    }
}
