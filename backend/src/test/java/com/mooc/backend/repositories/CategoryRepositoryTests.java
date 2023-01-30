package com.mooc.backend.repositories;

import com.mooc.backend.entities.Category;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;

@DataJpaTest
public class CategoryRepositoryTests {

    private final CategoryRepository categoryRepository;
    private final TestEntityManager testEntityManager;
    CategoryRepositoryTests(@Autowired CategoryRepository categoryRepository, @Autowired TestEntityManager testEntityManager) {
        this.categoryRepository = categoryRepository;
        this.testEntityManager = testEntityManager;
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
