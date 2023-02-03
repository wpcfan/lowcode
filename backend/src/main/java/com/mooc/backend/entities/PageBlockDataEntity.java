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
public class PageBlockDataEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "sort", nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(name = "content", nullable = false, columnDefinition = "json")
    private BlockData content;

    @ManyToOne
    @JoinColumn(name = "page_block_id", nullable = false)
    private PageBlockEntity pageBlock;
}
