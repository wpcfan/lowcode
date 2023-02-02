package com.mooc.backend.entities;

import com.mooc.backend.entities.blocks.PageBlock;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.Type;

import java.util.List;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
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

//    @Lob
    @Type(JsonType.class)
    @Column(name = "content", nullable = false, columnDefinition = "json")
    private List<PageBlock> content;

    @Type(JsonType.class)
    @Column(name = "config", nullable = false, columnDefinition = "json")
    private PageConfig config;
}
