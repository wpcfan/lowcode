package com.mooc.backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@TestPropertySource(locations="classpath:application-test.properties")
@SpringBootTest
class BackendApplicationTests {

    @Test
    void contextLoads() {
    }

}
