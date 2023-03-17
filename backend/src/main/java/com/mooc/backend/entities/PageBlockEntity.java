package com.mooc.backend.entities;

import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Type;

import java.util.SortedSet;
import java.util.TreeSet;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlockEntity implements Comparable<PageBlockEntity> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BlockType type;

    @Column(nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    @ToString.Exclude
    private BlockConfig config;

    @ManyToOne
    @JoinColumn(name = "page_id")
    private PageEntity page;

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

    @Override
    public int compareTo(PageBlockEntity o) {
        return this.getSort() - o.getSort();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        PageBlockEntity other = (PageBlockEntity) obj;
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
