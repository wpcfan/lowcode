# 第六章：数据对象映射 - 后端对象模型

前面一章我们学习了如何使用 Spring 写 API 接口，但是实际开发中，我们的业务逻辑会更加复杂，需要操作数据库，我们会从数据库中读取数据，然后将数据返回给前端，或者将前端传递过来的数据写入数据库。这一章我们就来学习如何操作数据库。

数据库的操作其实有多种形式，比如说我们可以使用 JDBC 直接操作数据库，可以使用一些简单的映射框架比如 MyBatis， 也可以使用 ORM (对象关系映射) 框架，比如 Hibernate 等。我们的课程中是使用 Spring Data JPA 和 Hibernate。

为什么要使用 ORM 框架呢？因为 ORM 框架可以帮助我们将数据库中的数据映射到 Java 对象中，然后我们就可以像操作 Java 对象一样操作数据库中的数据，这样就大大简化了数据库的操作。

而且在 Java 领域，使用 ORM 是一个很明显的趋势。首先在全球市场上 JPA 的份额比例是碾压 MyBatis 的，其次 MyBatis 是一个 SQL 映射框架，它只是简单的将 SQL 语句映射到 Java 方法中，但是它并没有将数据库中的数据映射到 Java 对象中，所以我们还需要自己去写代码将数据库中的数据映射到 Java 对象中，这样就会大大增加我们的开发成本。

![图 1](http://ngassets.twigcodes.com/5ed4219908019f7be842b570f3f32a4ebe70de545d283fb4bf72795e4b0523e8.png)

![图 2](http://ngassets.twigcodes.com/a4d179e2b8d635d7c7115055bbe9b65b31deac3d5a2a91005d32213bcb4b6d7c.png)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第六章：数据对象映射 - 后端对象模型](#第六章数据对象映射---后端对象模型)
  - [6.1 Spring Data JPA](#61-spring-data-jpa)
    - [6.1.1 构建实体类](#611-构建实体类)
    - [6.1.2 生成数据库表](#612-生成数据库表)

<!-- /code_chunk_output -->

## 6.1 Spring Data JPA

Spring Data JPA 是 Spring Data 的一个子项目，它是一个基于 JPA 的数据访问层框架，它可以简化数据访问层的开发，它的核心是 Repository，它是一个接口，我们只需要定义一个接口继承 Repository，然后 Spring Data JPA 会为我们自动生成实现类，我们只需要在接口中定义方法，然后 Spring Data JPA 会根据方法名自动生成 SQL 语句，然后执行 SQL 语句，将结果返回给我们。

JPA 是什么意思呢？JPA 是 Java Persistence API 的缩写，也就是 Java 持久化 API，这个是一个 Java EE 的标准，它是一个规范，它规定了如何将 Java 对象持久化到数据库中，它规定了如何将数据库中的数据映射到 Java 对象中。可以理解成它是 Java 中对于 ORM 的规范。

很多同学可能以为 JPA 就是 Hibernate，其实不然，JPA 是一个规范，Hibernate 是 JPA 的一个实现，也就是说 Hibernate 实现了 JPA 的规范，所以我们可以使用 Hibernate 来实现 JPA 的规范，也可以使用其他的实现 JPA 规范的框架，比如说 EclipseLink，OpenJPA 等。

集成 Spring Data JPA 只需要在 `build.gradle` 中添加以下依赖即可：

```groovy
implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
```

### 6.1.1 构建实体类

在 ORM 中，实体类就是我们的数据对象，它是一个 Java 对象，它代表了数据库中的一张表，我们可以将实体类中的属性映射到数据库中的字段中，然后我们就可以像操作 Java 对象一样操作数据库中的数据。

由于之前我们在前端已经抽象过一些领域模型，我们可以以此为基础来构建实体类，比如说我们之前抽象的页面布局模型，我们可以将它构建成一个实体类，如下所示：

```java
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_pages")
public class PageLayout {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String title;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Platform platform;

    @Enumerated(EnumType.STRING)
    @Column(name = "page_type", nullable = false)
    private PageType pageType;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    private PageConfig config;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time")
    private LocalDateTime startTime;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "end_time")
    private LocalDateTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private PageStatus status = PageStatus.Draft;
}
```

首先，我们使用了 `@Entity` 注解来标识这是一个实体类，然后我们使用 `@Table` 注解来指定这个实体类对应的数据库表，这里我们指定了表名为 `mooc_pages`。注意我们其实可以不使用 `@Table` 注解，因为默认情况下实体类的名称就是数据库表的名称，但是很多情况下，公司对于表名会有一些要求，所以我们还是使用 `@Table` 注解来指定实体类对应的数据库表。

然后我们使用 `@Id` 注解来标识这个实体类的主键，用 `@GeneratedValue` 注解来指定主键的生成策略，这里我们使用 `GenerationType.IDENTITY` 来指定主键的生成策略，这样主键就会自增。

这个实体类中的属性和数据库中的字段是一一对应的，比如说 `id` 就是数据库中的主键，`title` 就是数据库中的 `title` 字段。默认情况下字段名就是属性名，如果字段名和属性名不一致的话，我们可以使用 `@Column` 注解中的 `name` 属性来指定字段名。

我们在上面代码中其实对不同的字段使用了 `@Column` 的不同属性

1. `nullable`：是否允许为空
2. `unique`：是否唯一
3. `length`：字段的长度
4. `columnDefinition`：字段的定义

我们还可以使用 `@Enumerated` 注解来指定枚举类型的字段，比如说 `platform` 和 `pageType` 就是枚举类型的字段，这里我们使用 `EnumType.STRING` 来指定它们的类型，在数据库中就会以字符串的形式存储枚举类型的字段。

`@Temporal` 注解用来指定日期类型的字段，比如说 `startTime` 和 `endTime` 就是日期类型的字段，这里我们使用 `TemporalType.TIMESTAMP` 来指定它们的类型，在数据库中就会以时间戳的形式存储日期类型的字段。

`@Type` 注解用来指定 `JSON` 类型的字段，比如说 `config` 就是 `JSON` 类型的字段，使用 `@Type(JsonType.class)` 和 `@Column(columnDefinition = "json")` 配合使用来指定它的类型，这样在数据库中就会以 `JSON` 的形式存储 `JSON` 类型的字段。当然这个要注意的是不是所有数据库都支持 `JSON` 类型的字段。

具体来说，`config` 这里是一个 `PageConfig` 类型

```java
/**
 * 页面配置
 * 包括页面的水平间距、垂直间距、基准屏幕宽度
 */
@Schema(description = "页面配置")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper = false)
// 需要序列化的对象需要实现 Serializable 接口
public class PageConfig implements Serializable {
    // 序列化 ID
    @Serial
    private static final long serialVersionUID = 1L;
    // 水平内边距
    @Schema(description = "水平内边距", example = "0.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double horizontalPadding;
    // 垂直内边距
    @Schema(description = "垂直内边距", example = "0.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double verticalPadding;
    // 基准屏幕宽度 points 或者 dip
    @Schema(description = "基准屏幕宽度", example = "400.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("1200.00")
    private Double baselineScreenWidth;
}
```

它保存在数据库中会是一个 `JSON` 结构：

```json
{
  "horizontalPadding": 0,
  "verticalPadding": 0,
  "baselineScreenWidth": 400
}
```

上面的实体类对应的数据库表结构如下，以 `MYSQL` 为例：

```sql
CREATE TABLE mooc_pages
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
    created_at datetime              NULL,
    updated_at datetime              NULL,
    title      VARCHAR(100)          NOT NULL,
    platform   VARCHAR(255)          NOT NULL,
    page_type  VARCHAR(255)          NOT NULL,
    config     JSON                  NOT NULL,
    start_time datetime              NULL,
    end_time   datetime              NULL,
    status     VARCHAR(255)          NOT NULL,
    CONSTRAINT pk_mooc_pages PRIMARY KEY (id)
);

ALTER TABLE mooc_pages
    ADD CONSTRAINT uc_mooc_pages_title UNIQUE (title);
```

这个脚本可以通过 `JPA Structure` 面板中，右键点击 `PageLayout` 实体类，选择 `Show DDL...` 来生成。

![图 4](http://ngassets.twigcodes.com/6650c5cc973b48b0ee0988aff6449db8297cc19e14b250f949659d394a7156fa.png)

![图 3](http://ngassets.twigcodes.com/7659d3bd31c571501c6e0382592e554d68e9d92fba3a30adb6ea57d0dd582fbe.png)

当然上面的实体类中，有几个枚举类型，我们还没有定义，我们可以在 `enumerations` 包下定义这些枚举类型，如下所示：

```java
public enum Platform {
    App,
    Web
}
```

`Platform` 是最简单的一个枚举类型，它只有两个值，`App` 和 `Web`，这个枚举类型表示页面布局的平台，是 `App` 还是 `Web`。 Java 里面的枚举类型有 `ordinal` 和 `name` 两个属性，`ordinal` 表示枚举类型的序号，`name` 表示枚举类型的名称，`ordinal` 是从 0 开始的，`name` 就是枚举类型的名称，比如说 `Platform` 的 `ordinal` 是 0，`name` 是 `App`。

但有些时候，我们需要复杂一些的枚举类型，比如说下面的 `PageStatus`

```java
public enum PageStatus {
    Draft("草稿"),
    Published("发布"),
    Archived("归档");

    private final String value;

    PageStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
```

这个枚举类型是自定义了构造函数的，它有三个值，`Draft`、`Published` 和 `Archived`，这三个值都有一个 `value` 属性，这个 `value` 属性就是枚举类型的名称，比如说 `PageStatus.Draft` 的 `value` 就是 `草稿`。

但这带来另一个问题，如果我们在序列化的时候，想使用 `value` 而不是 `name`，那么我们就需要自定义序列化和反序列化的逻辑，这里我们使用 `@JsonCreator` 和 `@JsonValue` 来实现自定义序列化和反序列化的逻辑，如下所示：

```java
public enum PageType {
    Home("home"),
    About("about"),
    Category("category");

    private final String value;

    PageType(String value) {
        this.value = value;
    }

    @JsonCreator
    public static PageType fromValue(String value) {
        for (PageType pageType : PageType.values()) {
            if (pageType.value.equals(value)) {
                return pageType;
            }
        }
        throw new IllegalArgumentException("Invalid PageType value: " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
```

当然这两个注解不需要一起添加，需要序列化的时候，我们就添加 `@JsonValue` 注解，需要反序列化的时候，我们就添加 `@JsonCreator` 注解。比如上面的代码，如果我们只希望给前端 API 输出 JSON 的时候，使用 `value` 属性，那么我们就只需要添加 `@JsonValue` 注解。

### 6.1.2 生成数据库表

Spring Data JPA 会根据实体类自动生成数据库表，但是我们需要在 `application.properties` 中配置数据库连接信息，如下所示：

```properties
# H2 数据库控制台设置
spring.h2.console.enabled=false
# JPA 设置
## 生成DDL语句
spring.jpa.hibernate.ddl-auto=none
## 显示SQL语句
spring.jpa.show-sql=false
## SQL语句格式化
spring.jpa.properties.hibernate.format_sql=false
## Hibernate统计信息
spring.jpa.properties.hibernate.generate_statistics=false
## Hibernate SQL注释
spring.jpa.properties.hibernate.use_sql_comments=true
# 数据源设置
## 数据库连接 URL
spring.datasource.url=jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
## 数据库用户名
spring.datasource.username=sa
## 数据库密码
spring.datasource.password=
## 数据库驱动
spring.datasource.driver-class-name=org.h2.Driver
```

上面的配置文件中，我们配置了 `spring.jpa.hibernate.ddl-auto` 为 `none`，这个配置表示不自动生成数据库表，如果我们想要自动生成数据库表，我们可以将这个配置改为 `update`，这样每次启动应用的时候，Spring Data JPA 都会自动更新数据库表结构。我们希望在开发模式下，自动生成数据库表，而在生产模式下，不自动生成数据库表，这样可以避免生产环境的数据库表被意外的修改，所以我们可以在 `application-dev.properties` 中添加配置，如下所示：

```properties
# H2 数据库控制台设置，开发模式下可用
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
# JPA 设置
spring.jpa.generate-ddl=true
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.generate_statistics=true
```

为了我们在开发阶段方便的使用数据库，我们在开发时使用 H2 数据库，生产环境使用 MySQL 数据库。所以我们更改 `application-prod.properties` 的数据源和 JPA 设置。

```properties
# JPA 设置
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
# 数据源设置
spring.datasource.url=jdbc:mysql://localhost:3306/low_code?useUnicode=true&characterEncoding=utf-8&useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=user
spring.datasource.password=password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```
