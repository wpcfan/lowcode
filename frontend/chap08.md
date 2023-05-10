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
    - [实现左侧面板](#实现左侧面板)
    - [实现中间画布](#实现中间画布)

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

### 实现左侧面板

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

### 实现中间画布

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

上面的代码中，我们通过`Draggable`和`DragTarget`实现了拖拽功能，通过`Draggable`我们可以拖拽出一个`feedback`，通过`DragTarget`我们可以接收一个`Draggable`传递过来的数据。这个组件比较复杂的原因是每个 `Draggable` 同时也是一个 `DragTarget`，这样可以实现拖拽排序的功能。

另外需要注意的是，我们这个画布上重用了`BannerWidget`、`ImageRowWidget`、`ProductRowWidget`、`WaterfallWidget`这几个组件，这些组件都是通过`PageBlock`的`type`属性来区分的，这样可以实现不同类型的组件在画布上的拖拽和排序。而且为了可视化的效果，我们需要给这些没有数据的组件一些默认的数据，这样才能在画布上看到效果。

右侧面板的代码如下：

```dart
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'widgets/widgets.dart';

/// 右侧面板
/// [state] 画布状态
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
    required this.state,
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
  });
  final CanvasState state;
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
                    block: state.selectedBlock!,
                    onSave: onSavePageBlock,
                    onDelete: onDeleteBlock,
                  ),
                  _buildBlockDataPane(),
                ],
              ),
            ),
          )
        : PageConfigForm(
            layout: state.layout!,
            onSave: onSavePageLayout,
          );
    return child.padding(horizontal: 12);
  }

  BlockDataPane _buildBlockDataPane() {
    return BlockDataPane(
      block: state.selectedBlock!,
      productRepository: productRepository,
      onCategoryAdded: (category) {
        final data = BlockData<Category>(
          sort: state.selectedBlock!.data.length,
          content: category,
        );
        onCategoryAdded(data);
      },
      onCategoryUpdated: (category) {
        final matchedData = state.selectedBlock!.data.first;
        final data = BlockData<Category>(
          id: matchedData.id,
          sort: matchedData.sort,
          content: category,
        );
        onCategoryUpdated(data);
      },
      onCategoryRemoved: (category) {
        final index = state.selectedBlock!.data
            .indexWhere((element) => element.content.id == category.id);
        if (index == -1) return;
        onCategoryRemoved.call(index);
      },
      onProductAdded: (product) {
        final data = BlockData<Product>(
          sort: state.selectedBlock!.data.length,
          content: product,
        );
        onProductAdded(data);
      },
      onProductRemoved: (product) {
        final index = state.selectedBlock!.data
            .indexWhere((element) => element.content.id == product.id);
        if (index == -1) return;
        onProductRemoved(state.selectedBlock!.data[index].id!);
      },
      onImageAdded: (image) {
        final data = BlockData<ImageData>(
          sort: state.selectedBlock!.data.length,
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
