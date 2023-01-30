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

#### Spring Data JPA 的实体类

Spring Data JPA 的实体类如下：

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

#### Spring Data JPA 的接口

Spring Data JPA 的接口如下：

```java
public interface UserRepository extends JpaRepository<User, Long> {
}
```

#### Spring Data JPA 的测试

Spring Data JPA 的测试如下：

```java
@SpringBootTest
class SampleJPATests {
    @Autowired
    private UserRepository userRepository;

    @Test
    void test() {
        User user = new User();
        user.setName("张三");
        user.setAge(18);
        user.setEmail("zhangsan@local.dev");
        userRepository.save(user);
    }
}
```