package com.mooc.backend.mapper;

import org.junit.jupiter.api.Test;
import org.mybatis.spring.boot.test.autoconfigure.MybatisTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.assertEquals;

@TestPropertySource(locations = "classpath:application-test.properties")
@MybatisTest
public class PagesMapperTests {

    @Autowired
    private PagesMapper pagesMapper;

    @Test
    void testSelect() {
        var pages = pagesMapper.selectByPrimaryKey(1L);
        assertEquals("首页布局", pages.getTitle());
    }
}
