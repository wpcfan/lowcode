package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.blocks.*;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.LinkType;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ActiveProfiles("test")
@DataJpaTest
public class PageBlockRepositoryTests {
    @Autowired
    private PageBlockRepository pageBlockRepository;
    @Autowired
    private TestEntityManager entityManager;

    private PageLayout page1;

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
        var bannerBlockData1 = PageBlockData.builder()
                .sort(1)
                .content(bannerImageData1)
                .build();
        entityManager.persist(bannerBlockData1);
        var bannerBlockData2 = PageBlockData.builder()
                .sort(2)
                .content(bannerImageData2)
                .build();
        entityManager.persist(bannerBlockData2);
        var pinnedHeader = PageBlock.builder()
                .sort(1)
                .title("Test Pinned Header")
                .type(BlockType.Banner)
                .config(blockConfig)
                .build();
        pinnedHeader.addData(bannerBlockData1);
        pinnedHeader.addData(bannerBlockData2);
        entityManager.persist(pinnedHeader);

        var rowBlockData1 = PageBlockData.builder()
                .sort(1)
                .content(rowImageData1)
                .build();
        entityManager.persist(rowBlockData1);
        var rowBlockData2 = PageBlockData.builder()
                .sort(2)
                .content(rowImageData2)
                .build();
        entityManager.persist(rowBlockData2);
        var rowBlockData3 = PageBlockData.builder()
                .sort(3)
                .content(rowImageData3)
                .build();
        entityManager.persist(rowBlockData3);
        var imageRow = PageBlock.builder()
                .sort(2)
                .title("Test Image Row")
                .type(BlockType.ImageRow)
                .config(blockConfig)
                .build();
        imageRow.addData(rowBlockData1);
        imageRow.addData(rowBlockData2);
        imageRow.addData(rowBlockData3);
        entityManager.persist(imageRow);

        var product = new Product();
        product.setSku("Test SKU");
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        entityManager.persist(product);

        var productBlockData1 = ProductDataDTO.fromEntity(product);
        var productBlockData2 = ProductDataDTO.fromEntity(product);
        var productData1 = PageBlockData.builder()
                .sort(1)
                .content(productBlockData1)
                .build();
        entityManager.persist(productData1);
        var productData2 = PageBlockData.builder()
                .sort(2)
                .content(productBlockData2)
                .build();
        entityManager.persist(productData2);
        var productRow = PageBlock.builder()
                .sort(3)
                .title("Test Product Row")
                .type(BlockType.ProductRow)
                .config(blockConfig)
                .build();

        productRow.addData(productData1);
        productRow.addData(productData2);
        entityManager.persist(productRow);

        page1 = PageLayout.builder()
                .pageType(PageType.Home)
                .platform(Platform.App)
                .config(pageConfig)
                .title("Test Page 1")
                .build();

        page1.addPageBlock(pinnedHeader);
        page1.addPageBlock(imageRow);
        page1.addPageBlock(productRow);

        entityManager.persist(page1);
        entityManager.flush();
    }

    @AfterEach
    void afterEach() {
        entityManager.clear();
    }

    @Test
    public void updateSortByPageIdAndSortGreaterThanEqual_whenPageIdNotFound_thenThrowException() {
        // 准备测试数据
        Long pageId = page1.getId();
        Integer newSort = 2;

        // 执行测试
        pageBlockRepository.updateSortByPageIdAndSortGreaterThanEqual(pageId, newSort);

        // 断言结果
        var page = entityManager.find(PageLayout.class, pageId);
        var blocks = page.getPageBlocks();
        assertEquals(3, blocks.size());
        assertEquals(2, blocks.stream().filter(b -> b.getSort() == 1).count());
    }
}
