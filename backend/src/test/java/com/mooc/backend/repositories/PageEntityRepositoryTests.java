package com.mooc.backend.repositories;

import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.entities.*;
import com.mooc.backend.entities.blocks.BlockConfig;
import com.mooc.backend.entities.blocks.ImageData;
import com.mooc.backend.entities.blocks.Link;
import com.mooc.backend.entities.blocks.ProductData;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.LinkType;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

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

        var page = PageEntity.builder()
                .pageType(PageType.Home)
                .platform(Platform.Android)
                .config(pageConfig)
                .build();

        page.addPageBlock(pinnedHeader);
        page.addPageBlock(imageRow);
        page.addPageBlock(productRow);

        testEntityManager.persist(page);
        testEntityManager.flush();

        var pages = pageEntityRepository.findAll();

        assertEquals(1, pages.size());
        assertEquals(PageType.Home, pages.get(0).getPageType());
        assertEquals(Platform.Android, pages.get(0).getPlatform());
        assertEquals(3, pages.get(0).getPageBlocks().size());
        assertEquals(2, pages.get(0).getPageBlocks().stream().filter(block -> block.getType() == BlockType.PinnedHeader).findFirst().get().getData().size());
        assertEquals(3, pages.get(0).getPageBlocks().stream().filter(block -> block.getType() == BlockType.ImageRow).findFirst().get().getData().size());
        assertEquals(2, pages.get(0).getPageBlocks().stream().filter(block -> block.getType() == BlockType.ProductRow).findFirst().get().getData().size());
    }
}
