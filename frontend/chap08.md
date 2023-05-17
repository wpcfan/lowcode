# 第八章：实现画布页面的接口和前台

画布页面是我们课程中最为复杂的一个页面，它的复杂性体现在两个方面：

- 画布页面的布局是一个所见即所得的可视化界面，运营人员可以通过这个界面来配置页面的布局
- 画布页面的布局是由一个个区块组成的，每个区块的内容都是不一样的，比如有图片行，轮播图，商品行，以及商品瀑布流等等，而且每个区块的内容都是可以配置的，比如图片行可以放一张图片，也可以放多张图片，轮播图可以多张图片，商品行可以放 1-2 个商品，商品瀑布流可以配置商品的类目 ID 等等。这个界面涉及到的配置项非常多，而且每个配置项都是不一样的。
- 画布页面的布局是可以拖拽的，也就是说，运营人员可以通过拖拽的方式来调整区块的顺序。

从前端到后端的实现，我们都需要考虑这两个方面的复杂性。

在本章的内容中，我们会接触到很多新的知识点，比如：

- flutter 的拖拽
- JPA 的级联操作
- JPA 的自定义查询
- JPA 的批量更新

这一章的内容较多，为了避免割裂感，我们会一部分一部分的实现 API 和前台，最后再做一个总结。

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第八章：实现画布页面的接口和前台](#第八章实现画布页面的接口和前台)
  - [8.1 画布 API 的策略分析](#81-画布-api-的策略分析)
  - [8.2 区块的拖拽](#82-区块的拖拽)
    - [8.2.1 从区块列表拖放到画布的 Service 实现](#821-从区块列表拖放到画布的-service-实现)
    - [8.2.2. 测试 `addBlockToPage` 方法](#822-测试-addblocktopage-方法)
    - [8.2.3 作业：测试 `insertBlockToPage` 方法](#823-作业测试-insertblocktopage-方法)
    - [8.2.4 通过测试了解级联操作的 SQL](#824-通过测试了解级联操作的-sql)
    - [8.2.5 实现添加和插入区块的 API](#825-实现添加和插入区块的-api)
    - [8.2.6 测试添加区块的 API](#826-测试添加区块的-api)
    - [8.2.7 作业：测试插入区块的 API](#827-作业测试插入区块的-api)
    - [8.2.8 Flutter 实现拖拽](#828-flutter-实现拖拽)
    - [8.2.9 实现左侧面板](#829-实现左侧面板)
    - [8.2.10 实现中间画布](#8210-实现中间画布)
    - [8.2.11 右侧面板](#8211-右侧面板)
    - [8.2.12 添加区块和插入区块的 Repository](#8212-添加区块和插入区块的-repository)
    - [8.2.13 添加区块和插入区块的 Bloc](#8213-添加区块和插入区块的-bloc)
    - [8.2.14 完成画布页面](#8214-完成画布页面)
    - [8.2.15 作业：实现区块的拖拽排序](#8215-作业实现区块的拖拽排序)
      - [8.2.15.1 @Modifying 注解](#82151-modifying-注解)
      - [8.2.15.2 自定义 Repository](#82152-自定义-repository)
  - [8.3 区块和数据的 CRUD 操作](#83-区块和数据的-crud-操作)
    - [8.3.1 给区块添加数据的服务](#831-给区块添加数据的服务)
    - [8.3.2 更新区块和数据的服务](#832-更新区块和数据的服务)
    - [8.3.3 作业：实现删除区块和数据的服务](#833-作业实现删除区块和数据的服务)
    - [8.3.4 区块和数据的 CRUD API](#834-区块和数据的-crud-api)
  - [8.4 完成画布页面的前端](#84-完成画布页面的前端)
    - [8.4.1 表单组件](#841-表单组件)
      - [8.4.1.1 文本输入表单组件](#8411-文本输入表单组件)
      - [8.4.1.2 颜色选择器表单组件](#8412-颜色选择器表单组件)
    - [8.4.2 表单页面](#842-表单页面)
      - [8.4.2.1 页面配置表单](#8421-页面配置表单)
      - [8.4.2.2 作业：区块配置表单](#8422-作业区块配置表单)
      - [8.4.2.3 图片区块数据表单](#8423-图片区块数据表单)
      - [8.4.2.4 商品区块数据表单](#8424-商品区块数据表单)
      - [8.4.2.5 瀑布流区块数据表单](#8425-瀑布流区块数据表单)
    - [8.4.3 实现右侧面板](#843-实现右侧面板)
    - [8.3.6 实现区块和数据的 BLoC](#836-实现区块和数据的-bloc)
    - [8.3.6 实现最终的画布](#836-实现最终的画布)

<!-- /code_chunk_output -->

## 8.1 画布 API 的策略分析

画布页面的 API 设计，我们可以从两个方面来考虑：

1. 如何保存？是前端整体提交，还是每个区块单独提交？
2. 如何实现拖拽的顺序调整？是前端实现，还是后端实现？

每种设计都有各自的优缺点，我们来分析一下：

1. 前端整体提交：优点是实现简单，缺点是每次保存都要提交整个画布的数据，如果画布的数据量很大，那么每次保存都会很慢。一旦前端出现问题，比如网络问题，那么就会导致画布整体数据丢失。
2. 区块单独提交：优点是每次保存只提交一个区块的数据，速度快，而且不会丢失数据。缺点是实现相对复杂，需要前端和后端配合实现。
3. 前端实现拖拽顺序调整：如果前端实现，其本质还是前端整体提交，因为顺序调整会影响多个区块的数据，所以每次保存都要提交整个画布的数据。
4. 后端实现拖拽顺序调整：如果后端实现，那么前端只需要提交当前区块的数据，后端负责调整顺序，这样就可以实现区块单独提交。

我们的课程中会采用第二种和第四种设计，也就是区块单独提交和后端实现拖拽顺序调整。但我们也会介绍从在 JPA 维度上如何实现级联保存。

## 8.2 区块的拖拽

区块的拖拽分两种

- 从区块列表拖拽到画布
  - 从后端的角度看：从区块列表拖拽到画布，本质上是在画布中新增一个区块。也就是说在指定的画布上新建一个区块。
  - 从前端的角度看：要实现这个功能，我们需要在区块列表中监听拖拽事件，当拖拽到画布上时，就需要调用后端的接口来新增一个区块。
  - 另外，如果画布中已经有其他区块的情况下，需要考虑拖拽的区块和已有区块的顺序问题。这种情况下就变成了一个插入的问题。
- 在画布中拖拽区块的顺序
  - 从后端的角度看：在画布中拖拽区块的顺序，本质上是调整 `PageBlock` 的 `sort` 字段的值。但需要注意的是，`sort` 字段的值是唯一的，也就是说，如果我们要调整某个区块的顺序，那么就需要调整其他区块的顺序。比如，如果我们要把第一个区块调整到第二个区块的位置，那么第二个区块的 `sort` 字段的值就需要加 1，以此类推。但如果是新增的区块，那么就不需要调整其他区块的顺序，这个新增区块会放在最后。
  - 从前端的角度看：要实现这个功能，我们需要在画布中监听拖拽事件，当拖拽结束时，就需要调用后端的接口来调整区块的顺序。

### 8.2.1 从区块列表拖放到画布的 Service 实现

我们先来实现从区块列表拖放到画布的 Service，也就是 `PageCreateService` 中的 `addBlockToPage` 方法和 `insertBlockToPage` 方法。

```java
@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {
    private final PageQueryService pageQueryService;
    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;
    // ... 省略其他代码
    public PageLayout addBlockToPage(Long pageId, CreateOrUpdatePageBlockDTO block) {
        var pageLayout = pageQueryService.findById(pageId);
        if (pageLayout.getStatus() != PageStatus.Draft) {
            throw new CustomException("只有草稿状态的页面才能添加区块", "PageCreateService#addBlockToPage", Errors.ConstraintViolationException.code());
        }
        if (block.type() == BlockType.Waterfall && pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId) > 0L) {
            throw new CustomException("瀑布流区块只能有一个", "PageCreateService#addBlockToPage", Errors.ConstraintViolationException.code());
        }
        var blockEntity = block.toEntity();
        blockEntity.setSort(pageLayout.getPageBlocks().size());
        pageLayout.addPageBlock(blockEntity);
        pageBlockRepository.save(blockEntity);
        return pageLayout;
    }

    public PageLayout insertBlockToPage(Long id, CreateOrUpdatePageBlockDTO insertPageBlockDTO) {
        var pageLayout = pageQueryService.findById(id);
        if (pageLayout.getStatus() != PageStatus.Draft) {
            throw new CustomException("只有草稿状态的页面才能插入区块", "PageCreateService#insertBlockToPage", Errors.ConstraintViolationException.code());
        }
        if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, id) > 0L) {
            throw new CustomException("瀑布流区块只能有一个", "PageCreateService#insertBlockToPage", Errors.ConstraintViolationException.code());
        }
        if (insertPageBlockDTO.type() == BlockType.Waterfall && pageBlockRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, id, insertPageBlockDTO.sort()) > 0) {
            throw new CustomException("瀑布流区块必须在最后", "PageCreateService#insertBlockToPage", Errors.ConstraintViolationException.code());
        }
        pageLayout.getPageBlocks().stream()
                .filter(pageBlockEntity -> pageBlockEntity.getSort() >= insertPageBlockDTO.sort())
                .forEach(pageBlockEntity -> pageBlockEntity.setSort(pageBlockEntity.getSort() + 1));
        var blockEntity = insertPageBlockDTO.toEntity();
        pageLayout.addPageBlock(blockEntity);
        return pageLayoutRepository.save(pageLayout);
    }
}
```

我们先来看 `addBlockToPage` 方法，这个方法的逻辑很简单，就是先判断页面的状态是否是草稿，如果不是草稿，就抛出异常。然后判断区块的类型是否是瀑布流，如果是瀑布流，就判断页面中是否已经存在瀑布流区块，如果已经存在，就抛出异常。最后，我们把区块添加到页面中，并保存到数据库中。

接下来，我们来看 `insertBlockToPage` 方法，这个方法的逻辑稍微复杂一些。首先，我们也是先判断页面的状态是否是草稿，如果不是草稿，就抛出异常。然后判断区块的类型是否是瀑布流，如果是瀑布流，就判断页面中是否已经存在瀑布流区块，如果已经存在，就抛出异常。然后，我们需要把要插入的区块的 `sort` 字段的值和后面的区块的 `sort` 字段的值都加 1。最后，我们把区块添加到页面中，并保存到数据库中。

在 `addBlockToPage` 方法中，我们保存关系使用的是 `pageBlockRepository.save(blockEntity)` ，这个遵循的是由关系的维护端进行保存的原则。在 `insertBlockToPage` 方法中，我们保存关系使用的是 `pageLayoutRepository.save(pageLayout)` ，这是为什么呢？

因为我们在 `PageLayout` 中定义了级联保存的策略，所以当我们保存 `PageLayout` 时，会级联保存 `PageBlock`，所以我们只需要保存 `PageLayout` 就可以了。

```java
@OneToMany(mappedBy = "page", cascade = {CascadeType.ALL}, orphanRemoval = true)
@ToString.Exclude
@Builder.Default
private SortedSet<PageBlock> pageBlocks = new TreeSet<>();
```

在 `@OneToMany` 注解中，我们使用了 `cascade = {CascadeType.ALL}`，这表示级联保存，也就是当我们保存 `PageLayout` 时，会级联保存 `PageBlock`。我们还使用了 `orphanRemoval = true`，这表示当我们删除 `PageLayout` 时，会级联删除 `PageBlock`。

在关系型数据库中，Cascade 是指在对一个实体进行操作时，自动对与之相关联的实体进行相应的操作。Cascade 操作可以在实体之间建立关联关系，同时也可以在删除或更新实体时，自动对关联的实体进行相应的操作。以下是几种常见的 Cascade 操作：

1. `CascadeType.ALL`：表示对实体进行所有操作，包括持久化、合并、删除、刷新等。当对一个实体进行操作时，与之相关联的所有实体都会进行相应的操作。这种 Cascade 操作通常用于父子关系的实体之间。

2. `CascadeType.PERSIST`：表示对实体进行持久化操作。当对一个实体进行持久化操作时，与之相关联的实体也会进行持久化操作。这种 Cascade 操作通常用于一对多或多对多的关系中。例如，假设有一个 Order 实体和一个 OrderItem 实体，它们之间是一对多的关系，一个订单可以包含多个订单项。如果在 Order 实体的 orderItems 属性上设置了 CascadeType.PERSIST，那么当持久化一个订单时，与之关联的订单项也会被持久化。这样可以避免手动对订单项进行持久化操作，提高开发效率。需要注意的是，过度使用 CascadeType.PERSIST 可能会导致性能问题，因为它会导致大量的数据库操作。因此，在使用 CascadeType.PERSIST 时需要根据具体的业务场景进行选择和使用。

3. `CascadeType.MERGE`：表示对实体进行合并操作。当对一个实体进行合并操作时，与之相关联的实体也会进行合并操作。这种 Cascade 操作通常用于多对多的关系中。

4. `CascadeType.REMOVE`：表示对实体进行删除操作。当对一个实体进行删除操作时，与之相关联的实体也会进行删除操作。这种 Cascade 操作通常用于一对多或多对多的关系中。

5. `CascadeType.REFRESH`：表示对实体进行刷新操作。当对一个实体进行刷新操作时，与之相关联的实体也会进行刷新操作。这种 Cascade 操作通常用于多对多的关系中。

Cascade 操作的使用场景和意义主要是为了简化实体之间的关联关系，避免手动对关联实体进行操作，提高开发效率。同时，Cascade 操作也可以保证实体之间的关联关系的完整性，避免出现数据不一致的情况。但是，需要注意的是，过度使用 Cascade 操作可能会导致性能问题，因此需要根据具体的业务场景进行选择和使用。

在注解中，可以指定一种或者多种组合的 Cascade 操作，比如 `cascade = {CascadeType.PERSIST, CascadeType.MERGE}`，表示对实体进行持久化和合并操作。当然，也可以不指定任何 Cascade 操作。如果不指定任何 Cascade 操作，那么就不会对关联的实体进行任何操作。

### 8.2.2. 测试 `addBlockToPage` 方法

```java
@ExtendWith(SpringExtension.class)
public class PageCreateServiceTests {
    /**
     * 当页面状态不是草稿时，添加区块应该抛出异常
     */
    @Test
    void addBlockToPage_shouldThrowException_whenPageStatusIsNotDraft() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, null, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Published);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.addBlockToPage(pageId, block));
    }

    /**
     * 当瀑布流区块已经存在时，再次添加瀑布流区块应该抛出异常
     */
    @Test
    void addBlockToPage_shouldThrowException_whenWaterfallBlockAlreadyExists() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, null, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(1L);

        // Act & Assert
        assertThrows(CustomException.class, () -> pageCreateService.addBlockToPage(pageId, block));
    }

    /**
     * 当所有条件都满足时，添加区块应该成功
     */
    @Test
    void addBlockToPage_shouldAddBlockToPage_whenAllConditionsAreMet() {
        // Arrange
        Long pageId = 1L;
        CreateOrUpdatePageBlockDTO block = new CreateOrUpdatePageBlockDTO("title", BlockType.Waterfall, 0, BlockConfig.builder().build());
        PageLayout pageLayout = new PageLayout();
        pageLayout.setStatus(PageStatus.Draft);
        Mockito.when(pageQueryService.findById(pageId)).thenReturn(pageLayout);
        Mockito.when(pageBlockRepository.countByTypeAndPageId(BlockType.Waterfall, pageId)).thenReturn(0L);
        Mockito.when(pageBlockRepository.countByTypeAndPageIdAndSortGreaterThanEqual(BlockType.Waterfall, pageId, block.sort())).thenReturn(0L);
        Mockito.when(pageBlockRepository.save(any(PageBlock.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        PageLayout result = pageCreateService.addBlockToPage(pageId, block);

        // Assert
        assertEquals(pageLayout, result);
        assertEquals(1, result.getPageBlocks().size());
        assertEquals(block.type(), result.getPageBlocks().first().getType());
        assertEquals(block.sort(), result.getPageBlocks().first().getSort());
    }
}
```

我们分别通过几个测试用例，测试了 `addBlockToPage` 方法的三个分支：

- 当页面状态不是草稿时，添加区块应该抛出异常
- 当瀑布流区块已经存在时，再次添加瀑布流区块应该抛出异常
- 当所有条件都满足时，添加区块应该成功

### 8.2.3 作业：测试 `insertBlockToPage` 方法

提示：

在测试插入成功的测试用例中，需要验证插入的区块的 `sort` 是否正确。但页面布局中定义的 `pageBlocks` 是 `SortedSet`，需要使用一些函数式的技巧来验证 `sort` 是否正确。

```java
result.getPageBlocks().stream().skip(1).findFirst().get().getType()
```

其中 `skip(n)` 代表跳过前 n 个元素，`findFirst()` 代表获取第一个元素，因为是 `Optional` 类型，所以后面跟了一个 `get()` 代表获取元素的值。

### 8.2.4 通过测试了解级联操作的 SQL

在 `PageLayoutRepositoryTests` 中添加下列测试用例：

```java
@Test
void testCascadeSave_shouldBeSuccess_whenAddBlockToPage() {
    var now = LocalDateTime.now();
    var pageConfig = PageConfig.builder()
            .baselineScreenWidth(375.0)
            .horizontalPadding(16.0)
            .build();

    var page = PageLayout.builder()
            .pageType(PageType.About)
            .platform(Platform.App)
            .status(PageStatus.Published)
            .config(pageConfig)
            .title("Test Page Projection")
            .startTime(now.minusDays(1))
            .endTime(now.plusDays(1))
            .build();

    var block = PageBlock.builder()
            .type(BlockType.Waterfall)
            .title("Test Block")
            .sort(1)
            .config(BlockConfig.builder().build())
            .build();

    page.addPageBlock(block);

    entityManager.persist(page);
    entityManager.flush();

    var pageInDb = pageLayoutRepository.findById(page.getId());
    assertTrue(pageInDb.isPresent());
    assertEquals(1, pageInDb.get().getPageBlocks().size());
    assertEquals(block.getId(), pageInDb.get().getPageBlocks().stream().findFirst().get().getId());

    var block1 = PageBlock.builder()
            .type(BlockType.Banner)
            .title("Test Block 1")
            .sort(2)
            .config(BlockConfig.builder().build())
            .build();
    page.addPageBlock(block1);

    var block2 = PageBlock.builder()
            .type(BlockType.Banner)
            .title("Test Block 2")
            .sort(3)
            .config(BlockConfig.builder().build())
            .build();
    page.addPageBlock(block2);
    System.out.println("pageMerged");
    var pageMerged =entityManager.merge(page);

    entityManager.flush();

    var pageInDb2 = pageLayoutRepository.findById(page.getId());
    assertTrue(pageInDb2.isPresent());
    assertEquals(3, pageInDb2.get().getPageBlocks().size());
    assertEquals(pageMerged.getPageBlocks(), pageInDb2.get().getPageBlocks());
}
```

如果我们看一下输出的日志，可以看到，`entityManager.persist(page)` 输出的 SQL 语句是：

```sql
insert into mooc_pages (id, config, created_at, end_time, page_type, platform, start_time, status, title, updated_at) values (default, ?, ?, ?, ?, ?, ?, ?, ?, ?)
insert into mooc_page_blocks (id, config, page_id, sort, title, type) values (default, ?, ?, ?, ?, ?)
```

而 `entityManager.merge(page)` 输出的 SQL 语句是：

```sql
insert into mooc_page_blocks (id, config, page_id, sort, title, type) values (default, ?, ?, ?, ?, ?)
insert into mooc_page_blocks (id, config, page_id, sort, title, type) values (default, ?, ?, ?, ?, ?)
```

我们可以看到对于规定了级联操作模式为 `CascadeType.All` 情况下，虽然我们调用的是 `entityManager.merge(page)` ，产生的语句却是对 `mooc_page_blocks` 表的插入语句。所以这个时候用父对象来去保存即可。

### 8.2.5 实现添加和插入区块的 API

在 `PageAdminController` 中添加下列代码：

```java
@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/pages")
public class PageAdminController {
    // ... 省略其他代码

    @Operation(summary = "添加页面区块")
    @PostMapping("/{id}/blocks")
    public PageDTO addBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageBlockDTO block) {
        checkPageStatus(id);
        return PageDTO.fromEntity(pageCreateService.addBlockToPage(id, block));
    }

    @Operation(summary = "插入页面区块")
    @PostMapping("/{id}/blocks/insert")
    public PageDTO insertBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Valid @RequestBody CreateOrUpdatePageBlockDTO insertPageBlockDTO) {
        checkPageStatus(id);
        return PageDTO.fromEntity(pageCreateService.insertBlockToPage(id, insertPageBlockDTO));
    }
}
```

代码是非常简单的，值得一说的是 API 路径的设计。我们在添加区块的时候，使用的是 `POST /api/v1/admin/pages/{id}/blocks` ，这种设计非常符合直觉，因为区块一定是从属于某个页面的，这个路径参数 `{id}` 就是页面的 id。那么这个页面下的区块资源就是 `{id}/blocks` ，我们在这个页面下要新增区块的话，就以 `POST` 的方式来请求这个路径。

当然这个插入的 API 路径，有点不符合 RESTful 的设计，我们使用了动词 `insert` ，但我们不需要原教旨主义，我们只需要符合直觉就可以了。

### 8.2.6 测试添加区块的 API

```java
@ActiveProfiles("test")
@Import(PageProperties.class)
@WebMvcTest(controllers = PageAdminController.class)
public class PageAdminControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private PageCreateService pageCreateService;

    @MockBean
    private PageUpdateService pageUpdateService;

    @MockBean
    private PageDeleteService pageDeleteService;

    @MockBean
    private PageQueryService pageQueryService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void testAddBlockWhenPageLayoutNotFound() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);
        when(pageQueryService.findById(pageId)).thenThrow(new CustomException("页面不存在", "PageQueryService#findById", Errors.DataNotFoundException.code()));
        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().is5xxServerError())
                .andExpect(jsonPath("$.code").value(Errors.DataNotFoundException.code()));
    }

    @Test
    public void testAddBlockWhenPagePublished() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);

        // 设置页面状态为已发布
        var page = new PageLayout();
        page.setId(pageId);
        page.setStatus(PageStatus.Published);
        when(pageQueryService.findById(pageId)).thenReturn(page);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().is5xxServerError())
                .andExpect(jsonPath("$.code").value(Errors.ConstraintViolationException.code()));
    }

    @Test
    public void testAddBlockWithInvalidRequest() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var block = new CreateOrUpdatePageBlockDTO("title", null, null, null);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.type").value("http://localhost:8080/errors/validation"));
    }

    @Test
    public void testAddBlockWithValidRequest() throws Exception {
        // 准备测试数据
        Long pageId = 1L;
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .blockHeight(100.0)
                .blockWidth(400.0)
                .build();
        var block = new CreateOrUpdatePageBlockDTO("title", BlockType.Banner, 1, blockConfig);

        // 设置依赖服务正常返回
        var page = new PageLayout();
        page.setId(pageId);
        page.setStatus(PageStatus.Draft);
        when(pageQueryService.findById(pageId)).thenReturn(page);
        when(pageCreateService.addBlockToPage(pageId, block)).thenReturn(page);

        // 模拟请求
        mockMvc.perform(post("/api/v1/admin/pages/{id}/blocks", pageId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(block)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(pageId));
    }
}
```

我们在上述测试用例中，模拟了四种情况：

- 页面布局不存在
- 页面布局已发布
- 页面布局存在，请求参数不合法
- 页面布局存在，请求参数合法

### 8.2.7 作业：测试插入区块的 API

类比上述的测试用例，完成插入区块的测试用例。

### 8.2.8 Flutter 实现拖拽

我们在 Flutter 中实现拖拽的功能，需要使用到 `Draggable` 和 `DragTarget` 这两个 Widget。

`Draggable` 是一个可拖拽的 Widget，我们可以通过它的 `child` 属性来指定它的子 Widget，然后通过 `feedback` 属性来指定拖拽时的 Widget，通过 `data` 属性来指定拖拽时传递的数据。

`DragTarget` 是一个可接收拖拽的 Widget，我们可以通过它的 `builder` 属性来指定它的子 Widget，然后通过 `onWillAccept` 属性来指定是否接收拖拽，通过 `onAccept` 属性来指定接收拖拽时的回调函数。

按我们的设计画布的左侧是一个区块列表，中间区域是一个画布，右侧是一个区块属性编辑器，我们需要在左侧的区块列表中，将每个区块都包装成一个 `Draggable` ，然后在中间的画布中，将整个画布包装成一个 `DragTarget` ，这样我们就可以实现拖拽的功能了。

为了可以更清晰的了解这两个 Widget 的使用，我们可以先做一个非常简化的例子，如下所示：

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Left-Middle-Right Layout',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Left-Middle-Right Layout'),
        ),
        body: Row(
          children: [
            // Left column
            Container(
              width: 200,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Draggable(
                    data: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Icon(Icons.ac_unit),
                          SizedBox(width: 10),
                          Text('Component $index'),
                        ],
                      ),
                    ),
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Icon(Icons.ac_unit),
                          SizedBox(width: 10),
                          Text('Component $index'),
                        ],
                      ),
                    ),
                    feedback: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Icon(Icons.ac_unit),
                          SizedBox(width: 10),
                          Text('Component $index'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Middle column
            Expanded(
              child: DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      children: _components,
                    ),
                  );
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) {
                  _components.add(data as Widget);
                },
              ),
            ),
            // Right column
            Container(
              width: 200,
              color: Colors.grey,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Properties'),
                        Tab(text: 'Data'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Center(child: Text('Properties')),
                          Center(child: Text('Data')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _components = [];
}
```

大家可以体会一下上面这个例子，然后再去实现我们的画布。整体大框架其实是很类似的，但由于我们的这个页面要复杂，所以我们单独封装左中右三个区域的 Widget。

### 8.2.9 实现左侧面板

其中左侧的面板的代码如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

/// 左侧面板组件
/// [widgets] 组件列表
class LeftPane extends StatelessWidget {
  const LeftPane({super.key, required this.widgets});
  final List<WidgetData> widgets;

  @override
  Widget build(BuildContext context) {
    return widgets
        .map((e) => _buildDraggableWidget(e))
        .toList()
        .toColumn()
        .scrollable();
  }

  Widget _buildDraggableWidget(WidgetData data) {
    final listTile = ListTile(
      leading: Icon(
        data.icon,
        color: Colors.white54,
      ),
      title: Text(
        data.label,
        style: const TextStyle(color: Colors.white54),
      ),
    );
    return Draggable(
      data: data,

      /// 拖拽时的组件展现，这里使用了透明度和宽度限制
      feedback: listTile.card().opacity(0.5).constrained(
            width: 400,
            height: 80,
          ),
      child: listTile.card().constrained(
            height: 80,
          ),
    );
  }
}
```

左侧面板的代码比较简单，就是将每个组件都包装成一个 `Draggable` ，然后在拖拽时，我们使用了一个 `Card` 来展现，这样就可以实现拖拽时的效果了。要说明的一点是，我们引入了 `WidgetData` 这个类，这个类是我们自己定义的，用来描述每个组件的数据，代码如下：

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class WidgetData extends Equatable {
  const WidgetData(
      {required this.icon,
      required this.label,
      this.sort,
      this.type = PageBlockType.banner});

  final IconData icon;
  final String label;
  final PageBlockType type;
  final int? sort;

  @override
  String toString() {
    return 'WidgetData{icon: $icon, label: $label, index: $sort}';
  }

  @override
  List<Object?> get props => [icon, label, sort];

  WidgetData copyWith({IconData? icon, String? label, int? sort}) {
    return WidgetData(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      sort: sort ?? this.sort,
    );
  }
}
```

定义这个类的目的是为了在拖拽时，我们可以将这个数据传递给接收者，这样接收者就可以知道拖拽的是哪个组件了。

### 8.2.10 实现中间画布

中间的画布的代码如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

import 'models/models.dart';

/// 中间画布
class CenterPane extends StatelessWidget {
  const CenterPane(
      {super.key,
      this.onTap,
      required this.blocks,
      required this.products,
      required this.defaultBlockConfig,
      required this.pageConfig,
      this.onBlockAdded,
      this.onBlockInserted,
      this.onBlockMoved,
      this.onBlockSelected});
  final void Function()? onTap;
  final List<PageBlock<dynamic>> blocks;
  final List<Product> products;
  final BlockConfig defaultBlockConfig;
  final PageConfig pageConfig;
  final void Function(PageBlock<dynamic> block)? onBlockAdded;
  final void Function(PageBlock<dynamic> block)? onBlockInserted;
  final void Function(PageBlock<dynamic> block, int targetSort)? onBlockMoved;
  final void Function(PageBlock<dynamic> block)? onBlockSelected;

  @override
  Widget build(BuildContext context) {
    // 整体作为左侧拖拽目标
    final dragTarget = DragTarget(
      builder: (context, candidateData, rejectedData) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildListItem(index);
          },
          itemCount: blocks.length,
        );
      },
      onWillAccept: (data) {
        if (data is WidgetData && data.sort == null) {
          if (data.type == PageBlockType.waterfall &&
              blocks.indexWhere((el) => el.type == PageBlockType.waterfall) !=
                  -1) {
            /// 已有瀑布流不能拖拽
            return false;
          }
          return true;
        }
        return false;
      },
      onAccept: (WidgetData data) {
        _addBlock(data, blocks.length + 1);
      },
    );
    return dragTarget
        .gestures(onTap: onTap)
        .padding(
          horizontal: pageConfig.horizontalPadding ?? 0.0,
          vertical: pageConfig.verticalPadding ?? 0.0,
        )
        .backgroundColor(Colors.grey)
        .constrained(width: pageConfig.baselineScreenWidth ?? 375.0);
  }

  DragTarget<Object> _buildListItem(int index) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        final item = blocks[index];
        return _buildDraggableWidget(
            item, index, pageConfig.baselineScreenWidth ?? 375.0);
      },
      onWillAccept: (data) {
        /// 如果是从侧边栏拖拽过来的，那么index为null
        if (data is WidgetData && data.sort == null) {
          if (data.type == PageBlockType.waterfall) {
            /// 瀑布流不能插入到中间
            return false;
          }
          return true;
        }

        /// 已经有瀑布流不能拖拽
        if (data is PageBlock && data.type != PageBlockType.waterfall) {
          /// 如果是从画布中拖拽过来的，需要判断拖拽的和放置的不是同一个
          final int dragIndex = blocks.indexWhere((it) => it.sort == data.sort);
          final int dropIndex =
              blocks.indexWhere((it) => it.sort == blocks[index].sort);
          debugPrint('dragIndex: $dragIndex, dropIndex: ');
          return dragIndex != dropIndex;
        }
        return false;
      },
      onAccept: (data) {
        /// 获取要放置的位置
        final int dropIndex =
            blocks.indexWhere((it) => it.sort == blocks[index].sort);

        if (data is WidgetData) {
          /// 处理从侧边栏拖拽过来的
          /// 如果是从侧边栏拖拽过来的，在放置的位置下方插入
          if (data.sort == null) {
            return _insertBlock(data, dropIndex + 1);
          }
        }
        if (data is PageBlock) {
          /// 处理从画布中拖拽过来的
          onBlockMoved?.call(data, blocks[dropIndex].sort);
        }
      },
    );
  }

  void _insertBlock(WidgetData data, int dropIndex) {
    switch (data.type) {
      case PageBlockType.banner:
        return onBlockInserted?.call(
          PageBlock<ImageData>(
            type: PageBlockType.banner,
            title: 'Banner $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.waterfall:
        return onBlockInserted?.call(
          PageBlock<Category>(
            type: PageBlockType.waterfall,
            title: 'Waterfall $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig,
            data: const [],
          ),
        );
      case PageBlockType.imageRow:
        return onBlockInserted?.call(
          PageBlock<ImageData>(
            type: PageBlockType.imageRow,
            title: 'ImageRow $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.productRow:
        return onBlockInserted?.call(
          PageBlock<Product>(
            type: PageBlockType.productRow,
            title: 'ProductRow $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      default:
        return;
    }
  }

  void _addBlock(WidgetData data, int dropIndex) {
    switch (data.type) {
      case PageBlockType.banner:
        return onBlockAdded?.call(
          PageBlock<ImageData>(
            type: PageBlockType.banner,
            title: 'Banner $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.waterfall:
        return onBlockAdded?.call(
          PageBlock<Category>(
            type: PageBlockType.waterfall,
            title: 'Waterfall $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig,
            data: const [],
          ),
        );
      case PageBlockType.imageRow:
        return onBlockAdded?.call(
          PageBlock<ImageData>(
            type: PageBlockType.imageRow,
            title: 'ImageRow $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.productRow:
        return onBlockAdded?.call(
          PageBlock<Product>(
            type: PageBlockType.productRow,
            title: 'ProductRow $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      default:
        return;
    }
  }

  Widget _buildDraggableWidget(PageBlock block, int index, double itemWidth) {
    final config = block.config;
    page({required Widget child}) => Draggable(
          data: block,
          feedback: SizedBox(
            width: itemWidth,
            child: Opacity(opacity: 0.5, child: child),
          ),
          child: SizedBox(
            width: itemWidth,
            child: Container(
              color: Colors.black45,
              child: child,
            ),
          ),
        );

    Widget child;
    switch (block.type) {
      case PageBlockType.banner:
        final it = block as PageBlock<ImageData>;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : [
                const ImageData(
                    image: 'http://localhost:8080/api/v1/image/400/100/First'),
                const ImageData(
                    image: 'http://localhost:8080/api/v1/image/400/100/Second'),
                const ImageData(
                    image: 'http://localhost:8080/api/v1/image/400/100/Third')
              ];
        child = BannerWidget(
          items: items,
          config: config,
        );
        break;
      case PageBlockType.imageRow:
        final it = block as PageBlock<ImageData>;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : const [
                ImageData(
                    image: 'http://localhost:8080/api/v1/image/100/80/First'),
                ImageData(
                    image: 'http://localhost:8080/api/v1/image/100/80/Second'),
                ImageData(
                    image: 'http://localhost:8080/api/v1/image/100/80/Third')
              ];
        child = ImageRowWidget(
          items: items,
          config: config,
        );
        break;
      case PageBlockType.productRow:
        final it = block as PageBlock<Product>;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : [
                const Product(
                  id: 1,
                  name: 'Product 1',
                  description: 'Description 1',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product1'
                  ],
                  price: '¥100.23',
                )
              ];
        child = ProductRowWidget(
          items: items,
          config: config,
        );
        break;
      case PageBlockType.waterfall:
        final it = block as PageBlock<Category>;
        final items = products.isNotEmpty
            ? products
            : const [
                Product(
                  id: 1,
                  name: 'Product 1',
                  description: 'Description 1',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product1'
                  ],
                  price: '¥100.23',
                ),
                Product(
                  id: 2,
                  name: 'Product 2',
                  description: 'Description 2',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product2'
                  ],
                  price: '¥200.34',
                ),
                Product(
                  id: 3,
                  name: 'Product 3',
                  description: 'Description 3',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product3'
                  ],
                  price: '¥300.45',
                ),
                Product(
                  id: 4,
                  name: 'Product 4',
                  description: 'Description 4',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product4'
                  ],
                  price: '¥400.56',
                ),
              ];

        child = WaterfallWidget(
          products: items,
          config: config,
          isPreview: true,
        );
        break;
      default:
        return Container();
    }

    return page(child: IgnorePointer(child: child)).gestures(
        behavior: HitTestBehavior.opaque,
        onTap: () => onBlockSelected?.call(block));
  }
}
```

上面的代码中，我们通过 `Draggable` 和 `DragTarget` 实现了拖拽功能，通过 `Draggable` 我们可以拖拽出一个 `feedback` ，通过 `DragTarget` 我们可以接收一个 `Draggable` 传递过来的数据。这个组件比较复杂的原因是每个 `Draggable` 同时也是一个 `DragTarget` ，这样可以实现拖拽排序的功能。

另外需要注意的是，我们这个画布上重用了`BannerWidget`、`ImageRowWidget`、`ProductRowWidget`、`WaterfallWidget`这几个组件，这些组件都是通过 `PageBlock` 的`type`属性来区分的，这样可以实现不同类型的组件在画布上的拖拽和排序。而且为了可视化的效果，我们需要给这些没有数据的组件一些默认的数据，这样才能在画布上看到效果。而且这里面我们利用了在第五章的实现的占位图 API。

由于画布上的组件应该屏蔽组件本身的点击事件，所以我们在这里使用了 `IgnorePointer` 组件，这样就可以屏蔽掉组件本身的点击事件。然后我们在外层包裹了一个 `GestureDetector` ，这样就可以监听到组件的点击事件，然后通过 `onBlockSelected` 回调函数将组件的数据传递给父组件。

### 8.2.11 右侧面板

由于右侧面板涉及的功能比较多，而且 API 部分仍未完成，所以我们给出一个简化版本，代码如下：

```dart
import 'package:flutter/material.dart';

class RightPane extends StatelessWidget {

  const RightPane({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Properties'),
                Tab(text: 'Data'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Properties')),
                  Center(child: Text('Data')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

这里我们使用了 `TabBar` 和 `TabBarView` 来实现右侧面板的切换功能，这里我们只实现了两个 Tab，一个是 `Properties`，一个是 `Data`，这里的 `Properties` 是用来设置组件的属性的，`Data` 是用来设置组件的数据的。

### 8.2.12 添加区块和插入区块的 Repository

对于我们已经实现的 API，在客户端需要新建一个 `Repository` 来调用这些 API，这样可以将 API 的调用和业务逻辑分离开来，这样可以使得代码更加清晰。这里我们新建一个 `PageBlockRepository`，代码如下：

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageBlockRepository {
  final String baseUrl;
  final Dio client;

  PageBlockRepository({
    Dio? client,
    this.baseUrl = '/pages',
  }) : client = client ?? AdminClient();

  Future<PageLayout> createBlock(int pageId, PageBlock block) async {
    debugPrint('PageAdminRepository.createBlock($pageId, $block)');

    final url = '$baseUrl/$pageId/blocks';
    final response = await client.post(url, data: block.toJson());

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.createBlock($pageId, $block) - success');

    return result;
  }

  Future<PageLayout> insertBlock(int pageId, PageBlock block) async {
    debugPrint('PageAdminRepository.createBlock($pageId, $block)');

    final url = '$baseUrl/$pageId/blocks/insert';
    final response = await client.post(url, data: block.toJson());

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageAdminRepository.createBlock($pageId, $block) - success');

    return result;
  }
}
```

在 `repositories/repositories.dart` 中添加如下代码：

```dart
library repositories;

export 'file_admin_repository.dart';
export 'file_upload_repository.dart';
export 'page_admin_repository.dart';
export 'page_block_repository.dart';
export 'page_repository.dart';
```

### 8.2.13 添加区块和插入区块的 Bloc

接下来我们可以构建画布的事件，我们这一节需要构建三个：

- `CanvasEventLoad`：加载画布
- `CanvasEventAddBlock`：添加区块
- `CanvasEventInsertBlock`：插入区块

```dart
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class CanvasEvent extends Equatable {}

/// 加载画布
class CanvasEventLoad extends CanvasEvent {
  CanvasEventLoad(this.id) : super();
  final int id;

  @override
  List<Object?> get props => [id];
}

/// 添加页面区块
class CanvasEventAddBlock extends CanvasEvent {
  CanvasEventAddBlock(this.pageId, this.block) : super();
  final PageBlock block;
  final int pageId;

  @override
  List<Object?> get props => [pageId, block];
}

/// 插入页面区块
class CanvasEventInsertBlock extends CanvasEvent {
  CanvasEventInsertBlock(this.pageId, this.block) : super();
  final PageBlock block;
  final int pageId;

  @override
  List<Object?> get props => [pageId, block];
}
```

然后我们可以构建画布的状态，由于在画布上我们需要构建一个层次结构和 App 首页几乎一样的效果，所以我们需要一个类似的状态结构：

```dart
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CanvasState extends Equatable {
  final PageLayout? layout;
  final List<Product> waterfallList;
  final String error;
  final FetchStatus status;

  const CanvasState({
    this.layout,
    this.error = '',
    this.waterfallList = const [],
    this.status = FetchStatus.initial,
  });

  @override
  List<Object?> get props =>
      [layout, error, waterfallList, status];

  CanvasState copyWith({
    PageLayout? layout,
    String? error,
    List<Product>? waterfallList,
    FetchStatus? status,
  }) {
    return CanvasState(
      layout: layout ?? this.layout,
      error: error ?? this.error,
      waterfallList: waterfallList ?? this.waterfallList,
      status: status ?? this.status,
    );
  }
}

class CanvasInitial extends CanvasState {
  const CanvasInitial() : super();
}
```

然后我们可以构建画布的 Bloc，代码如下：

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  final PageAdminRepository adminRepo;
  final PageBlockRepository blockRepo;
  final ProductRepository productRepo;
  CanvasBloc(
      this.adminRepo, this.blockRepo, this.productRepo)
      : super(const CanvasInitial()) {
    on<CanvasEventLoad>(_onCanvasEventLoad);
    on<CanvasEventAddBlock>(_onCanvasEventAddBlock);
    on<CanvasEventInsertBlock>(_onCanvasEventInsertBlock);
  }

  /// 错误处理
  void _handleError(Emitter<CanvasState> emit, dynamic error) {
    final message =
        error.error is CustomException ? error.error.message : error.toString();
    emit(state.copyWith(
      error: message,
      saving: false,
      status: FetchStatus.error,
    ));
  }

  /// 加载瀑布流
  Future<List<Product>> _loadWaterfallData(PageLayout layout) async {
    try {
      final waterfallBlock = layout.blocks
          .firstWhere((element) => element.type == PageBlockType.waterfall);

      if (waterfallBlock.data.isNotEmpty) {
        final categoryId = waterfallBlock.data.first.content.id;
        if (categoryId != null) {
          final waterfall =
              await productRepo.getByCategory(categoryId: categoryId);
          return waterfall.data;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  /// 插入区块
  void _onCanvasEventInsertBlock(
      CanvasEventInsertBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await blockRepo.insertBlock(event.pageId, event.block);
      emit(state.copyWith(
        layout: layout,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 添加区块
  void _onCanvasEventAddBlock(
      CanvasEventAddBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout =
          await blockRepo.createBlock(state.layout!.id!, event.block);

      emit(state.copyWith(
        layout: layout,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 加载页面
  void _onCanvasEventLoad(
      CanvasEventLoad event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final layout = await adminRepo.get(event.id);
      final waterfallList = await _loadWaterfallData(layout);

      emit(state.copyWith(
        status: FetchStatus.populated,
        layout: layout,
        waterfallList: waterfallList,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }
}
```

上面的代码中，我们主要是实现了加载画布、添加区块和插入区块的逻辑，其中加载画布的逻辑和 App 首页的逻辑几乎一样，所以我们就不再赘述了。

### 8.2.14 完成画布页面

这个页面主要是把中间和右侧的页面组合起来，之所以不整合左侧是因为我们想做一个响应式布局，左侧在手机端显示的时候会以抽屉菜单的形式弹出。

画布页面代码如下：

```dart
library canvas;

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:nested/nested.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'center_pane.dart';
import 'right_pane.dart';

export 'left_pane.dart';
export 'models/widget_data.dart';

/// 画布页面
/// [id] 画布id
/// [scaffoldKey] scaffold key
class CanvasPage extends StatelessWidget {
  const CanvasPage({
    super.key,
    required this.id,
    required this.scaffoldKey,
  });
  final int id;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      /// 仓库提供者
      providers: _buildRepositoryProviders,
      child: MultiBlocProvider(
        /// bloc提供者
        providers: _buildBlocProviders,
        child: Builder(builder: (context) {
          final productRepository = context.read<ProductRepository>();
          return BlocConsumer<CanvasBloc, CanvasState>(
            listener: (context, state) {
              if (state.error.isNotEmpty) {
                _handleErrors(context, state);
              }
            },
            builder: (context, state) {
              if (state.status == FetchStatus.initial) {
                return const Text('initial').center();
              }
              if (state.status == FetchStatus.loading) {
                return const CircularProgressIndicator().center();
              }
              final rightPane =
                  _buildRightPane(context);
              final centerPane = _buildCenterPane(state, context);
              final body = _buildBody(context, centerPane, rightPane);

              return Scaffold(
                key: scaffoldKey,
                body: body,
                endDrawer: Drawer(child: rightPane),
              );
            },
          );
        }),
      ),
    );
  }

  /// 处理错误，显示snackbar
  void _handleErrors(BuildContext context, CanvasState state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(state.error,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            )),
      ),
    );
  }

  /// 构建 BlocProviders 数组
  List<SingleChildWidget> get _buildBlocProviders => [
        BlocProvider<CanvasBloc>(
          create: (context) => CanvasBloc(
            context.read<PageAdminRepository>(),
            context.read<PageBlockRepository>(),
            context.read<PageBlockDataRepository>(),
            context.read<ProductRepository>(),
          )..add(CanvasEventLoad(id)),
        ),
      ];

  /// 构建 RepositoryProviders 数组
  List<SingleChildWidget> get _buildRepositoryProviders => [
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(),
        ),
        RepositoryProvider<PageBlockRepository>(
          create: (context) => PageBlockRepository(),
        ),
        RepositoryProvider<PageBlockDataRepository>(
          create: (context) => PageBlockDataRepository(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
      ];

  /// 构建主体，包含中间部分和右侧部分
  Widget _buildBody(
          BuildContext context, CenterPane centerPane, RightPane rightPane) =>
      (Responsive.isDesktop(context)
              ? [centerPane, const Spacer(), rightPane.expanded(flex: 4)]
              : [centerPane])
          .toRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
      );

  /// 构建中间部分
  CenterPane _buildCenterPane(CanvasState state, BuildContext context) =>
      CenterPane(
        blocks: state.layout?.blocks ?? [],
        products: state.waterfallList,
        defaultBlockConfig: BlockConfig(
          horizontalPadding: 12,
          verticalPadding: 12,
          horizontalSpacing: 6,
          verticalSpacing: 6,
          blockWidth: (state.layout?.config.baselineScreenWidth ?? 375.0) - 24,
          blockHeight: 140,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
        pageConfig: state.layout?.config ??
            const PageConfig(
              horizontalPadding: 0.0,
              verticalPadding: 0.0,
              baselineScreenWidth: 375.0,
            ),
        onBlockAdded: (block) => context
            .read<CanvasBloc>()
            .add(CanvasEventAddBlock(state.layout!.id!, block)),
        onBlockInserted: (block) => context
            .read<CanvasBloc>()
            .add(CanvasEventInsertBlock(state.layout!.id!, block)),
      );

  /// 构建右侧部分
  RightPane _buildRightPane(BuildContext context) => RightPane();
}
```

上面代码中，我们把 `providers` 数组通过函数的方式返回，这样可以让代码更加清晰，同时也可以避免 `build` 方法中的代码过长。我们使用了 `BlocConsumer` 来监听 `CanvasBloc` 的状态，当状态发生变化时，我们会根据状态来显示不同的页面。 `BlocConsumer` 相当于同时处理 `BlocListener` 和 `BlocBuilder`，这样可以让代码更加简洁。在 `listener` 中，我们会根据状态来显示错误信息，这里我们使用了 `ScaffoldMessenger` 来显示错误信息，这样可以避免在显示错误信息时，把页面的内容给覆盖掉。在 `builder` 中，我们会根据状态来显示不同的页面，如果状态是 `initial`，我们会显示 `Text`，如果状态是 `loading`，我们会显示 `CircularProgressIndicator`，如果状态是 `success`，我们会显示 `Scaffold`，这个 `Scaffold` 包含了 `body` 和 `endDrawer`，`body` 是中间部分，`endDrawer` 是右侧部分。在 `body` 中，我们会根据屏幕的大小来显示不同的内容，如果是桌面端，我们会显示中间部分和右侧部分，如果是移动端，我们只会显示中间部分。在 `endDrawer` 中，我们会显示右侧部分。

那么左侧部分怎么办呢？我们在桌面端和移动端是不同处理方式，桌面端是直接在页面左侧，而移动端则是在抽屉菜单中。为了兼顾移动端，我们需要新建一个 `SideMenu`

```dart
import 'package:canvas/canvas.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: bgColor,
      child:
          // 左侧组件列表面板
          LeftPane(widgets: [
        WidgetData(
          icon: Icons.photo_library,
          label: '轮播图',
          type: PageBlockType.banner,
        ),
        WidgetData(
          icon: Icons.imagesearch_roller,
          label: '图片行',
          type: PageBlockType.imageRow,
        ),
        WidgetData(
          icon: Icons.production_quantity_limits,
          label: '产品行',
          type: PageBlockType.productRow,
        ),
        WidgetData(
          icon: Icons.category,
          label: '瀑布流',
          type: PageBlockType.waterfall,
        ),
      ]),
    );
  }
}
```

然后就可以改造路由了，我们需要把 `PageTableView` 改造成 `ShellRoute`，这样就可以在路由中添加侧边栏了。根路由的组件中也添加 `drawer`，这样就可以在移动端显示侧边栏了。

```dart
import 'package:canvas/canvas.dart';
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
    routes: [
      ShellRoute(
        builder: (context, state, child) => [
          // 只有桌面端才直接显示侧边栏
          if (Responsive.isDesktop(context))
            // 默认 flex = 1
            // 它占据 1/6 屏幕
            const SideMenu().expanded(),
          // 它占据 5/6 屏幕
          child.expanded(flex: 5),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.start),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return CanvasPage(
                id: id,
                scaffoldKey: innerScaffoldKey,
              );
            },
          ),
        ],
      )
    ],
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

### 8.2.15 作业：实现区块的拖拽排序

已经添加到画布的区块，可以在垂直方向上进行拖拽排序，当拖拽到某个位置时，会把当前区块插入到这个位置，这个位置以及之下的原有区块会向下或向上移动。

我们在前端已经实现了这个功能的基础支持，你需要在后端实现 API 和前端的 API 调用以及数据的更新。

提示：

1. 后端：在 `PageAdminController` 中添加一个路径为 `/{id}/blocks/{blockId}/move/{targetSort}` 的方法。其中 `id` 是页面的 ID，`blockId` 是区块的 ID，`targetSort` 是目标位置的排序值。

2. 后端：在 `PageUpdateService` 中添加一个 `moveBlock` 方法处理排序的业务逻辑。需要注意处理两种情况：目标位置在当前位置之前和之后。

- 可以使用 `PageLayout.getBlocks()` 方法获取当前页面的所有区块的集合。
- 使用 `PageLayout.getBlocks().stream().filter()` 方法过滤出当前区块之前或之后的区块集合。
- 使用 `forEach` 方法遍历这个集合，然后更新排序值。
- 由于已经设置了 `CascadeType.ALL`，所以使用 `PageLayoutRepository.save()` 方法保存页面的时候，会自动保存区块的排序值。

3. 前端：在 `PageBlockRepository` 中添加一个 `moveBlock` 方法调用我们的 API。

4. 前端：添加一个 BLoC 事件 `CanvasEventMoveBlock` 然后在 `CanvasBloc` 中处理这个事件，更新对应的状态。

5. 前端：在 `CanvasPage` 中调用 `CenterPane` 时传入处理 `onBlockMoved` 事件的方法。

#### 8.2.15.1 @Modifying 注解

在上面的作业中，我们需要更新指定页面下，指定排序值之后的所有块的排序值。我们在 git 中采用了实体类的操作方式，但是我们也可以使用 JPA 的 `@Modifying` 注解来实现。

```java
public interface PageBlockRepository extends JpaRepository<PageBlock, Long> {
  /**
     * 更新指定页面下，指定排序值之后的所有块的排序值
     * 需要了解的知识点：
     * <p><pre>@Modifying(flushAutomatically = true, clearAutomatically = false)</pre> 是一个注解
     * 用于标记需要修改数据的方法。其中，flushAutomatically 和 clearAutomatically 是两个可选参数，
     * 它们的作用如下：</p>
     * <ul>
     *     <li>
     *          flushAutomatically: 当设置为 true 时，表示在执行修改操作<b>之前<b/>，会先将持久化上下文中的所有修改同步到数据库中。
     *          这样可以确保修改操作的数据是最新的，但也会增加数据库的负担。
     *          如果设置为 false，则不会自动同步，需要手动调用 flush() 方法。
     *     </li>
     *     <li>
     *          clearAutomatically: 当设置为 true 时，表示在执行修改操作<b>之后</b>，会清空持久化上下文中的所有缓存对象。
     *          如果设置为 false，则不会自动清空，需要手动调用 clear() 方法。
     *     </li>
     * </ul>
     * @param id
     * @param sort
     * @return
     */
    @Modifying(flushAutomatically = true, clearAutomatically = false)
    @Query("update PageBlock p set p.sort = p.sort + 1 where p.page.id = ?1 and p.sort >= ?2")
    int updateSortByPageIdAndSortGreaterThanEqual(Long id, Integer sort);

    @Modifying(flushAutomatically = true, clearAutomatically = false)
    @Query("update PageBlock p set p.sort = p.sort - 1 where p.page.id = ?1 and p.sort <= ?2")
    int updateSortByPageIdAndSortLessThanEqual(Long pageId, Integer sort);
}
```

上面的代码中，我们使用了 `@Modifying` 注解，它的作用是标记需要修改数据的方法。其中，`flushAutomatically` 和 `clearAutomatically` 是两个可选参数，它们的作用如下：

- `flushAutomatically`: 当设置为 `true` 时，表示在执行修改操作**之前**，会先将持久化上下文中的所有修改同步到数据库中。这样可以确保修改操作的数据是最新的，但也会增加数据库的负担。如果设置为 `false`，则不会自动同步，需要手动调用 `flush()` 方法。

- `clearAutomatically`: 当设置为 `true` 时，表示在执行修改操作**之后**，会清空持久化上下文中的所有缓存对象。如果设置为 `false`，则不会自动清空，需要手动调用 `clear()` 方法。

`@Modifying` 注解有助于我们方便的实现较为复杂的批量更新操作。对比实体类的操作来说，它的优势在于有的时候可以生成更有效率的 SQL。

#### 8.2.15.2 自定义 Repository

有的时候，或者是历史原因，或者是其他原因，我们需要自定义 Repository 来实现一些特殊的功能。这种情况下，我们可以使用多接口继承的方式来实现。比如我们需要对于 `Product` 这个实体类建立一个自定义的 `CustomProductRepository`，它的代码如下：

```java
public interface CustomProductRepository {
    List<ProductDTO> findProductDTOsByCategoriesId(Long id);
}
```

然后我们让 `ProductRepository` 继承这个接口，这是一个小技巧，由于继承关系，`ProductRepository` 拥有 `findProductDTOsByCategoriesId` 这个方法的定义：

```java
public interface ProductRepository extends JpaRepository<Product, Long>, CustomProductRepository  {
    // ... 省略其他代码
}
```

接下来我们实现 `CustomProductRepository` 接口：

```java
public class CustomProductRepositoryImpl implements CustomProductRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    @Override
    public List<ProductDTO> findProductDTOsByCategoriesId(Long id) {
        return entityManager.createNativeQuery(
                        """
                                SELECT
                                    p.id AS id,
                                    p.name AS name,
                                    p.description as description,
                                    p.price AS price,
                                    c.id AS c_id,
                                    c.code AS c_code,
                                    c.name AS c_name,
                                    pi.image_url AS pi_image_url
                                FROM
                                    mooc_products p
                                LEFT JOIN
                                    mooc_product_categories pc
                                ON
                                    p.id = pc.product_id
                                LEFT JOIN
                                    mooc_categories c
                                ON
                                    pc.category_id = c.id
                                LEFT JOIN
                                    mooc_product_images pi
                                ON
                                    p.id = pi.product_id
                                WHERE
                                    c.id = :id
                                """)
                .setParameter("id", id)
                .unwrap(Query.class)
                .setTupleTransformer(((tuple, aliases) -> {
                    Map<String, Integer> aliasToIndexMap = Arrays.stream(aliases)
                            .collect(HashMap::new, (map, alias) -> map.put(alias.toLowerCase(Locale.ROOT), map.size()), Map::putAll);
                    return ProductDTO.builder()
                            .id((Long) tuple[aliasToIndexMap.get("id")])
                            .name((String) tuple[aliasToIndexMap.get("name")])
                            .description((String) tuple[aliasToIndexMap.get("description")])
                            .price((BigDecimal) tuple[aliasToIndexMap.get("price")])
                            .categories(Set.of(CategoryDTO.builder()
                                    .id((Long) tuple[aliasToIndexMap.get("c_id")])
                                    .code((String) tuple[aliasToIndexMap.get("c_code")])
                                    .name((String) tuple[aliasToIndexMap.get("c_name")])
                                    .build()))
                            .images(aliasToIndexMap.containsKey("pi_image_url") && tuple.length > aliasToIndexMap.get("pi_image_url") + 1 ? Set.of((String) tuple[aliasToIndexMap.get("pi_image_url")]) : new HashSet<>())
                            .build();
                }))
                .getResultList();
    }
}
```

在上面代码中，我们使用了 `@PersistenceContext` 注解来注入 `EntityManager` 对象，然后使用 `createNativeQuery` 方法来创建一个原生 SQL 查询，最后使用 `unwrap` 方法将 `Query` 对象转换为 `org.hibernate.query.Query` 对象，然后使用 `setTupleTransformer` 方法来设置结果集的转换器，最后使用 `getResultList` 方法来获取查询结果。

在其他地方调用 `ProductRepository` 的时候，就可以直接调用 `findProductDTOsByCategoriesId` 方法来获取结果了。

## 8.3 区块和数据的 CRUD 操作

### 8.3.1 给区块添加数据的服务

在 `PageCreateService` 中添加一个 `addDataToBlock` 方法，用于给区块添加数据。

```java
@Transactional
@RequiredArgsConstructor
@Service
public class PageCreateService {

    private final PageQueryService pageQueryService;
    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;
    private final PageBlockDataRepository pageBlockDataRepository;
    // ... 省略其他代码
    /**
     * 给区块添加数据
     * @param blockId 区块ID
     * @param data 数据
     * @return 区块数据
     */
    public PageBlockData addDataToBlock(Long blockId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockRepository.findById(blockId)
                .map(blockEntity -> {
                    if (blockEntity.getType() == BlockType.Waterfall && blockEntity.getData().size() > 0) {
                        throw new CustomException("瀑布流区块只能有一个数据", "PageCreateService#addDataToBlock", Errors.ConstraintViolationException.code());
                    }
                    if (blockEntity.getType() == BlockType.ProductRow && blockEntity.getData().size() >= 2) {
                        throw new CustomException("产品行区块最多只能有2个数据", "PageCreateService#addDataToBlock", Errors.ConstraintViolationException.code());
                    }
                    var dataEntity = data.toEntity();
                    dataEntity.setSort(blockEntity.getData().size() + 1);
                    dataEntity.setPageBlock(blockEntity);
                    return pageBlockDataRepository.save(dataEntity);
                }).orElseThrow(() -> new CustomException("区块不存在", "PageCreateService#addDataToBlock", Errors.DataNotFoundException.code()));
    }
}
```

可以看到，我们在这个方法中，首先通过 `blockId` 获取到区块，然后判断区块的类型，如果是瀑布流区块，那么就判断区块中是否已经有数据了，如果有数据，就抛出异常。如果是产品行区块，那么就判断区块中的数据是否已经有两个了，如果有两个，就抛出异常。

### 8.3.2 更新区块和数据的服务

接下来我们实现更新区块和区块数据的功能。这一部分比较简单。我们在 `PageUpdateService` 中添加 `updateBlock` 和 `updateBlockData` 方法。

```java
@Slf4j
@Transactional
@RequiredArgsConstructor
@Service
public class PageUpdateService {
    private final PageQueryService pageQueryService;
    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;
    private final PageBlockDataRepository pageBlockDataRepository;
    // ... 省略其他代码

    /**
     * 更新区块
     * @param blockId 区块ID
     * @param block 区块数据
     * @return 区块
     */
    public PageBlock updateBlock(Long blockId, CreateOrUpdatePageBlockDTO block) {
        return pageBlockRepository.findById(blockId)
                .map(pageBlockEntity -> {
                    pageBlockEntity.setConfig(block.config());
                    pageBlockEntity.setSort(block.sort());
                    pageBlockEntity.setTitle(block.title());
                    pageBlockEntity.setType(block.type());
                    return pageBlockRepository.save(pageBlockEntity);
                }).orElseThrow(() -> new CustomException("未找到对应的区块", "PageUpdateService#updateBlock", Errors.DataNotFoundException.code()));
    }

    /**
     * 更新区块数据
     * @param dataId 数据ID
     * @param data 数据
     * @return 区块数据
     */
    public PageBlockData updateData(Long dataId, CreateOrUpdatePageBlockDataDTO data) {
        return pageBlockDataRepository.findById(dataId)
                .map(dataEntity -> {
                    dataEntity.setSort(data.sort());
                    dataEntity.setContent(data.content());
                    return pageBlockDataRepository.save(dataEntity);
                }).orElseThrow(() -> new CustomException("未找到对应的数据", "PageUpdateService#updateData", Errors.FileDeleteException.code()));
    }
}
```

上面两个方法中，我们都先进行了一次查询，这是因为我们需要判断是否存在对应的数据，如果不存在，就抛出异常。

上面代码中的 `CreateOrUpdatePageBlockDTO` 和 `CreateOrUpdatePageBlockDataDTO` 是我们定义的两个 DTO 类。

```java
public record CreateOrUpdatePageBlockDTO(
        @Schema(description = "区块标题", example = "直降促销活动区块") @NotBlank String title,
        @Schema(description = "区块类型", example = "image_row") @NotNull BlockType type,
        @Schema(description = "区块排序", example = "1") @NotNull @Positive Integer sort,
        @NotNull @Valid BlockConfig config) {
    public PageBlock toEntity() {
        return PageBlock.builder()
                .title(title)
                .type(type)
                .sort(sort)
                .config(config)
                .build();
    }
}
```

```java
public record CreateOrUpdatePageBlockDataDTO(
        @Schema(description = "数据排序", example = "1") @NotNull @Positive Integer sort,
        @NotNull @Valid BlockData content) {
    public PageBlockData toEntity() {
        return PageBlockData.builder()
                .sort(sort)
                .content(content)
                .build();
    }
}
```

### 8.3.3 作业：实现删除区块和数据的服务

接下来，我们实现删除区块和数据的服务。这一部分的代码比较简单，我们在 `PageDeleteService` 中添加 `deleteBlock` 和 `deleteBlockData` 方法。

删除有两种方式，你可以直接使用 `PageBlockDataRepository` 和 `PageBlockRepository` 中的 `deleteById` 方法，也可以使用 `PageLayout` 和 `PageBlock` 中的集合来删除并保存。

第一种方式的优点是从后端角度看比较简单，但如果需要验证删除的数据是否存在，就需要先查询一次，然后再删除，这种情况下和第二种的区别就不大了。我们 git 中的代码使用的是第二种方式。但大家可以分别实现一下，体会一下两种方式的区别。

### 8.3.4 区块和数据的 CRUD API

我们在 `PageAdminController` 中添加区块和数据的 CRUD API。其路径遵循 RESTful API 的规范。

- 修改区块：`PUT /api/v1/admin/pages/{id}/blocks`
- 删除区块：`DELETE /api/v1/admin/pages/{id}/blocks/{blockId}`
- 添加区块数据：`POST /api/v1/admin/pages/{id}/blocks/{blockId}/data`
- 修改区块数据：`PUT /api/v1/admin/pages/{id}/blocks/{blockId}/data`
- 删除区块数据：`DELETE /api/v1/admin/pages/{id}/blocks/{blockId}/data/{dataId}`

```java
@Slf4j
@Tag(name = "页面管理", description = "添加、修改、删除、查询页面，发布页面，撤销发布页面，添加区块，删除区块，修改区块，添加区块数据，删除区块数据，修改区块数据")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin/pages")
public class PageAdminController {
    private final PageCreateService pageCreateService;
    private final PageUpdateService pageUpdateService;
    private final PageQueryService pageQueryService;

    // ... 省略其他代码

    @Operation(summary = "添加页面区块数据")
    @PostMapping("/{id}/blocks/{blockId}/data")
    public PageBlockData addData(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @RequestBody CreateOrUpdatePageBlockDataDTO data) {
        log.debug("add data: id = {}, blockId = {}, data = {}", id, blockId, data);
        checkPageStatus(id);
        return pageCreateService.addDataToBlock(blockId, data);
    }

    @Operation(summary = "修改页面区块数据")
    @PutMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public PageBlockData updateData(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @Parameter(description = "页面区块数据 id", name = "dataId") @PathVariable Long dataId,
            @RequestBody CreateOrUpdatePageBlockDataDTO data) {
        log.debug("update data: id = {}, blockId = {}, dataId = {}, data = {}", id, blockId, dataId, data);
        checkPageStatus(id);
        return pageUpdateService.updateData(dataId, data);
    }

    @Operation(summary = "删除页面区块数据")
    @DeleteMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public void deleteData(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @Parameter(description = "页面区块数据 id", name = "dataId") @PathVariable Long dataId) {
        log.debug("delete data: id = {}, blockId = {}, dataId = {}", id, blockId, dataId);
        checkPageStatus(id);
        pageDeleteService.deleteData(blockId, dataId);
    }

    @Operation(summary = "修改页面区块")
    @PutMapping("/{id}/blocks/{blockId}")
    public PageBlock updateBlock(
            @Parameter(description = "页面 id", name = "id") @PathVariable Long id,
            @Parameter(description = "页面区块 id", name = "blockId") @PathVariable Long blockId,
            @RequestBody CreateOrUpdatePageBlockDTO block) {
        log.debug("update block: id = {}, blockId = {}, block = {}", id, blockId, block);
        checkPageStatus(id);
        return pageUpdateService.updateBlock(blockId, block);
    }
}
```

## 8.4 完成画布页面的前端

我们在之前完成了从左侧组件列表拖放添加区块，以及在中间区域拖放区块更改顺序的功能。接下来要实现的有以下几个功能：

- 点击区块，右侧显示区块的配置和数据的标签页，用于编辑区块信息和添加/修改/删除区块数据。由于区块的数据是不一样的，所以我们需要根据区块的类型来显示不同的表单。

  1. 图片类型的区块。需要已表格形式显示图片的 URL 和跳转链接。点击添加按钮，可以弹出一个表单对话框，用于添加图片的 URL 和跳转链接。其中 URL 的文本框点击右侧图标可以弹出之前我们完成的图片选择器，用于选择图片。

  2. 商品类型的区块。需要已表格形式显示商品的 SKU、图片、名称和价格。表格上方有一个搜索框，可以按商品的名称、描述、sku 或分类名称来查询，选中一个商品后，商品会添加到表格中。点击表格中的删除按钮，可以删除商品。

  3. 瀑布流类型的区块。需要显示搜索框，可以按类目名称或代码进行查询，查询结果是一个类目树，左边是单选 radio，右边是类目的名称。

- 点击页面区域：在区块之外，但在画布之上的其他区域点击，要显示页面的配置标签页，用于修改页面的信息。

### 8.4.1 表单组件

由于我们在这一节会有大量的表单，所以我们先把表单组件抽取出来，方便我们复用。

#### 8.4.1.1 文本输入表单组件

文本类型的表单组件比较简单，我们只需要传入一些参数，就可以生成一个文本输入框。我们可以通过 `TextFormField` 组件来实现，为了方便表单校验，我们在这里面采用了声明式的校验器数组作为输入参数，校验器数组中的每一个元素都是一个校验器，校验器是一个函数，接收一个字符串参数，返回一个字符串，如果返回的字符串为空，则表示校验通过，否则表示校验不通过，返回的字符串就是错误信息。

```dart
import 'package:flutter/material.dart';

import '../validators/validators.dart';

/// 文本输入表单组件
/// [keyboardType] 键盘类型
/// [initialValue] 初始值
/// [label] 标签
/// [hint] 提示
/// [suffix] 后缀
/// [validators] 校验器
/// [onChanged] 值改变回调
class MyTextFormField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? label;
  final String? hint;
  final Widget? suffix;
  final InputDecoration decoration;
  final List<Validator> validators;
  final void Function(String?)? onChanged;
  MyTextFormField({
    super.key,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.label,
    this.hint,
    this.suffix,
    required this.validators,
    this.onChanged,
  }) : decoration = InputDecoration(
          labelText: label,
          hintText: hint,
          suffix: suffix,
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      /// 需要注意，如果设置 initialValue，那么这个 widget 在切换的时候不会更新
      /// 因为在 widget 树中，这个 widget 的位置没有变化，所以不会重新 build
      /// 所以需要使用 controller 来控制
      controller: TextEditingController(text: initialValue),
      decoration: decoration,
      keyboardType: keyboardType,
      validator: (value) {
        for (var validator in validators) {
          var error = validator(value);
          if (error != null) {
            return error;
          }
        }
        return null;
      },
      onSaved: onChanged,
    );
  }
}
```

#### 8.4.1.2 颜色选择器表单组件

这个组件主要方便运营人员选择颜色，并转换为 Hex 格式的字符串。我们使用了一个第三方组件 `flex_color_picker` 来实现颜色选择器，这个组件的使用方法可以参考官方文档：[https://pub.dev/packages/flex_color_picker](https://pub.dev/packages/flex_color_picker)。

```dart
import 'package:common/common.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

/// 自定义表单字段，用于选择颜色
/// Flutter 中的表单字段是一个抽象类，它的子类必须实现 [FormField] 类。
/// 我们在这里实现了一个自定义的表单字段，用于选择颜色。
/// 该表单字段的初始值是一个 [Color] 对象，它的值是用户选择的颜色。
/// 该表单字段的验证器是一个 [FormFieldValidator<Color>] 函数，它的参数是用户选择的颜色。
/// 该表单字段的保存器是一个 [FormFieldSetter<Color>] 函数，它的参数是用户选择的颜色。
/// 该表单字段的构建器是一个 [FormFieldBuilder<Color>] 函数，它的参数是一个 [FormFieldState<Color>] 对象。
class ColorPickerFormField extends FormField<Color> {
  final String label;

  /// Stateful widgets 的初始值变化时是不会重绘的，所以我们需要一个 [ValueNotifier] 来通知表单字段重绘。
  /// 这里我们使用了一个 [ValueNotifier]，它的值是用户选择的颜色或初始值。
  /// 值变化后，我们通过 [ValueListenableBuilder] 来重绘表单字段。
  /// 只有在点击弹出框的确定按钮时，我们才会调用 [FormFieldState.didChange] 方法来更新表单字段的值。
  final ValueNotifier<Color> colorNotifier;
  ColorPickerFormField({
    super.key,
    required this.label,
    required this.colorNotifier,
    required FormFieldSetter<Color> onSaved,
    required FormFieldValidator<Color> validator,
  }) : super(
          initialValue: colorNotifier.value,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<Color> state) {
            return ValueListenableBuilder(
              valueListenable: colorNotifier,
              builder: (BuildContext context, Color value, Widget? child) {
                final item = [
                  Text(label),
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 50,
                    height: 50,
                  ).decorated(
                    color: value,
                    border: Border.all(
                      color: state.hasError ? Colors.red : Colors.grey,
                      width: 1,
                    ),
                  ),
                ].toRow().gestures(onTap: () async {
                  Color? newColor = await showDialog<Color>(
                    context: state.context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: ColorPicker(
                          color: state.value!,
                          enableOpacity: true,
                          pickersEnabled: const {
                            ColorPickerType.primary: true,
                            ColorPickerType.accent: true,
                            ColorPickerType.bw: true,
                            ColorPickerType.custom: false,
                            ColorPickerType.wheel: true,
                          },
                          pickerTypeLabels: const {
                            ColorPickerType.primary: '主色',
                            ColorPickerType.accent: '强调色',
                            ColorPickerType.bw: '黑白',
                            ColorPickerType.custom: '自定义',
                            ColorPickerType.wheel: '色轮',
                          },
                          pickerTypeTextStyle:
                              Theme.of(context).textTheme.titleSmall,
                          width: 40,
                          height: 40,
                          borderRadius: 4,
                          spacing: 5,
                          runSpacing: 5,
                          wheelDiameter: 155,
                          heading: Text(
                            '选择颜色',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          subheading: Text(
                            '选择颜色的亮度',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          wheelSubheading: Text(
                            '选择颜色的饱和度',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          showMaterialName: true,
                          showColorName: true,
                          showColorCode: true,
                          copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                            editFieldCopyButton: true,
                          ),
                          onColorChanged: (Color color) {
                            colorNotifier.value = color;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop<Color?>(null);
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop<Color?>(colorNotifier.value);
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );

                  if (newColor != null) {
                    /// 调用 [FormFieldState.didChange] 方法来更新表单字段的值。
                    state.didChange(newColor);
                  } else {
                    /// 如果用户没有选择颜色，我们就把表单字段的值重置为初始值。
                    colorNotifier.value = state.value!;
                  }
                });
                return item;
              },
            );
          },
        );
}
```

### 8.4.2 表单页面

#### 8.4.2.1 页面配置表单

页面配置表单组件，用于配置页面的属性。比如页面标题、水平内边距、垂直内边距、基准屏幕宽度等。

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';

/// 页面配置表单组件
/// [layout] 画布布局
/// [onSave] 保存回调
class PageConfigForm extends StatefulWidget {
  const PageConfigForm({super.key, required this.layout, this.onSave});
  final PageLayout layout;
  final void Function(PageLayout)? onSave;
  @override
  State<PageConfigForm> createState() => _PageConfigFormState();
}

class _PageConfigFormState extends State<PageConfigForm> {
  final _formKey = GlobalKey<FormState>();
  late PageLayout? _formValue;

  @override
  Widget build(BuildContext context) {
    /// 初始化表单值
    _formValue = widget.layout;
    final elements = [
      const Text('页面属性'),
      ..._createFormItems(),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();
            widget.onSave?.call(_formValue!);
          }
        },
        child: const Text('保存'),
      ),
    ];
    return Form(
      key: _formKey,
      child: elements.toColumn(mainAxisSize: MainAxisSize.min),
    );
  }

  /// 创建表单项
  List<Widget> _createFormItems() {
    return [
      MyTextFormField(
        label: '标题',
        hint: '请输入标题',
        validators: [
          Validators.required(label: '标题'),
          Validators.maxLength(label: '标题', maxLength: 100),
          Validators.minLength(label: '标题', minLength: 2),
        ],
        initialValue: _formValue?.title,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(title: value);
          });
        },
      ),
      MyTextFormField(
        label: '水平内边距',
        hint: '请输入水平内边距',
        validators: [
          Validators.required(label: '水平内边距'),
          Validators.isInteger(label: '水平内边距'),
          Validators.min(label: '水平内边距', min: 0),
          Validators.max(label: '水平内边距', max: 1000),
        ],
        initialValue: _formValue?.config.horizontalPadding.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(
                config: _formValue?.config
                    .copyWith(horizontalPadding: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '垂直内边距',
        hint: '请输入垂直内边距',
        validators: [
          Validators.required(label: '垂直内边距'),
          Validators.isInteger(label: '垂直内边距'),
          Validators.min(label: '垂直内边距', min: 0),
          Validators.max(label: '垂直内边距', max: 1000),
        ],
        initialValue: _formValue?.config.verticalPadding.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(
                config: _formValue?.config
                    .copyWith(verticalPadding: double.parse(value ?? '0')));
          });
        },
      ),
      MyTextFormField(
        label: '基准屏幕宽度',
        hint: '请输入基准屏幕宽度',
        validators: [
          Validators.required(label: '基准屏幕宽度'),
          Validators.isInteger(label: '基准屏幕宽度'),
          Validators.min(label: '基准屏幕宽度', min: 0),
          Validators.max(label: '基准屏幕宽度', max: 1000),
        ],
        initialValue: _formValue?.config.baselineScreenWidth.toString(),
        onChanged: (value) {
          setState(() {
            _formValue = _formValue?.copyWith(
                config: _formValue?.config
                    .copyWith(baselineScreenWidth: double.parse(value ?? '0')));
          });
        },
      ),
    ];
  }
}
```

上面代码中，我们使用了 `MyTextFormField` 组件，它是对 `TextFormField` 组件的封装，它的 `onChanged` 回调函数会在表单字段的值发生变化时被调用，我们在这个回调函数中更新表单值。这里你可以看到声明式的验证器的好处，我们只需要在 `validators` 属性中声明验证器，就可以实现表单字段的验证。

#### 8.4.2.2 作业：区块配置表单

类似的，你可以创建一个区块配置表单组件 `BlockConfigForm` ，用于配置区块的属性。比如区块标题、排序、水平内边距、垂直内边距、水平间距、垂直间距、块宽度、块高度、背景颜色、边框颜色和边框宽度等。

#### 8.4.2.3 图片区块数据表单

图片区块数据表单组件 `ImageDataForm` 用于配置图片区块的数据。图片区块的数据是一个 `List<BlockData<ImageData>>` 类型的数据，它是一个列表，列表中的每一项都是一个 `BlockData<ImageData>` 类型的数据，它包含了图片的数据和配置。图片的数据是一个 `ImageData` 类型的数据，它包含了图片的地址、链接类型和链接地址等。

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../popups/popups.dart';

/// 图片数据表单组件
/// [data] 数据
class ImageDataForm extends StatelessWidget {
  const ImageDataForm({
    super.key,
    required this.data,
    required this.onImageRemoved,
    required this.onImageAdded,
  });
  final List<BlockData<ImageData>> data;
  final void Function(int) onImageRemoved;
  final void Function(ImageData) onImageAdded;

  @override
  Widget build(BuildContext context) {
    /// 表格列头：图片、链接类型、链接地址、操作
    const dataColumns = [
      DataColumn(label: Text('图片')),
      DataColumn(label: Text('链接类型')),
      DataColumn(label: Text('链接地址')),
      DataColumn(label: Text('操作')),
    ];

    /// 表格行：图片、链接类型、链接地址、删除按钮
    final dataRows = data.map((e) => DataRow(cells: _buildCells(e))).toList();

    /// 表头：添加图片按钮
    final header = [
      IconButton(
        onPressed: () async {
          await showDialog<CreateOrUpdateImageDataDialog>(
            context: context,
            builder: (context) => CreateOrUpdateImageDataDialog(
              title: '添加图片',
              onCreate: onImageAdded,
            ),
          );
        },
        icon: const Icon(Icons.add),
        tooltip: '添加图片数据',
      ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.end)
        .backgroundColor(Colors.grey[600]!);

    /// 表格
    final table = DataTable(
      columns: dataColumns,
      rows: dataRows,
    );

    /// 最终组件
    final widget = [
      header,
      table,
    ].toColumn().scrollable();
    return widget;
  }

  List<DataCell> _buildCells(BlockData<ImageData> blockData) {
    final item = blockData.content;
    return [
      DataCell(Image.network(item.image)),
      DataCell(Text(item.link?.type.value ?? '')),
      DataCell(Text(item.link?.value ?? '')),
      DataCell(
        IconButton(
          onPressed: () => onImageRemoved(blockData.id!),
          icon: const Icon(Icons.delete),
        ),
      ),
    ];
  }
}
```

表头中，我们使用了一个弹出对话框用来进行图片的添加，这个弹出对话框是一个 `CreateOrUpdateImageDataDialog` 组件，它用于创建或更新图片数据。这个组件的代码如下：

```dart
import 'package:common/common.dart';
import 'package:files/files.dart';
import 'package:flutter/material.dart';
import 'package:forms/forms.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

/// 用于图片数据的对话框
/// [onUpdate] 更新回调
/// [onCreate] 创建回调
/// [data] 数据
/// [title] 标题
class CreateOrUpdateImageDataDialog extends StatefulWidget {
  const CreateOrUpdateImageDataDialog({
    super.key,
    this.onUpdate,
    this.onCreate,
    this.data,
    required this.title,
  });
  final void Function(ImageData data)? onUpdate;
  final void Function(ImageData data)? onCreate;
  final ImageData? data;
  final String title;

  @override
  State<CreateOrUpdateImageDataDialog> createState() =>
      _CreateOrUpdateImageDataDialogState();
}

class _CreateOrUpdateImageDataDialogState
    extends State<CreateOrUpdateImageDataDialog> {
  /// 表单数据
  late ImageData _formValue;

  /// 表单key
  final _formKey = GlobalKey<FormState>();

  /// 选中的图片
  String _selectedImage = '';

  /// 初始化
  @override
  void initState() {
    super.initState();
    _formValue = widget.data ??
        const ImageData(
          image: '',
          link: MyLink(type: LinkType.route, value: ''),
        );
  }

  /// 销毁
  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cancelButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('取消'),
    );
    final confirmButton = TextButton(
      onPressed: () => _validateAndSave(context),
      child: const Text('确定'),
    );
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: _createFormItems().toColumn(mainAxisSize: MainAxisSize.min),
      ),
      actions: [cancelButton, confirmButton],
    );
  }

  /// 创建表单项
  List<Widget> _createFormItems() {
    return [
      MyTextFormField(
        label: '图片地址',
        hint: '请输入图片地址',
        suffix: IconButton(
          icon: const Icon(Icons.image),
          onPressed: _showImageExplorer,
        ),
        validators: [
          Validators.required(label: '图片地址'),
          Validators.maxLength(label: '图片地址', maxLength: 255),
          Validators.minLength(label: '图片地址', minLength: 12),
        ],
        initialValue:
            _selectedImage.isEmpty ? widget.data?.image : _selectedImage,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(image: value ?? '');
          });
        },
      ),
      DropdownButtonFormField<LinkType>(
        value: widget.data?.link?.type,
        decoration: const InputDecoration(
          labelText: '链接类型',
        ),
        items: const [
          DropdownMenuItem(
            value: LinkType.route,
            child: Text('路由'),
          ),
          DropdownMenuItem(
            value: LinkType.url,
            child: Text('链接'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                link: _formValue.link?.copyWith(type: value ?? LinkType.route));
          });
        },
      ),
      MyTextFormField(
        label: '链接地址',
        hint: '请输入链接地址',
        validators: [
          Validators.required(label: '链接地址'),
          Validators.maxLength(label: '链接地址', maxLength: 255),
          Validators.minLength(label: '链接地址', minLength: 12),
        ],
        initialValue: _formValue.link?.value,
        onChanged: (value) {
          setState(() {
            _formValue = _formValue.copyWith(
                link: _formValue.link?.copyWith(value: value ?? '') as MyLink);
          });
        },
      ),
    ];
  }

  void _validateAndSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (widget.onCreate != null && widget.data == null) {
        widget.onCreate?.call(_formValue);
      }
      if (widget.onUpdate != null && widget.data != null) {
        widget.onUpdate?.call(_formValue);
      }
    }
    Navigator.of(context).pop();
  }

  void _showImageExplorer() async {
    final FileDto? result = await showDialog<FileDto?>(
      context: context,
      builder: (context) => const ImageExplorer(),
    );
    if (result != null) {
      setState(() {
        _selectedImage = result.url;
      });
    }
  }
}
```

#### 8.4.2.4 商品区块数据表单

对于商品数据，我们需要一个表格展现给用户商品的必要属性：

- 商品 SKU
- 商品名称
- 商品图片
- 商品价格

```dart
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 商品表格组件
/// [products] 商品列表
/// [onRemove] 删除回调
class ProductTable extends StatelessWidget {
  const ProductTable({
    super.key,
    required this.products,
    this.onRemove,
  });
  final List<Product> products;
  final void Function(Product)? onRemove;

  @override
  Widget build(BuildContext context) {
    const columns = [
      DataColumn(label: Text('商品SKU')),
      DataColumn(label: Text('商品名称')),
      DataColumn(label: Text('商品图片')),
      DataColumn(label: Text('商品价格')),
      DataColumn(label: Text('操作')),
    ];
    return DataTable(
      columns: columns,
      rows: products.map((e) => DataRow(cells: _buildCells(e))).toList(),
    );
  }

  List<DataCell> _buildCells(Product e) {
    return [
      DataCell(Text(e.sku ?? '')),
      DataCell(Text(e.name ?? '')),
      DataCell(Image.network(
        e.images.first,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      )),
      DataCell(Text(e.price.toString())),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onRemove?.call(e),
      )),
    ];
  }
}
```

商品的数据表单就是一个输入框和一个表格的组合，输入框用于输入关键字，同样是利用 Autocompelete 组件，表格用于展示选中的商品。

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'product_table.dart';

/// 商品数据表单组件
/// [data] 数据
/// [onAdd] 添加商品回调
/// [onRemove] 删除商品回调
class ProductDataForm extends StatefulWidget {
  const ProductDataForm({
    super.key,
    this.onAdd,
    this.onRemove,
    required this.data,
    required this.productRepository,
  });
  final void Function(Product)? onRemove;
  final void Function(Product)? onAdd;
  final List<BlockData<Product>> data;
  final ProductRepository productRepository;

  @override
  State<ProductDataForm> createState() => _ProductDataFormState();
}

class _ProductDataFormState extends State<ProductDataForm> {
  /// 选中的商品
  final List<Product> _selectedProducts = [];

  /// 匹配的商品
  final List<Product> _matchedProducts = [];

  @override
  Widget build(BuildContext context) {
    /// 初始化选中的商品
    setState(() {
      _selectedProducts.clear();
      _selectedProducts.addAll(widget.data.map((e) => e.content));
    });
    return [
      _buildAutocomplete(context),
      const SizedBox(height: 16),
      ProductTable(
        products: _selectedProducts,
        onRemove: widget.onRemove,
      )
    ].toColumn(mainAxisSize: MainAxisSize.min).scrollable();
  }

  Autocomplete<Product> _buildAutocomplete(BuildContext context) {
    return Autocomplete<Product>(
      optionsBuilder: (textValue) async {
        /// 从服务器获取匹配的商品列表
        final matchedProducts = await _searchProducts(textValue.text);
        setState(() {
          _matchedProducts.clear();
          _matchedProducts.addAll(matchedProducts);
        });
        return _matchedProducts;
      },
      optionsViewBuilder: (context, onSelected, options) => Material(
        child: ListView(
          shrinkWrap: true,
          children: options
              .map((e) => ListTile(
                    title: Text(e.name ?? ''),
                    leading: Image.network(
                      e.images.first,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                    onTap: () {
                      onSelected(e);
                    },
                  ))
              .toList(),
        ),
      ),
      onSelected: (option) {
        if (_selectedProducts.length > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('最多只能选择两个商品'),
            ),
          );
          return;
        }
        setState(() {
          if (!_selectedProducts
              .where((element) => element.id == option.id)
              .isNotEmpty) {
            _selectedProducts.add(option);
            widget.onAdd?.call(option);
          } else {
            _selectedProducts.removeWhere((element) => element.id == option.id);
            widget.onRemove?.call(option);
          }
        });
      },
      displayStringForOption: (option) => option.sku ?? '',
    );
  }

  /// 从服务器获取匹配的商品列表
  /// [text] 搜索关键字
  Future<List<Product>> _searchProducts(String text) async {
    final res = await widget.productRepository.searchByKeyword(text);
    return res;
  }
}
```

#### 8.4.2.5 瀑布流区块数据表单

瀑布流区块需要指定一个类目作为数据，其代码如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

/// 用于类目数据的表单
/// [onCategoryAdded] 类目添加回调
/// [onCategoryUpdated] 类目更新回调
/// [onCategoryRemoved] 类目移除回调
/// [data] 类目数据
class CategoryDataForm extends StatelessWidget {
  const CategoryDataForm({
    super.key,
    required this.onCategoryAdded,
    required this.onCategoryUpdated,
    required this.onCategoryRemoved,
    required this.data,
  });
  final void Function(Category) onCategoryAdded;
  final void Function(Category) onCategoryUpdated;
  final void Function(Category) onCategoryRemoved;
  final List<BlockData<Category>> data;

  @override
  Widget build(BuildContext context) {
    /// 类目仓库
    final categoryRepository = context.read<CategoryRepository>();

    return FutureBuilder(
      future: _getCategories(categoryRepository),
      initialData: const [],
      builder: (context, snapshot) {
        /// 加载中
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator().center();
        }

        /// 错误
        if (snapshot.hasError) {
          return Text('错误: ${snapshot.error}');
        }

        /// 没有数据
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('没有数据').center();
        }

        /// 类目
        final categories = snapshot.data as List<Category>;

        final autoComplete = Autocomplete<Category>(
          /// 构建选项
          optionsBuilder: (text) {
            return categories
                .where((element) => element.name!
                    .toLowerCase()
                    .contains(text.text.toLowerCase()))
                .toList();
          },

          /// 选中回调
          onSelected: (option) {
            if (data
                .where((element) => element.content.id == option.id)
                .isNotEmpty) {
              onCategoryRemoved(option);
            } else {
              if (data.isEmpty) {
                onCategoryAdded(option);
                return;
              }
              onCategoryUpdated(option);
            }
          },

          /// 选中值在输入框中的显示
          displayStringForOption: (option) => option.name ?? '',
        );
        final tree = _buildCategoryTree(categories);
        return [autoComplete, tree]
            .toColumn(mainAxisSize: MainAxisSize.min)
            .scrollable();
      },
    );
  }

  /// 获取类目
  Future<List<Category>> _getCategories(
      CategoryRepository categoryRepository) async {
    final categories = await categoryRepository.getCategories();
    return categories;
  }

  /// 构建类目树
  Widget _buildCategoryTree(Iterable<Category> categories) {
    return Material(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = categories.elementAt(index);
          return _buildCategoryItem(category);
        },
        itemCount: categories.length,
      ),
    );
  }

  /// 构建类目项
  Widget _buildCategoryItem(Category category) {
    return [
      /// 类目
      RadioListTile(
        title: Text(category.name ?? ''),
        value: category,
        selected: data.isEmpty ? false : data.first.content.id == category.id,
        groupValue: data.isEmpty ? null : data.first.content,
        onChanged: (value) {
          if (value != null) {
            if (data.isNotEmpty) {
              onCategoryUpdated(value);
              return;
            }
            onCategoryAdded(category);
          } else {
            onCategoryRemoved(category);
          }
        },
      ),

      /// 子类目
      if (category.children != null && category.children!.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildCategoryTree(category.children!),
        ),
    ].toColumn(mainAxisSize: MainAxisSize.min);
  }
}
```

上面代码中，我们使用了`Autocomplete`组件，该组件可以实现输入框的自动补全功能。由于类目是有父子关系的，所以我们使用了递归的方式构建了类目树。我们对子类目进行了缩进，以便于区分父子关系。

### 8.4.3 实现右侧面板

之前我们实现的右侧面板是一个空白的面板，现在我们需要根据不同的区块类型，实现不同的面板。利用我们之前完成的一系列组件，我们可以实现右侧的面板如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'widgets/widgets.dart';

/// 右侧面板
/// [selectedBlock] 选中的区块
/// [layout] 页面布局
/// [showBlockConfig] 是否显示块配置
/// [onSavePageLayout] 保存页面布局回调
/// [onSavePageBlock] 保存页面块回调
/// [onDeleteBlock] 删除块回调
/// [onCategoryAdded] 添加分类回调
/// [onCategoryUpdated] 更新分类回调
/// [onCategoryRemoved] 删除分类回调
/// [onProductAdded] 添加商品回调
/// [onProductRemoved] 删除商品回调
///
class RightPane extends StatelessWidget {
  const RightPane({
    super.key,
    required this.showBlockConfig,
    required this.productRepository,
    this.onSavePageLayout,
    this.onSavePageBlock,
    this.onDeleteBlock,
    required this.onCategoryAdded,
    required this.onCategoryUpdated,
    required this.onCategoryRemoved,
    required this.onProductAdded,
    required this.onProductRemoved,
    required this.onImageAdded,
    required this.onImageRemoved,
    this.selectedBlock,
    this.layout,
  });
  final PageBlock<dynamic>? selectedBlock;
  final PageLayout? layout;
  final bool showBlockConfig;
  final ProductRepository productRepository;
  final void Function(PageBlock)? onSavePageBlock;
  final void Function(PageLayout)? onSavePageLayout;
  final void Function(int)? onDeleteBlock;
  final void Function(BlockData<Product>) onProductAdded;
  final void Function(int) onProductRemoved;
  final void Function(BlockData<Category>) onCategoryAdded;
  final void Function(BlockData<Category>) onCategoryUpdated;
  final void Function(int) onCategoryRemoved;
  final void Function(BlockData<ImageData>) onImageAdded;
  final void Function(int) onImageRemoved;

  @override
  Widget build(BuildContext context) {
    final child = showBlockConfig
        ? DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              appBar: const TabBar(
                tabs: [
                  Tab(text: '配置'),
                  Tab(text: '数据'),
                ],
              ),
              body: TabBarView(
                children: [
                  BlockConfigForm(
                    block: selectedBlock!,
                    onSave: onSavePageBlock,
                    onDelete: onDeleteBlock,
                  ),
                  _buildBlockDataPane(),
                ],
              ),
            ),
          )
        : PageConfigForm(
            layout: layout!,
            onSave: onSavePageLayout,
          );
    return child.padding(horizontal: 12);
  }

  BlockDataPane _buildBlockDataPane() {
    return BlockDataPane(
      block: selectedBlock!,
      productRepository: productRepository,
      onCategoryAdded: (category) {
        final data = BlockData<Category>(
          sort: selectedBlock!.data.length,
          content: category,
        );
        onCategoryAdded(data);
      },
      onCategoryUpdated: (category) {
        final matchedData = selectedBlock!.data.first;
        final data = BlockData<Category>(
          id: matchedData.id,
          sort: matchedData.sort,
          content: category,
        );
        onCategoryUpdated(data);
      },
      onCategoryRemoved: (category) {
        final index = selectedBlock!.data
            .indexWhere((element) => element.content.id == category.id);
        if (index == -1) return;
        onCategoryRemoved.call(index);
      },
      onProductAdded: (product) {
        final data = BlockData<Product>(
          sort: selectedBlock!.data.length,
          content: product,
        );
        onProductAdded(data);
      },
      onProductRemoved: (product) {
        final index = selectedBlock!.data
            .indexWhere((element) => element.content.id == product.id);
        if (index == -1) return;
        onProductRemoved(selectedBlock!.data[index].id!);
      },
      onImageAdded: (image) {
        final data = BlockData<ImageData>(
          sort: selectedBlock!.data.length,
          content: image,
        );
        onImageAdded(data);
      },
      onImageRemoved: (id) {
        onImageRemoved(id);
      },
    );
  }
}
```

上面代码中，我们根据`showBlockConfig`属性，判断是否显示块配置面板。如果显示，则显示块配置面板，否则显示页面配置面板。块配置面板中，我们使用了`TabBar`和`TabBarView`组件，实现了块配置和块数据的切换。

### 8.3.6 实现区块和数据的 BLoC

添加以下事件：

- `CanvasEventUpdate`：更新画布，也就是页面配置点击保存后的逻辑

- `CanvasEventUpdateBlock`：更新页面区块，也就是块配置点击保存后的逻辑

- `CanvasEventDeleteBlock`：删除页面区块，也就是块配置点击删除后的逻辑

- `CanvasEventAddBlockData`：添加区块数据，也就是块数据点击添加后的逻辑

- `CanvasEventUpdateBlockData`：更新区块数据，也就是块数据点击保存后的逻辑

- `CanvasEventDeleteBlockData`：删除区块数据，也就是块数据点击删除后的逻辑

```dart
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class CanvasEvent extends Equatable {}

// ... 省略其他代码

/// 更新画布
class CanvasEventUpdate extends CanvasEvent {
  CanvasEventUpdate(this.id, this.layout) : super();
  final PageLayout layout;
  final int id;

  @override
  List<Object?> get props => [id, layout];
}

/// 更新页面区块
class CanvasEventUpdateBlock extends CanvasEvent {
  CanvasEventUpdateBlock(this.pageId, this.blockId, this.block) : super();
  final PageBlock block;
  final int pageId;
  final int blockId;

  @override
  List<Object?> get props => [pageId, blockId, block];
}

/// 删除页面区块
class CanvasEventDeleteBlock extends CanvasEvent {
  CanvasEventDeleteBlock(this.pageId, this.blockId) : super();
  final int pageId;
  final int blockId;

  @override
  List<Object?> get props => [pageId, blockId];
}

/// 选择页面区块
class CanvasEventSelectBlock extends CanvasEvent {
  CanvasEventSelectBlock(this.block) : super();
  final PageBlock block;

  @override
  List<Object?> get props => [block];
}

/// 取消选择页面区块
class CanvasEventSelectNoBlock extends CanvasEvent {
  CanvasEventSelectNoBlock() : super();

  @override
  List<Object?> get props => [];
}

/// 添加页面区块数据
class CanvasEventAddBlockData extends CanvasEvent {
  CanvasEventAddBlockData(this.data) : super();
  final BlockData data;

  @override
  List<Object> get props => [data];
}

/// 删除页面区块数据
class CanvasEventDeleteBlockData extends CanvasEvent {
  CanvasEventDeleteBlockData(this.dataId) : super();
  final int dataId;

  @override
  List<Object> get props => [dataId];
}

/// 更新页面区块数据
class CanvasEventUpdateBlockData extends CanvasEvent {
  CanvasEventUpdateBlockData(this.data) : super();
  final BlockData data;

  @override
  List<Object> get props => [data];
}

class CanvasEventErrorCleared extends CanvasEvent {
  CanvasEventErrorCleared() : super();

  @override
  List<Object?> get props => [];
}
```

添加以下状态，由于选择区块的时候会显示该区块的配置和数据表单，所以我们需要一个 `selectedBlock` ，当选择一个区块的时候，这个状态会被写入，而当点击页面的时候，这个状态会被设置为 `null`。：

```dart
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CanvasState extends Equatable {
  final PageLayout? layout;
  final List<Product> waterfallList;
  final bool saving;
  final String error;
  final FetchStatus status;
  final PageBlock? selectedBlock;

  const CanvasState({
    this.layout,
    this.saving = false,
    this.error = '',
    this.waterfallList = const [],
    this.status = FetchStatus.initial,
    this.selectedBlock,
  });

  @override
  List<Object?> get props =>
      [layout, saving, error, waterfallList, status, selectedBlock];

  CanvasState clearSelectedBlock() {
    return CanvasState(
      layout: layout,
      saving: saving,
      error: error,
      waterfallList: waterfallList,
      status: status,
      selectedBlock: null,
    );
  }

  CanvasState copyWith({
    PageLayout? layout,
    bool? saving,
    String? error,
    List<Product>? waterfallList,
    FetchStatus? status,
    PageBlock? selectedBlock,
  }) {
    return CanvasState(
      layout: layout ?? this.layout,
      saving: saving ?? this.saving,
      error: error ?? this.error,
      waterfallList: waterfallList ?? this.waterfallList,
      status: status ?? this.status,
      selectedBlock: selectedBlock ?? this.selectedBlock,
    );
  }
}

class CanvasInitial extends CanvasState {
  const CanvasInitial() : super();
}
```

那么对应的 BLoC 代码如下：

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'canvas_event.dart';
import 'canvas_state.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  final PageAdminRepository adminRepo;
  final PageBlockRepository blockRepo;
  final PageBlockDataRepository blockDataRepo;
  final ProductRepository productRepo;
  CanvasBloc(
      this.adminRepo, this.blockRepo, this.blockDataRepo, this.productRepo)
      : super(const CanvasInitial()) {
    on<CanvasEventLoad>(_onCanvasEventLoad);
    on<CanvasEventUpdate>(_onCanvasEventUpdate);
    on<CanvasEventAddBlock>(_onCanvasEventAddBlock);
    on<CanvasEventUpdateBlock>(_onCanvasEventUpdateBlock);
    on<CanvasEventInsertBlock>(_onCanvasEventInsertBlock);
    on<CanvasEventMoveBlock>(_onCanvasEventMoveBlock);
    on<CanvasEventDeleteBlock>(_onCanvasEventDeleteBlock);
    on<CanvasEventSelectBlock>(_onCanvasEventSelectBlock);
    on<CanvasEventSelectNoBlock>(_onCanvasEventSelectNoBlock);
    on<CanvasEventAddBlockData>(_onCanvasEventAddBlockData);
    on<CanvasEventDeleteBlockData>(_onCanvasEventDeleteBlockData);
    on<CanvasEventUpdateBlockData>(_onCanvasEventUpdateBlockData);
    on<CanvasEventErrorCleared>(_onCanvasEventErrorCleared);
  }

  /// 清除错误
  void _onCanvasEventErrorCleared(
      CanvasEventErrorCleared event, Emitter<CanvasState> emit) {
    emit(state.copyWith(error: ''));
  }

  /// 错误处理
  void _handleError(Emitter<CanvasState> emit, dynamic error) {
    final message =
        error.error is CustomException ? error.error.message : error.toString();
    emit(state.copyWith(
      error: message,
      saving: false,
      status: FetchStatus.error,
    ));
  }

  /// 加载瀑布流
  Future<List<Product>> _loadWaterfallData(PageLayout layout) async {
    try {
      final waterfallBlock = layout.blocks
          .firstWhere((element) => element.type == PageBlockType.waterfall);

      if (waterfallBlock.data.isNotEmpty) {
        final categoryId = waterfallBlock.data.first.content.id;
        if (categoryId != null) {
          final waterfall =
              await productRepo.getByCategory(categoryId: categoryId);
          return waterfall.data;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  PageLayout? _buildNewLayoutWhenBlockChanges(PageBlock<dynamic> newBlock) {
    final blocks = state.layout?.blocks ?? [];
    final blockIndex =
        blocks.indexWhere((element) => element.id == state.selectedBlock!.id!);

    final newLayout = state.layout?.copyWith(blocks: [
      ...blocks.sublist(0, blockIndex),
      newBlock,
      ...blocks.sublist(blockIndex + 1)
    ]);
    return newLayout;
  }

  /// 更新区块数据
  void _onCanvasEventUpdateBlockData(
      CanvasEventUpdateBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final data = await blockDataRepo.updateData(
          state.layout!.id!, state.selectedBlock!.id!, event.data);
      final dataList = state.selectedBlock!.data;
      final dataIndex = dataList.indexWhere((element) => element.id == data.id);
      if (dataIndex != -1) {
        dataList[dataIndex] = data;
      }
      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final newLayout = _buildNewLayoutWhenBlockChanges(newBlock);
      final waterfallList = await _loadWaterfallData(state.layout!);
      emit(state.copyWith(
        layout: newLayout,
        waterfallList: waterfallList,
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 删除区块数据
  void _onCanvasEventDeleteBlockData(
      CanvasEventDeleteBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      await blockDataRepo.deleteData(
          state.layout!.id!, state.selectedBlock!.id!, event.dataId);
      final dataList = state.selectedBlock!.data;
      final dataIndex =
          dataList.indexWhere((element) => element.id == event.dataId);
      if (dataIndex != -1) {
        dataList.removeAt(dataIndex);
      }
      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final newLayout = _buildNewLayoutWhenBlockChanges(newBlock);
      emit(state.copyWith(
        layout: newLayout,
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));

      /// 如果选中的区块是瀑布流，清空瀑布流数据
      if (state.selectedBlock!.type == PageBlockType.waterfall) {
        emit(state.copyWith(waterfallList: []));
      }
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 添加区块数据
  void _onCanvasEventAddBlockData(
      CanvasEventAddBlockData event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final blockData = await blockDataRepo.addData(
          state.layout!.id!, state.selectedBlock!.id!, event.data);
      final dataList = state.selectedBlock!.data;
      dataList.add(blockData);

      final newBlock = state.selectedBlock!.copyWith(data: dataList);
      final newLayout = _buildNewLayoutWhenBlockChanges(newBlock);
      final waterfallList = await _loadWaterfallData(state.layout!);
      emit(state.copyWith(
        layout: newLayout,
        waterfallList: waterfallList,
        selectedBlock: newBlock,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 点击页面时，清除选中的区块
  void _onCanvasEventSelectNoBlock(
      CanvasEventSelectNoBlock event, Emitter<CanvasState> emit) {
    emit(state.clearSelectedBlock());
  }

  /// 选中区块
  void _onCanvasEventSelectBlock(
      CanvasEventSelectBlock event, Emitter<CanvasState> emit) {
    emit(state.copyWith(selectedBlock: event.block));
  }

  /// 插入区块
  void _onCanvasEventInsertBlock(
      CanvasEventInsertBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await blockRepo.insertBlock(event.pageId, event.block);
      emit(state.copyWith(
        layout: layout,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 更新区块
  void _onCanvasEventUpdateBlock(
      CanvasEventUpdateBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final block =
          await blockRepo.updateBlock(event.pageId, event.blockId, event.block);
      final blocks = state.layout?.blocks ?? [];
      final index = blocks.indexWhere((element) => element.id == event.blockId);
      if (index == -1) {
        return;
      }
      emit(state.copyWith(
        layout: state.layout?.copyWith(blocks: [
          ...blocks.sublist(0, index),
          block,
          ...blocks.sublist(index + 1)
        ]),
        selectedBlock: block,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 移动区块
  void _onCanvasEventMoveBlock(
      CanvasEventMoveBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout =
          await blockRepo.moveBlock(event.pageId, event.blockId, event.sort);
      emit(state.copyWith(
        layout: layout,
        selectedBlock: event.blockId == state.selectedBlock?.id
            ? state.selectedBlock?.copyWith(sort: event.sort)
            : layout.blocks
                .firstWhere((element) => element.id == event.blockId),
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 添加区块
  void _onCanvasEventAddBlock(
      CanvasEventAddBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout =
          await blockRepo.createBlock(state.layout!.id!, event.block);

      emit(state.copyWith(
        layout: layout,
        error: '',
        saving: false,
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 删除区块
  void _onCanvasEventDeleteBlock(
      CanvasEventDeleteBlock event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      await blockRepo.deleteBlock(event.pageId, event.blockId);
      final blocks = state.layout?.blocks ?? [];
      final index = blocks.indexWhere((element) => element.id == event.blockId);
      if (index == -1) {
        return;
      }
      blocks.removeAt(index);
      emit(CanvasState(
        status: FetchStatus.populated,
        layout: state.layout?.copyWith(blocks: blocks),
        saving: false,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 加载页面
  void _onCanvasEventLoad(
      CanvasEventLoad event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      final layout = await adminRepo.get(event.id);
      final waterfallList = await _loadWaterfallData(layout);

      emit(state.copyWith(
        status: FetchStatus.populated,
        layout: layout,
        waterfallList: waterfallList,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }

  /// 保存页面
  void _onCanvasEventUpdate(
      CanvasEventUpdate event, Emitter<CanvasState> emit) async {
    emit(state.copyWith(saving: true));
    try {
      final layout = await adminRepo.update(event.id, event.layout);
      emit(state.copyWith(
        saving: false,
        layout: layout,
        error: '',
      ));
    } catch (e) {
      _handleError(emit, e);
    }
  }
}
```

上面代码中，我们定义了一系列的事件，这些事件都是对应的操作，比如：加载页面、保存页面、插入区块、更新区块、移动区块、添加区块、删除区块等等。

### 8.3.6 实现最终的画布

最终的画布，和之前类似，我们需要在外层包裹 `MultiRepositoryProvider` 和 `MultiBlocProvider`，然后利用 `BlocConsumer` 来监听状态变化，然后根据状态来渲染不同的页面。

```dart
library canvas;

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:nested/nested.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'center_pane.dart';
import 'right_pane.dart';

export 'left_pane.dart';
export 'models/widget_data.dart';

/// 画布页面
/// [id] 画布id
/// [scaffoldKey] scaffold key
class CanvasPage extends StatelessWidget {
  const CanvasPage({
    super.key,
    required this.id,
    required this.scaffoldKey,
  });
  final int id;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      /// 仓库提供者
      providers: _buildRepositoryProviders,
      child: MultiBlocProvider(
        /// bloc提供者
        providers: _buildBlocProviders,
        child: Builder(builder: (context) {
          final productRepository = context.read<ProductRepository>();
          return BlocConsumer<CanvasBloc, CanvasState>(
            listener: (context, state) {
              if (state.error.isNotEmpty) {
                _handleErrors(context, state);
              }
            },
            builder: (context, state) {
              if (state.status == FetchStatus.initial) {
                return const Text('initial').center();
              }
              if (state.status == FetchStatus.loading) {
                return const CircularProgressIndicator().center();
              }
              final rightPane =
                  _buildRightPane(state, productRepository, context);
              final centerPane = _buildCenterPane(state, context);
              final body = _buildBody(context, centerPane, rightPane);

              return Scaffold(
                key: scaffoldKey,
                body: body,
                endDrawer: Drawer(child: rightPane),
              );
            },
          );
        }),
      ),
    );
  }

  /// 处理错误，显示snackbar
  void _handleErrors(BuildContext context, CanvasState state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(state.error,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            )),
      ),
    );
    context.read<CanvasBloc>().add(CanvasEventErrorCleared());
  }

  /// 构建 BlocProviders 数组
  List<SingleChildWidget> get _buildBlocProviders => [
        BlocProvider<CanvasBloc>(
          create: (context) => CanvasBloc(
            context.read<PageAdminRepository>(),
            context.read<PageBlockRepository>(),
            context.read<PageBlockDataRepository>(),
            context.read<ProductRepository>(),
          )..add(CanvasEventLoad(id)),
        ),
      ];

  /// 构建 RepositoryProviders 数组
  List<SingleChildWidget> get _buildRepositoryProviders => [
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(),
        ),
        RepositoryProvider<PageBlockRepository>(
          create: (context) => PageBlockRepository(),
        ),
        RepositoryProvider<PageBlockDataRepository>(
          create: (context) => PageBlockDataRepository(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(),
        ),
      ];

  /// 构建主体，包含中间部分和右侧部分
  Widget _buildBody(
          BuildContext context, CenterPane centerPane, RightPane rightPane) =>
      (Responsive.isDesktop(context)
              ? [centerPane, const Spacer(), rightPane.expanded(flex: 4)]
              : [centerPane])
          .toRow(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
      );

  /// 构建中间部分
  CenterPane _buildCenterPane(CanvasState state, BuildContext context) =>
      CenterPane(
        blocks: state.layout?.blocks ?? [],
        products: state.waterfallList,
        defaultBlockConfig: BlockConfig(
          horizontalPadding: 12,
          verticalPadding: 12,
          horizontalSpacing: 6,
          verticalSpacing: 6,
          blockWidth: (state.layout?.config.baselineScreenWidth ?? 375.0) - 24,
          blockHeight: 140,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent,
          borderWidth: 0,
        ),
        pageConfig: state.layout?.config ??
            const PageConfig(
              horizontalPadding: 0.0,
              verticalPadding: 0.0,
              baselineScreenWidth: 375.0,
            ),
        onTap: () => context.read<CanvasBloc>().add(CanvasEventSelectNoBlock()),
        onBlockAdded: (block) => context
            .read<CanvasBloc>()
            .add(CanvasEventAddBlock(state.layout!.id!, block)),
        onBlockInserted: (block) => context
            .read<CanvasBloc>()
            .add(CanvasEventInsertBlock(state.layout!.id!, block)),
        onBlockSelected: (block) =>
            context.read<CanvasBloc>().add(CanvasEventSelectBlock(block)),
        onBlockMoved: (block, targetSort) => context.read<CanvasBloc>().add(
            CanvasEventMoveBlock(state.layout!.id!, block.id!, targetSort)),
      );

  /// 构建右侧部分
  RightPane _buildRightPane(CanvasState state,
          ProductRepository productRepository, BuildContext context) =>
      RightPane(
        showBlockConfig: state.selectedBlock != null,
        selectedBlock: state.selectedBlock,
        layout: state.layout,
        productRepository: productRepository,
        onSavePageBlock: (pageBlock) => context.read<CanvasBloc>().add(
              CanvasEventUpdateBlock(
                  state.layout!.id!, pageBlock.id!, pageBlock),
            ),
        onSavePageLayout: (pageLayout) => context.read<CanvasBloc>().add(
              CanvasEventUpdate(state.layout!.id!, pageLayout),
            ),
        onDeleteBlock: (blockId) => _deleteBlock(context, state, blockId),
        onCategoryAdded: (data) =>
            context.read<CanvasBloc>().add(CanvasEventAddBlockData(data)),
        onCategoryUpdated: (data) =>
            context.read<CanvasBloc>().add(CanvasEventUpdateBlockData(data)),
        onCategoryRemoved: (dataId) =>
            context.read<CanvasBloc>().add(CanvasEventDeleteBlockData(dataId)),
        onProductAdded: (data) =>
            context.read<CanvasBloc>().add(CanvasEventAddBlockData(data)),
        onProductRemoved: (dataId) =>
            context.read<CanvasBloc>().add(CanvasEventDeleteBlockData(dataId)),
        onImageAdded: (imageData) =>
            context.read<CanvasBloc>().add(CanvasEventAddBlockData(
                  imageData,
                )),
        onImageRemoved: (dataId) =>
            context.read<CanvasBloc>().add(CanvasEventDeleteBlockData(dataId)),
      );

  /// 删除区块
  Future<void> _deleteBlock(
      BuildContext context, CanvasState state, int blockId) async {
    final bloc = context.read<CanvasBloc>();
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('删除'),
            content: const Text('确定要删除吗？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
    if (result) {
      bloc.add(
        CanvasEventDeleteBlock(state.layout!.id!, blockId),
      );
    }
  }
}
```
