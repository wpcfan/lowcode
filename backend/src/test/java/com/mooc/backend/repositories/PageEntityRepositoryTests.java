package com.mooc.backend.repositories;

import com.mooc.backend.dtos.ProductDataDTO;
import com.mooc.backend.entities.PageBlockDataEntity;
import com.mooc.backend.entities.PageBlockEntity;
import com.mooc.backend.entities.PageEntity;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.entities.blocks.ImageDTO;
import com.mooc.backend.entities.blocks.Link;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.*;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
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
                .baselineScreenWidth(375.0)
                .horizontalPadding(16.0)
                .build();
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .build();
        var bannerImageData1 = new ImageDTO(bannerImage, "Test Image 1", linkBaidu);

        var bannerImageData2 = new ImageDTO(bannerImage, "Test Image 2", linkSina);
        var rowImageData1 = new ImageDTO(rowImage, "Test Image 1", linkBaidu);
        var rowImageData2 = new ImageDTO(rowImage, "Test Image 2", linkBaidu);
        var rowImageData3 = new ImageDTO(rowImage, "Test Image 3", linkBaidu);
        var bannerBlockData1 = PageBlockDataEntity.builder()
                .sort(1)
                .content(bannerImageData1)
                .build();
        testEntityManager.persist(bannerBlockData1);
        var bannerBlockData2 = PageBlockDataEntity.builder()
                .sort(2)
                .content(bannerImageData2)
                .build();
        testEntityManager.persist(bannerBlockData2);
        var pinnedHeader = PageBlockEntity.builder()
                .sort(1)
                .title("Test Pinned Header")
                .type(BlockType.Banner)
                .config(blockConfig)
                .build();
        pinnedHeader.addData(bannerBlockData1);
        pinnedHeader.addData(bannerBlockData2);
        testEntityManager.persist(pinnedHeader);

        var rowBlockData1 = PageBlockDataEntity.builder()
                .sort(1)
                .content(rowImageData1)
                .build();
        testEntityManager.persist(rowBlockData1);
        var rowBlockData2 = PageBlockDataEntity.builder()
                .sort(2)
                .content(rowImageData2)
                .build();
        testEntityManager.persist(rowBlockData2);
        var rowBlockData3 = PageBlockDataEntity.builder()
                .sort(3)
                .content(rowImageData3)
                .build();
        testEntityManager.persist(rowBlockData3);
        var imageRow = PageBlockEntity.builder()
                .sort(2)
                .title("Test Image Row")
                .type(BlockType.ImageRow)
                .config(blockConfig)
                .build();
        imageRow.addData(rowBlockData1);
        imageRow.addData(rowBlockData2);
        imageRow.addData(rowBlockData3);
        testEntityManager.persist(imageRow);

        var product = new Product();
        product.setSku("Test SKU");
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        testEntityManager.persist(product);

        var productBlockData1 = ProductDataDTO.fromEntity(product);
        var productBlockData2 = ProductDataDTO.fromEntity(product);
        var productData1 = PageBlockDataEntity.builder()
                .sort(1)
                .content(productBlockData1)
                .build();
        testEntityManager.persist(productData1);
        var productData2 = PageBlockDataEntity.builder()
                .sort(2)
                .content(productBlockData2)
                .build();
        testEntityManager.persist(productData2);
        var productRow = PageBlockEntity.builder()
                .sort(3)
                .title("Test Product Row")
                .type(BlockType.ProductRow)
                .config(blockConfig)
                .build();

        productRow.addData(productData1);
        productRow.addData(productData2);
        testEntityManager.persist(productRow);

        page1 = PageEntity.builder()
                .pageType(PageType.Home)
                .platform(Platform.App)
                .config(pageConfig)
                .title("Test Page 1")
                .build();

        page1.addPageBlock(pinnedHeader);
        page1.addPageBlock(imageRow);
        page1.addPageBlock(productRow);

        testEntityManager.persist(page1);

        page2 = PageEntity.builder()
                .pageType(PageType.Home)
                .platform(Platform.App)
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
                .platform(Platform.App)
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
                .platform(Platform.Web)
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
        assertEquals(Platform.App, pages.get(0).getPlatform());
        assertEquals(3, pages.get(0).getPageBlocks().size());
        assertEquals(2, pages.get(0).getPageBlocks().stream()
                .filter(block -> block.getType() == BlockType.Banner).findFirst().get().getData()
                .size());
        assertEquals(3, pages.get(0).getPageBlocks().stream()
                .filter(block -> block.getType() == BlockType.ImageRow).findFirst().get().getData()
                .size());
        assertEquals(2, pages.get(0).getPageBlocks().stream()
                .filter(block -> block.getType() == BlockType.ProductRow).findFirst().get().getData()
                .size());
    }

    @Test
    public void testFindPublishedPage() throws Exception {
        var page1 = testEntityManager.find(PageEntity.class, this.page1.getId());
        var now = LocalDateTime.now();
        page1.setStartTime(now.minusDays(1));
        page1.setEndTime(now.plusDays(1));
        page1.setStatus(PageStatus.Published);
        testEntityManager.persist(page1);

        var page2 = testEntityManager.find(PageEntity.class, this.page2.getId());
        page2.setStartTime(now.minusMinutes(59));
        page2.setEndTime(now.plusMinutes(59));
        page2.setStatus(PageStatus.Published);
        testEntityManager.persist(page2);

        testEntityManager.flush();

        // 从 JPA 返回 Stream 时，需要在事务中执行，而且使用 try-with-resource 语法
        try (var stream = pageEntityRepository.streamPublishedPage(now, Platform.App, PageType.Home)) {
            assertEquals(2, stream.count());
        }
        try (var stream = pageEntityRepository.streamPublishedPage(now, Platform.App, PageType.Home)) {
            assertEquals(1, stream
                    .peek(p -> System.out.println("Before filter: " + p.getId()))
                    .filter(p -> p.getEndTime().isAfter(now.plusHours(1)))
                    .peek(p -> System.out.println("After filter: " + p.getId()))
                    .count());
        }
    }

    @Test
    void testUpdatePageStatusToArchived() {
        var page1 = testEntityManager.find(PageEntity.class, this.page1.getId());
        var now = LocalDateTime.now();
        page1.setStartTime(now.minusDays(2));
        page1.setEndTime(now.minusDays(1));
        page1.setStatus(PageStatus.Published);
        testEntityManager.persist(page1);
        // 即使我们不加这一行，也会在下面的 updatePageStatusToDraft() 方法中自动 flush
        // 因为在 updatePageStatusToDraft() 方法中，我们使用了 @Modifying(flushAutomatically = true)
        testEntityManager.flush();

        var count = pageEntityRepository.updatePageStatusToArchived(now);
        assertEquals(1, count);

        // 在执行完上面的 updatePageStatusToDraft() 方法后，`PersistenceContext` 中的缓存会被清空
        // 大家可以尝试一下，如果不设置 `clearAutomatically = true`，那么下面的 `assertEquals` 会失败
        var result = pageEntityRepository.findById(this.page1.getId());
        assertEquals(PageStatus.Archived, result.get().getStatus());
    }

    @Test
    void testCountPublishedTimeConflict() throws Exception {
        var page1 = testEntityManager.find(PageEntity.class, this.page1.getId());
        var now = LocalDateTime.now();
        page1.setStartTime(now.minusDays(1));
        page1.setEndTime(now.plusDays(1));
        page1.setStatus(PageStatus.Published);
        testEntityManager.persist(page1);

        var page2 = testEntityManager.find(PageEntity.class, this.page2.getId());
        page2.setStartTime(now.minusMinutes(59));
        page2.setEndTime(now.plusMinutes(59));
        page2.setStatus(PageStatus.Draft);
        testEntityManager.persist(page2);

        testEntityManager.flush();

        var count = pageEntityRepository.countPublishedTimeConflict(now, Platform.App, PageType.Home);
        assertEquals(1, count);

        var count2 = pageEntityRepository.countPublishedTimeConflict(now, Platform.App, PageType.Category);
        assertEquals(0, count2);

        var count3 = pageEntityRepository.countPublishedTimeConflict(now, Platform.Web, PageType.Home);
        assertEquals(0, count3);
    }
}
