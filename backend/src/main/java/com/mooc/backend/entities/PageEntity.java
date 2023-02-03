package com.mooc.backend.entities;

import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
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
@Table(name = "mooc_pages")
public class PageEntity extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "platform", nullable = false)
    private Platform platform;

    @Enumerated(EnumType.STRING)
    @Column(name = "page_type", nullable = false)
    private PageType pageType;

    @OneToMany(mappedBy = "page", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @Builder.Default
    private Set<PageBlockEntity> pageBlocks = new HashSet<>();

    public void addPageBlock(PageBlockEntity pageBlockEntity) {
        pageBlocks.add(pageBlockEntity);
        pageBlockEntity.setPage(this);
    }

    @Type(JsonType.class)
    @Column(name = "config", nullable = false, columnDefinition = "json")
    private PageConfig config;
}
