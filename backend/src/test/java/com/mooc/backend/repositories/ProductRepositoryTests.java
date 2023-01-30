package com.mooc.backend.repositories;

import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import static org.hamcrest.MatcherAssert.assertThat;

//@TestPropertySource(locations="classpath:application-test.properties")
@ActiveProfiles("test")
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

        assertThat("There should be 1 product", products.size() == 1);
        assertThat("The product name should be 'Test Product'", products.get(0).getName().equals("Test Product"));
        assertThat("The product description should be 'Test Description'", products.get(0).getDescription().equals("Test Description"));
        assertThat("The product price should be 10000", products.get(0).getPrice() == 10000);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(10100);
        testEntityManager.persist(product2);
        testEntityManager.flush();

        products = productRepository.findAll();

        assertThat("There should be 2 products", products.size() == 2);
        assertThat("The product name should be 'Test Product'", products.get(0).getName().equals("Test Product"));
        assertThat("The product description should be 'Test Description'", products.get(0).getDescription().equals("Test Description"));
        assertThat("The product price should be 10000", products.get(0).getPrice() == 10000);
        assertThat("The product2 name should be 'Test Product 2'", products.get(1).getName().equals("Test Product 2"));
        assertThat("The product2 description should be 'Test Description 2'", products.get(1).getDescription().equals("Test Description 2"));
        assertThat("The product2 price should be 10100", products.get(1).getPrice() == 10100);
    }

    @Test
    public void findByCategories_Id() {
        var category = new Category();
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

        assertThat("There should be 1 product", products.size() == 1);
        assertThat("The product name should be 'Test Product'", products.get(0).getName().equals("Test Product"));
        assertThat("The product description should be 'Test Description'", products.get(0).getDescription().equals("Test Description"));
        assertThat("The product price should be 10000", products.get(0).getPrice() == 10000);

    }
}
