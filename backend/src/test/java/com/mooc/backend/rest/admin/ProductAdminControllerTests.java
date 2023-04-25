package com.mooc.backend.rest.admin;

import com.mooc.backend.config.PageProperties;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.services.ProductAdminService;
import com.mooc.backend.services.ProductQueryService;
import com.mooc.backend.services.QiniuService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = ProductAdminController.class)
public class ProductAdminControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductQueryService productQueryService;

    @MockBean
    private ProductAdminService productAdminService;

    @MockBean
    private QiniuService qiniuService;

    @Test
    public void testFindPageableByExample() throws Exception {
        var category = new Category();
        category.setId(1L);
        category.setCode("cat_one");
        category.setName("Category 1");

        var product1 = new Product();
        product1.setId(1L);
        product1.setSku("sku_1");
        product1.setName("Product 1");
        product1.setDescription("Description 1");
        product1.setPrice(BigDecimal.valueOf(100000));
        product1.setCategories(Set.of(category));

        var product2 = new Product();
        product2.setId(2L);
        product2.setSku("sku_2");
        product2.setName("Product 2");
        product2.setDescription("Description 2");
        product2.setPrice(BigDecimal.valueOf(200000));
        product2.setCategories(Set.of(category));

        var pageSize = 10;
        var pageNumber = 0;
        var pageRequest = Pageable.ofSize(pageSize).withPage(pageNumber);

        var keyword = "test";
        var result = new PageImpl<>(List.of(product1, product2), pageRequest, 2);
        Mockito.when(productQueryService.findPageableByExample(Mockito.any(Example.class),
                        Mockito.any(Pageable.class)))
                .thenReturn(result);

        mockMvc.perform(get("/api/v1/admin/products/by-example?keyword={keyword}", keyword)
                        .accept("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.page", is(pageNumber)))
                .andExpect(jsonPath("$.size", is(pageSize)))
                .andExpect(jsonPath("$.totalSize", is(2)))
                .andExpect(jsonPath("$.totalPage", is(1)))
                .andExpect(jsonPath("$.items", hasSize(2)))
                .andExpect(jsonPath("$.items[0].id", is(1)))
                .andExpect(jsonPath("$.items[0].name", is("Product 1")))
                .andExpect(jsonPath("$.items[0].description", is("Description 1")))
                .andExpect(jsonPath("$.items[0].price", is("¥100,000.00")))
                .andExpect(jsonPath("$.items[0].categories", hasSize(1)))
                .andExpect(jsonPath("$.items[0].categories[0].code", is("cat_one")))
                .andExpect(jsonPath("$.items[0].categories[0].name", is("Category 1")))
                .andExpect(jsonPath("$.items[1].id", is(2)))
                .andExpect(jsonPath("$.items[1].name", is("Product 2")))
                .andExpect(jsonPath("$.items[1].description", is("Description 2")))
                .andExpect(jsonPath("$.items[1].price", is("¥200,000.00")))
                .andExpect(jsonPath("$.items[1].categories", hasSize(1)))
                .andExpect(jsonPath("$.items[1].categories[0].code", is("cat_one")))
                .andExpect(jsonPath("$.items[1].categories[0].name", is("Category 1")));
    }
}
