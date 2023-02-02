package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.entities.blocks.ImageData;
import com.mooc.backend.entities.blocks.ImageRowPageBlock;
import com.mooc.backend.entities.blocks.Link;
import com.mooc.backend.entities.blocks.PinnedHeaderPageBlock;
import com.mooc.backend.enumerations.LinkType;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ActiveProfiles("test")
@DataJpaTest
public class PageEntityRepositoryTests {

    @Autowired
    private PageEntityRepository pageEntityRepository;
    @Autowired
    private TestEntityManager testEntityManager;

    @Test
    public void testFindAll() {
        var page = new PageEntity();
        var linkBaidu = Link.builder()
                .type(LinkType.Url)
                .value("https://www.baidu.com")
                .build();
        var linkSina = Link.builder()
                .type(LinkType.Url)
                .value("https://www.sina.com.cn")
                .build();
        var bannerImage = "https://via.placeholder.com/400/50";
        var rowImage = "https://via.placeholder.com/120/50";
        var pinnedHeader = PinnedHeaderPageBlock.builder()
                .id(UUID.randomUUID().toString())
                .sort(1)
                .title("Test Pinned Header")
                .data(List.of(
                        ImageData.builder()
                                .title("Test Image 1")
                                .sort(1)
                                .image(bannerImage)
                                .link(linkBaidu)
                                .build(),
                        ImageData.builder()
                                .title("Test Image 2")
                                .sort(2)
                                .image(bannerImage)
                                .link(linkSina)
                                .build()
                ))
                .build();
        var imageRow = ImageRowPageBlock.builder()
                        .title("Test Image Row")
                        .sort(2)
                        .data(List.of(
                                ImageData.builder()
                                        .title("Test Image 1")
                                        .sort(1)
                                        .image(rowImage)
                                        .link(linkBaidu)
                                        .build(),
                                ImageData.builder()
                                        .title("Test Image 2")
                                        .sort(2)
                                        .image(rowImage)
                                        .link(linkBaidu)
                                        .build(),
                                ImageData.builder()
                                        .title("Test Image 3")
                                        .sort(3)
                                        .image(rowImage)
                                        .link(linkBaidu)
                                        .build()
                        ))
                .build();
        page.setPageType(PageType.Home);
        page.setPlatform(Platform.Android);
        page.setContent(List.of(
                pinnedHeader,
                imageRow
        ));
        testEntityManager.persist(page);
        testEntityManager.flush();

        var pages = pageEntityRepository.findAll();

        assertEquals(1, pages.size());
        assertEquals(2, pages.get(0).getContent().size());

    }
}
