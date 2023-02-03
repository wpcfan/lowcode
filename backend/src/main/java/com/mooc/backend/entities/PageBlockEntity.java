package com.mooc.backend.entities;

import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Type;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlockEntity {
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

    @OneToMany(mappedBy = "pageBlock", cascade = CascadeType.REMOVE, orphanRemoval = true)
    @ToString.Exclude
    @Builder.Default
    private Set<PageBlockDataEntity> data = new HashSet<>();

    public void addData(PageBlockDataEntity pageBlockDataEntity) {
        data.add(pageBlockDataEntity);
        pageBlockDataEntity.setPageBlock(this);
    }
}
