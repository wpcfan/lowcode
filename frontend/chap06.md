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
    - [6.3.2 作业：完成产品和类别等实体类](#632-作业完成产品和类别等实体类)
  - [6.4 生成数据库表](#64-生成数据库表)
    - [6.4.1 自动创建数据库表](#641-自动创建数据库表)
      - [6.4.1.1 Spring Data Jpa 自动建表](#6411-spring-data-jpa-自动建表)
      - [6.4.1.2 使用 Flyway 管理数据库版本](#6412-使用-flyway-管理数据库版本)
    - [6.4.2 手动创建数据库表](#642-手动创建数据库表)
      - [6.4.2.1 使用 Docker 启动 MySQL 数据库](#6421-使用-docker-启动-mysql-数据库)
      - [6.4.2.2 使用 JPA Buddy 插件生成数据库表](#6422-使用-jpa-buddy-插件生成数据库表)
  - [6.5 对象关系](#65-对象关系)
    - [6.5.1 一对多：布局/区块/数据](#651-一对多布局区块数据)
    - [6.5.2 多对多：类目和商品](#652-多对多类目和商品)
    - [6.5.3 维护方和被维护方](#653-维护方和被维护方)
    - [6.5.4 作业：实现商品和商品图片的关系](#654-作业实现商品和商品图片的关系)
    - [6.5.5 JPA 实体类测试](#655-jpa-实体类测试)
    - [6.5.5.1 作业：为实体类添加关系维护方法](#6551-作业为实体类添加关系维护方法)
    - [6.5.6 集合类型的选择](#656-集合类型的选择)
    - [6.5.7 测试验证顺序存储和读取](#657-测试验证顺序存储和读取)
    - [6.5.8 作业：改造 PageBlockData](#658-作业改造-pageblockdata)
  - [6.6 审计字段](#66-审计字段)
  - [6.7 综合实战：给 APP 首页构建 API](#67-综合实战给-app-首页构建-api)
    - [6.7.1 作业：完成 `CategoryDTO` 和 `ProductDTO` 的定义](#671-作业完成-categorydto-和-productdto-的定义)
    - [6.7.2 作业：完成 `ProductQueryService` 和 `ProductController`](#672-作业完成-productqueryservice-和-productcontroller)
  - [6.8 改造 APP 首页使用 API](#68-改造-app-首页使用-api)
    - [6.8.1 网络包改造](#681-网络包改造)
    - [6.8.2 Repository 层改造](#682-repository-层改造)

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

上面说的 `PageLayout` ， `PageBlock` 和 `PageBlockData` 三个实体对象之间都是一对多的关系

1. 一个页面布局可以由多个页面区块组成，所以 `PageLayout` 和 `PageBlock` 之间是一对多的关系
2. 一个页面区块可以有多个数据项，所以 `PageBlock` 和 `PageBlockData` 之间是一对多的关系
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

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        PageLayout other = (PageLayout) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
```

首先，我们使用了 `@Entity` 注解来标识这是一个实体类，然后我们使用 `@Table` 注解来指定这个实体类对应的数据库表，这里我们指定了表名为 `mooc_pages`。注意我们其实可以不使用 `@Table` 注解，因为默认情况下实体类的名称就是数据库表的名称，但是很多情况下，公司对于表名会有一些要求，所以我们还是使用 `@Table` 注解来指定实体类对应的数据库表。

对于不熟悉 Java 的同学，有必要说一下 `equals` 和 `hashCode` 方法，这两个方法是用来判断两个对象是否相等的，如果两个对象相等，那么它们的 `hashCode` 方法返回的值也是相等的。这两个方法是由 `Object` 类提供的，但是我们在这里重写了这两个方法，这是因为对于实体类来说，我们通常会使用它的 `id` 来判断两个实体类是否相等，所以我们在这里重写了这两个方法，让它们使用 `id` 来判断两个实体类是否相等。而 `hashCode` 方法中采用 `31` 这个数字是因为它是一个质数，这样可以减少哈希碰撞的概率。总之 JPA 的实体类基本都需要重写这两个方法，重写的方式也是一样的。

然后我们使用 `@Id` 注解来标识这个实体类的主键，用 `@GeneratedValue` 注解来指定主键的生成策略，这里我们使用 `GenerationType.IDENTITY` 来指定主键的生成策略，这样主键就会自增。

这个实体类中的属性和数据库中的字段是一一对应的，比如说 `id` 就是数据库中的主键，`title` 就是数据库中的 `title` 字段。默认情况下字段名就是属性名，如果字段名和属性名不一致的话，我们可以使用 `@Column` 注解中的 `name` 属性来指定字段名。

我们在上面代码中其实对不同的字段使用了 `@Column` 的不同属性

1. `nullable`：是否允许为空
2. `unique`：是否唯一
3. `length`：字段的长度
4. `columnDefinition`：字段的定义

我们还可以使用 `@Enumerated` 注解来指定枚举类型的字段，比如说 `platform` 和 `pageType` 就是枚举类型的字段，这里我们使用 `EnumType.STRING` 来指定它们的类型，在数据库中就会以字符串的形式存储枚举类型的字段。

| 枚举类型映射方式 | 说明                                                                        |
| ---------------- | --------------------------------------------------------------------------- |
| ORDINAL          | 默认值，使用枚举的序数来映射枚举类型，比如：`PageStatus.Draft` 映射为 `0`。 |
| STRING           | 使用枚举的名称来映射枚举类型，比如：`PageStatus.Draft` 映射为 `Draft`。     |

一般来说，我们会采用 `STRING` 策略来映射枚举类型，这样可以避免枚举类型的值发生变化时，数据库中的值也会发生变化。

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

上面的 `PageStatus` 枚举类型在序列化的时候，会使用 `name` 来表示枚举类型，比如说 `PageStatus.Draft` 的 `name` 就是 `Draft`，但这带来另一个问题，如果我们在序列化的时候，想使用 `value` 而不是 `name`，那么我们就需要自定义序列化和反序列化的逻辑，这里我们使用 `@JsonCreator` 和 `@JsonValue` 来实现自定义序列化和反序列化的逻辑，如下所示：

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

在 Spring Data JPA 中，实体类属性类型和数据库字段类型的映射关系如下：

| 实体类属性类型 | 数据库字段类型 |
| -------------- | -------------- |
| String         | VARCHAR        |
| Integer        | INT            |
| Long           | BIGINT         |
| Float          | FLOAT          |
| Double         | DOUBLE         |
| BigDecimal     | DECIMAL        |
| Boolean        | BIT            |
| Date           | DATETIME       |
| byte[]         | BLOB           |

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

在 `@GeneratedValue` 注解中，我们可以设置 `strategy` 属性来指定主键生成策略，比如：

| 主键生成策略 | 说明                                                                                       |
| ------------ | ------------------------------------------------------------------------------------------ |
| AUTO         | 主键由程序控制，是默认选项，不设置就是这个策略。                                           |
| IDENTITY     | 主键由数据库自动生成（主要是自动增长型）                                                   |
| SEQUENCE     | 通过数据库的序列产生主键，通过 `@SequenceGenerator` 注解指定序列名，MySql 不支持这种方式。 |
| TABLE        | 通过特定的数据库表产生主键。                                                               |

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

接下来我们看一下区块数据，这个相对复杂一些，因为区块数据是不固定的，我们需要根据不同的区块类型来保存不同的数据，比如 `Banner` 区块， `ImageRow` 区块， `ProductRow` 区块， `Waterfall` 区块等等，这些区块的数据都是不一样的，我们需要根据不同的区块类型来保存不同的数据。

所以我们对于 `PageBlockData` 的 `content` 使用的是 `JSON` 类型，这样就可以保存不同的数据了，代码如下：

```java
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_page_block_data")
public class PageBlockData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    private BlockData content;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "page_block_id")
    private PageBlock pageBlock;

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        PageBlockData other = (PageBlockData) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
```

但如果只是定义 `JSON` 又会过于宽泛，所以我们定义了 `BlockData` 这个接口。后面会把图片类型数据，商品类型数据以及类目类型数据都实现这个接口。

```java
public interface BlockData extends Serializable {
    BlockDataType getDataType();
}
```

上面的 `BlockDataType` 是一个枚举类型，用来标识不同的区块类型，代码如下：

```java
public enum BlockDataType {
    Category("category"),
    Product("product"),
    Image("image");

    private final String value;

    BlockDataType(String value) {
        this.value = value;
    }

    public static BlockDataType fromValue(String value) {
        for (BlockDataType blockDataType : BlockDataType.values()) {
            if (blockDataType.value.equals(value)) {
                return blockDataType;
            }
        }
        throw new IllegalArgumentException("Invalid BlockDataType value: " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
```

然后我们来分别定义以下几个数据的类型

1. 图片类数据，我们使用了 `record` 来定义，代码如下：

   ```java
   public record ImageDTO(
       @Schema(description = "图片地址", example = "http://localhost:8080/api/images/100/100/image1") @NotNull String image,
       @Schema(description = "图片地址", example = "image1") @NotNull String title,
       @NotNull Link link
   ) implements BlockData {
       @JsonProperty(access = JsonProperty.Access.READ_ONLY)
       @Override
       public BlockDataType getDataType() {
           return BlockDataType.Image;
       }

       @Override
       public boolean equals(Object o) {
           if (this == o) return true;
           if (o == null || getClass() != o.getClass()) return false;

           ImageDTO imageDTO = (ImageDTO) o;

           if (!Objects.equals(image, imageDTO.image)) return false;
           if (!Objects.equals(title, imageDTO.title)) return false;
           return Objects.equals(link, imageDTO.link);
       }

       @Override
       public int hashCode() {
           int result = image != null ? image.hashCode() : 0;
           result = 31 * result + (title != null ? title.hashCode() : 0);
           result = 31 * result + (link != null ? link.hashCode() : 0);
           return result;
       }
   }
   ```

2. 类似的商品类数据代码如下

   ```java
   public record ProductDataDTO(
       Long id,
       String sku,
       String name,
       String description,
       String originalPrice,
       String price,
       Set<CategoryDTO> categories,
       Set<String> images
   ) implements BlockData {
       @Serial
       private static final long serialVersionUID = -1;

       public static ProductDataDTO fromEntity(Product product) {
           return new ProductDataDTO(
                   product.getId(),
                   product.getSku(),
                   product.getName(),
                   product.getDescription(),
                   MathUtils.formatPrice(product.getOriginalPrice()),
                   MathUtils.formatPrice(product.getPrice()),
                   product.getCategories().stream().map(CategoryDTO::fromEntity).collect(Collectors.toSet()),
                   product.getImages().stream().map(ProductImage::getImageUrl).collect(Collectors.toSet())
           );
       }

       @JsonProperty(access = JsonProperty.Access.READ_ONLY)
       @Override
       public BlockDataType getDataType() {
           return BlockDataType.Product;
       }

       @Override
       public boolean equals(Object obj) {
           if (this == obj)
               return true;
           if (obj == null)
               return false;
           if (getClass() != obj.getClass())
               return false;
           ProductDataDTO other = (ProductDataDTO) obj;
           if (id == null) {
               return other.id == null;
           } else return id.equals(other.id);
       }

       @Override
       public int hashCode() {
           final int prime = 31;
           int result = 1;
           result = prime * result + ((id == null) ? 0 : id.hashCode());
           return result;
       }
   }
   ```

3. 类目类型的数据使用传统的 `class` 定义，大家可以体会一下区别

   ```java
   @Getter
   @Builder
   @NoArgsConstructor
   @AllArgsConstructor
   public class CategoryDTO implements BlockData, Comparable<CategoryDTO> {

       @Serial
       private static final long serialVersionUID = -1;
       private Long id;
       private String name;
       private String code;
       private Long parentId;

       @Builder.Default
       private SortedSet<CategoryDTO> children = new TreeSet<>();

       public static CategoryDTO fromEntity(Category category) {
           return CategoryDTO.builder()
                   .id(category.getId())
                   .name(category.getName())
                   .code(category.getCode())
                   .parentId(category.getParent() != null ? category.getParent().getId() : null)
                   .children(category.getChildren().stream()
                           .map(CategoryDTO::fromEntity)
                           .collect(TreeSet::new, Set::add, Set::addAll))
                   .build();
       }

       public Category toEntity() {
           var category = Category.builder()
                   .name(getName())
                   .code(getCode())
                   .build();
           Optional.ofNullable(getChildren()).orElse(new TreeSet<>()).forEach(child -> category.addChild(child.toEntity()));
           return category;
       }

       @JsonProperty(access = JsonProperty.Access.READ_ONLY)
       @Override
       public BlockDataType getDataType() {
           return BlockDataType.Category;
       }

       @Override
       public int compareTo(CategoryDTO o) {
           return this.getName().compareTo(o.getName());
       }

       @Override
       public boolean equals(Object obj) {
           if (this == obj)
               return true;
           if (obj == null)
               return false;
           if (getClass() != obj.getClass())
               return false;
           CategoryDTO other = (CategoryDTO) obj;
           if (id == null) {
               return other.id == null;
           } else return id.equals(other.id);
       }

       @Override
       public int hashCode() {
           final int prime = 31;
           int result = 1;
           result = prime * result + ((id == null) ? 0 : id.hashCode());
           return result;
       }
   }
   ```

### 6.3.2 作业：完成产品和类别等实体类

请使用 `JPA Designer` 完成 `Product`， `Category` 等实体类的设计，类之间的关系暂时不需要考虑，表名前缀都是 `mooc_`。暂时不需要考虑 `Auditable` 接口，这个是审计接口，我们后面会讲到。

其中类的设计请参考下图

![图 8](http://ngassets.twigcodes.com/60a25fb7b91ce1e58feac721545640ee342815d3ea6a4a1f707ed0b865b28864.png)

## 6.4 生成数据库表

### 6.4.1 自动创建数据库表

#### 6.4.1.1 Spring Data Jpa 自动建表

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

点击 `Connect` 按钮，可以看到数据库中已经有了 `mooc_page_layout`，`mooc_page_block`，`mooc_page_block_data` 等表。

![图 18](http://ngassets.twigcodes.com/d1368f60966cf95e4389c1fd7695af3c84ea42f64478ceb132a6d22c1ef57439.png)

#### 6.4.1.2 使用 Flyway 管理数据库版本

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

### 6.4.2 手动创建数据库表

如果我们不想使用 Spring Data JPA 自动创建数据库表，这个地方，我们就使用一种更流行的数据库 MySQL ，我们可以使用 `JPA Structure` 面板来生成数据库表的创建语句，然后手动执行这些语句来创建数据库表。

#### 6.4.2.1 使用 Docker 启动 MySQL 数据库

首先我们需要一个 `docker-compose.yml` 文件，用来启动 MySQL 数据库，如下所示：

```yaml
version: "3.7"

services:
  # MySQL 服务
  mysql:
    # 使用 mysql 8.x 镜像
    image: mysql:8
    # 容器名称
    container_name: mysql
    # 重启策略
    restart: always
    # 环境变量
    environment:
      MYSQL_ROOT_PASSWORD: root # 设置 root 用户的密码
      MYSQL_DATABASE: low_code # 创建默认数据库，数据库名为 low_code
      MYSQL_USER: user # 创建默认用户，用户名为 user
      MYSQL_PASSWORD: password # 设置默认用户的密码
    ports:
      - "3306:3306" # host:container
    # 挂载数据卷
    volumes:
      - mysql:/var/lib/mysql # 将容器中的 /var/lib/mysql 目录挂载到宿主机的 mysql 目录下
  # Adminer 服务，用于管理 MySQL 数据库
  adminer:
    # 不加版本号，使用 adminer 的最新镜像
    image: adminer
    container_name: adminer
    # 重启策略
    restart: always
    ports:
      - "8081:8080" # host:container
    environment:
      ADMINER_DEFAULT_SERVER: mysql # 设置 Adminer 默认连接的数据库服务器为 mysql，即上面的 MySQL 服务
# 数据卷
volumes:
  # 数据卷名称
  mysql:
    # 数据卷驱动
    driver: local
```

点击 `services` 左边的启动按钮，就可以启动 MySQL 数据库了。

![图 22](http://ngassets.twigcodes.com/cb84997d8a4069cebd75e86dcef5b0621dfd7289966e557ee9dd0b2ca553fc8e.png)

#### 6.4.2.2 使用 JPA Buddy 插件生成数据库表

这个脚本可以通过 `JPA Structure` 面板中。

![图 4](http://ngassets.twigcodes.com/6650c5cc973b48b0ee0988aff6449db8297cc19e14b250f949659d394a7156fa.png)

右键点击 `PageLayout` 实体类，选择 `Show DDL...` 来生成

![图 3](http://ngassets.twigcodes.com/7659d3bd31c571501c6e0382592e554d68e9d92fba3a30adb6ea57d0dd582fbe.png)

然后选择 `DB Type` 为 `MySQL`，然后点击 `OK` 按钮，就可以生成数据库表的创建语句。

![图 19](http://ngassets.twigcodes.com/e204adc1108bd0bea5435ebce0cb4d24d5b3bf68bd9819d50b65f0f4ca9bcb71.png)

```sql
CREATE TABLE mooc_pages
(
    id         BIGINT AUTO_INCREMENT NOT NULL,
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

拷贝这个脚本，然后在 `JPA Structure` 面板中右键点击 `DB connections`，选择 `New` -> `DB Connection`。

![图 20](http://ngassets.twigcodes.com/264cfb41bdf6320ea50da78ad76b931ca73da482ed018f178e80fda733f59f75.png)

然后在弹出的对话框中，选择 `MySQL`，然后在 `用户` 输入框填写 `user`，在 `密码` 输入框填写 `password`，数据库填写 `low_code`，然后点击 `OK` 按钮。

![图 21](http://ngassets.twigcodes.com/aaabefbf332ff61d9034aca415cd04dc08f7b01c4c1b087c29385c97222290d8.png)

然后在右侧的 `数据库` 面板中，就可以看到 `low_code` 数据库了。

![图 23](http://ngassets.twigcodes.com/2fbc3a593825e88db18541c197ecf093fa5f5a50f478097cde846dbacb0189b6.png)

然后右键点击 `low_code` 数据库，选择 `新建` -> `查询控制台`。

![图 24](http://ngassets.twigcodes.com/34177a39a410eec3035c2fd63181ceb6e12ceedcf4b1004104d63dca6b297cb7.png)

点击执行，即可创建数据库表。

![图 25](http://ngassets.twigcodes.com/70ca5cef30f72c3bf7d8da9978f1f5febbd73ef07be58855c3e506d4562be5ed.png)

## 6.5 对象关系

### 6.5.1 一对多：布局/区块/数据

在 Spring Data JPA 中，我们可以使用 `@ManyToOne`、`@OneToOne`、`@OneToMany`、`@ManyToMany` 注解来标注实体类之间的关联关系。

我们先来看一个例子， `PageLayout` 和 `PageBlock` 是一对多的关系，一个页面可以有多个区块，一个区块只能属于一个页面。

那么在 `PageLayout` 中可以定义一个 `Set<PageBlock>` 类型的属性 ` pageBlocks`

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
    // ...
    // 一对多，对于有初始值的属性，在有 @Builder 注解的类中
    // 需要使用 @Builder.Default 注解
    @OneToMany(mappedBy = "page")
    @ToString.Exclude
    @Builder.Default
    private Set<PageBlock> pageBlocks = new HashSet<>();
    // ...
}
```

在 `PageBlock` 中可以定义 `PageLayout` 类型的元素 `page`，但是这里关系是反过来的，所以需要使用 `@ManyToOne` 注解来标注。

```java
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlock {
    // ...
    @ManyToOne
    @JoinColumn(name = "page_id")
    private PageLayout page;
    // ...
}
```

可以看到一般来说定义关系的时候，都是在多的一方定义一个一的一方的类型的元素，然后在一的一方定义一个多的一方的类型的集合。在 `@OneToMany(mappedBy = "page")` 中，`mappedBy` 表示的是多的一方也就是 `PageBlock` 中的 `page`。在 `PageBlock` 中的 `page` 属性的 `@JoinColumn(name = "page_id")` 表示的是在 `PageBlock` 表中的 `page_id` 列是外键，指向 `PageLayout` 表中的 `id` 列。

如果这时候，我们看一下生成的 `sql` ，可以看到 `PageBlock` 表中有 `page_id` 列，而且是外键引用了 `mooc_pages` 的 `id`。

```sql
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
```

接下来我们可以同样定义 `PageBlock` 和 `PageBlockData` 之间的关系，`PageBlock` 和 `PageBlockData` 是一对多的关系，一个区块可以有多个数据项。

首先在 `PageBlock` 中定义一个 `Set<PageBlockData>` 类型的属性 `data`

```java
public class PageBlock {
    // ...
    @OneToMany(mappedBy = "pageBlock")
    @ToString.Exclude
    @Builder.Default
    private Set<PageBlockData> data = new HashSet<>();
    // ...
}
```

然后在 `PageBlockData` 中定义一个 `PageBlock` 类型的属性 `pageBlock`，同样的，由于这里关系是反过来的，所以需要使用 `@ManyToOne` 注解来标注。

```java
public class PageBlockData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    private BlockData content;

    @ManyToOne
    @JoinColumn(name = "page_block_id")
    private PageBlock pageBlock;
    // ...
}
```

如果要是自身的引用，比如 `Category` 和 `Category` 之间的关系，那么可以定义一个 `Category` 类型的属性 `parent`，然后在 `Category` 中定义一个 `Set<Category>` 类型的属性 `children`。

```java
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_categories")
public class Category extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String code;

    @Column(nullable = false)
    private String name;

    @ManyToOne
    // @JoinColumn 这个注解是用来指定外键的
    // 如果不指定，会默认使用外键名为：实体名_主键名
    // @JoinColumn(name = "parent_id")
    private Category parent;

    @OneToMany(mappedBy = "parent")
    @ToString.Exclude
    @Builder.Default
    private Set<Category> children = new HashSet<>();

    // ...
}
```

### 6.5.2 多对多：类目和商品

`Category` 和 `Product` 是多对多的关系，一个分类可以有多个产品，一个产品可以属于多个分类。那么对于这种情况我们怎么处理呢？

```java
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String sku;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false)
    private String description;

    @Column(name = "original_price", precision = 10, scale = 2)
    private BigDecimal originalPrice;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    /**
     * 定义多对多关系
     */
    @ManyToMany
    @JoinTable(
            name = "mooc_product_categories",
            joinColumns = @JoinColumn(name = "product_id", referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "category_id", referencedColumnName = "id")
    )
    @ToString.Exclude
    @Builder.Default
    private Set<Category> categories = new HashSet<>();

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Product other = (Product) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
```

`@ManyToMany` 表示多对多的关系，`@JoinTable` 表示中间表的定义，`joinColumns` 表示的是当前实体在中间表中的外键，`inverseJoinColumns` 表示的是另一个实体在中间表中的外键。在这个例子中，`Product` 在中间表中的外键是 `product_id`，`Category` 在中间表中的外键是 `category_id`。

在 `Category` 中，`products` 属性其实是可选的，因为我们在 `Product` 中已经定义了关系，所以在 `Category` 中可以不用有这个属性。

当然如果你确实有这个需求，比如说在编辑类别的时候，可以列出全部产品，那可以有这个属性，但一般来说一个类别下的产品会很多，每次查询都关联出来产品列表，其实不是很好。我们其实可以通过查询指定类别的产品来实现这个功能，后面我们讲到 Repository 的时候会讲到。

如果需要 `Category` 中有 `products` 属性，那么可以这样定义：

```java
public class Category {
    @ManyToMany(mappedBy = "categories")
    @ToString.Exclude
    @Builder.Default
    private Set<Product> products = new HashSet<>();
}
```

`@ManyToMany` 中的 `mappedBy` 是另一个实体 是 `Product` 中的 `categories` 属性。

### 6.5.3 维护方和被维护方

在上面的例子中，我们可以看到，`Product` 和 `Category` 是多对多的关系，那么在这个关系中，`Product` 是维护方，`Category` 是被维护方。那么什么是维护方，什么是被维护方呢？

在 JPA 中，实体类之间的关系可以分为双向关系和单向关系。双向关系中，两个实体类都可以访问对方，而单向关系中，只有一个实体类可以访问另一个实体类。在双向关系中，我们需要确定关系的维护方（owning side）和被维护方（inverse side）。关系的维护方负责更新数据库中的外键值，而被维护方则不负责更新。

确定关系的维护方时，可以遵循以下原则：

对于 `@OneToOne` 和 `@ManyToMany` 关系，通常可以任意选择一方作为关系的维护方。在这种情况下，选择哪一方作为维护方主要取决于业务逻辑和实际需求。

对于 `@OneToMany` 和 `@ManyToOne` 关系，通常将多方（即包含 `@ManyToOne` 注解的实体类）作为关系的维护方。这是因为在多对一关系中，多方实体类中的外键列用于引用一方实体类的主键，因此多方实体类需要负责更新外键值。

在双向关系中，关系的维护方使用 `@JoinColumn` 注解来指定外键列名，而被维护方则使用 `mappedBy` 属性来指定关系的维护方。例如，在 `PageLayout` 和 `PageBlock` 的关系中，`PageBlock` 是关系的维护方，因此在 `PageBlock` 中使用 `@JoinColumn` 注解来指定外键列名，而在 `PageLayout` 中使用 `mappedBy` 属性来指定关系的维护方。

```java
@Entity
@Table(name = "mooc_pages")
public class Author {
    // ...

    @OneToMany(mappedBy = "page")
    private Set<PageBlock> pageBlocks = new HashSet<>();
}

@Entity
@Table(name = "mooc_page_blocks")
public class PageBlock {
    // ...

    @ManyToOne
    @JoinColumn(name = "page_id")
    private PageLayout page;
}
```

### 6.5.4 作业：实现商品和商品图片的关系

商品和商品图片是一对多的关系，一个商品可以有多个商品图片，一个商品图片只能属于一个商品。商品图片的基础信息如下：

```java
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_product_images")
public class ProductImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ProductImage other = (ProductImage) obj;
        if (id == null) {
            return other.id == null;
        } else return id.equals(other.id);
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        return result;
    }
}
```

请改造 `Product` 和 `ProductImage` 的关系，使得 `Product` 和 `ProductImage` 之间可以建立一对多的关系。

### 6.5.5 JPA 实体类测试

我们还没有写 JPA Repository，但是我们可以先写一个 JPA 实体类测试，来验证我们的实体类是否正确。

```java
@SpringBootTest
public class JpaEntityTest {
    @Autowired
    private EntityManager entityManager;

    @Test
    void testJpaEntities() {
        Product product = Product.builder()
                .sku("sku_001")
                .name("iPhone 12")
                .description("Apple iPhone 12")
                .price(BigDecimal.valueOf(6999))
                .build();
        ProductImage productImage = ProductImage.builder()
                .imageUrl("https://example.com/iphone12.jpg")
                .build();
        productImage.setProduct(product);
        product.getImages().add(productImage);

        entityManager.persist(product);
        entityManager.persist(productImage);

        entityManager.flush();

        var foundProduct = entityManager.find(Product.class, product.getId());
        assertEquals(product, foundProduct);
    }
}
```

需要介绍一下 `EntityManager`，它是 JPA 的核心接口，用于管理实体类和数据库之间的映射关系。我们可以通过 `EntityManager` 的 `persist` 方法来将实体类保存到数据库中，通过 `find` 方法来从数据库中查询实体类。`flush` 方法用于将实体类的变更同步到数据库中。

我们分别将 `product` 和 `productImage` 保存到数据库中，然后通过 `find` 方法来查询 `product`，并验证查询结果是否正确。

值得说明的是

- 我们在 `productImage` 中设置了 `product`，并将 `productImage` 添加到 `product` 的 `images` 集合中，这是为了建立 `product` 和 `productImage` 之间的关系。可能你会问，是否两边都要设置呢？仅仅从数据库的角度来看，答案是不需要，因为我们在 `ProductImage` 中使用了 `@ManyToOne` 注解，这意味着 `ProductImage` 是关系的维护方，因此我们只需要在 `ProductImage` 中设置 `product` 即可，因为维护方负责更新数据库中的外键值。为了保持对象模型的一致性，建议在保存时分别给两个实体类添加关联关系。

- 我们对于关系的维护方和被维护方的选择，我们选择了 `productImage` 作为关系的维护方，因此我们先保存 `product`，再保存 `productImage`。

![图 26](http://ngassets.twigcodes.com/a270cbb78da8d2da0accfe79d2db72fd794ec4a60b7580a888c454fcc4a89e9b.png)

这提示我们，在方法中我们使用了 `entityManager.persist` 方法，但没有使用事务，所以我们需要在测试类或者测试方法上添加 `@Transactional` 注解。

```java
@SpringBootTest
class BackendApplicationTests {
    @Autowired
    private EntityManager entityManager;

    @Test
    @Transactional
    void testJpaEntities() {
        Product product = Product.builder()
                .sku("sku_001")
                .name("iPhone 12")
                .description("Apple iPhone 12")
                .price(BigDecimal.valueOf(6999))
                .build();
        ProductImage productImage = ProductImage.builder()
                .imageUrl("https://example.com/iphone12.jpg")
                .build();
        // 写入外键，维护关系
        productImage.setProduct(product);
        // 为了保证数据一致，与数据库本身变化无关
        product.getImages().add(productImage);

        entityManager.persist(product);
        entityManager.persist(productImage);

        entityManager.flush();

        var foundProduct = entityManager.find(Product.class, product.getId());
        assertEquals(product, foundProduct);
    }

}
```

为了写入外键，我们需要在 `productImage` 中设置 `product`，为了保证数据一致，我们需要在 `product` 中添加 `productImage`。这段逻辑其实对于实体类是非常普遍的，因为我们可以添加一些辅助方法来简化这段逻辑。

```java
public class Product {
    // ...
    public void addImage(ProductImage image) {
        images.add(image);
        image.setProduct(this);
    }

    public void removeImage(ProductImage image) {
        images.remove(image);
        image.setProduct(null);
    }
}
```

这样的话，我们就可以将上面的代码简化为

```java
@SpringBootTest
class BackendApplicationTests {
    @Autowired
    private EntityManager entityManager;

    @Test
    @Transactional
    void testJpaEntities() {
        Product product = Product.builder()
                .sku("sku_001")
                .name("iPhone 12")
                .description("Apple iPhone 12")
                .price(BigDecimal.valueOf(6999))
                .build();
        ProductImage productImage = ProductImage.builder()
                .imageUrl("https://example.com/iphone12.jpg")
                .build();
        product.addImage(productImage);

        entityManager.persist(product);
        entityManager.persist(productImage);

        entityManager.flush();

        var foundProduct = entityManager.find(Product.class, product.getId());
        assertEquals(product, foundProduct);
    }

}
```

这样做的好处是，我们可以将关系的维护逻辑封装到实体类中，这样我们在使用的时候就不需要关心维护逻辑，只需要调用相应的方法即可。

### 6.5.5.1 作业：为实体类添加关系维护方法

请按上面的方式为 `Category` 和 `Product` 添加关系维护方法。其中有两对关系

1. `Category` 和 `Product` 之间的关系

2. `Category` 和自身之间的关系

### 6.5.6 集合类型的选择

在构建实体关系的时候，我们经常会遇到一对多的关系，比如一个商品可以有多个商品图片，一个商品图片只能属于一个商品。在这种情况下，我们可以使用 `Set` 或者 `List` 来表示一对多的关系。

一般而言， `Set` 的性能要优于 `List`，因为

1. `Set` 是基于哈希表实现的，而 `List` 是基于数组实现的。

2. 而且不能忽略的是 `Set` 生成的 `SQL` 语句比 `List` 生成的 `SQL` 更高效。

但 `Set` 不能保证元素的顺序，如果我们需要保证元素的顺序，那么我们可以使用 `SortedSet`，它可以保证元素的顺序。

```java
@Entity
@Table(name = "mooc_pages")
public class PageLayout {
    // ...
    @OneToMany(mappedBy = "page")
    @ToString.Exclude
    @Builder.Default
    private SortedSet<PageBlock> pageBlocks = new TreeSet<>();
}
```

但这样的话，要求 `PageBlock` 实现 `Comparable<PageBlock>` 接口。

```java
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlock implements Comparable<PageBlock> {
    // ...
    @Override
    public int compareTo(PageBlock o) {
        return this.getSort() - o.getSort();
    }
}
```

这样的话，我们就可以保证 `PageBlock` 的顺序了。

### 6.5.7 测试验证顺序存储和读取

我们可以写一个测试来验证顺序存储和读取。

```java
@SpringBootTest
class BackendApplicationTests {
    @Autowired
    private EntityManager entityManager;

    @Test
    @Transactional
    void testSetOrder() {
        var pageConfig = PageConfig.builder()
                .baselineScreenWidth(400.0)
                .horizontalPadding(12.0)
                .verticalPadding(12.0)
                .build();
        PageLayout pageLayout = PageLayout.builder()
                .title("首页")
                .pageType(PageType.Home)
                .platform(Platform.App)
                .status(PageStatus.Draft)
                .config(pageConfig)
                .build();
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(12.0)
                .blockWidth(375.0)
                .blockHeight(200.0)
                .horizontalSpacing(0.0)
                .verticalSpacing(0.0)
                .build();
        PageBlock pageBlock1 = PageBlock.builder()
                .title("轮播图")
                .type(BlockType.Banner)
                .config(blockConfig)
                .sort(2) // 此处顺序为 2
                .build();
        PageBlock pageBlock2 = PageBlock.builder()
                .title("商品列表")
                .type(BlockType.ProductRow)
                .config(blockConfig)
                .sort(1) // 此处顺序为 1
                .build();

        pageBlock1.setPage(pageLayout);
        pageBlock2.setPage(pageLayout);
        // 先添加顺序为 2 的 pageBlock1，再添加顺序为 1 的 pageBlock2
        pageLayout.getPageBlocks().add(pageBlock1);
        pageLayout.getPageBlocks().add(pageBlock2);
        entityManager.persist(pageLayout);
        entityManager.persist(pageBlock1);
        entityManager.persist(pageBlock2);

        entityManager.flush();

        var foundPageLayout = entityManager.find(PageLayout.class, pageLayout.getId());
        assertEquals(pageLayout, foundPageLayout);
        assertEquals(2, foundPageLayout.getPageBlocks().size());
        // 第一个元素的顺序为 1
        assertEquals(pageBlock2, foundPageLayout.getPageBlocks().iterator().next());
    }

}
```

上面代码中，我们先添加顺序为 2 的 `pageBlock1`，再添加顺序为 1 的 `pageBlock2`，但是在读取的时候，我们发现第一个元素的顺序为 1，这说明 `SortedSet` 会自动帮我们排序。

### 6.5.8 作业：改造 PageBlockData

同样的，区块的数据项也是有顺序的

1. 改造 `PageBlock` 中的 `data` 类型

2. 让 `PageBlockData` 实现 `Comparable<PageBlockData>` 接口

3. 测试验证顺序存储和读取

## 6.6 审计字段

在后端开发中，我们经常会遇到一些审计字段，比如创建时间、更新时间、创建人、更新人等。Spring Boot 为我们提供了 `@CreatedDate`、`@LastModifiedDate`、`@CreatedBy`、`@LastModifiedBy` 注解，我们可以使用这些注解来实现审计字段。一旦使用这些注解，我们就不需要在代码中手动设置这些字段了，Spring Boot 会自动帮我们设置。也就是几乎不需要写代码就可以实现这些字段的更新。

在本课程中我们只使用 `@CreatedDate` 和 `@LastModifiedDate`，其他的注解我们不使用。因为 `@CreatedBy` 和 `@LastModifiedBy` 需要我们实现 `AuditorAware` 接口，这个接口的作用是获取当前用户，但是我们的课程中没有用户系统，所以我们不使用这两个注解。

启用审计字段的步骤如下：

1. 在 `Application` 类上添加 `@EnableJpaAuditing` 注解

2. 在实体类中添加 `@EntityListeners(AuditingEntityListener.class)` 注解

3. 在实体类中添加 `@CreatedDate` 和 `@LastModifiedDate` 注解

由于我们在每个需要的实体类都要添加 `@CreatedDate` 和 `@LastModifiedDate` 注解，所以我们可以创建一个基类，然后让所有的实体类都继承这个基类。

```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class Auditable {

    @CreatedDate
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime updatedAt;

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}
```

然后我们让 `PageLayout`、`Product`、`Category` 以及 `ProductImage` 继承这个基类。

```java
public class PageLayout extends Auditable {
    // ...
}

public class Product extends Auditable {
    // ...
}

public class Category extends Auditable {
    // ...
}

public class ProductImage extends Auditable {
    // ...
}
```

`PageBlock` 和 `PageBlockData` 不需要审计字段的原因是，这两个实体类是通过 `PageLayout` 来维护的，所以我们只需要在 `PageLayout` 中添加审计字段即可。

## 6.7 综合实战：给 APP 首页构建 API

由于之前我们已经构建了 `PageLayoutRepository`，所以我们可以直接使用这个仓储来构建 API。按 Java 的习惯模式，我们在 `Service` 层中定义一个 `PageQueryService` 类，然后在这个类中定义一个 `findPublished` 方法，这个方法用来查询已发布的页面布局。

```java
@RequiredArgsConstructor
@Service
public class PageQueryService {
    private final EntityManager entityManager;

    @Transactional(readOnly = true)
    public Optional<PageLayout> findPublished(Platform platform, PageType pageType) {
        var now = LocalDateTime.now();
        var query = entityManager.createQuery(
                """
                select pl from PageLayout pl
                where pl.platform = :platform
                and pl.pageType = :pageType
                and pl.startTime <= :now
                and pl.endTime >= :now
                order by pl.startTime desc
                """,
                PageLayout.class
        );
        query.setParameter("platform", platform);
        query.setParameter("pageType", pageType);
        query.setParameter("now", now);
        var stream = query.getResultStream();
        return stream.findFirst();
    }
}
```

上面代码中，我们使用 `EntityManager` 来构建查询语句，然后使用 `getResultStream` 方法来获取查询结果的流，最后使用 `findFirst` 方法来获取第一个元素。查询语句中的 `:platform`、`:pageType` 和 `:now` 是占位符，我们可以使用 `setParameter` 方法来设置这些占位符的值。

然后我们需要在 `PageController` 中定义一个 `findPublished` 方法，这个方法用来接收请求，然后调用 `PageQueryService` 的 `findPublished` 方法来查询数据，最后将查询到的数据返回给客户端。

```java
package com.mooc.backend.rest.app;

import com.mooc.backend.dtos.PageDTO;
import com.mooc.backend.enumerations.Errors;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.error.CustomException;
import com.mooc.backend.services.PageQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@Tag(name = "页面", description = "获取页面信息")
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/v1/app/pages")
public class PageController {

    final PageQueryService pageQueryService;

    @Operation(summary = "根据 pageType 获取页面信息")
    @GetMapping("/published/{pageType}")
    public PageDTO findPublished(
            @Parameter(description = "页面类型", name = "pageType") @PathVariable PageType pageType,
            @Parameter(description = "平台类型", name = "platform") @RequestParam(defaultValue = "App") Platform platform) {
        return pageQueryService.findPublished(platform, pageType)
                .map(PageDTO::fromEntity)
                .orElseThrow(() -> new CustomException("Page not found", "PageController#findPublished",
                        Errors.DataNotFoundException.code()));
    }
}
```

这里我们使用了 `@GetMapping("/published/{pageType}")` 注解来标记这个方法是一个 `GET` 请求，请求的路径是 `/published/{pageType}`，其中 `{pageType}` 是一个路径参数，这个参数会被传递到 `findPublished` 方法中。另外我们使用了 `@RequestParam(defaultValue = "App")` 注解来标记 `platform` 参数是一个查询参数，如果客户端没有传递这个参数，那么就使用默认值 `App`。

值得指出的的是，我们没有直接返回 `PageLayout` 实体，而是返回了 `PageDTO`，这是因为我们不希望直接将实体返回给客户端，而是希望将实体转换为 `DTO`，然后再返回给客户端。这是因为有很多情况下，我们不希望暴露所有的属性，而是只暴露部分属性，这样可以提高安全性，同时也会减少数据的传输量，提高性能。

这个 `PageDTO` 的定义如下：

```java
package com.mooc.backend.dtos;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.entities.blocks.PageConfig;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import lombok.Builder;
import lombok.Getter;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.SortedSet;
import java.util.TreeSet;

@Getter
@Builder
public class PageDTO implements Serializable {
    @Serial
    private static final long serialVersionUID = -1;
    private Long id;
    private String title;
    private Platform platform;
    private PageType pageType;
    private PageConfig config;
    @Builder.Default
    private SortedSet<PageBlock> blocks = new TreeSet<>();
    /**
     * 页面启用时间，只有在启用时间之后，且处于已发布状态下才会显示给用户
     */
    private LocalDateTime startTime;

    /**
     * 页面失效时间，只有在失效时间之前，且处于已发布状态下才会显示给用户
     */
    private LocalDateTime endTime;

    private PageStatus status;

    public static PageDTO fromEntity(PageLayout page) {
        return PageDTO.builder()
                .id(page.getId())
                .title(page.getTitle())
                .platform(page.getPlatform())
                .pageType(page.getPageType())
                .config(page.getConfig())
                .blocks(page.getPageBlocks())
                .startTime(page.getStartTime())
                .endTime(page.getEndTime())
                .status(page.getStatus())
                .build();
    }

    public PageLayout toEntity() {
        return PageLayout.builder()
                .title(getTitle())
                .platform(getPlatform())
                .pageType(getPageType())
                .config(getConfig())
                .pageBlocks(getBlocks())
                .build();
    }
}
```

对比 `PageLayout` 实体，我们可以看到 `PageDTO` 中的属性没有审计字段，这是因为 App 角度不需要知道这些字段。另外我们还定义了一个 `fromEntity` 方法，这个方法用来将 `PageLayout` 实体转换为 `PageDTO`，这样就可以将实体转换为 `DTO`，然后再返回给客户端。另外我们还定义了一个 `toEntity` 方法，这个方法用来将 `PageDTO` 转换为 `PageLayout` 实体，这样就可以将 `DTO` 转换为实体，然后再保存到数据库中。这两个方法在构建 DTO 的时候是非常常见的，后面我们还会经常用到。

### 6.7.1 作业：完成 `CategoryDTO` 和 `ProductDTO` 的定义

在上面的例子中，我们已经完成了 `PageDTO` 的定义，现在我们需要完成 `CategoryDTO` 和 `ProductDTO` 的定义，这两个 DTO 的定义和 `PageDTO` 的定义非常类似，你可以参考 `PageDTO` 的定义来完成这两个 DTO 的定义。

提示：

1. 对于 `CategoryDTO` 我们不希望出现 `parent` 属性，因为这个属性会导致循环引用，所以我们需要将这个属性去掉。我们可以添加一个 `parentId` 属性，这个属性用来保存父分类的 ID。
2. `CategoryDTO` 的 `children` ，我们可能需要使用递归来完成，因为这个属性是一个树形结构，我们需要对这个集合的每个元素进行处理，然后再将处理后的结果添加到这个集合中。
3. `ProductDTO` 的 `images` 属性是一个字符串的集合，所以需要从 `ProductImage` 集合中获取到所有的图片的 URL，然后再将这些 URL 添加到 `images` 集合中。

### 6.7.2 作业：完成 `ProductQueryService` 和 `ProductController`

我们需要完成瀑布流商品的查询，这个查询需要分页。

- `ProductQueryService` 需要返回一个 `Slice<Product>`，这个类型是 Spring Data JPA 中的一个分页类型，这个类型中包含了分页的信息，以及当前页的数据。后面我们会详细讲解。对于分页的查询，在 Spring Data JPA 一般会需要传入一个 `Pageable` 对象，这个对象中包含了分页的信息，比如当前页码，每页的数据量等。在 Spring Data JPA 中，我们可以使用 `PageRequest.of(page, size)` 来创建一个 `Pageable` 对象，其中 `page` 是页码，`size` 是每页的数据量。在 `ProductQueryService` 中，我们需要使用 `setFirstResult` 和 `setMaxResults` 方法来设置分页的信息，这两个方法的参数分别是 `pageable.getOffset()` 和 `pageable.getPageSize()`。

- `ProductQueryService` 需要的查询语句如下：

  ```sql
  select p from Product p left join p.categories c where c.id = :id
  ```

- `ProductController` 中的 `getProductsByCategory` 方法需要使用 `ProductQueryService` 来查询数据，然后再将查询到的数据转换为 `ProductDTO`，最后再返回给客户端。

- `ProductController` 的 API 路径为 `/by-category/{id}/page`，其中 `{id}` 是分类的 ID，除了 `{id}` 之外，还需要传入 `page` 和 `size` 参数，这两个参数分别是页码和每页的数据量，如果方法的参数中有 `Pageable pageable`，那么 Spring MVC 会自动将 `page` 和 `size` 参数转换为 `Pageable` 对象，然后再传入到方法中。

- 如果我们直接返回 `Slice` 对象，那么 Spring MVC 会自动将 `Slice` 对象转换为 JSON，这个 JSON 非常复杂，这个结构类似于下面的样子：

  ```json
  {
    "first": true,
    "last": true,
    "size": 0,
    "content": [
      {
        "id": 0,
        "sku": "string",
        "name": "string",
        "description": "string",
        "originalPrice": 0,
        "price": 0,
        "categories": [
          {
            "id": 0,
            "name": "string",
            "code": "string",
            "parentId": 0,
            "children": ["string"],
            "dataType": "category"
          }
        ],
        "images": ["string"]
      }
    ],
    "number": 0,
    "sort": {
      "empty": true,
      "unsorted": true,
      "sorted": true
    },
    "pageable": {
      "offset": 0,
      "sort": {
        "empty": true,
        "unsorted": true,
        "sorted": true
      },
      "paged": true,
      "unpaged": true,
      "pageNumber": 0,
      "pageSize": 0
    },
    "numberOfElements": 0,
    "empty": true
  }
  ```

- 但这个结构显然过于臃肿，我们需要构建一个自己的 JSON 结构，这个结构类似于下面的样子，大家可以自己探索一下应该如何构建，可以参考 `SliceWrapper.java` ：

  ```json
  {
    "data": [
      {
        "id": 0,
        "sku": "string",
        "name": "string",
        "description": "string",
        "originalPrice": 0,
        "price": 0,
        "categories": [
          {
            "id": 0,
            "name": "string",
            "code": "string",
            "parentId": 0,
            "children": ["string"],
            "dataType": "category"
          }
        ],
        "images": ["string"]
      }
    ],
    "page": 0,
    "size": 0,
    "hasNext": true
  }
  ```

## 6.8 改造 APP 首页使用 API

### 6.8.1 网络包改造

我们需要对网络包进行改造，这样才能够使用新的 API。首先对于 App 的 API，我们在后端定义的路径前缀是 `api/v1/app` 。针对这些 App 可以使用的 API，我们有必要单独创建一个 Dio 实例，这样做的好处有几个

1. 可以为这些 API 单独添加缓存拦截器，这样可以避免重复请求
2. 可以统一管理这些 API 的请求头，比如 Content-Type 和 Accept
3. 可以统一 API 请求路径的前缀
4. 为以后 App 的 API 请求的优化和个性化做好准备

```dart
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'cache_options.dart';
import 'custom_exception_interceptor.dart';

/// 自定义的 Dio 实例，用于访问 APP 接口
/// 该实例会自动添加日志拦截器, 缓存拦截器和错误拦截器
/// 该实例会自动添加 Content-Type 和 Accept 头
/// 该实例会自动将后台返回的 Problem 对象转换为 DioError
///
/// DioMixin 是一个 Mixin，它会自动实现 Dio 的所有方法
/// Mixin 的好处是可以在不改变原有类的情况下，为类添加新的功能
/// 具体的实现原理可以参考：https://dart.dev/guides/language/language-tour#mixins
class AppClient with DioMixin implements Dio {
  static final AppClient _instance = AppClient._();
  factory AppClient() => _instance;

  AppClient._() {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/app',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    httpClientAdapter = HttpClientAdapter();
    interceptors.add(PrettyDioLogger());
    interceptors.add(DioCacheInterceptor(options: cacheOptions));
    interceptors.add(CustomExceptionInterceptor());
  }
}
```

上面代码中，我们使用了一个 `CacheOptions` 对象，用于配置缓存拦截器，这个拦截器是第三方库 `dio_cache_interceptor` 提供的，我们需要在 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  dio_cache_interceptor: ^1.0.0
```

这个缓存配置对象定义在 `cache_options.dart` 文件中，代码如下：

```dart
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// 全局缓存配置
final cacheOptions = CacheOptions(
  // 必选参数，默认缓存存储器
  store: MemCacheStore(),

  /// 所有下面的参数都是可选的

  /// 缓存策略，默认为 CachePolicy.request
  /// - CachePolicy.request: 如果缓存可用并且未过期，则使用缓存，否则从服务器获取响应并缓存
  /// - CachePolicy.forceCache: 当 Server 没有缓存的响应头时，强制使用缓存，也就是缓存每次成功的 GET 请求
  /// - CachePolicy.refresh: 不论缓存是否可用，都从服务器获取响应并根据响应头缓存
  /// - CachePolicy.refreshForceCache: 无论 Server 是否有缓存响应头，都从服务器获取响应并缓存
  /// - CachePolicy.noCache: 不使用缓存，每次都从服务器获取响应并根据响应头缓存
  policy: CachePolicy.forceCache,

  /// 例外状态码，当请求失败时，如果状态码在此列表中，则不使用缓存
  hitCacheOnErrorExcept: [401, 403],

  /// 覆盖 HTTP 响应头中的 max-age 字段，用于指定缓存的有效期
  /// 默认为 null，表示使用 HTTP 响应头中的 max-age 字段
  maxStale: const Duration(minutes: 10),

  /// 缓存优先级，默认为 CachePriority.normal
  priority: CachePriority.normal,

  /// 加密器，默认为 null，表示不加密
  cipher: null,

  /// 缓存键生成器，默认为 CacheOptions.defaultCacheKeyBuilder
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,

  /// 是否允许缓存 Post 请求，默认为 false
  /// 当设置为 true 时，建议改写 keyBuilder，以避免缓存多个不同的 POST 请求
  allowPostMethod: false,
);
```

由于服务端已经按 RFC 7807 规范实现了 Problem 对象，所以我们需要将 Problem 对象转换为 DioError 对象，这样就可以在 Dio 的错误回调中直接获取到 Problem 对象了。这里我们使用了一个自定义的拦截器 `CustomExceptionInterceptor` 来实现这个功能，代码如下：

```dart
import 'package:dio/dio.dart';
import 'package:models/models.dart';

import 'problem.dart';

class CustomExceptionInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final problem = Problem.fromJson(err.response?.data);
      throw CustomException(problem.title ?? err.message ?? '未知错误');
      // Add more status codes and custom exceptions as needed
    }
    super.onError(err, handler);
  }
}
```

这个 `Problem` 的对象定义在 `models` 包中，我们可以直接使用。这个对象的定义如下：

```dart
class Problem {
  final String? title;
  final String? detail;
  final String? instance;
  final int? status;
  final String? type;
  final int? code;
  final String? ua;
  final String? locale;

  Problem({
    this.title,
    this.detail,
    this.instance,
    this.status,
    this.type,
    this.code,
    this.ua,
    this.locale,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      title: json['title'],
      detail: json['detail'],
      instance: json['instance'],
      status: json['status'],
      type: json['type'],
      code: json['code'],
      ua: json['ua'],
      locale: json['locale'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detail': detail,
      'instance': instance,
      'status': status,
      'type': type,
      'code': code,
      'ua': ua,
      'locale': locale,
    };
  }

  @override
  String toString() {
    return 'Problem{title: $title, detail: $detail, instance: $instance, status: $status, type: $type, code: $code, ua: $ua, locale: $locale}';
  }

  Problem copyWith({
    String? title,
    String? detail,
    String? instance,
    int? status,
    String? type,
    int? code,
    String? ua,
    String? locale,
  }) {
    return Problem(
      title: title ?? this.title,
      detail: detail ?? this.detail,
      instance: instance ?? this.instance,
      status: status ?? this.status,
      type: type ?? this.type,
      code: code ?? this.code,
      ua: ua ?? this.ua,
      locale: locale ?? this.locale,
    );
  }
}
```

### 6.8.2 Repository 层改造

我们在这一层需要添加一个 `PageRepository` 类，用于获取页面布局数据。这个类的定义如下：

````dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

/// 页面布局仓库
class PageRepository {
  final String baseUrl;
  final Dio client;
  final bool enableCache;
  final bool refreshCache;

  /// 构造函数
  /// [client] Dio实例
  /// [baseUrl] 接口基础地址
  /// [enableCache] 是否启用缓存
  /// 注意下面的写法，是为了允许在调用时，只传入部分参数，而不是全部参数
  /// 例如：
  /// ```dart
  /// PageRepository(
  ///   baseUrl: '/pages',
  ///   enableCache: true,
  /// )
  /// ```
  /// 这样就可以省略掉client参数
  /// 但是，如果你传入了client参数，那么就会覆盖掉默认值
  /// 例如：
  /// ```dart
  /// PageRepository(
  ///   client: Dio(),
  ///   baseUrl: '/pages',
  ///   enableCache: true,
  /// )
  /// ```
  /// 构造函数的写法，在 `:` 后面，是初始化列表
  /// 初始化列表的写法，是为了在构造函数执行之前，先执行初始化列表中的代码
  /// 这样就可以在构造函数中，直接使用初始化列表中的变量，写法上更加简洁。
  ///
  PageRepository({
    Dio? client,
    this.baseUrl = '/pages',
    this.enableCache = true,
    this.refreshCache = false,
  }) : client = client ?? AppClient();

  Future<PageLayout> getByPageType(PageType pageType) async {
    debugPrint('PageRepository.getByPageType($pageType)');

    final url = '$baseUrl/published/${pageType.value}';

    final response = await client.get(
      url,
      options: enableCache
          ? refreshCache
              ? cacheOptions
                  .copyWith(policy: CachePolicy.refreshForceCache)
                  .toOptions()
              : null
          : cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions(),
    );

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageRepository.getByPageType($pageType) - success');

    return result;
  }
}
````

上面代码中，我们使用 `AppClient` 作为 `Dio` 的实例，使用 `get` 方法获取数据。而且配置了缓存策略。对于 App 来说，我们需要缓存页面布局数据，因为页面布局数据不会经常变化。

除了页面布局，我们还需要给瀑布流页面访问 API 定义一个 `ProductRepository` 类，这个类的定义如下：

```dart
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class ProductRepository {
  final String baseUrl;
  final Dio client;
  final bool enableCache;
  final bool refreshCache;

  ProductRepository({
    Dio? client,
    this.baseUrl = '/products',
    this.enableCache = true,
    this.refreshCache = false,
  }) : client = client ?? AppClient();

  Future<SliceWrapper<Product>> getByCategory(
      {required int categoryId, int page = 0}) async {
    debugPrint('ProductRepository.getByCategory($categoryId, $page)');
    final url = '$baseUrl/by-category/$categoryId/page?page=$page';

    final response = await client.get(
      url,
      options: enableCache
          ? refreshCache
              ? cacheOptions
                  .copyWith(policy: CachePolicy.refreshForceCache)
                  .toOptions()
              : null
          : cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions(),
    );

    final result = SliceWrapper<Product>.fromJson(
        response.data, (json) => Product.fromJson(json));

    debugPrint('ProductRepository.getByCategory($categoryId, $page) - success');

    return result;
  }
}
```

### 6.8.3 ViewModel 层改造
