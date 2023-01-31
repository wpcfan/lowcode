package com.mooc.backend.repositories;

import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.TestPropertySource;

import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;

@TestPropertySource(locations="classpath:application-test.properties")
//@ActiveProfiles("test")
@DataJpaTest
public class ProductRepositoryTests {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private TestEntityManager testEntityManager;

    @Test
    public void testFindAll() {
        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(10000);
        testEntityManager.persist(product);
        testEntityManager.flush();

        var products = productRepository.findAll();

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(10000, products.get(0).getPrice());

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(10100);
        testEntityManager.persist(product2);
        testEntityManager.flush();

        products = productRepository.findAll();

        assertEquals(2, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(10000, products.get(0).getPrice());
        assertEquals("Test Product 2", products.get(1).getName());
        assertEquals("Test Description 2", products.get(1).getDescription());
        assertEquals(10100, products.get(1).getPrice());
    }

    @Test
    public void testFindByCategories_Id() {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);

        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(10000);
        product.getCategories().add(category);
        testEntityManager.persist(product);
        testEntityManager.flush();

        var products = productRepository.findByCategoriesId(category.getId());

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(10000, products.get(0).getPrice());
    }

    @Test
    public void testFindProductDTOsByCategoriesId() throws Exception {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);

        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(10000);
        product.getCategories().add(category);
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(10100);
        product2.getCategories().add(category);
        testEntityManager.persist(product2);
        testEntityManager.flush();

        var products = productRepository.findProductDTOsByCategoriesId(category.getId());

        assertEquals(2, products.size());
        assertEquals("Test Product", products.get(0).name());
        assertEquals("Test Description", products.get(0).description());
        assertEquals(10000, products.get(0).price());
        assertEquals("Test Product 2", products.get(1).name());
        assertEquals("Test Description 2", products.get(1).description());
        assertEquals(10100, products.get(1).price());

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Test Category 2");
        testEntityManager.persist(category2);
        product.getCategories().add(category2);
        testEntityManager.persist(product);
        testEntityManager.flush();

        products = productRepository.findProductDTOsByCategoriesId(category2.getId());

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).name());
        assertEquals("Test Description", products.get(0).description());
        assertEquals(10000, products.get(0).price());
    }

    @Test
    public void testFindByNameLikeOrderByIdDesc() throws Exception {
        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(10000);
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(10100);
        testEntityManager.persist(product2);

        var product3 = new Product();
        product3.setName("Another Product 3");
        product3.setDescription("Test Description 3");
        product3.setPrice(10100);
        testEntityManager.persist(product3);

        testEntityManager.flush();

        var products = productRepository.findByNameLikeOrderByIdDesc("%Test%");

        assertEquals(2, products.size());
        assertEquals("Test Product 2", products.get(0).getName());
        assertEquals("Test Description 2", products.get(0).getDescription());
        assertEquals(10100, products.get(0).getPrice());
        assertEquals("Test Product", products.get(1).getName());
        assertEquals("Test Description", products.get(1).getDescription());
        assertEquals(10000, products.get(1).getPrice());
    }

    @Test
    public void testStreamByNameLikeAndCategoriesCode() throws Exception {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);

        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(10000);
        product.getCategories().add(category);
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(10100);
        product2.getCategories().add(category);
        testEntityManager.persist(product2);

        var product3 = new Product();
        product3.setName("Another Product 3");
        product3.setDescription("Test Description 3");
        product3.setPrice(10100);
        product3.getCategories().add(category);
        testEntityManager.persist(product3);

        testEntityManager.flush();

        var products = productRepository.streamByNameLikeIgnoreCaseAndCategoriesCode("%test%", "cat_one").toList();

        assertEquals(2, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(10000, products.get(0).getPrice());
        assertEquals("Test Product 2", products.get(1).getName());
        assertEquals("Test Description 2", products.get(1).getDescription());
        assertEquals(10100, products.get(1).getPrice());
    }
}
