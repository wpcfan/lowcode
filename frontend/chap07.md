# Spring Data JPA Repository

在上一章，我们使用 `EntityManager` 来访问和操作数据库。在这一章，我们将使用 `Repository` 来看一下如何更加简单地访问和操作数据库。

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Spring Data JPA Repository](#spring-data-jpa-repository)
  - [7.1 Repository](#71-repository)
    - [7.1.1 Spring Data JPA 的命名式查询](#711-spring-data-jpa-的命名式查询)
    - [7.1.2 Spring Data JPA 测试命名式查询](#712-spring-data-jpa-测试命名式查询)
    - [7.1.3 返回结果类型的选择](#713-返回结果类型的选择)
      - [7.1.3.1 投影查询](#7131-投影查询)
    - [7.1.4 使用 @Query 注解进行查询](#714-使用-query-注解进行查询)
      - [7.1.4.1 关联查询](#7141-关联查询)
      - [7.1.4.2 作业：类目的关联查询](#7142-作业类目的关联查询)
    - [7.1.5 Example 查询](#715-example-查询)
    - [7.1.6 Specification 查询 - 构建页面布局的动态查询](#716-specification-查询---构建页面布局的动态查询)
    - [7.1.7 测试 Specification](#717-测试-specification)
    - [7.1.8 Spring Data JPA 的分页支持](#718-spring-data-jpa-的分页支持)
  - [7.2 使用 Flyway 管理数据库版本](#72-使用-flyway-管理数据库版本)
  - [7.3 构建运营管理后台的页面布局列表](#73-构建运营管理后台的页面布局列表)
    - [7.3.1 作业：实现一个选择过滤组件和日期范围过滤组件](#731-作业实现一个选择过滤组件和日期范围过滤组件)
    - [7.3.2 Repository 层](#732-repository-层)
    - [7.3.3 实现页面列表的 BLoC](#733-实现页面列表的-bloc)
      - [7.3.3.1 作业：实现页面列表的 BLoC](#7331-作业实现页面列表的-bloc)
    - [7.3.4 搭建运营管理后台的页面列表](#734-搭建运营管理后台的页面列表)
    - [7.3.5 非查询类接口](#735-非查询类接口)
      - [7.3.5.1 Service 单元测试](#7351-service-单元测试)
      - [7.3.5.2 作业：完成删除页面布局的逻辑并单元测试](#7352-作业完成删除页面布局的逻辑并单元测试)
      - [7.3.5.3 完成运营管理后台的前端页面](#7353-完成运营管理后台的前端页面)
        - [7.3.5.3.1 Flutter 中的 Dialog](#73531-flutter-中的-dialog)
        - [7.3.5.3.2 BLoC 中如何更新内存中集合的数据](#73532-bloc-中如何更新内存中集合的数据)
        - [7.3.5.3.3 使用 go_router 设计页面路由](#73533-使用-go_router-设计页面路由)

<!-- /code_chunk_output -->

## 7.1 Repository

Spring Data JPA 的 `Repository` 是一个核心概念，它提供了一种简化数据库访问和操作的方法。`Repository` 是一个接口，它定义了用于执行基本的 CRUD（创建、读取、更新和删除）操作的方法。通过继承 `Repository` 接口，我们可以为实体类创建自定义的 `Repository，从而避免编写大量的数据访问代码。和` `EntityManager` 相比，`Repository` 更加简单易用，而且 `Repository` 也是基于 `EntityManager` 实现的。

Spring Data JPA 提供了几种预定义的 Repository 接口，它们分别提供了不同级别的功能：

- `CrudRepository`：这个接口继承自 Repository 接口，并提供了一组用于执行 CRUD 操作的方法。当你需要基本的 CRUD 功能时，可以让你的 Repository 接口继承 CrudRepository。

- `PagingAndSortingRepository`：这个接口继承自 CrudRepository 接口，并提供了用于分页和排序的方法。当你需要分页和排序功能时，可以让你的 Repository 接口继承 PagingAndSortingRepository。

- `JpaRepository`：这个接口继承自 PagingAndSortingRepository 接口，并提供了一些额外的 JPA 相关功能，如实体管理和查询。当你使用 JPA 作为持久化技术时，可以让你的 Repository 接口继承 JpaRepository。

要创建一个自定义的 Repository，你只需定义一个接口并继承相应的预定义 `Repository` 接口。例如，以下代码创建了一个用于操作 `PageLayout` 实体类的 Repository：

```java
public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
}
```

在这个例子中，我们继承了 `JpaRepository` 接口，我们指定了实体类（PageLayout）和主键类型（Long）作为泛型参数。它提供了一组用于执行 CRUD 操作的方法，如 `save()`、`findAll()`、`findById()`、`deleteById()` 等。这些方法都是基于 `EntityManager` 实现的，所以我们不需要再编写这些方法了。

### 7.1.1 Spring Data JPA 的命名式查询

Spring Data JPA 为我们提供了一种使用命名来查询数据的方式。这种方式有点像黑魔法，直接写出方法名字，不用具体实现就可以使用了。这些方法的命名规则如下：

- `findBy`：查询方法以 `findBy` 开头，后面跟着实体类的属性名，属性名的首字母要大写。例如，`findByTitle()` 表示根据 `title` 属性来查询数据。

- `And`：查询方法中可以使用 `And` 连接多个属性，表示这些属性之间是 `AND` 关系。例如，`findByTitleAndPlatform()` 表示根据 `title` 和 `platform` 属性来查询数据。

- `Or`：查询方法中可以使用 `Or` 连接多个属性，表示这些属性之间是 `OR` 关系。例如，`findByTitleOrPlatform()` 表示根据 `title` 或 `platform` 属性来查询数据。

- `Between`：查询方法中可以使用 `Between` 来指定一个范围，表示这个属性的值在这个范围内。例如，`findBySortBetween()` 表示根据 `sort` 属性来查询 `sort` 值在某个范围内的数据。

- `LessThan`：查询方法中可以使用 `LessThan` 来指定一个值，表示这个属性的值小于这个值。例如，`findBySortLessThan()` 表示根据 `sort` 属性来查询 `sort` 值小于某个值的数据。

- `GreaterThan`：查询方法中可以使用 `GreaterThan` 来指定一个值，表示这个属性的值大于这个值。例如，`findBySortGreaterThan()` 表示根据 `sort` 属性来查询 `sort` 值大于某个值的数据。

- `IsNull`：查询方法中可以使用 `IsNull` 来指定一个值，表示这个属性的值为 `null`。例如，`findByTitleIsNull()` 表示根据 `title` 属性来查询 `title` 值为 `null` 的数据。

- `IsNotNull`：查询方法中可以使用 `IsNotNull` 来指定一个值，表示这个属性的值不为 `null`。例如，`findByTitleIsNotNull()` 表示根据 `title` 属性来查询 `title` 值不为 `null` 的数据。

- `Like`：查询方法中可以使用 `Like` 来指定一个值，表示这个属性的值匹配这个值。例如，`findByTitleLike()` 表示根据 `title` 属性来查询 `title` 值匹配某个值的数据。可以使用通配符，例如 `%value%` ，表示查询任何包含给定值的字符串

- `NotLike`：查询方法中可以使用 `NotLike` 来指定一个值，表示这个属性的值不匹配这个值。例如，`findByTitleNotLike()` 表示根据 `title` 属性来查询 `title` 值不匹配某个值的数据。

- `OrderBy`：查询方法中可以使用 `OrderBy` 来指定一个属性，表示按照这个属性来排序。例如，`findByTitleOrderBySort()` 表示根据 `title` 属性来查询数据，并按照 `sort` 属性来排序。

- `Not`：查询方法中可以使用 `Not` 来指定一个属性，表示这个属性的值不等于指定的值。例如，`findByTitleNot()` 表示根据 `title` 属性来查询 `title` 值不等于某个值的数据。

- `In`：查询方法中可以使用 `In` 来指定一个属性，表示这个属性的值在指定的集合中。例如，`findByTitleIn()` 表示根据 `title` 属性来查询 `title` 值在某个集合中的数据。

- `NotIn`：查询方法中可以使用 `NotIn` 来指定一个属性，表示这个属性的值不在指定的集合中。例如，`findByTitleNotIn()` 表示根据 `title` 属性来查询 `title` 值不在某个集合中的数据。

- `IgnoreCase`：查询方法中可以使用 `IgnoreCase` 来指定一个属性，表示这个属性的值忽略大小写。例如，`findByTitleIgnoreCase()` 表示根据 `title` 属性来查询 `title` 值忽略大小写的数据。

命名形式查询是一种非常灵活的方法，可以快速简便地定义查询。通过命名形式查询，可以避免编写大量的查询代码，提高开发效率。

除了 `findBy...` 之外，还有 `countBy...`、`deleteBy...` 等方法，用于统计和删除数据。命名的规则和 `findBy...` 一样，只是方法的返回值不同。 `countBy...` 方法返回的是 `long` 类型的数据，`deleteBy...` 方法返回的是 `void` 类型。

我们来看个具体的例子

```java
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByNameLikeOrderByIdDesc(String name);
}
```

这个例子中，我们在 `ProductRepository` 中定义了一个 `findByNameLikeOrderByIdDesc()` 方法，表示根据 `name` 属性来查询 `name` 值匹配某个值的数据，并按照 `id` 属性来降序排序。

那么如果有表关联的情况呢？例如，我们要查询 `Product` 表中含有某一类别的所有商品，我们该怎么使用命名式查询呢？

```java
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByCategoriesId(Long id);
}
```

这个例子中，我们在 `ProductRepository` 中定义了一个 `findByCategoriesId()` 方法，前面的部分依然遵循了命名式查询的规则 : `findByCategories` , 后面的部分是 `Id` ，表示根据 `categories` 这个集合属性里面的元素的 `id` 属性来查询数据。

但需要注意的是，这种方式有时候是会有歧义的，比如在 `Product` 中我们有一个属性叫 `CategoriesId` ，那么这个时候，我们就需要使用 `findByCategories_Id()` 来表示根据 `categories` 这个集合属性里面的元素的 `id` 属性来查询数据。这个时候，我们就需要使用 `_` 来分隔实体类和属性。

### 7.1.2 Spring Data JPA 测试命名式查询

我们这里使用 `@DataJpaTest` 注解来测试 Spring Data JPA 的查询方法。`@DataJpaTest` 注解会提供一个 `TestEntityManager` 类型的 `EntityManager` 实例，用于测试数据的插入和删除。

这个 `TestEntityManager` 类型的 `EntityManager` 实例和 `EntityManager` 类型的 `EntityManager` 实例的功能是一样的，只是 `TestEntityManager` 不会对实际数据库产生真实的影响，它只会对内存中数据库进行操作。

```java
@DataJpaTest
public class ProductRepositoryTests {
    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private ProductRepository productRepository;

    @Test
    void testFindByNameLikeOrderByIdDesc() {
        var product = new Product();
        product.setSku("test_sku");
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        entityManager.persist(product);

        var product2 = new Product();
        product2.setSku("test_sku_2");
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        entityManager.persist(product2);

        var product3 = new Product();
        product3.setSku("test_sku_3");
        product3.setName("Another Product 3");
        product3.setDescription("Test Description 3");
        product3.setPrice(BigDecimal.valueOf(10200));
        entityManager.persist(product3);

        entityManager.flush();

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
    public void testFindByCategories_Id() {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        entityManager.persist(category);

        var product1 = new Product();
        product1.setSku("test_sku");
        product1.setName("Test Product");
        product1.setDescription("Test Description");
        product1.setPrice(BigDecimal.valueOf(10000));
        product1.getCategories().add(category);

        var product2 = new Product();
        product2.setSku("test_sku_2");
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));

        entityManager.persist(product1);
        entityManager.persist(product2);
        entityManager.flush();

        var products = productRepository.findByCategoriesId(category.getId());

        assertEquals(1, products.size());
        assertEquals("Test Product", products.get(0).getName());
        assertEquals("Test Description", products.get(0).getDescription());
        assertEquals(BigDecimal.valueOf(10000), products.get(0).getPrice());
    }

}
```

在 `testFindByNameLikeOrderByIdDesc` 这个测试用例中，我们使用 `TestEntityManager` 插入了 3 条数据，然后使用 `productRepository` 的 `findByNameLikeOrderByIdDesc()` 方法来查询 `name` 属性匹配 `%Test%` 的数据，并按照 `id` 属性来降序排序。

在 `testFindByCategories_Id` 这个测试用例中，我们先插入了一条 `Category` 类型的数据，然后插入了两条 `Product` 类型的数据，其中一条数据的 `categories` 属性包含了刚刚插入的 `Category` 类型的数据，然后使用 `productRepository` 的 `findByCategoriesId()` 方法来查询 `categories` 属性中包含了某个 `Category` 类型的数据的数据。

### 7.1.3 返回结果类型的选择

在 Spring Data JPA 中，我们可以使用 `List`、`Set`、`Optional`、`Page`、`Slice`、 `Stream` 等类型来作为查询方法的返回值类型。

一般对于集合对象，我们可以使用 `List` 或者 `Set` 来作为返回值类型，但是对于分页查询，我们就需要使用 `Page` 或者 `Slice` 来作为返回值类型。

`Stream` 类型的返回值类型，是在 Java 8 中引入的，它可以用来表示一个元素序列，但是它和 `List` 或者 `Set` 不同的是，它并不会将所有的元素都加载到内存中，而是在使用的时候才会加载，这样的话，就可以避免一次性加载大量的数据到内存中，从而导致内存溢出的问题。

对于单体对象，我们可以使用 `Optional` 来作为返回值类型，这样的话，如果查询结果为空的话，就会返回一个空的 `Optional` 对象，否则就会返回一个包含查询结果的 `Optional` 对象。当然你也可以返回这个对象本身的类型，但是这样的话，如果查询结果为空的话，就会返回一个 `null` 值。

我们可以在 `ProductRepository` 中定义如下方法：

```java
public interface ProductRepository extends JpaRepository<Product, Long> {
    // ...
    Stream<Product> streamByNameLikeIgnoreCaseAndCategoriesCode(String name, String code);
}
```

这个例子中，我们使用 `Stream` 作为返回值类型，然后在方法名中使用 `stream` 关键字来表示这是一个 `Stream` 类型的查询方法。这个方法查询所有商品名称包含指定参数的，且商品分类的 `code` 属性包含指定参数的商品数据。其中商品名称的匹配是忽略大小写的。然后我们在 `ProductRepositoryTests` 中添加如下测试用例：

```java
@DataJpaTest
public class ProductRepositoryTests {
    @Test
    public void testStreamByNameLikeAndCategoriesCode() throws Exception {
        var category = new Category();
        category.setCode("cat_one");
        category.setName("Test Category");
        entityManager.persist(category);

        var product = new Product();
        product.setSku("test_sku");
        product.setName("Test Product");
        product.setDescription("Test Description");
        product.setPrice(BigDecimal.valueOf(10000));
        product.getCategories().add(category);
        entityManager.persist(product);

        var product2 = new Product();
        product2.setSku("test_sku_2");
        product2.setName("Test Product 2");
        product2.setDescription("Test Description 2");
        product2.setPrice(BigDecimal.valueOf(10100));
        product2.getCategories().add(category);
        entityManager.persist(product2);

        var product3 = new Product();
        product3.setSku("test_sku_3");
        product3.setName("Another Product 3");
        product3.setDescription("Test Description 3");
        product3.setPrice(BigDecimal.valueOf(10200));
        product3.getCategories().add(category);
        entityManager.persist(product3);

        entityManager.flush();

        try (var stream = productRepository.streamByNameLikeIgnoreCaseAndCategoriesCode("%test%", "cat_one")) {
            var products = stream
                .peek(productDTO -> System.out.println(productDTO.getName()))
                .toList();
            assertEquals(2, products.size());
            assertEquals("Test Product", products.get(0).getName());
            assertEquals("Test Description", products.get(0).getDescription());
            assertEquals(BigDecimal.valueOf(10000), products.get(0).getPrice());
            assertEquals("Test Product 2", products.get(1).getName());
            assertEquals("Test Description 2", products.get(1).getDescription());
            assertEquals(BigDecimal.valueOf(10100), products.get(1).getPrice());
        }
    }
}
```

在这个测试用例中，我们使用 `try-with-resources` 语句来创建一个 `Stream` 对象，然后在 `try` 代码块中使用这个 `Stream` 对象来查询数据，最后在 `finally` 代码块中关闭这个 `Stream` 对象。和 `List` 或者 `Set` 不同的是，`Stream` 对象并不会一次性的将所有的数据都加载到内存中，而是在使用的时候才会加载。

#### 7.1.3.1 投影查询

有些时候我们可能只需要查询一部分数据，而不是所有的数据，这个时候我们可以使用投影查询来实现这个需求。投影查询可以用来查询实体类的部分属性，也可以用来查询实体类的部分属性和关联实体类的部分属性。

比如说我们只想查询 `PageLayout` 中的 `id` 和 `title` 属性，我们可以在 `JPA Structure` 面板中右键点击 `DTOs and Projections` ，选择 `New` -> `Spring Data Projection` ，然后在弹出的对话框中输入 `PageLayoutInfo` ，Package 输入 `com.mooc.backend.projections`，勾选 `id` 和 `title` 字段， 然后点击 `OK` 按钮，就可以创建一个 `PageLayoutInfo` 投影类，如图 1 所示。

![图 1](http://ngassets.twigcodes.com/2cb1805179e56ccad9ca86a8ea5f6d4d25a8f24ec8bbb9f2522f05a072887413.png)

其实这个投影就是一个接口:

```java
public interface PageLayoutInfo {
    Long getId();
    String getTitle();
}
```

然后在 `PageLayoutRepository` 中定义如下方法：

```java
@Query("select p.id as id, p.title as title from PageLayout p where p.id = ?1")
Optional<PageLayoutInfo> findProjectionById(Long id);
```

这个方法的目的是为了查询指定 ID 的页面布局的 `id` 和 `title` 属性。然后我们在 `PageLayoutRepositoryTests` 中添加如下测试用例：

```java
@Test
void testFindProjectionById() {
    var now = LocalDateTime.now();
    var pageConfig = PageConfig.builder()
            .baselineScreenWidth(375.0)
            .horizontalPadding(16.0)
            .build();

    var page1 = PageLayout.builder()
            .pageType(PageType.About)
            .platform(Platform.App)
            .status(PageStatus.Published)
            .config(pageConfig)
            .title("Test Page Projection")
            .startTime(now.minusDays(1))
            .endTime(now.plusDays(1))
            .build();

    entityManager.persist(page1);
    entityManager.flush();

    var page = pageLayoutRepository.findProjectionById(page1.getId());
    assertTrue(page.isPresent());
    assertEquals(page1.getId(), page.get().getId());
    assertEquals(page1.getTitle(), page.get().getTitle());
}
```

这样我们就可以通过投影查询来查询指定 ID 的页面布局的 `id` 和 `title` ，而不需要完整的查询出页面布局的所有属性。

所以其实需要查询哪些属性，就可以在投影类中定义哪些属性，然后在查询方法中使用 `as` 关键字来指定查询的属性和投影类中的属性的映射关系。

### 7.1.4 使用 @Query 注解进行查询

除了使用方法名来定义查询方法之外，我们还可以使用 `@Query` 注解来定义查询方法。`@Query` 注解可以用来定义查询语句，也可以用来定义更新语句。这种方式可以用来定义复杂的查询语句，或者是一些特殊的查询语句，比如使用原生的 SQL 语句来查询数据。

首先来回顾需求：

> 需求 10：app 得到的布局是当前时间在该布局的生效时间段内，且该布局处于发布状态，且目标平台为 `App`，且页面类型为首页。

我们可以在 `PageLayoutRepository` 中定义如下方法，这个方法的目的是为了满足 App 端可以查询到匹配的页面布局：

```java
public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
    /**
     * 查询所有满足条件的页面
     * 条件为：
     * 1. 当前时间在开始时间和结束时间之间
     * 2. 平台为指定平台
     * 3. 页面类型为指定页面类型
     * 4. 状态为已发布
     * <p>
     * 使用 Stream 返回，避免一次性查询所有数据，但使用的是延迟加载，
     * 所以在使用时需要使用 try-with-resources 语句，或者手动关闭
     * </p>
     * @param currentTime 当前时间
     * @param platform    平台
     * @param pageType    页面类型
     * @return 页面列表
     */
    @Query("""
    select p from PageLayout p
    where p.status = com.mooc.backend.enumerations.PageStatus.Published
    and p.startTime is not null and p.endTime is not null
    and p.startTime < ?1 and p.endTime > ?1
    and p.platform = ?2
    and p.pageType = ?3
    """)
    Stream<PageLayout> streamPublishedPage(LocalDateTime currentTime, Platform platform, PageType pageType);
}
```

在这个例子中，我们使用 `@Query` 注解来定义查询语句，然后使用 `?1`、`?2`、`?3` 等占位符来表示方法参数，这样的话，我们就可以在方法参数中使用这些占位符来表示查询语句中的参数。这样的话，我们就可以在查询语句中使用一些复杂的查询条件，而不仅仅局限于方法名中的那些查询条件。

`@Query` 注解中的语句叫做 JPQL（Java Persistence Query Language），它是一种面向对象的查询语言，它和 SQL 语言有些类似，但是它并不是直接操作数据库，而是操作实体对象。

也就是说在上面例子中 `select p from PageLayout p` 这个语句中的 `PageLayout` 并不是数据库中的表，而是实体对象。这个语句的意思是从 `PageLayout` 实体对象中查询数据，然后将查询结果封装成 `PageLayout` 实体对象的列表返回。当然转换成 SQL 语句之后确实也是从 `mooc_pages` 表中查询数据，但是这个 SQL 语句是由 JPA 自动生成的，我们并不需要关心。

由于查询的是实体对象，所以在查询条件中我们可以使用实体对象的属性，比如 `p.status`、`p.startTime`、`p.endTime`、`p.platform`、`p.pageType` 等。这些属性都是实体对象的属性，而不是数据库表的字段。这些属性的类型也不是数据库表的字段类型，而是实体对象的属性类型。

好处是我们不需要关心数据库表的字段名和字段类型，只需要关心实体对象的属性名和属性类型就可以了。比如 `p.status = com.mooc.backend.enumerations.PageStatus.Published` 这个语句中的 `com.mooc.backend.enumerations.PageStatus.Published` 是枚举类型，它并不是数据库表的字段，但是 JPA 会自动将枚举类型转换成数据库表的字段。

另外需要注意的是我们使用了多行字符串来定义 JPQL 语句，这个是 Java 13 的新特性，如果你使用的是 Java 11 或者更早的版本，那么你需要将 JPQL 语句写成一行，或者使用 `+` 运算符来连接多行字符串。

如果还是想使用原生 `SQL` 语句来查询数据，那么可以使用 `nativeQuery = true` 参数来指定使用原生 `SQL` 语句来查询数据，比如：

```java
@Query("select * from mooc_pages p where p.id = ?1", nativeQuery = true)
Optional<PageLayout> findByIdWithQuery(Long id);
```

当然一般情况下不建议使用原生 `SQL` 语句来查询数据，因为这样的话就和数据库耦合了，而且也不利于跨数据库的移植。

再来看一个例子，我们首先回顾一个需求

> 需求 4.3：运营人员可以发布布局，在发布时，需要选择布局的生效时间段，后端会校验时间段是否有重叠，如果有重叠，那么会提示运营人员，需要重新选择时间段

这个需求在数据的维度其实就是要查询指定时间段，指定平台，指定页面类型的页面布局的数量，如果数量大于 0，那么就说明有重叠的时间段，否则就没有重叠的时间段。为什么不查询布局呢？因为我们只需要知道数量，而不需要知道具体的布局。这样也会减少数据的传输量，提高性能。

我们可以在 `PageLayoutRepository` 中定义如下方法：

```java
/**
 * 计算指定时间、平台、页面类型的页面数量
 * 用于判断是否存在时间冲突的页面布局
 * @param time
 * @param platform
 * @param pageType
 * @return
 */
@Query("""
select count(p) from PageLayout p
where p.status = com.mooc.backend.enumerations.PageStatus.Published
and p.startTime is not null and p.endTime is not null
and p.startTime < ?1 and p.endTime > ?1
and p.platform = ?2
and p.pageType = ?3
""")
int countPublishedTimeConflict(LocalDateTime time, Platform platform, PageType pageType);
```

当然对于这个需求也可以使用命名规则查询，比如

```java
int countByStartTimeIsNotNullAndEndTimeIsNotNullAndStartTimeLessThanAndEndTimeGreaterThanAndPlatformAndPageTypeAndStatus(LocalDateTime time, LocalDateTime time, Platform platform, PageType pageType, PageStatus status);
```

很明显的，这种复杂查询如果使用命名规则查询的方式的话就会变得过长而且不容易看懂了，所以对于复杂查询还是使用 JPQL 方式或者我们后面会介绍的 Specification 方式会好很多。

#### 7.1.4.1 关联查询

如果遇到需要关联查询的情况，比如我们需要查询指定商品类目下的所有商品，那么我们可以使用 `@Query` 注解来定义查询语句，比如：

```java
@Query("""
select p from Product p
join p.categories c
where c.id = ?1
""")
List<Product> findByCategoryId(Long categoryId);
```

这个例子中我们查询的是指定商品类目下的所有商品，所以我们首先需要查询指定商品类目，然后再查询指定商品类目下的所有商品。这个查询语句中的 `join p.categories c` 表示我们要查询商品类目，然后将商品类目和商品关联起来，这样的话我们就可以在查询条件中使用商品类目的属性了，比如 `c.id = ?1`。

有的时候我们希望把关联的对象一并查询出来，比如我们希望查询指定商品类目下的所有商品，并且将商品类目也一并查询出来，那么我们可以使用 `left join fetch` 来实现，比如：

```java
@Query("""
select p from Product p
left join fetch p.categories c
where c.id = ?1
""")
List<Product> findByCategoryIdWithCategory(Long categoryId);
```

这个例子中我们使用 `left join fetch` 来将商品类目也一并查询出来，这样的话我们就可以在查询结果中直接使用商品类目了，而不需要再去查询商品类目了。也就是说 `Product` 类中的 `categories` 属性已经被填充了，我们可以直接使用了。

#### 7.1.4.2 作业：类目的关联查询

需求：

1. 由于类目是树状结构，所以我们需要查询指定类目下的所有子类目，包括子类目的子类目，以此类推。请写出一个可以查询所有类目的方法，查询出的 `Category` 的 `children` 属性也要被填充。
2. 写一个获得根类目列表的方法，查询出的 `Category` 的 `children` 属性也要被填充。判断根类目的方法是：如果一个类目的 `parent` 属性为 `null`，那么就是根类目。

### 7.1.5 Example 查询

Spring Data Jpa 还提供了一个 `Example` 查询的功能，它可以根据实体对象的属性来查询数据，这样的话就不需要自己写 JPQL 语句了。

比如，我们如果要查询所有商品名为 `Test` 开头的所有商品。我们在下面的测试用例中首先构造了一个商品类目，然后构造了三个商品，其中两个商品的名字都是以 `Test` 开头的，另外一个商品的名字不是以 `Test` 开头的。

然后我们构造查询条件，构造的过程非常简单，就是先构造一个商品对象，然后设置商品的名字为 `Test`。最后我们使用 `ExampleMatcher` 来构造一个匹配器，然后调用 `findAll` 方法来查询数据。

```java
@Test
public void testQueryByExample() throws Exception {

    var category = new Category();
    category.setCode("cat_one");
    category.setName("Test Category");
    entityManager.persist(category);

    var product = new Product();
    product.setSku("test_sku");
    product.setName("Test Product");
    product.setDescription("Test Description");
    product.setPrice(BigDecimal.valueOf(10000));
    product.addCategory(category);
    entityManager.persist(product);

    var product2 = new Product();
    product2.setSku("test_sku_2");
    product2.setName("Test Product 2");
    product2.setDescription("Test Description 2");
    product2.setPrice(BigDecimal.valueOf(10100));
    product2.getCategories().add(category);
    entityManager.persist(product2);

    var product3 = new Product();
    product3.setSku("test_sku_3");
    product3.setName("Another Product 3");
    product3.setDescription("Test Description 3");
    product3.setPrice(BigDecimal.valueOf(10200));
    product3.getCategories().add(category);
    entityManager.persist(product3);

    entityManager.flush();

    Product productQuery = new Product();
    productQuery.setName("Test");

    ExampleMatcher matcher = ExampleMatcher.matching()
            .withIgnoreCase("name")
            .withMatcher("name", ExampleMatcher.GenericPropertyMatchers.startsWith());

    Example<Product> example = Example.of(productQuery, matcher);

    var products = productRepository.findAll(example);

    assertEquals(2, products.size());
}
```

适用于 `Example` 查询的场景是查询条件比较简单的场景，如果查询条件比较复杂，那么就不适合使用 `Example` 查询了。 `Example` 也有一些限制，比如不能使用 `OR` 条件，不能使用 `LIKE` 条件，不能嵌套查询等等。

### 7.1.6 Specification 查询 - 构建页面布局的动态查询

`Specification` 查询是 Spring Data JPA 提供的一种基于 Criteria API 的查询方式。它允许你根据一组条件来执行查询，而无需编写复杂的查询语句。 `Specification` 查询通过创建一个 `Specification` 对象来描述查询条件，然后将其传递给 Repository 的查询方法中。

`Specification` 是一种基于类的查询方式，它的特点和优势如下

1. 灵活性：可以根据查询条件动态构建 `Specification` ，而不需要写多余的 DAO 层代码。
2. 可读性：使用 `Specification` 的查询条件是定义在单独的类中的，这样比直接写在 DAO 中的 JPQL 或 SQL 语句更加可读性。
3. 可维护性：使用 `Specification` 的查询条件是定义在单独的类中的，这样对于每一种查询条件可以单独维护，而不需要在 DAO 层对多余的代码进行维护。
4. 复用性： `Specification` 可以复用，即一个 `Specification` 可以在多个地方使用，这样可以提高代码的复用率。
5. 可测试性： `Specification` 可以独立测试，不需要依赖数据库。

要使用 `Specification` 查询，你需要执行以下步骤：

- 创建一个 `Specification` 对象，并实现 `toPredicate()` 方法来描述查询条件。
- Repository 继承 `JpaSpecificationExecutor` 接口。
- 调用 Repository 的 `findAll()` 或 `findOne()` 方法，并传入 `Specification` 对象作为参数。

由于 Specfication 是有一些学习门槛的，所以我们先来看一个简单的例子，比如我们查询所有名称中包含某一个字符串的商品类目，当然我们可以非常简单的以命名规则的方式来实现这个查询：

```java
public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByNameContaining(String name);
}
```

如果使用 `Specification` 来实现这个查询，那么我们首先需要创建一个 `Specification` 对象，然后实现 `toPredicate()` 方法来描述查询条件

```java
public class CategorySpecification implements Specification<Category> {
    final String nameContaining;

    public CategorySpecification(String nameContaining) {
        this.nameContaining = nameContaining;
    }

    @Override
    public Predicate toPredicate(Root<Category> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
        return criteriaBuilder.like(root.get("name"), "%" + nameContaining + "%");
    }
}
```

注意在 `toPredicate()` 方法中，我们使用 `CriteriaBuilder` 来构造查询条件，这里我们使用 `like()` 方法来构造一个 `LIKE` 条件，然后使用 `root.get("name")` 来获取 `name` 属性，最后我们将这个条件返回。 `root` 对象表示查询的根对象，通过它可以获取到任意属性，这里我们使用 `root.get("name")` 来获取 `name` 属性。我们暂时没有使用 `query` 对象，表示查询对象，可以用于定义查询的结果集、排序、分页等。。

然后 `CategoryRepository` 需要继承 `JpaSpecificationExecutor` 接口，这个接口提供了 `findAll()` 和 `findOne()` 方法，这两个方法都接收一个 `Specification` 对象作为参数。

```java
public interface CategoryRepository extends JpaRepository<Category, Long>, JpaSpecificationExecutor<Category> {
    // ...
}
```

在调用的时候，就可以使用 `CategorySpecification` 来构造查询条件了

```java
@Test
public void testSpecification() throws Exception {

    var category = new Category();
    category.setCode("cat_one");
    category.setName("Test Category");
    entityManager.persist(category);

    var category2 = new Category();
    category2.setCode("cat_two");
    category2.setName("Another Category");
    entityManager.persist(category2);

    entityManager.flush();

    var spec = new CategorySpecification("Test");

    var categories = categoryRepository.findAll(spec);

    assertEquals(1, categories.size());
}
```

那么问题来了，为什么我们可以靠一个简单的命名规则实现的查询，却要使用 `Specification` 来实现呢？这是因为 `Specification` 的优势在于它的灵活性，比如我们可以根据不同的条件来构造不同的 `Specification` 对象，然后传入 `findAll()` 方法中，这样就可以实现动态查询了。

还要说明的一点是 `Specification` 接口只有一个方法，所以我们可以使用 Lambda 表达式来简化代码，比如上面的例子可以简化为

```java
@Test
public void testSpecification() throws Exception {

    var category = new Category();
    category.setCode("cat_one");
    category.setName("Test Category");
    entityManager.persist(category);

    var category2 = new Category();
    category2.setCode("cat_two");
    category2.setName("Another Category");
    entityManager.persist(category2);

    entityManager.flush();
    // 就不需要 CategorySpecification 这个类了
    var spec = (Specification<Category>) (root, query, criteriaBuilder) -> criteriaBuilder.like(root.get("name"), "%Test%");

    var categories = categoryRepository.findAll(spec);

    assertEquals(1, categories.size());
}
```

当然这个简单的查询体现不出 `Specification` 的优势，我们来看一个稍微复杂一点的例子，比如这个需求：

- 需求 8：运营人员可以按条件查询布局，查询条件包括
  - 需求 8.1：布局名称含有输入字符
  - 需求 8.2：选择布局状态：草稿、已发布、已下线
  - 需求 8.3：选择布局生效起始时间段，比如查询所有生效起始时间在从 2020-01-01 00:00:00 到 2020-01-02 00:00:00 之间的布局
  - 需求 8.4：选择布局生效结束时间段，比如查询所有生效结束时间在从 2020-01-01 00:00:00 到 2020-01-02 00:00:00 之间的布局
  - 需求 8.5：选择平台 App / Web ，默认是 App，其中 web 做为扩展需求
  - 需求 8.6：选择布局的目标对象，比如 Home / Category / About 等等，这个是扩展需求

这显然是一个动态查询，从结果来说我们希望构建一个查询语句，类似于

```sql
select * from page_layout
where title like '%首页%'
and status = 'PUBLISHED'
and start_date between '2020-01-01 00:00:00' and '2020-01-02 00:00:00'
and end_date between '2020-01-01 00:00:00' and '2020-01-02 00:00:00'
and platform = 'APP';
```

当然根据不同条件，查询语句可能不同，比如如果没有选择生效起始时间段，那么查询语句就不需要包含 `start_date between '2020-01-01 00:00:00' and '2020-01-02 00:00:00'` 这个条件。也就是 `where` 后面的条件是动态的，我们需要根据不同的条件来构建不同的查询语句。

对于这样的动态查询语句，我们使用简单的命名规则是无法实现的，因为我们无法预知用户会选择哪些条件，也就无法预知查询语句的具体内容。如果使用 `@Query` 注解，那么要么我们得利用 SQL 语句拼接的方式来构建查询语句，要么就得写很多的 `@Query` 注解，这样的代码可读性和可维护性都很差。这时候 `Specification` 就可以发挥它的优势了。

我们首先构建一个查询对象，用于接收查询条件

```java
public record PageFilter(
        String title,
        Platform platform,
        PageType pageType,
        PageStatus status,
        LocalDateTime startDateFrom,
        LocalDateTime startDateTo,
        LocalDateTime endDateFrom,
        LocalDateTime endDateTo) {
}
```

然后，以这个 `PageFilter` 对象为参数，构建一个 `Specification` 对象，用于描述查询条件

```java
public class PageSpecs {
    /**
     * 用于构造动态查询条件
     * 1. 通过 PageFilter 对象获取查询条件
     * 2. 通过 builder 构造查询条件
     * 3. 通过 query 构造最终的查询语句
     * 4. 返回查询语句
     * <p>
     * 通过 Function 接口，将 PageFilter 对象转换为 Specification 对象
     * 通过 Specification 对象，可以构造动态查询条件
     */
    public static Function<PageFilter, Specification<PageLayout>> pageSpec = (filter) -> (root, query, builder) -> {
        // root: 代表查询的实体类
        // query: 查询语句
        // builder: 构造查询条件的工具
        List<Predicate> predicates = new ArrayList<>();
        if (filter.title() != null) {
            predicates.add(builder.like(builder.lower(root.get("title")), "%" + filter.title().toLowerCase() + "%"));
        }
        if (filter.platform() != null) {
            predicates.add(builder.equal(root.get("platform"), filter.platform()));
        }
        if (filter.pageType() != null) {
            predicates.add(builder.equal(root.get("pageType"), filter.pageType()));
        }
        if (filter.status() != null) {
            predicates.add(builder.equal(root.get("status"), filter.status()));
        }
        if (filter.startDateFrom() != null) {
            predicates.add(builder.greaterThanOrEqualTo(root.get("startTime"), filter.startDateFrom()));
        }
        if (filter.startDateTo() != null) {
            predicates.add(builder.lessThanOrEqualTo(root.get("startTime"), filter.startDateTo()));
        }
        if (filter.endDateFrom() != null) {
            predicates.add(builder.greaterThanOrEqualTo(root.get("endTime"), filter.endDateFrom()));
        }
        if (filter.endDateTo() != null) {
            predicates.add(builder.lessThanOrEqualTo(root.get("endTime"), filter.endDateTo()));
        }
        // 使用 builder.and() 方法，将所有的查询条件组合起来
        // 使用 query.where() 方法，将组合好的查询条件设置到查询语句中
        return query.where(builder.and(predicates.toArray(new Predicate[0])))
                .orderBy(builder.desc(root.get("id")))
                .getRestriction();
    };
}
```

上面的代码中，我们使用了高阶函数的思想，将 `PageFilter` 对象转换为 `Specification` 对象，然后在 `Specification` 对象中构造查询条件。

我们根据 `filter` 对象中的属性，构造了一个 `Predicate` 对象的集合，然后使用 `builder.and()` 方法将这些 `Predicate` 对象组合起来，最后使用 `query.where()` 方法将组合好的查询条件设置到查询语句中。

### 7.1.7 测试 Specification

我们在 `PageLayoutRepositoryTests` 类中，添加一个测试方法，用于测试 `Specification` 对象

```java
@DataJpaTest
public class PageLayoutRepositoryTests {
    @Autowired
    private PageLayoutRepository pageLayoutRepository;
    @Autowired
    private TestEntityManager entityManager;

    @Test
    void testPageSpecQuery() {
        var now = LocalDateTime.now();
        var pageConfig = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .horizontalPadding(16.0)
                .build();

        var page1 = PageLayout.builder()
                .pageType(PageType.About)
                .platform(Platform.App)
                .status(PageStatus.Published)
                .config(pageConfig)
                .title("Test Page_1")
                .startTime(now.minusDays(1))
                .endTime(now.plusDays(1))
                .build();

        var page2 = PageLayout.builder()
                .pageType(PageType.About)
                .platform(Platform.App)
                .status(PageStatus.Published)
                .config(pageConfig)
                .title("Page 2")
                .startTime(now.minusMinutes(59))
                .endTime(now.plusMinutes(59))
                .build();

        var page3 = PageLayout.builder()
                .pageType(PageType.About)
                .platform(Platform.App)
                .status(PageStatus.Draft)
                .config(pageConfig)
                .title("Page 3")
                .startTime(now.minusMinutes(59))
                .endTime(now.plusMinutes(59))
                .build();

        var page4 = PageLayout.builder()
                .pageType(PageType.About)
                .platform(Platform.Web)
                .status(PageStatus.Published)
                .config(pageConfig)
                .title("Page 4")
                .startTime(now.minusMinutes(59))
                .endTime(now.plusMinutes(59))
                .build();

        var page5 = PageLayout.builder()
                .pageType(PageType.About)
                .platform(Platform.App)
                .status(PageStatus.Published)
                .config(pageConfig)
                .title("Page 5")
                .startTime(now.minusMinutes(59))
                .endTime(now.plusMinutes(59))
                .build();

        entityManager.persist(page1);
        entityManager.persist(page2);
        entityManager.persist(page3);
        entityManager.persist(page4);
        entityManager.persist(page5);

        entityManager.flush();

        var pageFilter = new PageFilter(
                "Test",
                Platform.App,
                PageType.About,
                PageStatus.Published,
                now.minusDays(2),
                now,
                now,
                now.plusDays(2)
        );
        var spec = PageSpecs.pageSpec.apply(pageFilter);

        var pages = pageLayoutRepository.findAll(spec);
        assertEquals(1, pages.size());
        assertEquals(page1.getId(), pages.get(0).getId());

        pageFilter = new PageFilter(
                null,
                Platform.App,
                PageType.About,
                PageStatus.Published,
                null,
                null,
                null,
                null
        );
        spec = PageSpecs.pageSpec.apply(pageFilter);

        pages = pageLayoutRepository.findAll(spec);
        assertEquals(3, pages.size());
    }
}
```

在上面的代码中，我们使用 `PageFilter` 对象构造了一个 `Specification` 对象，然后使用 `findAll()` 方法查询数据。我们分别测试了两种情况：

- 第一种情况，查询条件中包含了 `title`、`platform`、`pageType`、`status`、`startDateFrom`、`startDateTo`、`endDateFrom`、`endDateTo` 这些属性

- 第二种情况，查询条件中只包含了 `platform`、`pageType`、`status` 这三个属性

当然这个测试用例如果想测完整，需要测试更多的情况，这里只是为了演示 `Specification` 的用法。大家可以自行扩展测试用例。

### 7.1.8 Spring Data JPA 的分页支持

Spring Data JPA 提供了一个 `Pageable` 接口，它可以帮助我们进行分页查询。我们可以通过 `PageRequest.of()` 方法来创建一个 `Pageable` 对象，它有两个参数，第一个参数是页码，第二个参数是每页的大小。

```java
@Test
void testPageableQuery() {
    var category = new Category();
    category.setCode("cat_one");
    category.setName("Test Category");
    entityManager.persist(category);

    var product = new Product();
    product.setSku("test_sku");
    product.setName("Test Product");
    product.setDescription("Test Description");
    product.setPrice(BigDecimal.valueOf(10000));
    product.addCategory(category);
    entityManager.persist(product);

    var product2 = new Product();
    product2.setSku("test_sku_2");
    product2.setName("Test Product 2");
    product2.setDescription("Test Description 2");
    product2.setPrice(BigDecimal.valueOf(10100));
    product2.getCategories().add(category);
    entityManager.persist(product2);

    var product3 = new Product();
    product3.setSku("test_sku_3");
    product3.setName("Another Product 3");
    product3.setDescription("Test Description 3");
    product3.setPrice(BigDecimal.valueOf(10200));
    product3.getCategories().add(category);
    entityManager.persist(product3);

    entityManager.flush();

    var pageable = PageRequest.of(0, 2, Sort.by("name").descending());
    var products = productRepository.findAll(pageable);

    assertEquals(2, products.getNumberOfElements());
    assertEquals(3, products.getTotalElements());
    assertEquals(2, products.getTotalPages());
    assertEquals("Test Product 2", products.getContent().get(0).getName());
    assertEquals("Test Product", products.getContent().get(1).getName());
}
```

在上面的代码中，我们使用 `PageRequest.of()` 方法创建了一个 `Pageable` 对象，然后使用 `findAll()` 方法查询数据。

返回的 `Page<T>` 对象提供了一些有用的方法，比如获取总页数、总记录数、当前页的记录数等。

如果返回是 `Page<T>` 的时候，其实是要执行两次查询，第一次查询是查询总记录数，第二次查询是查询当前页的数据。如果我们只需要查询当前页的数据，可以使用 `Slice<T>` 对象，它只会执行一次查询。

`Page<T>` 的常用属性如下：

- `int getTotalPages()`：获取总页数
- `long getTotalElements()`：获取总记录数
- `int getNumber()`：获取当前页码
- `int getNumberOfElements()`：获取当前页的记录数
- `List<T> getContent()`：获取当前页的数据
- `boolean hasContent()`：判断当前页是否有数据
- `boolean isFirst()`：判断当前页是否是第一页
- `boolean isLast()`：判断当前页是否是最后一页
- `boolean hasNext()`：判断是否有下一页
- `boolean hasPrevious()`：判断是否有上一页

`Slice<T>` 的常用属性如下：

- `int getNumber()`：获取当前页码
- `int getNumberOfElements()`：获取当前页的记录数
- `List<T> getContent()`：获取当前页的数据
- `boolean hasContent()`：判断当前页是否有数据
- `boolean isFirst()`：判断当前页是否是第一页
- `boolean isLast()`：判断当前页是否是最后一页
- `boolean hasNext()`：判断是否有下一页
- `boolean hasPrevious()`：判断是否有上一页

除了 `findAll` ，在其他的命名查询、 `@Query` 注解查询以及 `Specification` 查询方法中，我们也可以使用 `Pageable` 对象，比如：

```java
Page<Product> findByCategories(Category category, Pageable pageable);

@Query("select p from Product p where p.name like %:name%")
Page<Product> findByName(@Param("name") String name, Pageable pageable);

Page<Product> findAll(Specification<Product> spec, Pageable pageable);
```

## 7.2 使用 Flyway 管理数据库版本

Flyway 是一个开源的数据库版本管理工具，它可以帮助我们管理数据库的版本，可以帮助我们在不同的环境中，自动创建数据库表，自动更新数据库表结构。

SpringBoot 对 Flyway 提供了开箱即用的支持，我们可以在 `build.gradle` 中添加 Flyway 的依赖。

```groovy
implementation 'org.flywaydb:flyway-core'
implementation 'org.flywaydb:flyway-mysql'
```

然后在 `application.properties` 文件中添加 Flyway 的配置，当然还是先禁用，我们仅在开发模式下启用：

```properties
# 数据初始化设置
spring.sql.init.mode=never
spring.flyway.enabled=false
```

然后在 `application-dev.properties` 文件中启用 Flyway：

```properties
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration/h2
spring.flyway.baseline-on-migrate=true
```

在 `application-prod.properties` 文件中启用 Flyway：

```properties
# 数据初始化设置
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration/mysql
spring.flyway.baseline-on-migrate=true
```

在上面的配置中，我们使用了 `spring.flyway.enabled` 属性来启用 Flyway，然后使用了 `spring.flyway.locations` 属性来指定 Flyway 的脚本路径，这个路径是 `resources/db/migration`。
`spring.flyway.baseline-on-migrate` 属性来指定在对一个非空数据库执行迁移时，是否应该执行基线。这个属性对于初次部署到生产数据库时非常有用，因为生产库往往都是需要特殊权限预先建立的，而且往往是非空的，这时候我们就可以使用这个属性来指定 Flyway 在对一个非空数据库执行迁移时，是否应该执行基线。

在 `resources/db/migration` 目录下，我们创建两个子目录 `h2` 和 `mysql` ，这意味着我们需要支持两种数据库，一种是 H2，一种是 MySQL。

我们可以创建一个初始化脚本，比如 `V1.0__schema.sql`，这个脚本可以通过 JpaBuddy 来导出，`H2` 版本的内容如下：

```sql
CREATE TABLE mooc_categories
(
    id        BIGINT AUTO_INCREMENT NOT NULL,
    code      VARCHAR(255)          NOT NULL,
    name      VARCHAR(255)          NOT NULL,
    parent_id BIGINT,
    created_at datetime             NULL,
    updated_at datetime             NULL,
    CONSTRAINT pk_mooc_categories PRIMARY KEY (id)
);

ALTER TABLE mooc_categories
    ADD CONSTRAINT uc_mooc_categories_code UNIQUE (code);

ALTER TABLE mooc_categories
    ADD CONSTRAINT FK_MOOC_CATEGORIES_ON_PARENT FOREIGN KEY (parent_id) REFERENCES mooc_categories (id);

CREATE TABLE mooc_product_categories
(
    category_id BIGINT NOT NULL,
    product_id  BIGINT NOT NULL,
    CONSTRAINT pk_mooc_product_categories PRIMARY KEY (category_id, product_id)
);

CREATE TABLE mooc_products
(
    id          BIGINT AUTO_INCREMENT NOT NULL,
    name        VARCHAR(100)          NOT NULL,
    description VARCHAR(255)          NOT NULL,
    price       DECIMAL(10,2)         NOT NULL,
    created_at  datetime              NULL,
    updated_at  datetime              NULL,
    CONSTRAINT pk_mooc_products PRIMARY KEY (id)
);

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_category FOREIGN KEY (category_id) REFERENCES mooc_categories (id);

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_product FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_product_images
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    image_url  VARCHAR(255)          NOT NULL,
    product_id BIGINT                NULL,
    created_at datetime              NULL,
    updated_at datetime              NULL,
    CONSTRAINT pk_mooc_product_images PRIMARY KEY (id)
);

ALTER TABLE mooc_product_images
    ADD CONSTRAINT FK_MOOC_PRODUCT_IMAGES_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_pages
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    created_at datetime              NULL,
    updated_at datetime              NULL,
    platform   VARCHAR(255)          NOT NULL,
    page_type  VARCHAR(255)          NOT NULL,
    config     JSON                  NOT NULL,
    CONSTRAINT pk_mooc_pages PRIMARY KEY (id)
);

CREATE TABLE mooc_page_blocks
(
    id      BIGINT AUTO_INCREMENT NOT NULL,
    title   VARCHAR(255)          NOT NULL,
    type    VARCHAR(255)          NOT NULL,
    sort    INT                   NOT NULL,
    config  JSON                  NOT NULL,
    page_id BIGINT                NULL,
    CONSTRAINT pk_mooc_page_blocks PRIMARY KEY (id)
);

ALTER TABLE mooc_page_blocks
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCKS_ON_PAGE FOREIGN KEY (page_id) REFERENCES mooc_pages (id);

CREATE TABLE mooc_page_block_data
(
    id            BIGINT AUTO_INCREMENT NOT NULL,
    sort          INT                   NOT NULL,
    content       JSON                  NOT NULL,
    page_block_id BIGINT                NULL,
    CONSTRAINT pk_mooc_page_block_data PRIMARY KEY (id)
);

ALTER TABLE mooc_page_block_data
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCK_DATA_ON_PAGE_BLOCK FOREIGN KEY (page_block_id) REFERENCES mooc_page_blocks (id);
```

MySQL 版本的内容如下：

```sql
CREATE TABLE mooc_categories
(
    id        BIGINT AUTO_INCREMENT NOT NULL    COMMENT '主键',
    code      VARCHAR(255)          NOT NULL    COMMENT '分类编码',
    name      VARCHAR(255)          NOT NULL    COMMENT '分类名称',
    parent_id BIGINT                            COMMENT '父级分类',
    created_at datetime             NULL        COMMENT '创建时间',
    updated_at datetime             NULL        COMMENT '更新时间',
    CONSTRAINT pk_mooc_categories PRIMARY KEY (id)
) COMMENT '分类表';

ALTER TABLE mooc_categories
    ADD CONSTRAINT uc_mooc_categories_code UNIQUE (code);

ALTER TABLE mooc_categories
    ADD CONSTRAINT FK_MOOC_CATEGORIES_ON_PARENT FOREIGN KEY (parent_id) REFERENCES mooc_categories (id);

CREATE TABLE mooc_product_categories
(
    category_id BIGINT NOT NULL     COMMENT '分类ID',
    product_id  BIGINT NOT NULL     COMMENT '产品ID',
    CONSTRAINT pk_mooc_product_categories PRIMARY KEY (category_id, product_id)
) COMMENT '产品分类关联表';

CREATE TABLE mooc_products
(
    id            BIGINT AUTO_INCREMENT NOT NULL    COMMENT '主键',
    name          VARCHAR(100)          NOT NULL    COMMENT '产品名称',
    `description` VARCHAR(255)          NOT NULL    COMMENT '产品描述',
    price         DECIMAL(10,2)         NOT NULL    COMMENT '产品价格',
    created_at    datetime              NULL        COMMENT '创建时间',
    updated_at    datetime              NULL        COMMENT '更新时间',
    CONSTRAINT pk_mooc_products PRIMARY KEY (id)
) COMMENT '产品表';

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_category FOREIGN KEY (category_id) REFERENCES mooc_categories (id);

ALTER TABLE mooc_product_categories
    ADD CONSTRAINT fk_mooprocat_on_product FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_product_images
(
    id         BIGINT AUTO_INCREMENT NOT NULL   COMMENT '主键',
    image_url  VARCHAR(255)          NOT NULL   COMMENT '图片地址',
    product_id BIGINT                NULL       COMMENT '产品ID',
    created_at datetime              NULL       COMMENT '创建时间',
    updated_at datetime              NULL       COMMENT '更新时间',
    CONSTRAINT pk_mooc_product_images PRIMARY KEY (id)
) COMMENT '产品图片表';

ALTER TABLE mooc_product_images
    ADD CONSTRAINT FK_MOOC_PRODUCT_IMAGES_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES mooc_products (id);

CREATE TABLE mooc_pages
(
    id         BIGINT AUTO_INCREMENT NOT NULL   COMMENT '主键',
    created_at datetime              NULL       COMMENT '创建时间',
    updated_at datetime              NULL       COMMENT '更新时间',
    platform   VARCHAR(255)          NOT NULL   COMMENT '平台',
    page_type  VARCHAR(255)          NOT NULL   COMMENT '页面类型',
    config     JSON                  NOT NULL   COMMENT '页面配置',
    CONSTRAINT pk_mooc_pages PRIMARY KEY (id)
) COMMENT '页面表';

CREATE TABLE mooc_page_blocks
(
    id      BIGINT AUTO_INCREMENT NOT NULL      COMMENT '主键',
    title   VARCHAR(255)          NOT NULL      COMMENT '标题',
    type    VARCHAR(255)          NOT NULL      COMMENT '类型',
    sort    INT                   NOT NULL      COMMENT '排序',
    config  JSON                  NOT NULL      COMMENT '配置',
    page_id BIGINT                NULL          COMMENT '页面ID',
    CONSTRAINT pk_mooc_page_blocks PRIMARY KEY (id)
) COMMENT '页面块表';

ALTER TABLE mooc_page_blocks
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCKS_ON_PAGE FOREIGN KEY (page_id) REFERENCES mooc_pages (id);

CREATE TABLE mooc_page_block_data
(
    id            BIGINT AUTO_INCREMENT NOT NULL    COMMENT '主键',
    sort          INT                   NOT NULL    COMMENT '排序',
    content       JSON                  NOT NULL    COMMENT '内容',
    page_block_id BIGINT                NULL        COMMENT '页面块ID',
    CONSTRAINT pk_mooc_page_block_data PRIMARY KEY (id)
) COMMENT '页面块数据表';

ALTER TABLE mooc_page_block_data
    ADD CONSTRAINT FK_MOOC_PAGE_BLOCK_DATA_ON_PAGE_BLOCK FOREIGN KEY (page_block_id) REFERENCES mooc_page_blocks (id);
```

flyway 的版本管理是通过表 `flyway_schema_history` 来实现的，表结构如下：

| 字段名         | 类型          | 说明     |
| -------------- | ------------- | -------- |
| installed_rank | INT           | 版本号   |
| version        | VARCHAR(50)   | 版本号   |
| description    | VARCHAR(200)  | 版本描述 |
| type           | VARCHAR(20)   | 类型     |
| script         | VARCHAR(1000) | 脚本名称 |
| checksum       | INT           | 校验和   |
| installed_by   | VARCHAR(100)  | 安装人   |
| installed_on   | TIMESTAMP     | 安装时间 |
| execution_time | INT           | 执行时间 |
| success        | TINYINT       | 是否成功 |

我们每次改动数据库，无论是表结构，还是初始化数据，都需要在 flyway 中进行记录，这样才能保证数据库的版本管理。记录的方式是每次创建一个新的 sql 文件，文件名的命名规则是 `V{版本号}__{描述}.sql`，例如 `V1.0.0__init.sql`，然后在文件中编写 sql 语句，flyway 会自动执行 sql 语句，并记录到 `flyway_schema_history` 表中。

flyway 会自动按版本号顺序执行 sql 文件，如果某个版本的 sql 文件已经执行过了，flyway 会跳过该文件，不会再次执行。

当然如果我们采用 flyway 管理数据，那么之前的 `schema.sql` 和 `data.sql` 文件就不需要了，可以删除了。

## 7.3 构建运营管理后台的页面布局列表

运营管理后台的页面布局列表，是一个页面，页面中包含了一个表格，表格中展示了所有的页面布局，每一行是一个页面布局，每一列是页面布局的属性。

这个页面我们封装成一个独立的包 `pages` ，然后在 `admin` 引入这个包，这样就可以复用了。

这个页面本身也比较复杂，因为这个表格是一个比较复杂的表格，表格中的表头是可以进行对应字段筛选的组件，用于构建查询条件。而每一行数据的尾部，是一个操作按钮组，用于对数据进行修改，删除，上线，下线等操作。

对于这种类型的表格，我们可以封装一下形成一个较为通用的组件：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';

class CustomPaginatedTable extends StatelessWidget {
  const CustomPaginatedTable({
    super.key,
    required this.rowPerPage,
    required this.dataColumns,
    this.header,
    required this.showActions,
    required this.actions,
    required this.sortColumnIndex,
    required this.sortColumnAsc,
    this.onPageChanged,
    required this.dataTableSource,
  });
  final int rowPerPage;
  final List<DataColumn> dataColumns;
  final Widget? header;
  final bool showActions;
  final List<Widget> actions;
  final int sortColumnIndex;
  final bool sortColumnAsc;
  final void Function(int?)? onPageChanged;
  final DataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        cardColor: Theme.of(context).cardColor,
        textTheme: Typography.whiteCupertino);
    final table = PaginatedDataTable(
      header: header,
      rowsPerPage: rowPerPage,
      showFirstLastButtons: true,
      onRowsPerPageChanged: onPageChanged,
      actions: actions,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortColumnAsc,
      columns: dataColumns,
      source: dataTableSource,
    );
    return Theme(
      data: themeData,
      child: table,
    ).scrollable();
  }
}
```

上面代码中，我们封装了一个 `CustomPaginatedTable` 组件，这个组件接收了很多参数，这些参数都是用于构建表格的，其中 `dataTableSource` 是一个抽象类，用于构建表格的数据源，我们需要自己实现这个类，然后传递给 `CustomPaginatedTable` 组件。

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PageTableDataSource extends DataTableSource {
  PageTableDataSource({
    required this.items,
    required this.onUpdate,
    required this.onDelete,
    required this.onPublish,
    required this.onDraft,
    required this.onSelect,
  });

  final List<PageLayout> items;
  final void Function(int) onUpdate;
  final void Function(int) onDelete;
  final void Function(int) onPublish;
  final void Function(int) onDraft;
  final void Function(int) onSelect;

  @override
  DataRow getRow(int index) {
    final item = items[index];
    final statusIcon = item.status == PageStatus.published
        ? const Icon(Icons.published_with_changes, color: Colors.green)
        : item.status == PageStatus.draft
            ? const Icon(Icons.drafts, color: Colors.yellow)
            : const Icon(Icons.archive, color: Colors.grey);
    final config = item.config;

    return DataRow.byIndex(
      index: index,
      cells: _buildCells(item, index, statusIcon, config),
    );
  }

  List<DataCell> _buildCells(
      PageLayout item, int index, Icon statusIcon, PageConfig config) {
    return [
      DataCell(Text(
        item.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(decoration: TextDecoration.underline),
      ).inkWell(onTap: () => onSelect.call(index))),
      DataCell(Text(item.platform.value)),
      DataCell([statusIcon, Text(item.status.value)].toRow()),
      DataCell(Text(item.pageType.value)),
      DataCell(Text(item.startTime?.formatted ?? '')),
      DataCell(Text(item.endTime?.formatted ?? '')),
      DataCell(Tooltip(
        message: '''
水平内边距: ${config.horizontalPadding ?? 0}
垂直内边距: ${config.verticalPadding ?? 0}
基准屏幕宽度: ${config.baselineScreenWidth ?? ''}''',
        child: const Icon(Icons.code),
      )),
      DataCell(
        [
          if (item.isDraft)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onUpdate(index),
              tooltip: '编辑',
            ),
          if (item.isDraft)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => onDelete(index),
              tooltip: '删除',
            ),
          if (item.isDraft)
            IconButton(
              onPressed: () => onPublish(index),
              icon: const Icon(Icons.publish),
              tooltip: '发布',
            ),
          if (item.isPublished)
            IconButton(
              onPressed: () => onDraft(index),
              icon: const Icon(Icons.drafts),
              tooltip: '下架',
            ),
        ].toRow(),
      )
    ];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
```

这个自定义的数据源类中，我们实现了 `DataRow getRow(int index)` 方法，这个方法用于构建表格中的每一行数据，我们可以在这个方法中构建每一行数据的每一列，这里我们使用了 `DataCell` 组件，这个组件用于构建表格中的每一列数据。

然后我们需要一个 `PageTableWidget` 组件来使用 `CustomPaginatedTable` 组件，这个组件接收了很多参数，这些参数都是用于构建表格的，其中 `dataTableSource` 是一个抽象类，用于构建表格的数据源，我们需要自己实现这个类，然后传递给 `CustomPaginatedTable` 组件。

```dart
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import '../filters/filters.dart';
import 'custom_paginated_table.dart';
import 'page_table_data_source.dart';

class PageTableWidget extends StatelessWidget {
  const PageTableWidget({
    super.key,
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    this.onPageChanged,
    required this.onTitleChanged,
    required this.onPlatformChanged,
    required this.onStatusChanged,
    required this.onPageTypeChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onClearAll,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
    required this.onPublish,
    required this.onDraft,
    required this.onSelect,
    required this.query,
  });

  final List<PageLayout> items;
  final int page;
  final int pageSize;
  final int total;
  final void Function(int?)? onPageChanged;
  final void Function(String?) onTitleChanged;
  final void Function(Platform?) onPlatformChanged;
  final void Function(PageStatus?) onStatusChanged;
  final void Function(PageType?) onPageTypeChanged;
  final void Function(DateTimeRange?) onStartDateChanged;
  final void Function(DateTimeRange?) onEndDateChanged;
  final void Function() onClearAll;
  final void Function() onAdd;
  final void Function(PageLayout layout) onUpdate;
  final void Function(int) onDelete;
  final void Function(int) onPublish;
  final void Function(int) onDraft;
  final void Function(int) onSelect;
  final PageQuery query;

  @override
  Widget build(BuildContext context) {
    final title = TextFilterWidget(
      label: '标题',
      onFilter: onTitleChanged,
      popupTitle: '页面标题',
      popupHintText: '请输入页面标题包含的内容',
      value: query.title,
    );

    final platform = SelectionFilterWidget(
      label: '平台',
      onFilter: onPlatformChanged,
      items: [
        SelectionItem(value: Platform.app, label: Platform.app.value),
        SelectionItem(value: Platform.web, label: Platform.web.value),
      ],
      value: query.platform,
    );

    final pageType = SelectionFilterWidget(
      label: '页面类型',
      onFilter: onPageTypeChanged,
      items: [
        SelectionItem(value: PageType.home, label: PageType.home.value),
        SelectionItem(value: PageType.category, label: PageType.category.value),
        SelectionItem(value: PageType.about, label: PageType.about.value),
      ],
      value: query.pageType,
    );

    final status = SelectionFilterWidget(
      label: '状态',
      onFilter: onStatusChanged,
      items: [
        SelectionItem(value: PageStatus.draft, label: PageStatus.draft.value),
        SelectionItem(
            value: PageStatus.published, label: PageStatus.published.value),
        SelectionItem(
            value: PageStatus.archived, label: PageStatus.archived.value),
      ],
      value: query.status,
    );

    final startDate = DateRangeFilterWidget(
        label: '开始日期',
        helpText: '选择开始日期的范围',
        onFilter: onStartDateChanged,
        value: query.startDateFrom != null && query.startDateTo != null
            ? DateTimeRange(
                start: DateTime.parse(query.startDateFrom!),
                end: DateTime.parse(query.startDateTo!),
              )
            : null);

    final endDate = DateRangeFilterWidget(
        label: '结束日期',
        helpText: '选择结束日期的范围',
        onFilter: onEndDateChanged,
        value: query.endDateFrom != null && query.endDateTo != null
            ? DateTimeRange(
                start: DateTime.parse(query.endDateFrom!),
                end: DateTime.parse(query.endDateTo!),
              )
            : null);

    const pageConfig = Text('页面配置');

    const actionHeader = Text('操作');

    final dataColumns = [
      title,
      platform,
      status,
      pageType,
      startDate,
      endDate,
      pageConfig,
      actionHeader,
    ].map((e) => DataColumn(label: e)).toList();

    return CustomPaginatedTable(
      rowPerPage: pageSize,
      dataColumns: dataColumns,
      showActions: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAdd,
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_off_outlined),
          onPressed: onClearAll,
        ),
      ],
      header: const Text('Page Search Result'),
      sortColumnIndex: 0,
      sortColumnAsc: true,
      onPageChanged: onPageChanged,
      dataTableSource: PageTableDataSource(
          items: items,
          onUpdate: (index) => onUpdate(items[index]),
          onDelete: (index) {
            if (items[index].id != null) {
              onDelete.call(items[index].id!);
            }
          },
          onPublish: (index) {
            if (items[index].id != null) {
              onPublish.call(items[index].id!);
            }
          },
          onDraft: (index) {
            if (items[index].id != null) {
              onDraft.call(items[index].id!);
            }
          },
          onSelect: (index) {
            if (items[index].id != null) {
              onSelect.call(items[index].id!);
            }
          }),
    );
  }
}
```

`CustomPaginatedTable` 中每列都有一个可以过滤的字段，变化后会作为筛选条件的一部分，这个部分是通过设置 `dataColumns` 参数来实现的，这个参数是一个 `List<DataColumn>` 类型的参数，我们可以通过这个参数来构建表格的每一列，这里我们使用了 `DataColumn` 组件，这个组件用于构建表格中的每一列。

这种条件过滤组件分为几种

- `TextFilterWidget` 文本过滤组件，用于过滤文本类型的字段

- `SelectionFilterWidget` 选择过滤组件，用于过滤选择类型的字段，比如枚举类型

- `DateRangeFilterWidget` 日期范围过滤组件，用于过滤日期范围类型的字段

其中 `TextFilterWidget` 的代码如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// 一个带有过滤功能的文本控件，点击后会弹出一个对话框，输入关键字后点击确定，会调用 [onFilter] 方法
class TextFilterWidget extends StatelessWidget {
  const TextFilterWidget({
    super.key,
    required this.label,
    required this.onFilter,
    required this.popupTitle,
    required this.popupHintText,
    this.iconData = Icons.filter_alt,
    this.altIconData = Icons.filter_alt_off,
    this.clearIconData = Icons.clear,
    this.cancelText = '清除',
    this.confirmText = '确定',
    this.value,
  });

  final String label;
  final IconData iconData;
  final IconData altIconData;
  final IconData clearIconData;
  final String popupTitle;
  final String popupHintText;
  final String cancelText;
  final String confirmText;
  final String? value;
  final void Function(String?) onFilter;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    final icon = PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text(label),
            ),
            PopupMenuItem(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: popupHintText,
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (value) {
                  onFilter(value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            PopupMenuItem(
                child: [
              TextButton(
                onPressed: () {
                  controller.text = '';
                  onFilter(controller.text);
                  Navigator.of(context).pop();
                },
                child: Text(cancelText),
              ),
              TextButton(
                onPressed: () {
                  onFilter(controller.text);
                  Navigator.of(context).pop();
                },
                child: Text(confirmText),
              ),
            ].toRow()),
          ];
        },
        child: Icon(value == null || value!.isEmpty
            ? Icons.filter_alt
            : Icons.filter_alt_off));
    final clear = IconButton(
      icon: Icon(clearIconData),
      onPressed: () {
        controller.text = '';
        onFilter(controller.text);
      },
    );
    final arr = value == null || value!.isEmpty
        ? [Text(label), icon]
        : [Text(label), icon, clear];
    return arr.toRow();
  }
}
```

上面的代码中，我们使用了 `PopupMenuButton` 组件，这个组件用于构建一个弹出菜单，这个菜单中包含了一个 `TextFormField` 组件，这个组件用于输入过滤的关键字，输入完成后点击确定按钮，会调用 `onFilter` 方法，这个方法会将输入的关键字作为参数传递进去。

### 7.3.1 作业：实现一个选择过滤组件和日期范围过滤组件

实现一个选择过滤组件和日期范围过滤组件，这两个组件的代码和 `TextFilterWidget` 类似，只是输入的类型不同，选择过滤组件的输入类型是枚举类型，日期范围过滤组件的输入类型是日期范围类型。

### 7.3.2 Repository 层

我们在 `repositories` 包中需要给管理后台一个自己的 `PageAdminRepository` ，代码如下：

```dart
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageAdminRepository {
  final String baseUrl;
  final Dio client;

  PageAdminRepository({
    Dio? client,
    this.baseUrl = '/pages',
  }) : client = client ?? AdminClient();

  /// 按条件查询页面
  /// [query] 查询条件
  Future<PageWrapper<PageLayout>> search(PageQuery query) async {
    debugPrint('PageAdminRepository.search($query)');

    final url = _buildUrl(query);
    debugPrint('PageAdminRepository.search($query) - url: $url');

    final response = await client.get(url, options: cacheOptions.toOptions());

    final result = PageWrapper.fromJson(
      response.data,
      (json) => PageLayout.fromJson(json),
    );

    debugPrint('PageAdminRepository.search($query) - success');

    return result;
  }

  String _buildUrl(PageQuery query) {
    final params = <String, String>{};

    if (query.title != null && query.title!.isNotEmpty) {
      params['title'] = query.title!;
    }

    if (query.platform != null) {
      params['platform'] = query.platform!.value;
    }

    if (query.pageType != null) {
      params['pageType'] = query.pageType!.value;
    }

    if (query.status != null) {
      params['status'] = query.status!.value;
    }

    if (query.startDateFrom != null) {
      params['startDateFrom'] = query.startDateFrom!;
    }

    if (query.startDateTo != null) {
      params['startDateTo'] = query.startDateTo!;
    }

    if (query.endDateFrom != null) {
      params['endDateFrom'] = query.endDateFrom!;
    }

    if (query.endDateTo != null) {
      params['endDateTo'] = query.endDateTo!;
    }

    params['page'] = query.page.toString();

    final url = Uri.parse(baseUrl).replace(queryParameters: params);

    return url.toString();
  }
}
```

上面代码中，我们定义了一个 `PageAdminRepository` 类，这个类中包含了一个 `search` 方法，这个方法用于按条件查询页面，这个方法的参数是一个 `PageQuery` 对象，这个对象中包含了查询条件，这个方法的返回值是一个 `Future<PageWrapper<PageLayout>>` 对象，这个对象中包含了查询结果。

### 7.3.3 实现页面列表的 BLoC

如果我们暂时只考虑条件筛选的事件，那么这些事件定义如下：

```dart
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class PageEvent extends Equatable {}

class PageEventTitleChanged extends PageEvent {
  PageEventTitleChanged(this.title) : super();
  final String? title;

  @override
  List<Object?> get props => [title];
}

class PageEventPlatformChanged extends PageEvent {
  PageEventPlatformChanged(this.platform) : super();
  final Platform? platform;

  @override
  List<Object?> get props => [platform];
}

class PageEventPageTypeChanged extends PageEvent {
  PageEventPageTypeChanged(this.pageType) : super();
  final PageType? pageType;

  @override
  List<Object?> get props => [pageType];
}

class PageEventPageStatusChanged extends PageEvent {
  PageEventPageStatusChanged(this.pageStatus) : super();
  final PageStatus? pageStatus;

  @override
  List<Object?> get props => [pageStatus];
}

class PageEventStartDateChanged extends PageEvent {
  PageEventStartDateChanged(this.startDateFrom, this.startDateTo) : super();
  final DateTime? startDateFrom;
  final DateTime? startDateTo;

  @override
  List<Object?> get props => [startDateFrom, startDateTo];
}

class PageEventEndDateChanged extends PageEvent {
  PageEventEndDateChanged(this.endDateFrom, this.endDateTo) : super();
  final DateTime? endDateFrom;
  final DateTime? endDateTo;

  @override
  List<Object?> get props => [endDateFrom, endDateTo];
}
```

#### 7.3.3.1 作业：实现页面列表的 BLoC

- 请根据事件思考页面列表的状态，然后实现页面列表的状态。

- 根据事件和状态，实现页面列表的 BLoC。

### 7.3.4 搭建运营管理后台的页面列表

有了 BLoC，我们就可以搭建页面列表了，代码如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'widgets/widgets.dart';

class PageTableView extends StatelessWidget {
  const PageTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PageBloc>(
            create: (context) => PageBloc(
              context.read<PageAdminRepository>(),
            )..add(PageEventClearAll()),
          ),
        ],
        child: BlocConsumer<PageBloc, PageState>(
          listenWhen: (previous, current) =>
              previous.loading != current.loading,
          listener: (context, state) {
            if (state.loading) {
              return;
            }
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
              context.read<PageBloc>().add(PageEventClearError());
            }
          },
          builder: (context, state) {
            final bloc = context.read<PageBloc>();
            switch (state.status) {
              case FetchStatus.initial:
                return const Text('initial').center();
              case FetchStatus.loading:
                return const CircularProgressIndicator().center();
              default:
                return _buildPageTable(state, bloc, context);
            }
          },
        ),
      ),
    );
  }

  PageTableWidget _buildPageTable(
      PageState state, PageBloc bloc, BuildContext context) {
    return PageTableWidget(
      query: state.query,
      items: state.items,
      page: state.page,
      pageSize: state.pageSize,
      total: state.total,
      onPageChanged: (int? value) => bloc.add(PageEventPageChanged(value)),
      onTitleChanged: (String? value) => bloc.add(PageEventTitleChanged(value)),
      onPlatformChanged: (Platform? value) =>
          bloc.add(PageEventPlatformChanged(value)),
      onStatusChanged: (PageStatus? value) =>
          bloc.add(PageEventPageStatusChanged(value)),
      onPageTypeChanged: (PageType? value) =>
          bloc.add(PageEventPageTypeChanged(value)),
      onStartDateChanged: (DateTimeRange? value) =>
          bloc.add(PageEventStartDateChanged(value?.start, value?.end)),
      onEndDateChanged: (DateTimeRange? value) =>
          bloc.add(PageEventEndDateChanged(value?.start, value?.end)),
      onClearAll: () => debugPrint('onClearAll'),
      onAdd: () => debugPrint('onAdd'),
      onUpdate: (PageLayout layout) => debugPrint('onUpdate: $layout'),
      onDelete: (int id) => debugPrint('onDelete: $id'),
      onPublish: (int id) => debugPrint('onPublish: $id'),
      onDraft: (int id) => debugPrint('onDraft: $id'),
      onSelect: (int id) => debugPrint('onSelect: $id'),
    );
  }
}
```

### 7.3.5 非查询类接口

除了查询类接口，我们还需要实现非查询类接口，这些接口包括：添加页面、更新页面、删除页面、发布页面、下架页面。

由于 `JpaRepository` 本身对于 CRUD 操作已经有内置支持了，一般的修改操作，我们是不需要自己写代码的。我们在这里直接在 Service 层调用 `JpaRepository` 的方法即可。

要注意的一点是在 Java 中，一个比较好的实践是接口要简单，职责单一，所以我们在这里不要把所有的接口都放在一个接口中，而是根据职责的不同，将接口分成多个接口，这样可以更好的遵循接口隔离原则。

首先看创建页面的接口，代码如下：

```java
package com.mooc.backend.services;

import org.springframework.stereotype.Service;

import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.repositories.PageLayoutRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {

    private final PageLayoutRepository pageLayoutRepository;

    public PageLayout createPage(CreateOrUpdatePageDTO page) {
        return pageLayoutRepository.save(page.toEntity());
    }
}
```

上面的代码中，我们使用了 `@Transactional` 注解，这个注解的作用是告诉 Spring，这个方法是一个事务，如果方法执行成功，那么事务就会提交，如果方法执行失败，那么事务就会回滚。非查询类接口，一般都需要使用事务，因为我们需要保证数据的一致性。

在 `createPage` 方法中，我们调用了 `pageLayoutRepository` 的 `save` 方法，这个方法是 `JpaRepository` 提供的方法，用于保存数据，如果数据不存在，那么就是新增，如果数据已经存在，那么就是更新。这个方法的参数我们创建了一个 `CreateOrUpdatePageDTO` 对象，这个对象是用于接收前端传递过来的数据的，我们在这里使用了 `toEntity` 方法，将 DTO 对象转换成了实体对象。这个 `CreateOrUpdatePageDTO` 对象的代码如下：

```java
public record CreateOrUpdatePageDTO(
        @Schema(description = "布局标题", example = "首页布局") @NotBlank @Size(min = 2, max = 100) String title,
        @Schema(description = "平台", example = "App") @NotNull Platform platform,
        @Schema(description = "页面类型", example = "home") @NotNull PageType pageType,
        @NotNull @Valid PageConfig config) {

    public PageLayout toEntity() {
        return PageLayout.builder()
                .title(title)
                .platform(platform)
                .pageType(pageType)
                .config(config)
                .build();
    }
}
```

因为前端很多情况下上传的数据不一定需要和后端的实体保持完全一致的格式，而且我们也不希望前端直接操作实体，所以我们一般都会创建一个 DTO 对象，用于接收前端传递过来的数据，然后再将 DTO 对象转换成实体对象，这样可以更好的控制数据的格式。

类似的，我们再写一个 `PageUpdateService`，这个更新的服务比创建要复杂一些，因为我们要处理多种情况：

1. 由于我们从 UI 操作上来说会给运营人员有几个可以更新页面布局的地方：

- 更新页面本身的信息，包括标题，类型，目标平台和页面配置信息等。
- 发布页面（上架），此时仅仅需要更改页面状态和生效时间段
- 撤销发布（下架），这种情况下，需要改变页面状态为 `PageStatus.Draft` 还有将生效时间段设置为 `null`

2. 我们当然可以只提供一个方法，前端根据不同情况设置不同的值即可。但是这样的话，等于前端不管什么情况都要传递回一个完整的页面布局结构。这会导致前端需要维护这些信息，而且需要保证正确，这个显然是有问题的。作为 API，我们首先要保证后端要有校验数据的能力，而且要给前端尽可能简单的接口，只传递必要信息。所以我们可以将上面几个操作分别提供校验以及更新的方法。

```java
@Slf4j
@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageQueryService pageQueryService;
    private final PageLayoutRepository pageLayoutRepository;

    public PageLayout updatePage(Long id, CreateOrUpdatePageDTO page) {
        var pageEntity = pageQueryService.findById(id);
        if (pageEntity.getStatus() == PageStatus.Published) {
            throw new CustomException("已发布的页面不允许修改", "PageUpdateService#updatePage", Errors.ConstraintViolationException.code());
        }
        pageEntity.setTitle(page.title());
        pageEntity.setConfig(page.config());
        pageEntity.setPageType(page.pageType());
        pageEntity.setPlatform(page.platform());
        return pageEntity;
    }

    public PageLayout publishPage(Long id, PublishPageDTO page) {
        var pageEntity = pageQueryService.findById(id);
        // 设置为当天的零点
        var startTime = page.startTime().with(LocalTime.MIN);
        // 设置为当天的23:59:59.999999999
        var endTime = page.endTime().with(LocalTime.MAX);
        if (pageLayoutRepository.countPublishedTimeConflict(startTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
            throw new CustomException("开始时间和已有数据冲突", "PageUpdateService#publishPage", Errors.ConstraintViolationException.code());
        }
        if (pageLayoutRepository.countPublishedTimeConflict(endTime, pageEntity.getPlatform(), pageEntity.getPageType()) > 0) {
            throw new CustomException("结束时间和已有数据冲突", "PageUpdateService#publishPage", Errors.ConstraintViolationException.code());
        }
        pageEntity.setStatus(PageStatus.Published);
        pageEntity.setStartTime(startTime);
        pageEntity.setEndTime(endTime);
        return pageLayoutRepository.save(pageEntity);
    }

    public PageLayout draftPage(Long id) {
        var pageEntity = pageQueryService.findById(id);
        pageEntity.setStatus(PageStatus.Draft);
        pageEntity.setStartTime(null);
        pageEntity.setEndTime(null);
        return pageLayoutRepository.save(pageEntity);
    }

    @Operation(summary = "发布页面")
    @PatchMapping("/{id}/publish")
    public PageDTO publishPage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody PublishPageDTO publishPageDTO) {
        return PageDTO.fromEntity(pageUpdateService.publishPage(id, publishPageDTO));
    }

    @Operation(summary = "取消发布页面")
    @PatchMapping("/{id}/draft")
    public PageDTO draftPage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id) {
        return PageDTO.fromEntity(pageUpdateService.draftPage(id));
    }
}
```

上面的代码中，我们在保存之前做了一些校验，比如：

- 如果页面已经发布，那么就不允许修改
- 如果发布时间段和已有的页面布局时间段冲突，那么就不允许发布

之后在 Controller 层，我们就可以直接调用 `PageCreateService` 的 `createPage` 方法，为了简单起见，我们还是利用 `PageAdminController`，代码如下：

```java
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/pages")
public class PageAdminController {

    private final PageCreateService pageCreateService;
    private final PageQueryService pageQueryService;

    @Operation(summary = "添加页面")
    @PostMapping()
    public PageDTO createPage(@Valid @RequestBody CreateOrUpdatePageDTO page) {
        if (pageQueryService.existsByTitle(page.title()))
            throw new CustomException("页面标题已存在", "PageAdminController#createPage",
                    Errors.DataAlreadyExistsException.code());
        return PageDTO.fromEntity(pageCreateService.createPage(page));
    }

    @Operation(summary = "修改页面")
    @PutMapping("/{id}")
    public PageDTO updatePage(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageDTO page) {
        checkPageStatus(id);
        return PageDTO.fromEntity(pageUpdateService.updatePage(id, page));
    }

    // ...
}
```

#### 7.3.5.1 Service 单元测试

`@ExtendWith` 是 JUnit 5 中的一个注解，用于扩展测试运行器（Test Runner）。它可以用来加载自定义的扩展（Extension），从而增强测试运行器的功能。

`@ExtendWith(SpringExtension.class)` 是 JUnit 5 中用于加载 Spring 扩展的注解。它的作用主要有以下几个方面：
自动加载 Spring 上下文：使用 `@ExtendWith(SpringExtension.class)` 注解可以自动加载 Spring 上下文，从而可以在测试中使用 Spring 的依赖注入、事务管理、AOP 等功能。在测试方法执行前，SpringExtension 会自动创建一个 Spring 上下文，并将其注入到测试类中。
简化测试配置：使用 `@ExtendWith(SpringExtension.class)` 注解可以简化测试配置，避免手动创建 Spring 上下文和配置测试环境的繁琐过程。SpringExtension 会自动加载 Spring 配置文件，并创建相应的 Bean。
支持测试运行器扩展：使用 `@ExtendWith(SpringExtension.class)` 注解可以支持测试运行器扩展，从而可以自定义测试运行器的行为。例如，可以使用 @MockBean 注解来模拟 Bean，或者使用 @Transactional 注解来管理事务。
总的来说，`@ExtendWith(SpringExtension.class)` 注解是 JUnit 5 中用于加载 Spring 扩展的注解。它可以自动加载 Spring 上下文，简化测试配置，支持测试运行器扩展，从而可以更加方便地进行集成测试。

```java
package com.mooc.backend.services;

import com.mooc.backend.dtos.CreateOrUpdatePageDTO;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageLayoutRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ExtendWith(SpringExtension.class)
public class PageCreateServiceTests {
    @MockBean
    private PageLayoutRepository pageLayoutRepository;
    @Test
    void testCreatePage() {
        var pageCreateService = new PageCreateService(pageLayoutRepository);
        var page = new CreateOrUpdatePageDTO("Page 1", Platform.App, PageType.Home, PageConfig.builder().build());

        Mockito.when(pageLayoutRepository.save(Mockito.any(PageLayout.class))).thenReturn(PageLayout.builder().id(1L).build());
        var result = pageCreateService.createPage(page);
        assertEquals(1L, result.getId());
    }
}
```

`@MockBean` 注解，用于模拟 Bean。它的作用主要有以下几个方面：

1. 模拟依赖：使用 `@MockBean` 注解可以模拟依赖，从而避免测试过程中对真实依赖的依赖。例如，如果这个服务依赖于一个 `PageLayoutRepository` ，我们可以使用 `@MockBean` 注解来模拟，从而避免测试过程中对真实数据库的依赖。

2. 简化测试配置：使用 `@MockBean` 注解可以简化测试配置，避免手动创建模拟对象的繁琐过程。Spring Boot Test 会自动创建模拟对象，并将其注入到测试类中。

3. 支持测试运行器扩展：使用 `@MockBean` 注解可以支持测试运行器扩展，从而自定义测试运行器的行为。例如，可以使用 `@MockBean` 注解来模拟 Bean，或者使用 `@Transactional` 注解来管理事务。

我们的 `PageCreateService` 有一个依赖 `PageLayoutRepository`，我们通过 `@MockBean` 注解可以方便的将其注入到这个测试中，我们并没有 `new` 这个依赖。我们在测试用例中模拟了 `PageLayoutRepository` 的 `save` 方法，这样就可以隔离依赖，单独测试 `PageCreateService` 。当然这个例子由于 `PageCreateService` 的 `createPage` 方法是单纯的调用 `PageLayoutRepository` 的 `save` 方法，所以其实真实意义并不大。一般来说，如果 Service 层有业务逻辑的话，我们可以很方便的用这种方法测试不同数据返回的情况下，业务逻辑是否正确。

```java
package com.mooc.backend.services;

import com.mooc.backend.dtos.PublishPageDTO;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.time.LocalDateTime;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;

@ExtendWith(SpringExtension.class)
public class PageUpdateServiceTests {
    @MockBean
    private PageLayoutRepository pageLayoutRepository;

    @MockBean
    private PageBlockRepository pageBlockRepository;

    @MockBean
    private PageBlockDataRepository pageBlockDataRepository;

    @MockBean
    private PageQueryService pageQueryService;

    @Test
    void testPublishPage() {
        var pageUpdateService = new PageUpdateService(pageQueryService, pageLayoutRepository, pageBlockRepository, pageBlockDataRepository);
        var now = LocalDateTime.now();
        var startTime = now.minusDays(1).with(LocalTime.MIN);
        var endTime = now.plusDays(1).with(LocalTime.MAX);
        var page = new PublishPageDTO(startTime, endTime);
        var entity = PageLayout.builder()
                .id(1L)
                .title("title")
                .status(PageStatus.Published)
                .pageType(PageType.Home)
                .platform(Platform.App)
                .build();
        Mockito.when(pageQueryService.findById(any(Long.class))).thenReturn(entity);
        Mockito.when(pageLayoutRepository.countPublishedTimeConflict(startTime, Platform.App, PageType.Home)).thenReturn(1);
        assertThrows(CustomException.class, () -> pageUpdateService.publishPage(1L, page));
    }
}
```

上面的测试用例中，我们模拟了 `PageQueryService` 的 `findById` 方法，`PageLayoutRepository` 的 `countPublishedTimeConflict` 方法。这样我们就可以测试 `PageUpdateService` 的 `publishPage` 方法了。这个方法的逻辑是，首先根据 `id` 查询 `PageLayout`，然后判断 `startTime` 和 `endTime` 是否和已经发布的页面冲突，如果冲突则抛出异常。我们可以通过模拟 `PageLayoutRepository` 的 `countPublishedTimeConflict` 方法来测试这个逻辑。

#### 7.3.5.2 作业：完成删除页面布局的逻辑并单元测试

在 `PageDeleteService` 中完成删除页面布局的逻辑，并编写单元测试。

#### 7.3.5.3 完成运营管理后台的前端页面

利用已经有的接口，完成运营管理后台的前端页面。运营管理后台的前端页面需要完成以下功能：

1. 页面列表：每一条信息的操作包括编辑、删除、发布、取消发布等操作。
2. 页面编辑：编辑页面的基本信息，包括标题、平台、页面类型等。
3. 页面创建：创建页面，需要填写页面的基本信息，包括标题、平台、页面类型等。

提示：

1. BLoC 中的事件可以参考以下定义

```dart
  class PageEventUpdate extends PageEvent {
  PageEventUpdate(this.id, this.layout) : super();
  final int id;
  final PageLayout layout;

  @override
  List<Object> get props => [id, layout];
}

class PageEventCreate extends PageEvent {
  PageEventCreate(this.layout) : super();

  final PageLayout layout;

  @override
  List<Object> get props => [layout];
}

class PageEventDelete extends PageEvent {
  PageEventDelete(this.id) : super();
  final int id;

  @override
  List<Object> get props => [id];
}

class PageEventPublish extends PageEvent {
  PageEventPublish(this.id, this.startTime, this.endTime) : super();
  final int id;
  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object> get props => [id];
}

class PageEventDraft extends PageEvent {
  PageEventDraft(this.id) : super();
  final int id;

  @override
  List<Object> get props => [id];
}
```

2. 创建和编辑可以使用 Dialog 完成，这个 Dialog 叫做 `CreateOrUpdatePageDialog` ，可以参考 `pages/lib/popups` 中的代码。

##### 7.3.5.3.1 Flutter 中的 Dialog

Flutter 中的 Dialog 有两种，一种是 `AlertDialog`，一种是 `SimpleDialog`。`AlertDialog` 是一个简单的对话框，只有一个标题和一个内容，一般用于提示。`SimpleDialog` 是一个复杂的对话框，可以有多个按钮，一般用于选择。我们可以通过 `showDialog` 方法来显示一个 Dialog。我们的作业使用 `AlertDialog` 即可。

```dart
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('提示'),
      content: Text('确定要删除吗？'),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () => Navigator.of(context).pop(), // 关闭对话框
        ),
        FlatButton(
          child: Text('确定'),
          onPressed: () {
            // 执行删除操作
            Navigator.of(context).pop(); // 关闭对话框
          },
        ),
      ],
    );
  },
);
```

##### 7.3.5.3.2 BLoC 中如何更新内存中集合的数据

在 BLoC 中，我们经常会遇到要维护一个集合的数据，比如说我们要维护一个页面的列表，这个列表是一个 `List<PageLayout>` 类型的数据。

- 如果新创建一个页面布局的话，一般会把这个元素添加到这个集合中，至于是添加到集合的头部还是尾部，这个取决于业务需求。下面是一个简单示例，把元素添加到集合的头部，这个用法和 `javascript` 很像。三个点代表把 `layouts` 中的元素展开。

  ```dart
  List<PageLayout> _addPageLayout(List<PageLayout> layouts, PageLayout layout) {
    return [layout, ...layouts];
  }
  ```

- 如果删除一个页面布局的话，一般会把这个元素从集合中删除。下面是一个简单示例，把元素从集合中删除。

  ```dart
  List<PageLayout> _deletePageLayout(List<PageLayout> layouts, int id) {
    return layouts.where((layout) => layout.id != id).toList();
  }
  ```

- 如果更新一个页面布局的话，相对会复杂一些，因为你需要找到这个元素在集合中的位置，然后把这个元素替换掉。下面是一个简单示例，把元素从集合中更新。

  ```dart
  // 如果服务器可以返回更新后的数据
  List<PageLayout> _updatePageLayout(List<PageLayout> layouts, PageLayout updated) {
    return layouts.map((item) {
      if (item.id == updated.id) {
        return updated;
      }
      return item;
    }).toList();
  }
  // 如果服务器不可以返回更新后的数据

  ```

##### 7.3.5.3.3 使用 go_router 设计页面路由

在 Flutter 中，我们可以使用 `Navigator` 来进行页面的跳转，但是这个 API 不够友好，我们可以使用 `go_router` 这个库来进行页面的跳转。`go_router` 的使用方法可以参考 [go_router](https://pub.dev/packages/go_router) 。

`go_router` 是一个声明式的路由库，我们可以在 `main.dart` 中定义路由，然后在其他地方使用 `context.go('/xxx)` 来进行页面的跳转。下面是一个简单的示例：

```dart
// main.dart
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
```

可以看到，路由的定义方式和 `vue` 等前端框架差不多，我们可以把所有路由放到一个数组中，然后在 `MyApp` 中使用 `routerConfig` 来配置路由。在 `GoRoute` 中的 `path` 就是路由的路径，`builder` 就是路由对应的页面的工厂函数。

但需要指出的是 `GoRoute` 只能路由整个页面，如果是页面的某些部分在路由中是不变的，那么就需要使用 `ShellRoute`，`ShellRoute` 可以在路由中保留某些部分，这样可以避免在路由时，这些部分被重新构建。我们可以通过下面的代码来实现 `ShellRoute`：

```dart
// routes/routes.dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/pages.dart';

import '../constants.dart';
import '../widgets/widgets.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();
final innerScaffoldKey = GlobalKey<ScaffoldState>();

final routes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => const PageTableView(),
  ),
];

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // 嵌套的路由使用 ShellRoute 包裹
    // 我们这里只想让 body 部分刷新，
    // 也就是切换路由时，只刷新 body 部分
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        key: scaffoldKey,
        drawer: const SideMenu(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Header(),
          primary: true,
          backgroundColor: bgColor,
        ),
        body: SafeArea(child: child),
      ),
      routes: routes,
    ),
  ],
);
```

然后在 `main.dart` 中使用 `routerConfig` 来配置路由：

```dart
void main() {
  /// 初始化 Bloc 的观察者，用于监听 Bloc 的生命周期
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 根组件
  @override
  Widget build(BuildContext context) {
    /// 使用 MaterialApp.router 来初始化路由
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '运营管理后台',

      /// 使用 ThemeData.dark 来初始化一个深色主题
      /// 使用 copyWith 来复制该主题，并修改部分属性
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          dataRowColor: MaterialStateProperty.all(secondaryColor),
          dividerThickness: 0,
        ),
      ),

      /// 使用 GlobalMaterialLocalizations.delegate 来初始化 Material 组件的本地化
      /// 使用 GlobalWidgetsLocalizations.delegate 来初始化 Widget 组件的本地化
      /// 使用 GlobalCupertinoLocalizations.delegate 来初始化 Cupertino 组件的本地化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// 使用 zh 来初始化中文本地化
      supportedLocales: const [
        Locale('zh'),
      ],

      /// 使用 routerConfig 来初始化路由
      routerConfig: routerConfig,
    );
  }
}
```
