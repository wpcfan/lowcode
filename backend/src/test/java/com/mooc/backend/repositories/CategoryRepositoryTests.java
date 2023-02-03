package com.mooc.backend.repositories;

import com.mooc.backend.entities.Category;
import com.mooc.backend.specifications.CategorySpecification;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.SqlGroup;
import org.testcontainers.containers.MySQLContainer;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ActiveProfiles("test")
@TestPropertySource(properties = {
        "spring.jpa.hibernate.ddl-auto=none",
        "spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL5Dialect",
        "spring.datasource.url=jdbc:mysql://localhost:3306/low_code?useUnicode=true&characterEncoding=utf-8&useSSL=false",
        "spring.datasource.username=user",
        "spring.datasource.password=password",
        "spring.datasource.driver-class-name=com.mysql.jdbc.Driver",
})
@SqlGroup(
        {
                @Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD, scripts = "classpath:sql/create_schema.sql"),
                @Sql(executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD, scripts = "classpath:sql/drop_schema.sql")
        }
)
@DataJpaTest
public class CategoryRepositoryTests {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private TestEntityManager testEntityManager;

    private static final MySQLContainer<?> mySQLContainer = new MySQLContainer<>("mysql:5.7")
            .withDatabaseName("low_code")
            .withUsername("user")
            .withPassword("password");

    @BeforeAll
    static void beforeAll() {
        mySQLContainer.start();
    }

    @AfterAll
    static void afterAll() {
        mySQLContainer.stop();
    }

    @Test
    public void testFindAll() {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);
        testEntityManager.flush();

        List<Category> categories = categoryRepository.findAll();

        assertEquals(1, categories.size());
        assertEquals("cat_one", categories.get(0).getCode());
        assertEquals("Test Category", categories.get(0).getName());

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Test Category 2");
        testEntityManager.persist(category2);
        testEntityManager.flush();

        categories = categoryRepository.findAll();

        assertEquals(2, categories.size());
        assertEquals("cat_one", categories.get(0).getCode());
        assertEquals("Test Category", categories.get(0).getName());
        assertEquals("cat_two", categories.get(1).getCode());
        assertEquals("Test Category 2", categories.get(1).getName());
    }

    @Test
    public void testFindByCode() throws Exception {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Test Category 2");
        testEntityManager.persist(category2);

        var category3 = new Category();
        category3.setCode("cat_three");
        category3.setName("Test Category 3");
        testEntityManager.persist(category3);

        var category4 = new Category();
        category4.setCode("cat_four");
        category4.setName("Test Category 4");
        testEntityManager.persist(category4);
        testEntityManager.flush();

        var categoryFromDb = categoryRepository.findByCode("cat_one");
        assertTrue(categoryFromDb.isPresent());
        assertEquals("cat_one", categoryFromDb.get().getCode());
        assertEquals("Test Category", categoryFromDb.get().getName());

        var notFound = categoryRepository.findByCode("none");
        assertTrue(notFound.isEmpty());
    }

    @Test
    public void testFindRoots() throws Exception {
        // 如果不指定级联方式的情况下，我们需要手动处理，要非常小心保存顺序
        // 原则是先保存
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Test Category 2");
        category2.setParent(category);
        testEntityManager.persist(category2);
        category.getChildren().add(category2);

        var category3 = new Category();
        category3.setCode("cat_three");
        category3.setName("Test Category 3");
        category3.setParent(category);
        testEntityManager.persist(category3);
        category.getChildren().add(category3);

        var category4 = new Category();
        category4.setCode("cat_four");
        category4.setName("Test Category 4");
        category4.setParent(category3);
        testEntityManager.persist(category4);
        category3.getChildren().add(category4);

        testEntityManager.persist(category3);
        testEntityManager.flush();

        var categoryFromDb = categoryRepository.findRoots();
        assertEquals(1, categoryFromDb.size());
        assertEquals("cat_one", categoryFromDb.get(0).getCode());
        assertEquals("Test Category", categoryFromDb.get(0).getName());
        assertEquals(2, categoryFromDb.get(0).getChildren().size());
    }

    @Test
    public void testFindAllWithChildren() throws Exception {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        testEntityManager.persist(category);

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Test Category 2");
        category2.setParent(category);
        testEntityManager.persist(category2);
        category.getChildren().add(category2);

        var category3 = new Category();
        category3.setCode("cat_three");
        category3.setName("Test Category 3");
        category3.setParent(category);
        testEntityManager.persist(category3);
        category.getChildren().add(category3);

        var category4 = new Category();
        category4.setCode("cat_four");
        category4.setName("Test Category 4");
        category4.setParent(category3);
        testEntityManager.persist(category4);
        category3.getChildren().add(category4);

        testEntityManager.persist(category);
        testEntityManager.flush();

        var categories = categoryRepository.findAllWithChildren();
        assertEquals(4, categories.size());
        assertEquals("cat_one", categories.get(0).getCode());
        assertEquals(2, categories.get(0).getChildren().size());
    }

    @Test
    public void testFindAllWithSpecification() throws Exception {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Computer Basics");
        testEntityManager.persist(category);

        var category2 = new Category();
        category2.setCode("cat_two");
        category2.setName("Data Mining");
        testEntityManager.persist(category2);

        var category3 = new Category();
        category3.setCode("cat_three");
        category3.setName("Computer Science");
        testEntityManager.persist(category3);

        var category4 = new Category();
        category4.setCode("cat_four");
        category4.setName("Data Science");
        testEntityManager.persist(category4);
        testEntityManager.flush();

        CategorySpecification specification = new CategorySpecification("Computer");
        var matched = categoryRepository.findAll(specification);
        assertEquals(2, matched.size());
    }
}
