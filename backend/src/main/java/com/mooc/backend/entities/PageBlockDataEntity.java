package com.mooc.backend.entities;

import com.mooc.backend.entities.blocks.BlockData;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Type;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_page_block_data")
public class PageBlockDataEntity implements Comparable<PageBlockDataEntity> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    private BlockData content;

    @ManyToOne
    @JoinColumn(name = "page_block_id")
    private PageBlockEntity pageBlock;

    @Override
    public int compareTo(PageBlockDataEntity o) {
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
        PageBlockDataEntity other = (PageBlockDataEntity) obj;
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
