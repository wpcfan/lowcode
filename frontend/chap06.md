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
  - [6.2 实体类分析](#62-实体类分析)
    - [6.2.1 页面布局](#621-页面布局)
    - [6.2.2 页面区块](#622-页面区块)
    - [6.2.3 数据项](#623-数据项)
    - [6.2.4 商品实体类](#624-商品实体类)
    - [6.2.5 分类实体类](#625-分类实体类)
    - [6.2.6 实体对象之间的关系](#626-实体对象之间的关系)
  - [6.3 构建实体类](#63-构建实体类)
    - [6.3.1 JPA Buddy 插件](#631-jpa-buddy-插件)
    - [6.3.2 作业：完成区块数据，产品和类别等实体类](#632-作业完成区块数据产品和类别等实体类)
  - [6.4 生成数据库表](#64-生成数据库表)
    - [6.4.1 自动创建数据库表](#641-自动创建数据库表)

<!-- /code_chunk_output -->

## 6.1 Spring Data JPA

Spring Data 本身是一个很大的项目，它包含了很多子项目，比如说 Spring Data JPA，Spring Data MongoDB，Spring Data Redis 等等，它们都是 Spring Data 的子项目，它们都是为了简化数据访问层的开发而存在的。熟悉了 Spring Data JPA，我们就可以很容易的学习其他的 Spring Data 子项目。这些项目的很多概念都是相通的。

Spring Data JPA 是 Spring Data 的一个子项目，它是一个基于 JPA 的数据访问层框架，它可以简化数据访问层的开发，它的核心是 Repository，它是一个接口，我们只需要定义一个接口继承 Repository，然后 Spring Data JPA 会为我们自动生成实现类，我们只需要在接口中定义方法，然后 Spring Data JPA 会根据方法名自动生成 SQL 语句，然后执行 SQL 语句，将结果返回给我们。

JPA 是什么意思呢？JPA 是 Java Persistence API 的缩写，也就是 Java 持久化 API，这个是一个 Java EE 的标准，它是一个规范，它规定了如何将 Java 对象持久化到数据库中，它规定了如何将数据库中的数据映射到 Java 对象中。可以理解成它是 Java 中对于 ORM 的规范。

很多同学可能以为 JPA 就是 Hibernate，其实不然，JPA 是一个规范，Hibernate 是 JPA 的一个实现，也就是说 Hibernate 实现了 JPA 的规范，所以我们可以使用 Hibernate 来实现 JPA 的规范，也可以使用其他的实现 JPA 规范的框架，比如说 EclipseLink，OpenJPA 等。

集成 Spring Data JPA 只需要在 `build.gradle` 中添加以下依赖即可：

```groovy
implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
runtimeOnly 'com.h2database:h2'
runtimeOnly 'com.mysql:mysql-connector-j'
```

上面的配置中，我们同时添加了 H2 和 MySQL 的依赖，这是因为我们在开发中一般会使用 H2 数据库作为我们的开发数据库，而在生产环境中我们一般会使用 MySQL 数据库，所以我们需要同时添加这两个依赖。

## 6.2 实体类分析

在 ORM 中，实体类就是我们的数据对象，它是一个 Java 对象，它代表了数据库中的一张表，我们可以将实体类中的属性映射到数据库中的字段中，然后我们就可以像操作 Java 对象一样操作数据库中的数据。

所以我们如果分析清楚了我们的业务模型，也就相当于我们完成了数据库的设计。

首先，我们来分析一下我们的业务模型，我们的业务模型是什么呢？

### 6.2.1 页面布局

1. 我们需要保存很多的页面布局，比如说我们有一个首页，我们需要保存首页的布局，但运营人员可能需要定义首页在不同时间段的布局，比如某个厂商买了我们的 Banner 广告，那么我们就需要在首页上展示这个厂商的 Banner 广告，但是这个厂商的广告只有一个月的时间，所以我们需要在这个厂商的广告过期之后，将首页的布局恢复到原来的样子，所以我们需要保存不同时间段的首页布局。所以我们需要有生效的时间 `startTime` 和失效的时间 `endTime` 。

2. 和前端 App 获取的布局相比，后端的布局是要有状态的，不可能所有布局都同时生效，所以我们区分 `发布` ， `草稿` 和 `归档` 三种状态。那么我们需要定义一个状态 `status` 。这个 status 是个枚举类型，它有三个值，分别是 `PUBLISHED` ， `DRAFT` 和 `ARCHIVED` 。这三个值分别代表了 `发布` ， `草稿` 和 `归档` 三种状态。

3. 后端需要考虑到多平台的问题。由于不同平台的特点和 UI 规范其实是不尽相同的。即使目前的布局可以暂时统一对待，但可以想见的是，不久的将来，一定会对不同平台有所区别，所以我们需要定义一个平台 `platform` ，这个 `platform` 是个枚举类型，它有两个值，分别是 `App` 和 `Web` 。在我们的课程中，我们只考虑 `App` 平台，所以这个值暂时只有 `App` 一个值。

4. 尽管我们目前只针对首页做了布局，但是我们的业务模型是可以扩展的，也就是说布局应该有一个 `type` 属性，这个 `type` 属性是一个枚举类型，它有三个值，分别是 `Home`, `Category` 和 `About` 。这两个值分别代表了首页、分类页和关于页面。当然这个枚举类型暂时只是为了举例，暂时只有 `Home` 一个值。

5. 页面本身也需要有一个 `config` 属性，这个 `config` 最好有一定的扩展性，暂时我们希望它至少包含 `horizontalPadding` , `verticalPadding` 和 `baselineScreenWidth` 三个属性，分别代表了页面的水平内边距，垂直内边距以及基线屏幕宽度。

6. 一个页面布局可以由多个页面区块组成，所以我们需要有一个 `blocks` 属性，这个属性是一个集合，集合中的元素是页面区块。

### 6.2.2 页面区块

1. 页面区块是页面布局的组成部分，一个页面布局可以由多个页面区块组成，每个页面区块都有一个 `type` 属性，这个 `type` 属性是一个枚举类型，我们从前面的章节中可以知道，这个类型的值可以有 `Banner`, `ImageRow`, `ProductRow` 和 `Waterfall` 。

2. 由于运营人员可以调整区块的顺序，所以我们需要有一个 `sort` 属性，这个属性是一个整数，它代表了区块在页面中的顺序。

3. 页面区块本身也需要有一个 `config` 属性，这个 `config` 最好有一定的扩展性，暂时我们希望它至少包含区块的水平内边距，垂直内边距，水平间距，垂直间距，区块宽度，区块高度，区块背景色，边框颜色，边框宽度等。

4. 页面区块需要包含多个数据项，所以我们需要有一个 `data` 属性，这个属性是一个集合，集合中的元素是数据项。

### 6.2.3 数据项

1. 区块中显示的数据来自于数据项，而数据项本身即有共同的特性，比如都有排序 `sort` 属性，都有一个 `id` 用于标识数据项
2. 也有不同之处，数据的内容不同，我们可以用一个字段区分，但也可以使用实现同一接口的不同类来区分，这里我们使用后者，我们定义一个 `BlockData` 接口，它有一个 `getDataType` 方法，这个方法返回一个枚举类型 `BlockDataType` ，这个枚举类型有三个值，分别是 `Product`, `Category` 和 `Image` 。这三个值分别代表了商品，分类和图片三种数据类型。

### 6.2.4 商品实体类

1. 商品实体类需要有一个 `id` 属性，这个属性是一个整数，它代表了商品的唯一标识
2. 商品实体类需要有一个 `name` 属性，这个属性是一个字符串，它代表了商品的名称
3. 商品实体类需要有一个 `price` 属性，这个属性是一个浮点数，它代表了商品的价格
4. 商品实体类需要有一个 `images` 的列表，它是一个集合，集合中的元素可以是图片的 URL 地址，但由于我们还想对图片做增删改查，所以我们需要有一个商品图片实体类
   - 这个图片实体类需要有一个 `id` 属性，这个属性是一个整数，它代表了图片的唯一标识
   - 这个图片实体类需要有一个 `imageUrl` 属性，这个属性是一个字符串，它代表了图片的 URL 地址

### 6.2.5 分类实体类

1. 分类实体类需要有一个 `id` 属性，这个属性是一个整数，它代表了分类的唯一标识
2. 分类实体类需要有一个 `name` 属性，这个属性是一个字符串，它代表了分类的名称
3. 分类实体类需要有一个 `code` 属性，这个属性是一个字符串，它代表了分类的编码

### 6.2.6 实体对象之间的关系

上面说的 `PageLayout` ， `PageBlock` 和 `BlockData` 三个实体对象之间都是一对多的关系

1. 一个页面布局可以由多个页面区块组成，所以 `PageLayout` 和 `PageBlock` 之间是一对多的关系
2. 一个页面区块可以有多个数据项，所以 `PageBlock` 和 `BlockData` 之间是一对多的关系
3. 一个商品可以有多个图片，所以 `Product` 和 `ProductImage` 之间是一对多的关系
4. 一个分类可以有多个商品，所以 `Category` 和 `Product` ，一个商品也可以属于多个分类，所以 `Product` 和 `Category` 之间是多对多的关系
5. 一个分类可以有多个子分类，所以 `Category` 和 `Category` 之间是一对多的关系
6. 另外需要考虑的一点是在后端，一般会有一些审计要求，比如记录创建时间，更新时间，创建人，更新人等，所以我们需要在这些实体类中添加这些字段。这里我们简化一些，只做创建时间和更新时间的审计。

综上，实体类之间的关系如下图所示：

![图 11](http://ngassets.twigcodes.com/47c635163035b42713318b976b43b1a56800b4eea356a4f69d4fab155ba872e1.png)

## 6.3 构建实体类

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

### 6.3.1 JPA Buddy 插件

在第二章，我们介绍了 `JPA Buddy` 插件，这个插件可以帮助我们生成实体类对应的数据库表结构，事实上，我们几乎可以不手动编写实体类，只需要通过 `JPA Buddy` 插件来生成实体类，然后再根据实体类来生成数据库表结构。

![图 9](http://ngassets.twigcodes.com/0c69ad57cb68faa57d15700f03be4cd13d4679cdb012842ef19d7881bdfba880.png)

只需要右键点击 `Persistence units` 下的 `Default` 节点，选择 `New` -> `JPA Entity`。

![图 10](http://ngassets.twigcodes.com/ddd3873a48dc29c486c97640666fc149a55c24770e6d4606730a80891a05048e.png)

然后在弹出的对话框中，在 `Name` 输入框中输入实体类的名称，比如 `PageBlock`， `Package` 输入框中输入实体类所在的包名，比如 `com.twigcodes.mooc.entities`， `Language` 选择 `Java`，`Entity Type` 选择 `Entity`， `Id` 选择 `Long`，`Id generation` 选择 `Identity`，然后点击 `OK` 按钮。我们可以得到下面这个区块实体类的代码：

```java
package com.mooc.backend.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "page_block")
public class PageBlock {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

}
```

然后我们可以通过 `JPA Designer` 面板来添加实体类的其他属性

![图 12](http://ngassets.twigcodes.com/cdee38c5e806fcf24a46ecb4289b35557775fa6d09e065042da4a80ff695591c.png)

比如双击 `Basic Type` 节点，添加一个字符串类型的 `title` 字段

![图 14](http://ngassets.twigcodes.com/7435b8788874fb3422c90e59f45cd50937b2d62d4376579189b45fbfabf21a5e.png)

勾选 `Mandatory`，然后点击 `OK` 按钮，我们可以得到下面这个实体类的代码，可以看到 `title` 字段已经被添加到实体类中了。

```java
@Getter
@Setter
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlock {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "title", nullable = false)
    String title;
}
```

我们再来添加一个枚举类型的字段，在开始之前，我们先创建一个枚举类，代码如下：

```java
public enum BlockType {
    Banner("banner"),
    ImageRow("image_row"),
    ProductRow("product_row"),
    Waterfall("waterfall");

    private final String value;

    BlockType(String value) {
        this.value = value;
    }

    public static BlockType fromValue(String value) {
        for (BlockType blockType : BlockType.values()) {
            if (blockType.value.equals(value)) {
                return blockType;
            }
        }
        throw new IllegalArgumentException("Invalid BlockType value: " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
```

在实体类的分析中我们已经介绍过，这个枚举类型是用来区分不同的区块类型的，比如 `Banner` 区块， `ImageRow` 区块， `ProductRow` 区块， `Waterfall` 区块等等。

我们接下来需要在 `PageBlock` 实体类中添加一个 `type` 字段，这个字段的类型是 `BlockType` 。双击 `Enum` 节点，添加一个 `type` 字段

![图 16](http://ngassets.twigcodes.com/47eeea214c4af4c7d6f32aa18b7a152dd6a8c1f7dd534a9ffb7494ba558c6677.png)

我们想在数据库中保存时，这个字段的值是 String，所以在 `Enum type` 选择 `STRING`，这个字段仍然是不可为空，所以选择 `Mandatory`，然后点击 `OK` 按钮，可以看到 `type` 字段已经被添加到实体类中了。

```java
public class PageBlock {
    // ...
    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private BlockType type;

}
```

接下来我们完成 `PageBlock` 实体类的其他属性，包括 `sort`， `config` 等字段，这两种都可以使用 `Basic Type` 添加，但 `sort` 选择类型为 `java.lang.Integer`，`config` 选择类型为 `com.mooc.backend.entities.blocks.BlockConfig`，这个类是我们自己定义的，用来保存区块的配置信息，代码如下：

```java
@Schema(description = "区块配置")
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Jacksonized
@Getter
@EqualsAndHashCode(callSuper = false)
public class BlockConfig implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private static final String HEX_COLOR_PATTERN
            = "^#(?:(?:[\\da-f]{3}){1,2}|(?:[\\da-f]{4}){1,2})$";

    @Schema(description = "水平内边距", example = "12.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double horizontalPadding;
    @Schema(description = "垂直内边距", example = "12.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double verticalPadding;
    @Schema(description = "水平间距", example = "4.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double horizontalSpacing;
    @Schema(description = "垂直间距", example = "4.0")
    @NotNull
    @PositiveOrZero
    @DecimalMax("100.00")
    private Double verticalSpacing;
    @Schema(description = "区块宽度", example = "376.0")
    @NotNull
    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockWidth;
    @Schema(description = "区块高度", example = "94.0")
    @DecimalMin("300")
    @DecimalMax("1200.00")
    private Double blockHeight;
    @Schema(description = "区块背景颜色", example = "#ffffff")
    @Pattern(regexp = HEX_COLOR_PATTERN)
    private String backgroundColor;
    @Schema(description = "区块边框颜色", example = "#000000")
    @Pattern(regexp = HEX_COLOR_PATTERN)
    private String borderColor;
    @Schema(description = "区块边框宽度", example = "1.0")
    @DecimalMin("0.0")
    @DecimalMax("10.0")
    private Double borderWidth;
}
```

然后使用 `JPA Designer` 可以非常方便的添加 `sort` 和 `config` 字段，代码如下：

```java
public class PageBlock {
    // ...
    @Column(name = "sort", nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    @ToString.Exclude
    private BlockConfig config;
}
```

但是由于 `config` 字段我们希望以 `JSON` 的形式保存到数据库中，所以我们需要使用 `@Type` 注解来指定 `JsonType` 类型，这个类型来自于 `hypersistence` 这个包。

### 6.3.2 作业：完成区块数据，产品和类别等实体类

请使用 `JPA Designer` 完成 `PageBlockData`， `Product`， `Category` 等实体类的设计，类之间的关系暂时不需要考虑，表名前缀都是 `mooc_`。

其中类的设计请参考下图

![图 8](http://ngassets.twigcodes.com/60a25fb7b91ce1e58feac721545640ee342815d3ea6a4a1f707ed0b865b28864.png)

## 6.4 生成数据库表

### 6.4.1 自动创建数据库表

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

然后我们启动应用，可以通过 H2 数据库控制台来查看数据库表结构，如下图所示：

![图 17](http://ngassets.twigcodes.com/32586174545312e1d29b2e0365569696044eca1e80f0e85b409fd46bdc7bd2b4.png)

这个脚本可以通过 `JPA Structure` 面板中，右键点击 `PageLayout` 实体类，选择 `Show DDL...` 来生成。

![图 4](http://ngassets.twigcodes.com/6650c5cc973b48b0ee0988aff6449db8297cc19e14b250f949659d394a7156fa.png)

![图 3](http://ngassets.twigcodes.com/7659d3bd31c571501c6e0382592e554d68e9d92fba3a30adb6ea57d0dd582fbe.png)
