package com.mooc.backend.controllers.app;

import com.mooc.backend.dtos.CategoryProjectionDTO;
import com.mooc.backend.dtos.PageRecord;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.rest.app.ProductController;
import com.mooc.backend.services.ProductService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.domain.*;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Set;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@WebMvcTest(controllers = ProductController.class)
public class ProductControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductService productService;

    @Test
    public void testFindAllByCategory() throws Exception {
        var category = CategoryProjectionDTO.builder()
                .id(1L)
                .code("cat_one")
                .name("Category 1")
                .build();

        var product1 = ProductDTO.builder()
                .id(1L)
                .name("Product 1")
                .description("Description 1")
                .price(100000)
                .categories(Set.of(category))
                .build();
        var product2 = ProductDTO.builder()
                .id(2L)
                .name("Product 2")
                .description("Description 2")
                .price(200000)
                .categories(Set.of(category))
                .build();

        Mockito.when(productService.findPageableByCategory(1L))
                .thenReturn(List.of(product1, product2));

        mockMvc.perform(get("/api/v1/app/products/by-category/1").accept("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].id", is(1)))
                .andExpect(jsonPath("$[0].name", is("Product 1")))
                .andExpect(jsonPath("$[0].description", is("Description 1")))
                .andExpect(jsonPath("$[0].price", is(100000)))
                .andExpect(jsonPath("$[0].categories", hasSize(1)))
                .andExpect(jsonPath("$[0].categories[0].code", is("cat_one")))
                .andExpect(jsonPath("$[0].categories[0].name", is("Category 1")))
                .andExpect(jsonPath("$[1].id", is(2)))
                .andExpect(jsonPath("$[1].name", is("Product 2")))
                .andExpect(jsonPath("$[1].description", is("Description 2")))
                .andExpect(jsonPath("$[1].price", is(200000)))
                .andExpect(jsonPath("$[1].categories", hasSize(1)))
                .andExpect(jsonPath("$[1].categories[0].code", is("cat_one")))
                .andExpect(jsonPath("$[1].categories[0].name", is("Category 1"))
        );
    }

    @Test
    public void testFindPageableByExample() throws Exception {
        var category = CategoryProjectionDTO.builder()
                .id(1L)
                .code("cat_one")
                .name("Category 1")
                .build();

        var product1 = ProductDTO.builder()
                .id(1L)
                .name("Product 1")
                .description("Description 1")
                .price(100000)
                .categories(Set.of(category))
                .build();
        var product2 = ProductDTO.builder()
                .id(2L)
                .name("Product 2")
                .description("Description 2")
                .price(200000)
                .categories(Set.of(category))
                .build();

        var pageSize = 20;
        var pageNumber = 0;
        var pageRequest = Pageable.ofSize(pageSize).withPage(pageNumber);

        var keyword = "test";
        var result = new PageImpl<>(List.of(product1, product2), pageRequest, 2);
        Mockito.when(productService.findPageableByExample(Mockito.any(Example.class), Mockito.any(Pageable.class)))
                .thenReturn(result);

        mockMvc.perform(get("/api/v1/app/products/by-example?keyword=" + keyword).accept("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.page", is(pageNumber)))
                .andExpect(jsonPath("$.size", is(pageSize)))
                .andExpect(jsonPath("$.totalSize", is(2)))
                .andExpect(jsonPath("$.totalPage", is(1)))
                .andExpect(jsonPath("$.data", hasSize(2)))
                .andExpect(jsonPath("$.data[0].id", is(1)))
                .andExpect(jsonPath("$.data[0].name", is("Product 1")))
                .andExpect(jsonPath("$.data[0].description", is("Description 1")))
                .andExpect(jsonPath("$.data[0].price", is(100000)))
                .andExpect(jsonPath("$.data[0].categories", hasSize(1)))
                .andExpect(jsonPath("$.data[0].categories[0].code", is("cat_one")))
                .andExpect(jsonPath("$.data[0].categories[0].name", is("Category 1")))
                .andExpect(jsonPath("$.data[1].id", is(2)))
                .andExpect(jsonPath("$.data[1].name", is("Product 2")))
                .andExpect(jsonPath("$.data[1].description", is("Description 2")))
                .andExpect(jsonPath("$.data[1].price", is(200000)))
                .andExpect(jsonPath("$.data[1].categories", hasSize(1)))
                .andExpect(jsonPath("$.data[1].categories[0].code", is("cat_one")))
                .andExpect(jsonPath("$.data[1].categories[0].name", is("Category 1"))
        );
    }
}
