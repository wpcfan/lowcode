package com.mooc.backend.repositories;

import com.mooc.backend.entities.Category;
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

import static org.hamcrest.MatcherAssert.assertThat;

//@TestPropertySource(locations="classpath:application-test.properties")
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
        category.setName("Test Category");
        testEntityManager.persist(category);
        testEntityManager.flush();

        List<Category> categories = categoryRepository.findAll();

        assertThat("There should be 1 category", categories.size() == 1);
        assertThat("The category name should be 'Test Category'", categories.get(0).getName().equals("Test Category"));

        var category2 = new Category();
        category2.setName("Test Category 2");
        testEntityManager.persist(category2);
        testEntityManager.flush();

        categories = categoryRepository.findAll();

        assertThat("There should be 2 categories", categories.size() == 2);
        assertThat("The category name should be 'Test Category'", categories.get(0).getName().equals("Test Category"));
        assertThat("The category name should be 'Test Category 2'", categories.get(1).getName().equals("Test Category 2"));
    }
}
