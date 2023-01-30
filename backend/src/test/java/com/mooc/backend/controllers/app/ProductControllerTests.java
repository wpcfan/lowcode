package com.mooc.backend.controllers.app;

import com.mooc.backend.dtos.CategoryDTO;
import com.mooc.backend.dtos.ProductDTO;
import com.mooc.backend.services.ProductService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@TestPropertySource(locations="classpath:application-test.properties")
@WebMvcTest
public class ProductControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductService productService;

    @Test
    public void testFindAllByCategory() throws Exception {
        var category = new CategoryDTO(1L, "Category 1");

        var product1 = new ProductDTO(1L, "Product 1", "Description 1", 100000, Set.of(category), new HashSet<>());
        var product2 = new ProductDTO(2L, "Product 2", "Description 2", 200000, Set.of(category), new HashSet<>());

        Mockito.when(productService.findAllByCategory(1L))
                .thenReturn(List.of(product1, product2));

        mockMvc.perform(get("/api/v1/app/products/by-category/1").accept("application/json"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].id", is(1)))
                .andExpect(jsonPath("$[0].name", is("Product 1")))
                .andExpect(jsonPath("$[0].description", is("Description 1")))
                .andExpect(jsonPath("$[0].price", is(100000)))
                .andExpect(jsonPath("$[0].categories", hasSize(1)))
                .andExpect(jsonPath("$[0].categories[0].id", is(1)))
                .andExpect(jsonPath("$[0].categories[0].name", is("Category 1")))
                .andExpect(jsonPath("$[1].id", is(2)))
                .andExpect(jsonPath("$[1].name", is("Product 2")))
                .andExpect(jsonPath("$[1].description", is("Description 2")))
                .andExpect(jsonPath("$[1].price", is(200000)))
                .andExpect(jsonPath("$[1].categories", hasSize(1)))
                .andExpect(jsonPath("$[1].categories[0].id", is(1)))
                .andExpect(jsonPath("$[1].categories[0].name", is("Category 1"))
        );
    }
}
