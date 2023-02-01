# 后台 API

后台的技术架构采用 `SpringBoot 3.0` , `SpringBoot 3.0` 是一次重大的升级， 要求 JDK 版本为 17 以上， 本项目采用 `JDK 19` 进行开发。

## Java 版本

Java 目前每年都会发布新的版本， 但是新版本的发布并不是每个人都能够及时的升级， 本项目采用 `JDK 19` 进行开发， 但是也会考虑向下兼容， 也就是说， 本项目的代码可以在 `JDK 17` 以上的版本上运行。
需要注意的是，在生产环境下我们最好使用 LTS 版本，也就是长期维护版本。Java 目前的 LTS 版本和其维护截止日期如下：

| 版本     | 维护截止日期     |
|--------|------------|
| JDK 8  | 2025-03-18 |
| JDK 11 | 2026-09-14 |
| JDK 17 | 2029-09-14 |

中间的过渡版本会引入新的特性，但是不会有长期的维护，在新特性稳定后才会发布 LTS 版本。

### Java 各版本的新特性

| 版本     | 新特性                                               |
|--------|---------------------------------------------------|
| JDK 8  | Lambda 表达式，方法引用，Stream API，Optional，Date/Time API |
| JDK 11 | 模块化系统，HTTP 客户端，JSON API，var，ZGC                   |
| JDK 17 | Records，Sealed Classes，Pattern Matching           |

#### Lambda 表达式

Lambda 表达式是 Java 8 中引入的一个新特性，它允许把函数作为一个方法的参数（函数作为参数传递进方法中）。使用 Lambda 表达式可以使代码变的更加简洁紧凑。

```java
// Java 7
Collections.sort(list, new Comparator<String>() {
    @Override
    public int compare(String o1, String o2) {
        return o1.compareTo(o2);
    }
});

// Java 8
Collections.sort(list, (String o1, String o2) -> {
    return o1.compareTo(o2);
});
```

#### 方法引用

方法引用通过方法的名字来指向一个方法。方法引用可以使语言的构造更紧凑简洁，减少冗余代码。

```java
// Java 7
Collections.sort(list, new Comparator<String>() {
    @Override
    public int compare(String o1, String o2) {
        return o1.compareTo(o2);
    }
});

// Java 8
Collections.sort(list, String::compareTo);
```

#### Stream API

Stream API 是 Java 8 中引入的一个新特性，它提供了一种高效且易于使用的处理数据的方式。Stream API 可以处理集合、数组等数据源中的数据。Stream API 不会改变原来的数据源，而是返回一个持有结果的新 Stream。

```java
// Java 7
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd", "", "jkl");
List<String> filtered = new ArrayList<>();
for (String string : strings) {
    if (!string.isEmpty()) {
        filtered.add(string);
    }
}

// Java 8
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd", "", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
```

#### Optional

Optional 类是 Java 8 中引入的一个新特性，它用来解决空指针异常。Optional 类的引入很好的解决空指针异常的问题，但是它也带来了一些问题，比如 Optional 类的使用不当会导致代码变得冗余，可读性差等问题。

```java
// Java 7
String name = null;
if (person != null) {
    name = person.getName();
}

// Java 8
String name = Optional.ofNullable(person).map(Person::getName).orElse("Unknown");
```

#### Date/Time API

Date/Time API 是 Java 8 中引入的一个新特性，它提供了一套新的 API 来处理日期和时间。Date/Time API 使日期和时间的处理变得更加简单，也解决了 Java 旧的日期和时间 API 存在的一些问题。

```java
// Java 7
Date date = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String formattedDate = sdf.format(date);

// Java 8
LocalDateTime now = LocalDateTime.now();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
String formattedDate = now.format(formatter);
```

#### 模块化系统

模块化系统是 Java 9 中引入的一个新特性，它允许把 Java 代码分成不同的模块，每个模块都有自己的命名空间，模块之间的依赖关系通过模块描述符来描述。模块化系统使得 Java 代码的组织变得更加清晰，也使得 Java 代码的重用变得更加容易。
简单来说模块化就是"Java包的包"，在包的上一层再抽象一层，把包组织成模块，模块之间的依赖关系通过模块描述符来描述。

Java 从 JDK 9 开始本身就是一个模块化的系统，可以通过以下命令查看 Java 9 或以上的 JDK 中的模块。

```bash
java --list-modules
```

如果是 Java 11，那么你会看到下面的输出结果

```
java.base@11.0.17
java.compiler@11.0.17
java.datatransfer@11.0.17
java.desktop@11.0.17
java.instrument@11.0.17
java.logging@11.0.17
java.management@11.0.17
java.management.rmi@11.0.17
java.naming@11.0.17
java.net.http@11.0.17
java.prefs@11.0.17
java.rmi@11.0.17
java.scripting@11.0.17
java.se@11.0.17
java.security.jgss@11.0.17
java.security.sasl@11.0.17
java.smartcardio@11.0.17
java.sql@11.0.17
java.sql.rowset@11.0.17
java.transaction.xa@11.0.17
java.xml@11.0.17
java.xml.crypto@11.0.17
jdk.accessibility@11.0.17
jdk.attach@11.0.17
jdk.charsets@11.0.17
jdk.compiler@11.0.17
jdk.crypto.cryptoki@11.0.17
jdk.crypto.ec@11.0.17
jdk.dynalink@11.0.17
jdk.editpad@11.0.17
jdk.hotspot.agent@11.0.17
jdk.httpserver@11.0.17
jdk.internal.ed@11.0.17
jdk.internal.jvmstat@11.0.17
jdk.internal.le@11.0.17
jdk.internal.opt@11.0.17
jdk.internal.vm.ci@11.0.17
jdk.internal.vm.compiler@11.0.17
jdk.internal.vm.compiler.management@11.0.17
jdk.jartool@11.0.17
jdk.javadoc@11.0.17
jdk.jcmd@11.0.17
jdk.jconsole@11.0.17
jdk.jdeps@11.0.17
jdk.jdi@11.0.17
jdk.jdwp.agent@11.0.17
jdk.jfr@11.0.17
jdk.jlink@11.0.17
jdk.jshell@11.0.17
jdk.jsobject@11.0.17
jdk.jstatd@11.0.17
jdk.localedata@11.0.17
jdk.management@11.0.17
jdk.management.agent@11.0.17
jdk.management.jfr@11.0.17
jdk.naming.dns@11.0.17
jdk.naming.ldap@11.0.17
jdk.naming.rmi@11.0.17
jdk.net@11.0.17
jdk.pack@11.0.17
jdk.rmic@11.0.17
jdk.scripting.nashorn@11.0.17
jdk.scripting.nashorn.shell@11.0.17
jdk.sctp@11.0.17
jdk.security.auth@11.0.17
jdk.security.jgss@11.0.17
jdk.unsupported@11.0.17
jdk.unsupported.desktop@11.0.17
jdk.xml.dom@11.0.17
jdk.zipfs@11.0.17
```

#### JShell

JShell 是 Java 9 中引入的一个新特性，它是一个交互式的 Java 解释器，它可以用来执行 Java 代码，也可以用来执行 Java 代码片段。JShell 是一个 REPL（Read-Eval-Print-Loop）环境，它可以用来执行 Java 代码，也可以用来执行 Java 代码片段。

```bash
jshell> ++i
$5 ==> 4

jshell> int i = 1
i ==> 1

jshell> i++
$7 ==> 1

jshell> i
i ==> 2

jshell> ++i
$9 ==> 3
```

可以使用下面命令启动 JShell

```bash
jshell
```

#### Process API

Process API 是 Java 9 中引入的一个新特性，它是一个进程 API，它可以用来启动一个进程，也可以用来获取一个进程的信息。Process API 与 Java 8 中引入的 ProcessBuilder 非常类似，但是 Process API 的 API 更加简洁。

```java
ProcessHandle processHandle = ProcessHandle.current();
System.out.println(processHandle.pid());
System.out.println(processHandle.info().command());
System.out.println(processHandle.info().commandLine());
System.out.println(processHandle.info().user());
System.out.println(processHandle.info().startInstant());
System.out.println(processHandle.info().totalCpuDuration());
System.out.println(processHandle.info().arguments());
```

#### JFR

JFR 是 Java 11 中引入的一个新特性，它是一个 Java Flight Recorder，它可以用来记录 Java 应用程序的运行时信息，比如 CPU 使用率、内存使用率、线程数量、GC 次数等等。JFR 是一个非常强大的性能分析工具，它可以用来分析 Java 应用程序的性能问题。

```java
public class JfrDemo {
    public static void main(String[] args) throws IOException {
        try (FileOutputStream fos = new FileOutputStream("jfr-demo.jfr")) {
            FlightRecorderMXBean flightRecorderMXBean = ManagementFactory.getPlatformMXBean(FlightRecorderMXBean.class);
            flightRecorderMXBean.dumpFlightRecording("jfr-demo.jfr");
        }
    }
}
```

#### HttpClient

HttpClient 是 Java 11 中引入的一个新特性，它是一个 HTTP 客户端，它可以用来发送 HTTP 请求，也可以用来解析 HTTP 响应。HttpClient 是一个异步的 HTTP 客户端，它的 API 与 Java 8 中引入的 CompletableFuture 非常类似，它的 API 也是基于回调函数的。

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://www.baidu.com"))
    .build();
CompletableFuture<HttpResponse<String>> response = client.sendAsync(request, HttpResponse.BodyHandlers.ofString());
response.thenAccept(res -> System.out.println(res.body()));
```

#### JSON API

JSON API 是 Java 11 中引入的一个新特性，它是一个 JSON API，它可以用来解析 JSON 数据，也可以用来生成 JSON 数据。JSON API 是一个非常强大的 JSON 解析工具，它的 API 与 Java 8 中引入的 Stream API 非常类似，它的 API 也是基于回调函数的。

```java
JsonReader jsonReader = Json.createReader(new StringReader("{\"name\":\"zhangsan\",\"age\":18}"));
JsonObject jsonObject = jsonReader.readObject();
jsonReader.close();
System.out.println(jsonObject.getString("name"));
System.out.println(jsonObject.getInt("age"));
```

#### var

var 是 Java 10 中引入的一个新特性，它是一个关键字，它可以用来声明一个变量，它的类型会根据变量的初始化表达式自动推断出来。var 是一个非常强大的特性，它可以让代码更加简洁，也可以让代码更加易读。

```java
var i = 1;
var s = "hello";
var list = new ArrayList<String>();
```

#### ZGC

ZGC 是 Java 11 中引入的一个新特性，它是一个 Z Garbage Collector，它是一个低延迟的垃圾收集器，它可以用来替代 CMS 垃圾收集器。ZGC 是一个非常强大的垃圾收集器，它可以让 Java 应用程序的响应时间更加稳定。
在 Java 11 环境启用 ZGC 垃圾收集器，需要在启动参数中添加如下配置：

```java
-XX:+UnlockExperimentalVMOptions
-XX:+UseZGC
```

#### Records

Records 是 Java 14 中引入的一个新特性，它是一个记录，它可以用来声明一个记录，它的属性会根据构造函数的参数自动推断出来。Records 是一个非常强大的特性，它可以让代码更加简洁，也可以让代码更加易读。

在没有它之前，我们一般会使用 Lombok 来生成 getter、setter、toString、equals、hashCode 等方法，但是对于 Records 来说，它已经自带了这些方法，所以我们不需要再使用 Lombok 来生成这些方法了。
当然它还无法完全取代 Lombok，因为它还不支持 @Data、@Builder、@AllArgsConstructor、@NoArgsConstructor、@RequiredArgsConstructor 等注解，所以我们还是需要使用 Lombok 来生成这些方法。
而且对于 JPA 的实体类来说，它还不支持 @Entity、@Table、@Id、@GeneratedValue 等注解，所以我们还是需要使用 Lombok 来生成这些注解。

目前来说它的最佳使用场景是 DTO，比如我们可以使用它来声明一个 UserDTO，它的属性会根据构造函数的参数自动推断出来。

```java
public record UserDTO(String name, int age) {
}
```

在 Spring Data 中，我们进行查询时，需要的结构往往和实体类有一定区别，这时候我们就可以使用它来声明一个 DTO，由于 Record 的简洁性，我们省去了原来的很多代码。

```java
public interface UserRepository extends JpaRepository<User, Long> {
    @Query("select new com.example.demo.UserDTO(u.name, u.age) from User u")
    List<UserDTO> findAllUserDTO();
}
```

#### Switch 模式匹配

Switch 模式匹配 是 Java 12 中引入的一个新特性，它是一个 switch 表达式，它可以用来替代 switch 语句，它的语法更加简洁，也更加易读。

```java
var i = switch (s) {
    case "hello" -> 1;
    case "world" -> 2;
    default -> 3;
};
```

#### Text Blocks

Text Blocks 是 Java 15 中引入的一个新特性，它是一个文本块，它可以用来替代字符串拼接，它的语法更加简洁，也更加易读。

```java
var s = """
    hello
    world
    """;
```

如果字符串中有变量，可以使用 ${} 来引用变量。

```java
var s = """
    hello
    ${name}
    """;
```

#### Pattern Matching for instanceof

Pattern Matching for instanceof 是 Java 14 中引入的一个新特性，它是一个 instanceof 表达式，它可以用来替代 instanceof 语句，它的语法更加简洁，也更加易读。

```java
if (obj instanceof String s) {
    System.out.println(s);
}
```

#### Sealed Classes

Sealed Classes 是 Java 15 中引入的一个新特性，它是一个密封类，它可以用来声明一个密封类，它的子类只能在当前文件中声明，它的语法更加简洁，也更加易读。

```java
public sealed class Shape permits Circle, Rectangle {
}

public final class Circle extends Shape {
}

public final class Rectangle extends Shape {
}
```

## SpringBoot 的测试

SpringBoot 对于各种类型的测试的支持都非常好，它支持单元测试、集成测试、Web 测试、数据库测试等。

### 单元测试

进行单元测试时，我们需要使用 @SpringBootTest 注解来启动 SpringBoot 应用，然后使用 @Autowired 注解来注入需要测试的 Bean，最后使用 @Test 注解来声明测试方法。

```java
@SpringBootTest
class DemoApplicationTests {

    @Autowired
    private UserService userService;

    @Test
    void contextLoads() {
        System.out.println(userService.findAll());
    }

}
```

#### Mock

在进行单元测试时，我们可能会经常遇到 Mock 的情况，Mock 是一种模拟对象，它可以用来模拟一个对象的行为，我们可以通过 Mockito 来进行 Mock。
比如我们有一个 UserService 类，它依赖于一个 UserRepository 类，我们可以通过 Mockito 来模拟 UserRepository 类的行为，然后将模拟的 UserRepository 类注入到 UserService 类中，这样我们就可以对 UserService 类进行单元测试了。

```java
@SpringBootTest
class DemoApplicationTests {

    @Autowired
    private UserService userService;

    @Test
    void contextLoads() {
        var userRepository = Mockito.mock(UserRepository.class);
        Mockito.when(userRepository.findAll()).thenReturn(List.of(new User()));
        userService.setUserRepository(userRepository);
        System.out.println(userService.findAll());
    }

}
```

上面代码中，我们通过 Mockito 来模拟 UserRepository 类的 findAll 方法，然后将模拟的 UserRepository 类注入到 UserService 类中，这样我们就可以对 UserService 类进行单元测试了。

很多初次接触 Mock 概念的同学可能会有疑问，为什么要使用 Mock 呢？我们可以通过下面的代码来对比一下使用 Mock 和不使用 Mock 的区别。

```java
@SpringBootTest
class DemoApplicationTests {

    @Autowired
    private UserService userService;

    @Test
    void contextLoads() {
        System.out.println(userService.findAll());
    }

}
```

上面代码中，我们没有使用 Mock，而是直接调用了 UserService 类的 findAll 方法，这样的话，我们就需要在测试环境中配置好数据库，然后在测试之前先往数据库中插入一些数据，这样才能保证测试的正确性，这样的话，我们的测试就和生产环境耦合在了一起，我们的测试就不是一个单元测试了，而是一个集成测试。
这种集成测试要求你的所有依赖都要正常运行起来，比如数据库，比如 Redis，比如 RabbitMQ 等等，这样的话，你的测试就会变得非常复杂。

#### MockMvc

在进行 Web 层的单元测试时，我们可以使用 MockMvc 来进行测试，MockMvc 是 Spring 提供的一个模拟 MVC 请求的工具类，它可以模拟发送 HTTP 请求，然后对返回的结果进行断言。

```java
@SpringBootTest
class DemoApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void contextLoads() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/user"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("$.length()").value(2))
                .andExpect(MockMvcResultMatchers.jsonPath("$[0].name"), Matchers.is("张三"));
    }
}
```

上面代码中，我们使用 MockMvc 来模拟发送了一个 GET 请求，然后对返回的结果进行了断言，断言的结果是返回的状态码是 200，然后断言返回的结果是一个 JSON 数组，数组的长度是 2。

注意 `$` 符号，它表示的是根节点，也就是整个 JSON 对象，`$.length()` 表示的是 JSON 数组的长度。如果 JSON 数组中的元素是一个对象，我们也可以使用 `$.name` 来获取对象中的 name 属性。
如果你的代码编译出错，提示找不到 `Matchers.is` 方法，那么你需要在 `build.gradle` 文件中添加如下依赖：

```gradle
testImplementation 'org.hamcrest:hamcrest-library'
```

### 集成测试

集成测试是指将多个模块组合在一起进行测试，它的目的是为了验证各个模块之间的交互是否符合预期，以及验证整个系统是否符合需求。

#### Spring Boot 的集成测试

Spring Boot 提供了一个测试工具类 `SpringBootTest`，它可以帮助我们快速地进行集成测试，我们只需要在测试类上添加 `@SpringBootTest` 注解，然后在测试方法上添加 `@Test` 注解，就可以进行集成测试了。

集成测试中我们可能需要一些外部的资源，比如数据库，比如 Redis，比如 RabbitMQ 等等，有的情况下我们还需要指定测试用例的生命周期。比如，我们需要在测试用例执行之前，先启动一个容器，然后在测试用例执行之后，再关闭这个容器，这时候我们就可以使用 `@TestInstance` 注解来指定测试用例的生命周期，比如：

SpringBoot 提供了 `testcontainers` 的依赖，我们可以使用 `testcontainers` 来启动一个容器，比如：

```java
@DataJpaTest
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class DemoApplicationTests {
    private static final MySQLContainer<?> mySQLContainer = new MySQLContainer<>("mysql:8.0.22")
            .withDatabaseName("test")
            .withUsername("root")
            .withPassword("root");

    @BeforeAll
    static void beforeAll() {
        mySQLContainer.start();
    }

    @AfterAll
    static void afterAll() {
        mySQLContainer.stop();
    }
}
```

这种测试容器的方式，可以让我们的测试用例更加独立，不会受到其他测试用例的影响。

添加 `testcontainers` 依赖，比如希望集成测试时有 MySQL ：

```gradle
dependencies {
    // ...
    testImplementation 'org.testcontainers:mysql:1.17.6'
}
```

注意，这个版本号不一定要和文档一致，最新版本号参考：[https://mvnrepository.com/artifact/org.testcontainers/mysql](https://mvnrepository.com/artifact/org.testcontainers/mysql)

不只是数据库，我们还可以使用 `testcontainers` 来启动一个 Redis 容器，比如：

```java
@DataJpaTest
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class DemoApplicationTests {
    private static final GenericContainer<?> redisContainer = new GenericContainer<>("redis:6.0.9")
            .withExposedPorts(6379);

    @BeforeAll
    static void beforeAll() {
        redisContainer.start();
    }

    @AfterAll
    static void afterAll() {
        redisContainer.stop();
    }
}
```

`testcontainers` 具体的文档可以参考：[https://www.testcontainers.org/](https://www.testcontainers.org/)

和每个测试添加 `@TestInstance(TestInstance.Lifecycle.PER_CLASS)` 注解不同，我们可以通过在 `tests/resources` 目录下创建一个 `junit-platform.properties` 来全局设置测试用例的生命周期，比如：

```properties
junit.jupiter.testinstance.lifecycle.default = per_class
```

除了 `PER_CLASS`, 还有 `PER_METHOD` 也就是按方法的生命周期，具体的可以参考：[https://junit.org/junit5/docs/current/user-guide/#writing-tests-test-instance-lifecycle](https://junit.org/junit5/docs/current/user-guide/#writing-tests-test-instance-lifecycle)

### 测试的配置文件

在测试中，我们可能需要使用不同的配置文件，比如，我们在开发环境中使用的是 `application-dev.yml`，但是在测试环境中，我们可能需要使用 `application-test.yml`，这时候我们可以通过 `@ActiveProfiles` 注解来指定测试用例使用的配置文件，比如：

```java
@DataJpaTest
@ActiveProfiles("test")
class DemoApplicationTests {
}
```

也可以使用 `@TestPropertySource` 注解来指定测试用例使用的配置文件，比如：

```java
@DataJpaTest
@TestPropertySource("classpath:application-test.yml")
class DemoApplicationTests {
}
```

## Spring Data JPA

### Spring Data JPA 的使用

Spring Data JPA 是 Spring Data 的一个子项目，它是一个基于 JPA 的数据访问层框架，它可以让我们在不写任何代码的情况下，通过简单的配置就可以实现对数据库的增删改查操作。

#### Spring Data JPA 的依赖

Spring Data JPA 的依赖如下：

```gradle
implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
```

#### Spring Data JPA 的配置

Spring Data JPA 的样例配置如下：

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2B8
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.database=mysql
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL5InnoDBDialect
```

### Spring Data JPA 的实体类

实体类是一个简单的 POJO，它需要使用 JPA 的注解来标注它的属性，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private Integer age;

    // getter and setter
}
```

上面代码中，我们使用了 `@Entity` 注解来标注这是一个实体类，使用 `@Id` 注解来标注这是一个主键，使用 `@GeneratedValue` 注解来标注这是一个自增的主键。
此外，我们还可以使用 `@Table` 注解来标注这个实体类对应的表名，比如：

```java
@Entity
@Table(name = "t_user")
public class User {
    // ...
}
```

默认字段名和属性名一致，如果不一致，可以使用 `@Column` 注解来标注，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name")
    private String name;

    private Integer age;

    // getter and setter
}
```

在 `@Column` 注解中，我们还可以设置 `nullable`、`unique`、`length` 等属性，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", nullable = false, unique = true, length = 20)
    private String name;

    private Integer age;

    // getter and setter
}
```

此外，我们还可以使用 `@Temporal` 注解来标注日期类型的属性，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", nullable = false, unique = true, length = 20)
    private String name;

    private Integer age;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createTime;

    // getter and setter
}
```

当然在 Spring Data JPA 中，我们即使不使用 `@Temporal` 注解，也可以使用 `java.time` 包中的日期类型，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", nullable = false, unique = true, length = 20)
    private String name;

    private Integer age;

    private LocalDateTime createTime;

    // getter and setter
}
```

框架会自动将 `java.time` 包中的日期类型转换为数据库中的日期类型。

对于二进制或者大文本类型的属性，我们可以使用 `@Lob` 注解来标注，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", nullable = false, unique = true, length = 20)
    private String name;

    private Integer age;

    @Lob
    private byte[] avatar;

    // getter and setter
}
```

#### 实体类和数据库表的映射关系

在 Spring Data JPA 中，实体类和数据库表的映射关系如下：

| 实体类属性类型    | 数据库字段类型  |
|------------|----------|
| String     | VARCHAR  |
| Integer    | INT      |
| Long       | BIGINT   |
| Float      | FLOAT    |
| Double     | DOUBLE   |
| BigDecimal | DECIMAL  |
| Boolean    | BIT      |
| Date       | DATETIME |
| byte[]     | BLOB     |

#### 表关联的映射

在 Spring Data JPA 中，我们可以使用 `@ManyToOne`、`@OneToOne`、`@OneToMany`、`@ManyToMany` 注解来标注实体类之间的关联关系，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", nullable = false, unique = true, length = 20)
    private String name;

    private Integer age;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;

    // getter and setter
}

@Entity
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "role_name", nullable = false, unique = true, length = 20)
    private String name;

    // getter and setter
}
```

在上面的代码中，我们使用 `@ManyToOne` 注解来标注 `User` 实体类和 `Role` 实体类之间的多对一关联关系，使用 `@JoinColumn` 注解来标注外键列。

如果一个用户有多个角色，我们可以使用 `@ManyToMany` 注解来标注实体类之间的关联关系，比如：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(
            name = "user_role",
            joinColumns = @JoinColumn(name = "user_id", referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "role_id", referencedColumnName = "id")
    )
    private Set<Role> roles = new HashSet<>();

    // getters and setters
}

@Entity
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @ManyToMany(mappedBy = "roles")
    private Set<User> users = new HashSet<>();

    // getters and setters
}

public interface UserRepository extends JpaRepository<User, Long> {
}

public interface RoleRepository extends JpaRepository<Role, Long> {
}

@Service
public class UserRoleService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Transactional
    public void assignRoleToUser(Long userId, Long roleId) {
        User user = userRepository.findById(userId).orElse(null);
        Role role = roleRepository.findById(roleId).orElse(null);
        if (user != null && role != null) {
            user.getRoles().add(role);
            role.getUsers().add(user);
            userRepository.save(user);
        }
    }
}
```

在上面的代码中，我们使用 `@ManyToMany` 注解来标注 `User` 实体类和 `Role` 实体类之间的多对多关联关系，使用 `@JoinTable` 注解来标注中间表的信息。
实际创建表的时候，Spring Data JPA 会自动创建中间表，中间表的名称为 `user_role`，中间表的外键列分别为 `user_id` 和 `role_id`。
在 `Role` 实体类中，我们使用 `@ManyToMany` 注解的 `mappedBy` 属性来标注 `User` 实体类中的 `roles` 属性。
在保存的时候，请注意，我们必须要保存外键关系所在的实体类，否则外键关系不会被保存，这里就是 `User` 实体类。

在 Spring Data JPA 中，处理多对多的表关联的最佳实践如下：

1. 定义实体：定义多对多关系的两个实体，并在实体中使用 @ManyToMany 注解描述关系。
2. 定义中间表：如果需要存储关系的其他信息，可以定义中间表，并使用 @JoinTable 注解描述。
3. 使用 JPA 接口：使用 JPA 接口对数据进行操作，例如增加、更新、删除、查询等。
4. 使用事务：因为处理多对多关系需要同时对多个表进行操作，因此需要使用事务。
5. 使用 DTO 进行数据传输：如果需要从数据库中检索多个实体，可以使用 DTO 进行数据传输，以避免 N+1 查询问题。

通过以上步骤，可以轻松地处理多对多的表关联，并在不影响代码质量的前提下提高开发效率。

这里再说一下如何使用 DTO 避免 `N+1` 问题，在存在多对多关系的情况下，一般默认的查询策略是 `LAZY`，也就是说，当我们查询 `User` 实体类的时候，`Role` 实体类不会被查询，只有当我们访问 `User` 实体类的 `roles` 属性的时候，`Role` 实体类才会被查询。
如果我们查询 `User` 实体类的时候，需要同时查询 `Role` 实体类，那么就会产生 `N+1` 问题，这里的 `N` 就是 `User` 实体类的数量，`1` 就是 `Role` 实体类的数量。
用 SQL 语句来表示的话，就是查询 `User` 实体类的时候，会执行 `N` 条 `SQL` 语句，每条 `SQL` 语句都会查询 `Role` 实体类，这样就会产生 `N+1` 问题。

为了避免 `N+1` 问题，我们可以使用 DTO 来进行数据传输，比如：

```java
public class UserDTO {
    private Long id;
    private String username;
    private String password;
    private List<Role> roles;
    // 省略 getter 和 setter 方法
}
```

然后在 `UserRepository` 接口中定义一个方法，用于查询 `User` 实体类的同时查询 `Role` 实体类，比如：

```java
@Query("select new com.example.demo.dto.UserDTO(u.id, u.username, u.password, u.roles) from User u left join u.roles r")
List<UserDTO> findAllUserDTO();
```

解决 N+1 问题还可以使用 `@EntityGraph` 注解

```java
@EntityGraph(value = "User.roles", type = EntityGraph.EntityGraphType.FETCH)
List<User> findAll();
```

`@EntityGraph` 注解的 `value` 属性指定了需要查询的实体类，`type` 属性指定了查询的类型，这里使用 `FETCH` 类型，表示立即加载。
这个注解是 `JPA` 的注解，而不是 `Spring Data JPA` 的注解，因此在使用的时候需要注意。

有时我们还会遇到自关联的情况，比如商品的类目可以有父类目，也可以有子类目：

```java
@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    @ManyToOne
    @JoinColumn(name = "parent_id")
    private Category parent;
    @OneToMany(mappedBy = "parent")
    private List<Category> children;
    // 省略 getter 和 setter 方法
}
```

这里的 `parent` 属性表示父类目，`children` 属性表示子类目，这里的 `parent` 和 `children` 属性都是自关联的关系。
对于自关联的实体，存储的时候要十分小心，因为自关联的实体会形成一个环，如果不小心就会形成死循环，导致内存溢出。
处理自关联实体存储的最佳实践是：

- 在保存自关联的实体类时，需要先保存最顶层的实体类，然后再保存其他的实体类，因为在关系中通常需要使用到已经存在的实体类的 id。
- 如果是在 Java 代码中使用 JPA 完成操作，可以在设置好实体类间关系后，使用 EntityManager 或者 Repository 的 save 方法进行保存。
- 如果是在数据库中通过 SQL 语句进行保存，则需要先插入顶层实体类，再插入其他实体类，并在插入其他实体类时通过设置外键的方式与顶层实体类进行关联。

总之，关键在于先保存顶层实体类，再保存其他实体类，并在保存过程中正确设置实体类间的关系。

在进行 API 接口设计的时候，同样需要注意一对多，多对多等关系，关联的实体会形成一个环，在 JSON 输出的时候要避免这种情况。

一种方式是在实体类中使用 `@JsonIgnore` 注解，忽略自关联的属性，比如：

```java
@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    @ManyToOne
    @JoinColumn(name = "parent_id")
    @JsonIgnore
    private Category parent;
    @OneToMany(mappedBy = "parent")
    @JsonIgnore
    private List<Category> children;
    // 省略 getter 和 setter 方法
}
```

另一种方式是使用 DTO，将实体类转换为 DTO，然后再将 DTO 转换为 JSON，这样就可以避免关联的属性形成环的问题。

### 表的自动创建

Spring Data JPA 会在应用启动的时候自动创建表，但是在创建表之前，我们需要先创建数据库，比如：

```sql
CREATE DATABASE spring_data_jpa;
```

然后在 `application.properties` 文件中配置数据库连接信息，比如：

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/spring_data_jpa?useUnicode=true&characterEncoding=utf-8&useSSL=false
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

我们还可以指定表的自动创建策略，比如：

```properties
spring.jpa.hibernate.ddl-auto=create
```

Spring Data JPA 支持的表的自动创建策略如下：

| 策略          | 说明                                                                                                             |
|-------------|----------------------------------------------------------------------------------------------------------------|
| create      | 每次加载 Hibernate 时都会删除上一次的生成的表，然后根据你的 model 类再重新来生成新表，即使两次没有任何改变，也要删除表后重新创建。                                     |
| create-drop | 每次加载 Hibernate 时根据 model 类生成表，但是 sessionFactory 一关闭,表就自动删除。                                                    |
| update      | 最常用的属性，第一次加载 Hibernate 时根据 model 类会自动建立起表的结构（前提是先建立好数据库），以后加载 Hibernate 时根据 model 类自动更新表结构，即使表结构改变了，但表中的行仍然存在。 |
| validate    | 每次加载 Hibernate 时，验证创建数据库表结构，只会和数据库中的表进行比较，不会创建新表，但是会插入新值。                                                      |
| none        | 什么都不做。                                                                                                         |

一般情况下在开发阶段，我们会使用这种自动的方式来创建表，但是在生产环境中，我们会使用数据库的脚本来创建表，这样可以保证表的创建和数据的初始化是分开的。

当然还有一些更专门的数据管理框架，比如 Flyway、Liquibase 等，它们可以帮助我们管理数据库的变更，比如创建表、修改表、删除表等。

#### 导出数据库脚本

我们可以使用 `spring.jpa.hibernate.ddl-auto=none` 来禁用自动创建表，然后使用 `spring.jpa.generate-ddl=true` 来导出数据库脚本，比如：

```properties
spring.jpa.hibernate.ddl-auto=none
spring.jpa.generate-ddl=true
```

这样就会在控制台输出数据库的脚本，比如：

```sql
create table person (id bigint not null auto_increment, age integer not null, name varchar(255), primary key (id)) engine=InnoDB
```

### Spring Data JPA 的接口

传统的 Spring 应用我们会创建一个 DAO 层，它的作用是封装对数据库的访问，比如：

```java
public interface PersonRepository {
    Person save(Person person);
    void delete(Person person);
    Person findOne(Long id);
    List<Person> findAll();
}
```

Spring Data JPA 中的 Repository 也是一个接口，它的作用也是封装对数据库的访问，但是它不需要我们自己去实现，Spring Data JPA 会为我们自动实现这个接口。

```java
public interface PersonRepository extends CrudRepository<Person, Long> {
}
```

Spring Data JPA 提供了多种不同类型的 Repository，它们提供了不同的操作和功能。

以下是几种常用的 Repository 的区别：

- CrudRepository：提供了对数据存储的基本 CRUD 操作，例如：save，findOne，findAll，delete 等。
- PagingAndSortingRepository：提供了分页和排序的功能。
- JpaSpecificationExecutor：提供了使用 JPA Criteria API 进行动态查询的功能。
- ListCrudRepository：提供了对数据存储的基本 CRUD 操作，但是返回的是 List，而不是 Iterable。
- ListPagingAndSortingRepository：提供了分页和排序的功能，但是返回的是 List，而不是 Iterable。
- QueryByExampleExecutor：提供了使用 Example 进行查询的功能。
- JpaRepository：提供了对数据存储的基本 CRUD 操作，以及分页和排序的功能，它是 ListCrudRepository, ListPagingAndSortingRepository 和 QueryByExampleExecutor 的组合。

这些 Repository 各有不同的用途，具体使用哪个取决于项目需要以及个人的开发习惯。通常情况下，CrudRepository 和 JpaRepository 都是足够用的。

不管选择哪种 Repository，Spring Data JPA 都提供了一种简化数据访问的方法，极大的减少了数据访问代码的量，提高了开发效率。

### Spring Data JPA 的查询

#### 命名形式查询

Spring Data JPA 中的命名形式查询是一种在不编写实际查询的情况下通过方法名称定义查询的方式。命名形式查询遵循一组预定义的规则，以定义查询语句。

命名形式查询规则如下：

1. 查询以“find…By”开头。
2. 在“By”之后指定要查询的字段。
3. 可以指定一个或多个字段。
4. 可以使用“And”和“Or”来连接多个字段。
5. 可以使用通配符，例如“%value%”，表示查询任何包含给定值的字符串。
6. 可以使用关键字，例如“IgnoreCase”，表示查询时忽略大小写。

例如，如果想要查询姓名为某字符串的用户，可以使用以下方法：

```java
public interface UserRepository extends CrudRepository<User, Long> {
    User findByName(String name);
}
```

如果想要查询姓名为某字符串并且年龄为某数字的用户，可以使用以下方法：

```java
public interface UserRepository extends CrudRepository<User, Long> {
    User findByNameAndAge(String name, Integer age);
}
```

命名形式查询是一种非常灵活的方法，可以快速简便地定义查询。通过命名形式查询，可以避免编写大量的查询代码，提高开发效率。

如果涉及到表关联时，比如用户和地址是一对多的关系，那么可以使用以下方法查询某个城市的所有用户：

```java
public interface UserRepository extends CrudRepository<User, Long> {
    User findByAddressCity(String city);
}
```

上面的命名中，Address 是 Address 实体类的名称，City 是 Address 实体类中的一个属性。为避免歧义，可以使用以下方法：

```java
public interface UserRepository extends CrudRepository<User, Long> {
    User findByAddress_City(String city);
}
```

其中 `_` 用来分隔实体类和属性。

值得指出的是，对于多对多的关系，Spring Data JPA 依然可以通过命名形式查询来实现。例如，如果用户和角色是多对多的关系，那么可以使用以下方法查询某个角色的所有用户：

```java
public interface UserRepository extends CrudRepository<User, Long> {
    User findByRoles_Name(String name);
}
```

注意，这里的 `Roles` 是 `User` 实体类中的一个属性，是用户的角色集合，`Name` 是 `Role` 实体类中的一个属性。

#### @Query 注解查询

除了使用命名形式查询，Spring Data JPA 还提供了另一种查询方式，即使用 `@Query` 注解来定义查询。`@Query` 注解可以定义在 Repository 接口的方法上，也可以定义在实体类的方法上。

```java
public interface UserRepository extends CrudRepository<User, Long> {
    @Query("select u from User u where u.name = ?1")
    User findUser(String name);
}
```

上面的代码中，`@Query` 注解中的 `value` 属性表示查询语句，`?1` 表示第一个参数，`?2` 表示第二个参数，以此类推。

需要注意的是注解中并不是真正的 SQL 语句，而是 JPA 查询语句，因此 `@Query` 注解中的查询语句并不是真正的 SQL 语句，而是 JPA 查询语句。例如，上面的查询语句可以翻译成如下的 SQL 语句：

```sql
select * from user where name = ?
```

JQL 语句和 SQL 语句的区别在于，JQL 语句中的表名和列名都是实体类的名称和属性，而不是数据库表的名称和列名。

#### Example 查询

Spring Data JPA 提供了 Example 查询，它的特点和优势如下：

1. 灵活性：可以根据查询条件动态构建 Example，而不需要写多余的 DAO 层代码。
2. 可读性：使用 Example 的查询条件是定义在单独的类中的，这样比直接写在 DAO 中的 JPQL 或 SQL 语句更加可读性。
3. 可维护性：使用 Example 的查询条件是定义在单独的类中的，这样比直接写在 DAO 中的 JPQL 或 SQL 语句更加可维护性。
4. 可扩展性：可以根据需要扩展 Example 的查询条件，而不需要修改 DAO 层代码。
5. 可复用性：可以将 Example 的查询条件抽取出来，作为一个公共的查询条件类，这样可以在多个 DAO 中复用。
6. 可测试性：可以使用单元测试来测试 Example 的查询条件，而不需要启动 Spring 容器。
7. 性能：Example 查询的性能比直接写在 DAO 中的 JPQL 或 SQL 语句要好。
8. 语法：Example 查询的语法比直接写在 DAO 中的 JPQL 或 SQL 语句要简单。
9. 代码量：Example 查询的代码量比直接写在 DAO 中的 JPQL 或 SQL 语句要少。

我们从一个例子来看看 Example 查询的用法。首先，定义一个查询条件类：

```java
public class UserExample {
    private String name;
    private Integer age;
    // 省略 getter 和 setter 方法
}
```

然后，定义一个查询方法：

```java
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findAll(Example<User> example);
}
```

最后，调用查询方法：

```java
UserExample userExample = new UserExample();
userExample.setName("张三");
userExample.setAge(20);
Example<User> example = Example.of(userExample);
List<User> users = userRepository.findAll(example);
```

再来看一个表关联的例子，其中 User 类和 Role 类是多对多的关系，我们需要查询出所有角色名为 `admin` 的用户：

```java
public class UserExample {
    private String name;
    private Integer age;
    private List<Role> roles;
    // 省略 getter 和 setter 方法
}
```

```java
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findAll(Example<User> example);
}
```

```java
UserExample userExample = new UserExample();
userExample.setRoles(Arrays.asList(new Role("admin")));
Example<User> example = Example.of(userExample);
List<User> users = userRepository.findAll(example);
```


#### Specification 查询

Spring Data JPA Specification 是一种基于类的查询方式，它的特点和优势如下：

1. 灵活性：可以根据查询条件动态构建 Specification，而不需要写多余的 DAO 层代码。
2. 可读性：使用 Specification 的查询条件是定义在单独的类中的，这样比直接写在 DAO 中的 JPQL 或 SQL 语句更加可读性。
3. 可维护性：使用 Specification 的查询条件是定义在单独的类中的，这样对于每一种查询条件可以单独维护，而不需要在 DAO 层对多余的代码进行维护。
4. 复用性：Specification 可以复用，即一个 Specification 可以在多个地方使用，这样可以提高代码的复用率。
5. 可测试性：Specification 可以独立测试，不需要依赖数据库。

总的来说，使用 Specification 可以提高代码的可读性、可维护性、复用性和可测试性，从而提高开发效率。

以下是一个使用 Spring Data JPA 的 Specification 的代码示例

1.首先，我们需要定义 UserSpecification 类，用来封装查询条件：

```java
import org.springframework.data.jpa.domain.Specification;

public class UserSpecification {

    public static Specification<User> findByName(String name) {
        return (root, query, builder) -> builder.equal(root.get("name"), name);
    }

    public static Specification<User> findByRole(Role role) {
        return (root, query, builder) -> builder.equal(root.get("roles"), role);
    }

    public static Specification<User> findByNameAndRole(String name, Role role) {
        return Specification.where(findByName(name)).and(findByRole(role));
    }
}
```

上面代码中，root, query, builder 是一组参数，分别代表了在 Specification 查询中的三个重要对象。

1. root: 表示查询的根对象，通常是实体类。
2. query: 表示查询对象，可以用于定义查询的结果集、排序、分页等。
3. builder: 表示条件构造器，用于构建查询条件。

这三个参数一起构成了 Specification 查询的基本结构，其中 root 和 builder 用于定义查询的条件，query 用于定义查询的结果。

在 `findByNameAndRole` 方法中，我们使用了 `Specification.where` 方法来构建查询条件，这个方法的作用是将两个查询条件进行组合，这里我们使用了 `and` 方法，也可以使用 `or` 方法。

2.然后，在 UserRepository 中使用 Specification 进行查询：

```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
}
```

3.最后，在业务代码中使用 Specification 进行查询：

```java
import org.springframework.beans.factory.annotation.Autowired;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public List<User> findByName(String name) {
        return userRepository.findAll(UserSpecification.findByName(name));
    }

    public List<User> findByRole(Role role) {
        return userRepository.findAll(UserSpecification.findByRole(role));
    }
}
```

如果你更习惯传统的 Java 编码方式，也可以实现 Specification 接口，然后在业务代码中直接使用：

```java
class UserSpecification implements Specification<User> {

    private String name;

    private Role role;

    public UserSpecification(String name, Role role) {
        this.name = name;
        this.role = role;
    }

    @Override
    public Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
        return builder.and(builder.equal(root.get("name"), name), builder.equal(root.get("roles"), role));
    }
}
```

或者通过匿名内部类的方式：

```java
import org.springframework.beans.factory.annotation.Autowired;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public List<User> findByName(String name) {
        return userRepository.findAll(new Specification<User>() {
            @Override
            public Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
                return builder.equal(root.get("name"), name);
            }
        });
    }

    public List<User> findByRole(Role role) {
        return userRepository.findAll(new Specification<User>() {
            @Override
            public Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
                return builder.equal(root.get("roles"), role);
            }
        });
    }
}
```

#### 自定义 Repository

基础的增删改查通过 Spring Data JPA 提供的 `JpaRepository` 已经可以满足我们的需求。但有时我们还是需要定义一些自定义的操作，比如某些批处理的更新操作，这时我们就需要自定义 Repository。

和我们的直觉不同，我们不是直接在 UserRepository 中定义自定义的方法，而是需要定义一个接口，然后让 UserRepository 继承这个接口。

```java
public interface CustomUserRepository {
    void updateNameById(Long id, String name);
}

public class CustomUserRepositoryImpl implements CustomUserRepository {

    @Autowired
    private EntityManager entityManager;

    @Override
    public void updateNameById(Long id, String name) {
        entityManager.createQuery("update User u set u.name = ?1 where u.id = ?2")
                .setParameter(1, name)
                .setParameter(2, id)
                .executeUpdate();
    }
}

public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User>, CustomUserRepository {

    List<User> findByName(String name);

    List<User> findByRole(Role role);
}
```

### Spring Data JPA 的分页支持

Spring Data JPA 提供了一个 Pageable 接口，它可以帮助我们进行分页查询。我们可以通过 PageRequest.of() 方法来创建一个 Pageable 对象，它有两个参数，第一个参数是页码，第二个参数是每页的大小。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public Page<User> findByName(String name, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return userRepository.findByName(name, pageable);
    }
}

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Page<User> findByName(String name, Pageable pageable);

    List<User> findByRole(Role role);
}
```

请注意，上面我们使用的是 `Page<User> findByName(String name, Pageable pageable)` 方法，它返回的是一个 Page 对象，而不是 List 对象。Page 对象是 Spring Data JPA 提供的一个接口，它继承了 Iterable 接口，所以我们可以使用 for-each 循环来遍历它。

```java
Page<User> page = userService.findByName("张三", 0, 10);
for (User user : page) {
    System.out.println(user);
}
```

Page 对象还提供了一些有用的方法，比如获取总页数、总记录数、当前页的记录数等。

```java
Page<User> page = userService.findByName("张三", 0, 10);
System.out.println("总页数：" + page.getTotalPages());
System.out.println("总记录数：" + page.getTotalElements());
System.out.println("当前页的记录数：" + page.getNumberOfElements());
```

### Spring Data JPA 的排序支持

Spring Data JPA 提供了一个 Sort 接口，它可以帮助我们进行排序查询。我们可以通过 Sort.by() 方法来创建一个 Sort 对象，它有两个参数，第一个参数是排序的字段，第二个参数是排序的方向。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public List<User> findByName(String name) {
        Sort sort = Sort.by(Sort.Direction.DESC, "id");
        return userRepository.findByName(name, sort);
    }
}

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findByName(String name, Sort sort);

    List<User> findByRole(Role role);
}
```

当然 Pageable 接口也是继承了 Sort 接口，所以我们也可以通过 PageRequest.of() 方法来创建一个 Pageable 对象，它有三个参数，第一个参数是页码，第二个参数是每页的大小，第三个参数是排序的字段和排序的方向。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public Page<User> findByName(String name, int page, int size) {
        Sort sort = Sort.by(Sort.Direction.DESC, "id");
        Pageable pageable = PageRequest.of(page, size, sort);
        return userRepository.findByName(name, pageable);
    }
}

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Page<User> findByName(String name, Pageable pageable);

    List<User> findByRole(Role role);
}
```

而且非常方便的是，我们在 Rest API 设计的时候，也可以在 URL 中传递排序的字段和排序的方向，这样就可以让前端开发人员自由的选择排序的字段和排序的方向。

```java
@GetMapping("/users")
public Page<User> findByName(@RequestParam String name,
                             @RequestParam int page,
                             @RequestParam int size,
                             @RequestParam String sort,
                             @RequestParam String direction) {
    Sort sort = Sort.by(Sort.Direction.fromString(direction), sort);
    Pageable pageable = PageRequest.of(page, size, sort);
    return userService.findByName(name, pageable);
}
```

甚至更简单一些，我们都不用定义这些参数，Spring Data JPA 会自动帮我们解析这些参数。

```java
@GetMapping("/users")
public Page<User> findByName(@RequestParam String name, Pageable pageable) {
    return userService.findByName(name, pageable);
}
```

如果采用这种方式，那么我们就可以在 URL 中传递这些参数了。

```http
GET /users?name=张三&page=0&size=10&sort=id,DESC
```

但是排序是可以多个字段的，比如我们可以根据 id 和 name 来进行排序，那么我们就可以在 URL 中传递多个 sort 和 direction 参数。

```http
GET /users?name=张三&page=0&size=10&sort=id,DESC&sort=name,ASC
```

如果我们想规定一些默认值，比如页面大小默认为 10，排序字段默认为 id，排序方向默认为 DESC，那么我们就可以在 Pageable 的实现类中定义这些默认值。

```java
public class PageableImpl implements Pageable {

    private int page = 0;

    private int size = 10;

    private Sort sort = Sort.by(Sort.Direction.DESC, "id");

    public PageableImpl(int page, int size, Sort sort) {
        this.page = page;
        this.size = size;
        this.sort = sort;
    }

    public PageableImpl(int page, int size) {
        this.page = page;
        this.size = size;
    }

    public PageableImpl() {
    }

    @Override
    public int getPageNumber() {
        return page;
    }

    @Override
    public int getPageSize() {
        return size;
    }

    @Override
    public long getOffset() {
        return page * size;
    }

    @Override
    public Sort getSort() {
        return sort;
    }

    @Override
    public Pageable next() {
        return new PageableImpl(page + 1, size, sort);
    }

    @Override
    public Pageable previousOrFirst() {
        return hasPrevious() ? new PageableImpl(page - 1, size, sort) : this;
    }

    @Override
    public Pageable first() {
        return new PageableImpl(0, size, sort);
    }

    @Override
    public boolean hasPrevious() {
        return page > 0;
    }
}
```

如果不想自己实现一个 `Pageable` ，我们也可以通过一个配置来完成这些默认设置。

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private static final int DEFAULT_PAGE_SIZE = 20;

    private static final int DEFAULT_PAGE_NUMBER = 0;

    private static final String DEFAULT_SORT_FIELD = "id";

    private static final Sort.Direction DEFAULT_SORT_DIRECTION = Sort.Direction.DESC;

    @Bean
    public PageableHandlerMethodArgumentResolver pageableResolver() {
        PageableHandlerMethodArgumentResolver resolver = new PageableHandlerMethodArgumentResolver();
        resolver.setFallbackPageable(PageRequest.of(DEFAULT_PAGE_NUMBER, DEFAULT_PAGE_SIZE, Sort.by(DEFAULT_SORT_DIRECTION, DEFAULT_SORT_FIELD)));
        return resolver;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(pageableResolver());
    }
}
```

此时，我们就可以在 URL 中不传递任何参数了，或者不传递 size 或 sort 参数，Spring Data JPA 会自动帮我们使用默认值。

```http
GET /users
GET /users?page=0
GET /users?page=0&size=10
GET /users?page=0&size=10&sort=id,DESC
```

这些请求都会成功，Spring Data JPA 会自动帮我们使用默认值。

如果不想全局设置，那么可以采用 Spring Data JPA 3.x 提供的 `@PageableDefault` 注解来设置默认值。

```java
@GetMapping("/users")
public Page<User> getUsers(@PageableDefault(size = 10, sort = {"id"}, direction = Sort.Direction.DESC) Pageable pageable) {
    return userRepository.findAll(pageable);
}
```

### Spring Data JPA 的测试

进行数据库测试的时候，Spring Data JPA 提供了一个 @DataJpaTest 注解，它可以帮助我们自动配置 Spring Data JPA 所需要的组件，比如 EntityManager、DataSource、JdbcTemplate 等。
我们进行 Repository 测试的时候往往需要配合使用 `TestEntityManager`，它可以帮助我们进行数据库的增删改查操作。

```java
@DataJpaTest
class DemoApplicationTests {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private UserRepository userRepository;

    @Test
    void contextLoads() {
        User user = new User();
        user.setName("张三");
        user.setAge(18);
        user.setEmail("zhangsan@local.dev");
        entityManager.persist(user);
        entityManager.flush();
        
        List<User> users = userRepository.findAll();
        Assertions.assertEquals(1, users.size());
        Assertions.assertEquals("张三", users.get(0).getName());
    }
}
```

为什么要使用 `TestEntityManager` 而不是直接使用 `UserRepository` 来进行数据库的增删改查操作呢？因为 `TestEntityManager` 可以帮助我们在进行数据库操作的时候，可以将数据保存到内存中，而不是真正的保存到数据库中，这样可以提高我们的测试效率。而且 `TestEntityManager` 还可以帮助我们进行数据库的回滚操作，也就是说，当我们的测试用例执行完毕之后，`TestEntityManager` 会帮助我们将内存中的数据清空，这样可以保证我们的测试用例之间的数据隔离。

在数据库测试中，我们经常会遇到需要预先插入一些数据到数据库中的情况，这时候我们可以使用 `@Sql` 注解来指定需要执行的 SQL 脚本，比如：

```java
@DataJpaTest
@Sql("classpath:/init.sql")
class DemoApplicationTests {
    // ...
}
```

在上面的代码中，我们使用了 `@Sql` 注解来指定需要执行的 SQL 脚本，这个 SQL 脚本的路径是 `resources/init.sql`，这个 SQL 脚本的内容如下：

```sql
INSERT INTO user (name, age, email) VALUES ('张三', 18, 'zhangsan@local.dev');
INSERT INTO user (name, age, email) VALUES ('李四', 20, 'lisi@local.dev');
```

这样，当我们的测试用例执行的时候，就会先执行这个 SQL 脚本，然后再执行我们的测试用例。

但是很快我们遇到另一个问题，如果下个测试不需要这些数据了，我们就需要再写一个 SQL 脚本来清空这些数据，这样就会导致我们的测试用例之间的耦合性变得很高，这时候我们就可以使用 `@Sql` 注解的 `executionPhase` 属性来指定 SQL 脚本的执行阶段，比如：

```java
@DataJpaTest
@SqlGroup({
        @Sql(value = "classpath:/init.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD),
        @Sql(value = "classpath:/clear.sql", executionPhase = Sql.ExecutionPhase.AFTER_TEST_METHOD)
})
class DemoApplicationTests {
    // ...
}
```

在上面的代码中，我们使用了 `@Sql` 注解的 `executionPhase` 属性来指定 SQL 脚本的执行阶段，这样我们就可以在测试用例执行之前，先执行 `init.sql`，然后在测试用例执行之后，再执行 `clear.sql`。

## Flyway 管理数据库版本

Flyway 是一个数据库版本管理工具，它可以帮助我们管理数据库的版本，比如我们可以使用 Flyway 来管理数据库的初始化脚本，也可以使用 Flyway 来管理数据库的变更脚本。

SpringBoot 对 Flyway 提供了开箱即用的支持，我们只需要在 `build.gradle` 文件中添加 `flyway` 依赖即可：

```groovy
dependencies {
    // ...
    implementation 'org.flywaydb:flyway-core'
}
```

然后在 `application.properties` 文件中添加 Flyway 的配置：

```properties
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
spring.flyway.baseline-on-migrate=true
```

在上面的配置中，我们使用了 `spring.flyway.enabled` 属性来启用 Flyway，然后使用了 `spring.flyway.locations` 属性来指定 Flyway 的脚本路径，这个路径是 `resources/db/migration`，然后使用了 `spring.flyway.baseline-on-migrate` 属性来指定 Flyway 在启动的时候是否需要执行初始化脚本，这个属性的默认值是 `false`，也就是说默认情况下，Flyway 不会执行初始化脚本，如果我们需要执行初始化脚本，那么我们就需要将这个属性设置为 `true`。

在 `resources/db/migration` 目录下，我们可以创建一个初始化脚本，比如 `V1.0__create_schema.sql`，这个脚本的内容如下：

```sql
CREATE TABLE user (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
```

然后我们启动应用，Flyway 会自动执行这个初始化脚本，然后我们就可以在数据库中看到 `user` 表了。

如果我们此时增加一个字段，比如 `address`，那么我们就可以创建一个变更脚本，比如 `V1.1__add_address_column.sql`，这个脚本的内容如下：

```sql
ALTER TABLE user ADD COLUMN address VARCHAR(255) NOT NULL;
```

然后我们再次启动应用，Flyway 会自动执行这个变更脚本，然后我们就可以在数据库中看到 `user` 表中多了一个 `address` 字段了。

大家可以看到和代码版本管理类似的概念，我们不是修改原来的脚本，而是创建一个新的脚本，这样就可以保证每次执行脚本的时候，都是执行的最新的脚本。

在使用数据库版本管理工具比如 Flyway 或 Liquibase 的时候，一定注意，不要直接修改数据库，否则可能会导致数据库版本管理工具无法正常工作。

所有对数据库的修改，不管是增删字段，还是添加删除修改初始化数据，都通过数据库版本管理工具来完成。

那么为什么要使用数据库版本管理呢？它带来的好处有哪些？

- 简化数据库迁移：可以简化数据库迁移过程，并且有助于避免数据库迁移过程中的错误。
- 更好的可重复性：可以使数据库迁移过程更加可重复，从而减少数据库迁移过程中的人为失误。
- 支持多种数据库类型：这些工具支持多种数据库类型，包括关系型数据库（如 MySQL，PostgreSQL 和 Oracle）和 NoSQL 数据库（如 MongoDB）。
- 支持自动回滚：如果在进行数据库迁移过程中发生错误，这些工具可以自动回滚数据库到先前的版本。
- 提高开发效率：可以提高开发效率，减少数据库迁移过程中的繁琐任务。
- 提供版本控制：这些工具提供了版本控制功能，可以方便的管理数据库的不同版本，从而保证数据库的安全和稳定。

通过在不同 Profile 的 `properties` 文件中定义不同的 `spring.flyway.locations`，我们可以很方便的在不同环境中使用不同的数据库。
比如，我们可以在 `application-dev.properties` 中定义如下内容：

```properties
spring.flyway.locations=classpath:db/migration/h2
```

然后在 `application-prod.properties` 中定义如下内容：

```properties
spring.flyway.locations=classpath:db/migration/mysql
```

这样，我们就可以在开发环境中使用 H2 数据库，而在生产环境中使用 MySQL 数据库了。
