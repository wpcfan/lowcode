package com.mooc.backend.repositories;

import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.entities.*;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.entities.blocks.ImageData;
import com.mooc.backend.entities.blocks.Link;
import com.mooc.backend.entities.blocks.ProductData;
import com.mooc.backend.enumerations.*;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ActiveProfiles("test")
@DataJpaTest
public class PageEntityRepositoryTests {

    @Autowired
    private PageEntityRepository pageEntityRepository;
    @Autowired
    private TestEntityManager testEntityManager;

    private PageEntity page1;
    private PageEntity page2;
    private PageEntity page3;
    private PageEntity page4;

    @BeforeEach
    void beforeEach() {
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
        var pageConfig = PageConfig.builder()
                .baselineScreenWidth(375)
                .baselineScreenHeight(667)
                .horizontalPadding(16)
                .horizontalSpacing(12)
                .verticalSpacing(8)
                .build();
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12)
                .verticalPadding(8)
                .horizontalSpacing(8)
                .verticalSpacing(8)
                .build();
        var bannerImageData1 = ImageData.builder()
                .title("Test Image 1")
                .sort(1)
                .image(bannerImage)
                .link(linkBaidu)
                .build();
        var bannerImageData2 = ImageData.builder()
                .title("Test Image 2")
                .sort(2)
                .image(bannerImage)
                .link(linkSina)
                .build();
        var rowImageData1 = ImageData.builder()
                .title("Test Image 1")
                .sort(1)
                .image(rowImage)
                .link(linkBaidu)
                .build();
        var rowImageData2 = ImageData.builder()
                .title("Test Image 2")
                .sort(2)
                .image(rowImage)
                .link(linkBaidu)
                .build();
        var rowImageData3 = ImageData.builder()
                .title("Test Image 3")
                .sort(3)
                .image(rowImage)
                .link(linkBaidu)
                .build();

        var bannerBlockData1 = PageBlockDataEntity.builder()
                .sort(1)
                .content(bannerImageData1)
                .build();

        var bannerBlockData2 = PageBlockDataEntity.builder()
                .sort(2)
                .content(bannerImageData2)
                .build();

        var pinnedHeader = PageBlockEntity.builder()
                .sort(1)
                .title("Test Pinned Header")
                .type(BlockType.PinnedHeader)
                .config(blockConfig)
                .build();
        pinnedHeader.addData(bannerBlockData1);
        pinnedHeader.addData(bannerBlockData2);

        var rowBlockData1 = PageBlockDataEntity.builder()
                .sort(1)
                .content(rowImageData1)
                .build();

        var rowBlockData2 = PageBlockDataEntity.builder()
                .sort(2)
                .content(rowImageData2)
                .build();

        var rowBlockData3 = PageBlockDataEntity.builder()
                .sort(3)
                .content(rowImageData3)
                .build();

        var imageRow = PageBlockEntity.builder()
                .sort(2)
                .title("Test Image Row")
                .type(BlockType.ImageRow)
                .config(blockConfig)
                .build();
        imageRow.addData(rowBlockData1);
        imageRow.addData(rowBlockData2);
        imageRow.addData(rowBlockData3);

        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(10000);
        testEntityManager.persist(product);

        var productBlockData1 = ProductData.builder()
                .sort(1)
                .product(ProductDTO.fromEntity(product))
                .build();
        var productBlockData2 = ProductData.builder()
                .sort(2)
                .product(ProductDTO.fromEntity(product))
                .build();
        var productData1 = PageBlockDataEntity.builder()
                .sort(1)
                .content(productBlockData1)
                .build();
        var productData2 = PageBlockDataEntity.builder()
                .sort(2)
                .content(productBlockData2)
                .build();

        var productRow = PageBlockEntity.builder()
                .sort(3)
                .title("Test Product Row")
                .type(BlockType.ProductRow)
                .config(blockConfig)
                .build();

        productRow.addData(productData1);
        productRow.addData(productData2);

        page1 = PageEntity.builder()
                .pageType(PageType.Home)
                .platform(Platform.Android)
                .config(pageConfig)
                .title("Test Page 1")
                .build();

        page1.addPageBlock(pinnedHeader);
        page1.addPageBlock(imageRow);
        page1.addPageBlock(productRow);

        testEntityManager.persist(page1);

        page2 = PageEntity.builder()
                .pageType(PageType.Home)
                .platform(Platform.Android)
                .config(pageConfig)
                .title("Test Page 2")
                .build();

        page2.addPageBlock(pinnedHeader);
        page2.addPageBlock(imageRow);
        page2.addPageBlock(imageRow);
        page2.addPageBlock(productRow);
        page2.addPageBlock(productRow);

        testEntityManager.persist(page2);

        page3 = PageEntity.builder()
                .pageType(PageType.Category)
                .platform(Platform.Android)
                .config(pageConfig)
                .title("Test Page 3")
                .build();

        page3.addPageBlock(pinnedHeader);
        page3.addPageBlock(imageRow);
        page3.addPageBlock(imageRow);
        page3.addPageBlock(productRow);
        page3.addPageBlock(productRow);

        testEntityManager.persist(page3);

        page4 = PageEntity.builder()
                .pageType(PageType.Category)
                .platform(Platform.iOS)
                .config(pageConfig)
                .title("Test Page 4")
                .build();

        page4.addPageBlock(imageRow);
        page4.addPageBlock(productRow);
        page4.addPageBlock(imageRow);
        page4.addPageBlock(productRow);

        testEntityManager.persist(page4);
        testEntityManager.flush();
    }

    @AfterEach
    void afterEach() {
        testEntityManager.clear();
    }

    @Test
    public void testFindAll() {
        var pages = pageEntityRepository.findAll();

        assertEquals(4, pages.size());
        assertEquals(PageType.Home, pages.get(0).getPageType());
        assertEquals(Platform.Android, pages.get(0).getPlatform());
        assertEquals(3, pages.get(0).getPageBlocks().size());
        assertEquals(2, pages.get(0).getPageBlocks().stream().filter(block -> block.getType() == BlockType.PinnedHeader).findFirst().get().getData().size());
        assertEquals(3, pages.get(0).getPageBlocks().stream().filter(block -> block.getType() == BlockType.ImageRow).findFirst().get().getData().size());
        assertEquals(2, pages.get(0).getPageBlocks().stream().filter(block -> block.getType() == BlockType.ProductRow).findFirst().get().getData().size());
    }

    @Test
    public void testFindPublishedPage() throws Exception {
        var page1 = testEntityManager.find(PageEntity.class, this.page1.getId());
        var now = LocalDateTime.now();
        page1.setStartTime(now.minusDays(1));
        page1.setEndTime(now.plusDays(1));
        page1.setStatus(PageStatus.Published);
        testEntityManager.persist(page1);

        var page2= testEntityManager.find(PageEntity.class, this.page2.getId());
        page2.setStartTime(now.minusMinutes(59));
        page2.setEndTime(now.plusMinutes(59));
        page2.setStatus(PageStatus.Published);
        testEntityManager.persist(page2);

        testEntityManager.flush();

        // 从 JPA 返回 Stream 时，需要在事务中执行，而且使用 try-with-resource 语法
        try (var stream = pageEntityRepository.streamPublishedPage(now, Platform.Android, PageType.Home)) {
            assertEquals(2, stream.count());
        }
        try (var stream = pageEntityRepository.streamPublishedPage(now, Platform.Android, PageType.Home)) {
            assertEquals(1, stream
                    .peek(p -> System.out.println("Before filter: " + p.getId()))
                    .filter(p -> p.getEndTime().isAfter(now.plusHours(1)))
                    .peek(p -> System.out.println("After filter: " + p.getId()))
                    .count());
        }
    }

    @Test
    void testUpdatePageStatusToDraft() {
        var page1 = testEntityManager.find(PageEntity.class, this.page1.getId());
        var now = LocalDateTime.now();
        page1.setStartTime(now.minusDays(1));
        page1.setEndTime(now.plusDays(1));
        page1.setStatus(PageStatus.Published);
        testEntityManager.persist(page1);
        // 即使我们不加这一行，也会在下面的 updatePageStatusToDraft() 方法中自动 flush
        // 因为在 updatePageStatusToDraft() 方法中，我们使用了 @Modifying(flushAutomatically = true)
        testEntityManager.flush();

        var count = pageEntityRepository.updatePageStatusToDraft(now, Platform.Android, PageType.Home);
        assertEquals(1, count);

        // 在执行完上面的 updatePageStatusToDraft() 方法后，`PersistenceContext` 中的缓存会被清空
        // 大家可以尝试一下，如果不设置 `clearAutomatically = true`，那么下面的 `assertEquals` 会失败
        var result = pageEntityRepository.findById(this.page1.getId());
        assertEquals(PageStatus.Draft, result.get().getStatus());
    }
}
