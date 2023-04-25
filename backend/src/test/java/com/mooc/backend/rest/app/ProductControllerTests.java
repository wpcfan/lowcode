package com.mooc.backend.rest.app;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import com.mooc.backend.config.PageProperties;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.services.ProductQueryService;

@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = ProductController.class)
public class ProductControllerTests {

        @Autowired
        private MockMvc mockMvc;

        @MockBean
        private ProductQueryService productQueryService;

        @Test
        public void testFindAllByCategory() throws Exception {
                var category = new Category();
                category.setId(1L);
                category.setCode("cat_one");
                category.setName("Category 1");

                var product1 = new Product();
                product1.setId(1L);
                product1.setName("Product 1");
                product1.setDescription("Description 1");
                product1.setPrice(BigDecimal.valueOf(100000));
                product1.setCategories(Set.of(category));

                var product2 = new Product();
                product2.setId(2L);
                product2.setName("Product 2");
                product2.setDescription("Description 2");
                product2.setPrice(BigDecimal.valueOf(200000));
                product2.setCategories(Set.of(category));

                Mockito.when(productQueryService.findPageableByCategory(1L))
                                .thenReturn(List.of(product1, product2));

                mockMvc.perform(get("/api/v1/app/products/by-category/{id}", 1).accept("application/json"))
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$", hasSize(2)))
                                .andExpect(jsonPath("$[0].id", is(1)))
                                .andExpect(jsonPath("$[0].name", is("Product 1")))
                                .andExpect(jsonPath("$[0].description", is("Description 1")))
                                .andExpect(jsonPath("$[0].price", is("¥100,000.00")))
                                .andExpect(jsonPath("$[0].categories", hasSize(1)))
                                .andExpect(jsonPath("$[0].categories[0].code", is("cat_one")))
                                .andExpect(jsonPath("$[0].categories[0].name", is("Category 1")))
                                .andExpect(jsonPath("$[1].id", is(2)))
                                .andExpect(jsonPath("$[1].name", is("Product 2")))
                                .andExpect(jsonPath("$[1].description", is("Description 2")))
                                .andExpect(jsonPath("$[1].price", is("¥200,000.00")))
                                .andExpect(jsonPath("$[1].categories", hasSize(1)))
                                .andExpect(jsonPath("$[1].categories[0].code", is("cat_one")))
                                .andExpect(jsonPath("$[1].categories[0].name", is("Category 1")));
        }


}
