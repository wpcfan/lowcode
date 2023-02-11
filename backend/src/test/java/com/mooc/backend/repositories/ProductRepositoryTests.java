package com.mooc.backend.repositories;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.test.context.TestPropertySource;

import com.mooc.backend.entities.Category;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;

@TestPropertySource(locations = "classpath:application-test.properties")
// @ActiveProfiles("test")
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
        product.setPrice(BigDecimal.valueOf(10000));
        testEntityManager.persist(product);
        testEntityManager.flush();

        var products = productRepository.findAll();

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10000), products.get(0).getPrice());

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        testEntityManager.persist(product2);
        testEntityManager.flush();

        products = productRepository.findAll();

        assertEquals(2, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10000), products.get(0).getPrice());
        assertEquals("Test Product 2", products.get(1).getName());
        assertEquals("Test Description 2", products.get(1).getDescription());
        assertEquals(BigDecimal.valueOf(10100), products.get(1).getPrice());
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
        product.setPrice(BigDecimal.valueOf(10000));
        product.getCategories().add(category);
        testEntityManager.persist(product);
        testEntityManager.flush();

        var products = productRepository.findByCategoriesId(category.getId());

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10000), products.get(0).getPrice());
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
        product.setPrice(BigDecimal.valueOf(10000));
        product.getCategories().add(category);
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        product2.getCategories().add(category);
        testEntityManager.persist(product2);
        testEntityManager.flush();

        var products = productRepository.findProductDTOsByCategoriesId(category.getId());

        assertEquals(2, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10000).setScale(2), products.get(0).getPrice());
        assertEquals("Test Product 2", products.get(1).getName());
        assertEquals("Test Description 2", products.get(1).getDescription());
        assertEquals(BigDecimal.valueOf(10100).setScale(2), products.get(1).getPrice());

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Test Category 2");
        testEntityManager.persist(category2);
        product.getCategories().add(category2);
        testEntityManager.persist(product);
        testEntityManager.flush();

        products = productRepository.findProductDTOsByCategoriesId(category2.getId());

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10000).setScale(2), products.get(0).getPrice());
    }

    @Test
    public void testFindByNameLikeOrderByIdDesc() throws Exception {
        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        testEntityManager.persist(product2);

        var product3 = new Product();
        product3.setName("Another Product 3");
        product3.setDescription("Test Description 3");
        product3.setPrice(BigDecimal.valueOf(10200));
        testEntityManager.persist(product3);

        testEntityManager.flush();

        var products = productRepository.findByNameLikeOrderByIdDesc("%Test%");

        assertEquals(2, products.size());
        assertEquals("Test Product 2", products.get(0).getName());
        assertEquals("Test Description 2", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10100), products.get(0).getPrice());
        assertEquals("Test Product", products.get(1).getName());
        assertEquals("Test Description", products.get(1).getDescription());
        assertEquals(BigDecimal.valueOf(10000), products.get(1).getPrice());
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
        product.setPrice(BigDecimal.valueOf(10000));
        product.getCategories().add(category);
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        product2.getCategories().add(category);
        testEntityManager.persist(product2);

        var product3 = new Product();
        product3.setName("Another Product 3");
        product3.setDescription("Test Description 3");
        product3.setPrice(BigDecimal.valueOf(10200));
        product3.getCategories().add(category);
        testEntityManager.persist(product3);

        testEntityManager.flush();

        try (var stream = productRepository.streamByNameLikeIgnoreCaseAndCategoriesCode("%test%", "cat_one")) {
            var products = stream.toList();
            assertEquals(2, products.size());
            assertEquals("Test Product", products.get(0).getName());
            assertEquals("Test Description", products.get(0).getDescription());
            assertEquals(BigDecimal.valueOf(10000), products.get(0).getPrice());
            assertEquals("Test Product 2", products.get(1).getName());
            assertEquals("Test Description 2", products.get(1).getDescription());
            assertEquals(BigDecimal.valueOf(10100), products.get(1).getPrice());
        }
    }

    @Test
    public void testQueryByExample() throws Exception {

        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        // 在没有指定 CascadeType 的情况下，需要手动保存关联对象
        testEntityManager.persist(category);

        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        product.addCategory(category);
        testEntityManager.persist(product);

        var product2 = new Product();
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        product2.getCategories().add(category);
        testEntityManager.persist(product2);

        testEntityManager.flush();

        Product productQuery = new Product();
        productQuery.setName("Test");
        Category categoryQuery = new Category();
        categoryQuery.setName("Test");
        productQuery.getCategories().add(categoryQuery);

        ExampleMatcher matcher = ExampleMatcher.matching()
                .withIgnoreCase("name")
                .withMatcher("name", ExampleMatcher.GenericPropertyMatchers.startsWith())
                .withMatcher("categories.name", ExampleMatcher.GenericPropertyMatchers.contains());

        Example<Product> example = Example.of(productQuery, matcher);

        var products = productRepository.findAll(example);

        assertEquals(2, products.size());
    }

    @Test
    public void testProductAndProductImage() throws Exception {
        var imageUrl = "https://via.placeholder.com/150";
        var productImage = new ProductImage();

        productImage.setImageUrl(imageUrl);

        var product = new Product();
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        product.addImage(productImage);
        testEntityManager.persist(product);

        testEntityManager.flush();

        var matched = productRepository.findById(product.getId());

        assertEquals("Test Product", matched.get().getName());
        assertEquals("Test Description", matched.get().getDescription());
        assertEquals(BigDecimal.valueOf(10000), matched.get().getPrice());
        assertTrue(matched.get().getImages().stream().anyMatch(image -> image.getImageUrl().equals(imageUrl)));
    }
}
