package com.mooc.backend.mapper;

import com.mooc.backend.domain.Page;
import com.mooc.backend.entities.blocks.PageConfig;
import org.junit.jupiter.api.Test;
import org.mybatis.spring.boot.test.autoconfigure.MybatisTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.*;

@TestPropertySource(locations = "classpath:application-test.properties")
@MybatisTest
public class PagesMapperTests {

    @Autowired
    private PageMapper pageMapper;

    @Test
    void testSelect() {
        var pages = pageMapper.selectByPrimaryKey(1L);
        assertEquals("首页布局", pages.getTitle());
    }

    @Test
    void testInsert() {
        var page = new Page();
        page.setPlatform("pc");
        page.setPageType("home");
        page.setConfig(PageConfig.builder()
                        .baselineScreenWidth(1920.0)
                        .horizontalPadding(12.0)
                        .verticalPadding(12.0)
                .build());
        page.setTitle("test001");
        page.setStatus("published");
        assertNull(page.getId());
        var result = pageMapper.insert(page);
        assertEquals(1, result);
        assertNotNull(page.getId());
        var pageSelected = pageMapper.selectByPrimaryKey(page.getId());
        assertEquals("test001", pageSelected.getTitle());
        assertNotNull(pageSelected.getCreatedAt());
        assertNotNull(pageSelected.getUpdatedAt());
    }
}
