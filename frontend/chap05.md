# 第五章：App 接口 - 用 Spring Boot 3.x 构建动态图片和文件管理 API

在我们以 API 角度实现需求之前，需要对一些核心知识做些了解。有了这些核心知识，不光在后面我们实现具体需求时，也包括大家在实际工作中会遇到的 Web 层的 80% 的常见问题都会得到解决。

所以，我们在这一章中，会首先给大家介绍 API 和 HTTP 的核心知识，然后我们会通过实现设计一个图片生成的 API，这个 API 是在开发阶段用来方便的生成各种尺寸的占位图的。

通过设计和完善这样一个 API 来让大家了解如何使用 Spring Boot 来开发 RESTful API，包括 API 的参数校验、异常处理、交互式文档、Profile，配置文件和测试的支持等知识点。

最后，我们会使用上述知识创建一个文件管理 API，它会支持单个和多个文件上传，已上传的文件浏览以及删除文件等操作，这个 API 后面我们会在后面章节中的配置图片数据源时使用到。

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第五章：App 接口 - 用 Spring Boot 3.x 构建动态图片和文件管理 API](#第五章app-接口---用-spring-boot-3x-构建动态图片和文件管理-api)
  - [5.1 API 和 HTTP 基础知识](#51-api-和-http-基础知识)
    - [5.1.1 基础知识：RESTful API 和 HTTP 流程](#511-基础知识restful-api-和-http-流程)
    - [5.1.2 基础知识：HTTP 状态码](#512-基础知识http-状态码)
    - [5.1.3 参数的传递](#513-参数的传递)
    - [5.1.4 RESTful API 设计](#514-restful-api-设计)
  - [5.2 使用 Spring Boot 设计一个图片生成的 API](#52-使用-spring-boot-设计一个图片生成的-api)
    - [5.2.1 使用 Spring MVC 开发 RESTful API](#521-使用-spring-mvc-开发-restful-api)
    - [5.2.2. 作业：完整的完成图片生成 API](#522-作业完整的完成图片生成-api)
  - [5.3 参数的校验](#53-参数的校验)
    - [5.3.1 Jakarta Bean Validation](#531-jakarta-bean-validation)
    - [5.3.2. 配置方法参数校验](#532-配置方法参数校验)
    - [5.3.3 作业：添加其他参数的校验](#533-作业添加其他参数的校验)
  - [5.4. Swagger 交互式文档](#54-swagger-交互式文档)
    - [5.4.1. 配置 Swagger 文档](#541-配置-swagger-文档)
    - [5.4.2 作业：给 API 添加描述和参数描述](#542-作业给-api-添加描述和参数描述)
  - [5.5 异常处理](#55-异常处理)
    - [5.5.1 自定义异常](#551-自定义异常)
    - [5.5.2 全局异常处理](#552-全局异常处理)
    - [5.5.3 RFC 7807 规范](#553-rfc-7807-规范)
    - [5.5.4 作业：完成异常处理](#554-作业完成异常处理)
      - [5.5.4.1 Java 的函数式编程知识点](#5541-java-的函数式编程知识点)
  - [5.6 Spring Boot 的配置文件](#56-spring-boot-的配置文件)
    - [5.6.1 配置日志级别](#561-配置日志级别)
      - [作业：配置日志级别](#作业配置日志级别)
    - [5.6.2 配置数据库连接信息](#562-配置数据库连接信息)
  - [5.6.3 Profile](#563-profile)
    - [5.6.4 作业：配置 Profile](#564-作业配置-profile)
  - [5.7 测试的支持](#57-测试的支持)
  - [5.8 文件管理 API](#58-文件管理-api)
    - [5.8.1 需求分析](#581-需求分析)
    - [5.8.2 七牛云](#582-七牛云)
    - [5.8.3 领域模型](#583-领域模型)
    - [5.8.4 七牛云配置](#584-七牛云配置)
    - [5.8.5 上传文件](#585-上传文件)
    - [5.8.6 作业：完成空间文件列表和删除文件功能](#586-作业完成空间文件列表和删除文件功能)
    - [5.8.7 上传文件接口](#587-上传文件接口)
    - [5.8.8 测试上传文件接口](#588-测试上传文件接口)
    - [5.8.9 作业：完成文件列表接口和删除文件接口，并编写单元测试](#589-作业完成文件列表接口和删除文件接口并编写单元测试)
      - [5.8.9.1 Swagger 文档](#5891-swagger-文档)
  - [5.9 使用前端原型进行集成验证](#59-使用前端原型进行集成验证)
    - [5.9.1 页面构成](#591-页面构成)
    - [5.9.2 顶部标题栏](#592-顶部标题栏)
    - [5.9.3 图片网格](#593-图片网格)
    - [5.9.4 构建图片浏览对话框](#594-构建图片浏览对话框)
      - [5.9.4.1 客户端访问 API](#5941-客户端访问-api)
      - [5.9.4.2 状态管理](#5942-状态管理)
      - [5.9.4.3 使用 flutter_bloc](#5943-使用-flutter_bloc)

<!-- /code_chunk_output -->

## 5.1 API 和 HTTP 基础知识

API 是应用程序接口，它是一组预定义的方法，用于访问应用程序的功能。API 通常是由开发人员创建的，以便其他开发人员可以使用它们来构建应用程序。API 通常是基于 HTTP 协议的，因此它们可以通过网络访问。API 通常是基于 RESTful 架构的，因此它们可以通过 HTTP 协议访问。

RESTful (Representational State Transfer) API 是基于 RESTful 架构的 API。RESTful 架构是一种软件架构风格，它是基于 HTTP 协议的。RESTful 架构风格的主要特征是使用 HTTP 协议的四种方法来实现 CRUD 操作:

    * GET - 用于读取数据
    * POST - 用于创建数据
    * PUT - 用于更新数据
    * DELETE - 用于删除数据

RESTful API 通常使用 JSON 格式来传输数据。

### 5.1.1 基础知识：RESTful API 和 HTTP 流程

下面结合一个简单的例子来说明 RESTful API 流程:

- 客户端向服务器发送 HTTP GET 请求，请求 URL 为 http://localhost:8080/api/v1/employees

- 服务器处理请求并返回 HTTP 响应，响应体为 JSON 格式的数据

```json
[
  {
    "id": 1,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@local.dev"
  },
  {
    "id": 2,
    "firstName": "Alice",
    "lastName": "Wayne",
    "email": "alice.wayne@local.dev"
  }
]
```

- 客户端处理响应

上面的例子中，我们略去了 HTTP 请求头和响应头的内容。HTTP 请求头和响应头包含了请求和响应的元数据，例如请求的方法、请求的 URL、响应的状态码等。

那么就这个简单的例子，我们看一下请求和响应的 HTTP 头部信息:

请求头：

```http
GET /api/v1/employees HTTP/1.1
Host: localhost:8080
User-Agent: curl/7.64.1
Accept: */*
```

- GET - 请求方法
- /api/v1/employees - 请求 URL
- HTTP/1.1 - HTTP 协议版本
- Host: localhost:8080 - 请求的主机名和端口号
- User-Agent: curl/7.64.1 - 客户端的 User-Agent
- Accept: _/_ - 客户端接受的响应类型

响应头：

```http
HTTP/1.1 200
Content-Type: application/json
Transfer-Encoding: chunked
Date: Mon, 18 Jan 2021 08:57:00 GMT

[
    {
        "id": 1,
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@local.dev"
    },
    {
        "id": 2,
        "firstName": "Alice",
        "lastName": "Wayne",
        "email": "alice.wayne@local.dev"
    }
]
```

- HTTP/1.1 200 - HTTP 协议版本和响应状态码
- Content-Type: application/json - 响应的内容类型
- Transfer-Encoding: chunked - 响应的传输编码
- Date: Mon, 18 Jan 2021 08:57:00 GMT - 响应的日期

再看一个 POST 请求的例子:

请求头：

```http
POST /api/v1/employees HTTP/1.1
Host: localhost:8080
User-Agent: curl/7.64.1
Accept: */*
Content-Type: application/json
Content-Length: 86

{
  "firstName": "John",
  "lastName": "Doe",
  "email": "
}
```

- POST - 请求方法
- /api/v1/employees - 请求 URL
- HTTP/1.1 - HTTP 协议版本
- Host: localhost:8080 - 请求的主机名和端口号
- User-Agent: curl/7.64.1 - 客户端的 User-Agent
- Accept: _/_ - 客户端接受的响应类型
- Content-Type: application/json - 请求体的内容类型
- Content-Length: 86 - 请求体的长度

响应头：

```http
HTTP/1.1 201
Content-Type: application/json
Transfer-Encoding: chunked
Date: Mon, 18 Jan 2021 08:57:00 GMT

{
    "id": 1,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@local.dev"
}
```

### 5.1.2 基础知识：HTTP 状态码

HTTP 状态码是服务器在响应 HTTP 请求时返回的状态码。HTTP 状态码由三位数字组成，第一个数字定义了响应的类别，且有五种可能取值:

- `1xx` (Informational): 请求已被服务器接收，继续处理
- `2xx` (Successful): 请求已成功被服务器接收、理解、并接受
- `3xx` (Redirection): 需要后续操作才能完成这一请求
- `4xx` (Client Error): 服务器无法处理请求，请求的格式错误，请求的方法错误
- `5xx` (Server Error): 服务器处理请求出错

常见的 HTTP 状态码有:

- `200` OK - 请求成功
- `201` Created - 请求成功并且服务器创建了新的资源
- `204` No Content - 请求成功但响应体为空
- `400` Bad Request - 请求的格式错误
- `401` Unauthorized - 未授权
- `403` Forbidden - 禁止访问
- `404` Not Found - 请求的资源不存在
- `405` Method Not Allowed - 请求方法不被允许
- `500` Internal Server Error - 服务器内部错误
- `503` Service Unavailable - 服务器暂时处于超负载或正在停机维护，无法处理请求

### 5.1.3 参数的传递

在 RESTful API 中，我们通常会使用两种方式传递参数:

- 使用 URL 参数：路径参数和查询参数, 一般在 `GET/DELETE` 请求中使用
- 使用请求体：JSON 格式，一般在 `POST/PUT/PATCH` 请求中使用

URL 参数可以分为两种:

- 路径参数 - 用于标识资源，例如 `/api/v1/employees/1` 表示 ID 为 1 的员工
- 查询参数 - 用于过滤资源，例如 `/api/v1/employees?firstName=John` 表示查询名字为 John 的员工

在请求体中，我们通常使用 JSON 格式来传递参数，例如:

```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@local.dev"
}
```

请求体的格式可以是 JSON、XML、CSV 等，但是我们通常使用 JSON 格式。

虽然说我们可以使用 URL 参数来传递参数，但是我们通常不会对 **非** GET 请求这么做，因为 URL 参数的长度是有限制的（一般是 2KB），而且 URL 参数会被记录到浏览器的历史记录中，这样会导致一些安全问题。

### 5.1.4 RESTful API 设计

RESTful API 设计是指如何设计一个 RESTful API。RESTful API 设计的目标是设计出一个易于使用的 API，使得 API 的使用者能够快速上手。

RESTful API 设计的原则有:

- 使用 HTTP 方法来表示操作类型
- 使用 URL 来表示资源
- 使用 HTTP 状态码来表示操作结果
- 使用 JSON 格式来传输数据

## 5.2 使用 Spring Boot 设计一个图片生成的 API

在这一节中，我们将设计一个图片生成的 API。大家如果看到前面的章节中，我们的图片地址通常是 `https://picsum.photos/600/300` 这种类型的，你可能会奇怪为什么没有文件名，这是因为我们的图片是动态生成的，我们可以通过 URL 参数来控制图片的大小和颜色。在你做原型的时候，这样的 API 是非常有用的，因为你不需要去准备图片，你只需要通过 URL 参数来控制图片的大小和颜色，就可以快速的生成图片。

还是首先看一下需求:

- 用户可以通过 URL 参数来控制图片的大小和颜色
  - 基础的 API URL 前缀是 `/api/v1/images`
  - 图片的宽度可以由第一个路径参数控制，例如 `/api/v1/images/200` 表示图片的宽度是 200 像素，如果不指定高度，那么图片的高度就是宽度，也就是一个正方形
  - 图片的高度可以由第二个路径参数控制，例如 `/api/v1/images/200/300` 表示图片的高度是 300 像素
  - 图片中的文字可以由第三个路径参数控制，例如 `/api/v1/images/200/300/Hello` 表示图片中的文字是 Hello，如果没有指定文本参数，那么就使用 `宽度x高度` 作为图片中的文字
  - 图片的背景颜色可以由第四个路径参数控制，例如 `/api/v1/images/200/300/Hello/FF0000` 表示图片的背景颜色是红色
  - 图片的文字颜色可以由第五个路径参数控制，例如 `/api/v1/images/200/300/Hello/FF0000/00FF00` 表示图片中的文字颜色是绿色

其实通过这个需求，你也可以看到 RESTful API 设计的优点，那就是 URL 会非常简洁且易于理解，大家几乎都不需要参考文档就能快速上手。

### 5.2.1 使用 Spring MVC 开发 RESTful API

在 Spring Boot 中，我们可以使用 Spring MVC 来开发 RESTful API。Spring MVC 是一个基于 Java 的 MVC 框架，它提供了一套注解来简化开发。

我们首先来看一下 Spring MVC 的基本使用方法。在 Spring Boot 中，我们可以使用 `@RestController` 注解来标记一个类为 RESTful API 控制器。我们在 `com.mooc.backend` 下建立一个新的包 `rest`，然后在 `rest` 下新建两个包 `admin` 和 `app`，在 `app` 包下新建一个 `ImageController` 类，代码如下:

```java
@RestController
public class ImageController {
}
```

在 Spring MVC 中，我们可以使用 `@RequestMapping` 注解来映射一个 URL 到一个方法:

```java
@RestController
public class ImageController {
    @RequestMapping("/image")
    public String listImage() {
        return "image";
    }
}
```

在上面的例子中，我们使用 `@RequestMapping` 注解来映射 `/image` URL 到 `listImage` 方法。当我们访问 <http://localhost:8080/image> 这个 URL 时，`listImage` 方法会被调用，并返回 `image` 字符串。

而且这个注解不光可以用在方法上，也可以用在类上:

```java
@RestController
@RequestMapping("/api/v1/image")
public class ImageController {
    @RequestMapping("")
    public String listImage() {
        return "image";
    }
}
```

用在类上的 `@RequestMapping` 注解会将这个注解的值作为 URL 的前缀。此时，每个这个类中的方法都会将这个前缀作为 URL 的前缀。

`@RequestMapping` 注解还有一个 `method` 属性，用来指定请求的 HTTP 方法:

```java
@RestController
@RequestMapping("/api/v1/image")
public class ImageController {
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String listImage() {
        return "image";
    }
}
```

在上面的例子中，我们使用 `method` 属性来指定请求的 HTTP 方法为 `GET`。如果我们使用 `POST` 方法来访问 <http://localhost:8080/api/v1/image> 这个 URL，那么就会返回 405 错误。

Spring MVC 还提供了一些注解来简化开发，例如 `@GetMapping`、`@PostMapping`、`@PutMapping`、`@DeleteMapping` 等，它们都是 `@RequestMapping` 注解的简化版本:

```java
@RestController
@RequestMapping("/api/v1/image")
public class ImageController {
    @GetMapping("/{width}")
    public ResponseEntity<String> generateImage(@PathVariable int width) throws IOException {
        return ResponseEntity.ok().body(width + "");
    }
}
```

在上面的例子中，我们使用 `@GetMapping` 注解来简化 `@RequestMapping` 注解的使用。`@GetMapping` 注解是 `@RequestMapping` 注解的简化版本，它的 `method` 属性默认为 `GET`。

这里我们还引入了一个新注解 `@PathVariable` ，它是用来获取 URL 中的路径参数的。使用这个注解的时候，`@GetMapping` 注解中的 `{width}` 会被当作路径参数，路径参数两边有 `{}` ，这是 Spring MVC 的一个约定。然后在方法的参数中，我们可以使用 `@PathVariable` 注解来获取路径参数的值。

比如说，我们访问 <http://localhost:8080/api/v1/image/200> 这个 URL，那么 `width` 参数的值就是 200。

在上面的代码中你可能会发现，我们使用了 `ResponseEntity` 来返回结果。这是因为 Spring MVC 默认会将返回的结果转换为 JSON 或 Text 格式，某些情况下你可能不希望这样，比如说你想返回一个图片，那么你就需要使用 `ResponseEntity` 来返回结果。

简单来说 `ResponseEntity` 就是一个 HTTP 响应，它包含了 HTTP 响应的状态码、响应头、响应体等信息。

当然如果你不想使用 `ResponseEntity` 来返回结果，那么你也可以使用 `ResponseStatus` 和 `@ResponseBody` 注解来返回结果:

```java
@RestController
@RequestMapping("/api/v1/image")
public class ImageController {
    @GetMapping("/{width}")
    @ResponseStatus(HttpStatus.OK)
    @ResponseBody
    public String generateImage(@PathVariable int width) throws IOException {
        return width + "";
    }
}
```

在上面的例子中，我们使用 `@ResponseStatus` 注解来指定 HTTP 响应的状态码为 200，使用 `@ResponseBody` 注解来指定响应的内容类型为 `text/plain` ，因为方法的返回值是一个字符串，所以 Spring MVC 会将这个字符串转换为 `text/plain` 格式。

对于比较复杂的情况，还是建议使用 `ResponseEntity` 来返回结果。

接下来我们尝试完整地实现一下我们的图片生成 API。

```java
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

@RestController
@RequestMapping(value = "/api/v1/image")
public class ImageController {
    @GetMapping(value = "/{width}", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> generateImage(@PathVariable int width) throws IOException {
        // 创建一个图片
        BufferedImage image = new BufferedImage(width, width, BufferedImage.TYPE_INT_RGB);
        // 获取图片的 Graphics 对象
        Graphics2D g = image.createGraphics();
        // 设置图片的背景颜色
        g.setColor(Color.GRAY);
        // 填充背景
        g.fillRect(0, 0, width, width);
        // 设置图片的前景颜色
        g.setColor(Color.BLACK);
        // 设置图片的字体
        g.setFont(new Font("Arial", Font.BOLD, 20));
        // 在图片上绘制文字
        g.drawString(width + "x" + width, width / 4, width / 2);
        // 释放资源
        g.dispose();

        // 创建一个字节数组输出流
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        // 将图片写入到字节数组输出流中
        ImageIO.write(image, "png", outputStream);
        return ResponseEntity.ok().body(outputStream.toByteArray());
    }
}
```

图片的生成的具体逻辑其实和我们的项目无关，这里就不多说了。

上面的代码中，我们使用了 `GetMapping` 注解的 `produces` 属性来指定响应的内容类型为 `image/png` 。这样我们就可以返回一个 PNG 格式的图片了。其实我们也可以使用 `ResponseEntity.ok().contentType(MediaType.IMAGE_PNG).body(outputStream.toByteArray())` 来返回一个图片。

也就是说 `@ResponseStatus(HttpStatus.OK)` 和 `ResponseEntity.ok()` 是等价的，都是用来指定 HTTP 响应的状态码为 200 的。

而 `@ResponseBody` 和 `ResponseEntity.body()` 是等价的，都是用来指定响应的内容类型的。

`@GetMapping` 注解的 `produces` 属性和 `ResponseEntity.contentType()` 方法都是用来指定响应的内容类型的。

实际返回的响应头类似于下面这样:

```http
HTTP/1.1 200
Content-Type: image/png
Date: Tue, 22 Jun 2021 08:00:00 GMT
```

如果我们使用 [Postman](https://www.postman.com/downloads/) 来测试一下，那么我们可以看到如下的结果:

![图 1](http://ngassets.twigcodes.com/71f42dad6338f96c5f76f7bf1595463883851dbfcf19c9c87b140a0b11286dc5.png)

### 5.2.2. 作业：完整的完成图片生成 API

我们之前的代码只实现了其中一个 `/api/v1/image/{width}` 这个 URL 的功能，现在我们需要完整地实现这个 API 并使用 Postman 进行测试。

我们需要实现的功能如下:

- 图片的宽度可以由第一个路径参数控制，例如 /api/v1/images/200 表示图片的宽度是 200 像素，如果不指定高度，那么图片的高度就是宽度，也就是一个正方形
- 图片的高度可以由第二个路径参数控制，例如 /api/v1/images/200/300 表示图片的高度是 300 像素
- 图片中的文字可以由第三个路径参数控制，例如 /api/v1/images/200/300/Hello 表示图片中的文字是 Hello，如果没有指定文本参数，那么就使用 `宽度x高度` 作为图片中的文字
- 图片的背景颜色可以由第四个路径参数控制，例如 /api/v1/images/200/300/Hello/FF0000 表示图片的背景颜色是红色
- 图片的文字颜色可以由第五个路径参数控制，例如 /api/v1/images/200/300/Hello/FF0000/00FF00 表示图片中的文字颜色是绿色

需要注意的几个点:

- 如果路径参数的个数不够，那么就使用默认值
- 其实几个方法使用的核心代码是一样的，所以我们可以把这些代码抽取出来，然后在不同的方法中调用这个抽取出来的方法
- 可以有多个路径参数，例如 /api/v1/images/{width}/{height}/{text}/{backgroundColor}/{foregroundColor}，当然在方法中我们需要使用 `@PathVariable` 注解来指定每个路径参数的名称

完整代码可以参考 `backend/src/main/java/com/mooc/backend/rest/app/ImageController.java`

你也可以尝试使用查询参数来实现这个 API，例如 `/api/v1/image?width=200&height=300&text=Hello&backgroundColor=FF0000&foregroundColor=00FF00`

提示：可以使用 `@RequestParam` 注解来指定查询参数的名称，比如：

```java
@GetMapping("")
public String hello(
    @RequestParam(name = "name", defaultValue = "World") String name
) throws IOException {
    // ...
}
```

`@RequestParam` 注解的 `name` 属性用来指定查询参数的名称，`defaultValue` 属性用来指定查询参数的默认值。

## 5.3 参数的校验

在上一节中，我们实现了一个图片生成的 API，但是这个 API 的参数是没有校验的，所以我们可以传入任意的参数，这样就会导致一些问题。

比如说，我们可以传入一个非常大的宽度，这样就会导致服务器内存不够用，从而导致服务器崩溃。

所以我们需要对参数进行校验，来避免这种问题。

### 5.3.1 Jakarta Bean Validation

Jakarta Bean Validation 是一个 Java 的参数校验框架，它可以帮助我们对参数进行校验。它是基于 JSR 303 标准的，所以我们可以使用 `jakarta.validation` 包中的注解来对参数进行校验。

Spring Boot 完美的支持了 Jakarta Bean Validation，只需要在 `build.gradle` 文件中添加 `spring-boot-starter-validation` 依赖，就可以使用 Jakarta Bean Validation 了。

```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-validation'
}
```

### 5.3.2. 配置方法参数校验

我们在 `com.mooc.backend` 下面新建一个 `config` 包，然后在这个包下面新建一个 `WebMvcConfig` 类，用来配置方法参数校验。

```java
package com.mooc.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.validation.beanvalidation.MethodValidationPostProcessor;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    /**
     * 开启方法级别的校验，可以在方法上使用 jakarta.validation 的注解
     * @return MethodValidationPostProcessor
     */
    @Bean
    public MethodValidationPostProcessor methodValidationPostProcessor() {
        return new MethodValidationPostProcessor();
    }
}
```

这个配置类是一个比较典型的 Spring Boot 配置类，我们就这个类的一些特点来介绍一下 Spring Boot 的配置类。

1. 我们可以看到这个类上面有一个 `@Configuration` 注解，这个注解的作用是把这个类标记为一个配置类，这样 Spring Boot 就会自动扫描到这个类。

2. `methodValidationPostProcessor` 方法上面有一个 `@Bean` 注解，这个注解的作用是把这个方法的返回值标记为一个 Bean，这样 Spring Boot 就会自动把这个 Bean 注册到 Spring 容器中。

3. `WebMvcConfigurer` 是一个接口，它是 Spring Boot 提供的一个用来配置 Spring MVC 的接口，我们可以通过实现这个接口来配置 Spring MVC。

然后在 `ImageController` 类中，我们需要使用 `@Validated` 注解来标记这个类，这样 Spring Boot 就会自动对这个类中的方法参数进行校验。

```java
// ...
import org.springframework.validation.annotation.Validated;

@Validated
@RestController
@RequestMapping(value = "/api/v1/image")
public class ImageController {
    @GetMapping(value = "/{width}")
    public ResponseEntity<byte[]> generateImage(@PathVariable @Min(12) @Max(1920) int width) throws IOException {
        return buildImageResponseEntity(width, width, width + "x" + width, Color.GRAY, Color.BLACK);
    }
    // ...
}
```

上面的代码中：

1. `@Validated` 注解的作用是把这个类标记为需要进行参数校验的类

2. `@Min` 和 `@Max` 注解的作用是把这个参数标记为需要进行最小值和最大值校验的参数，这样 Spring Boot 就会自动对这个参数进行校验

如果我们此时访问 `http://localhost:8080/api/v1/image/2000`，那么就会得到一个 HTTP 代码为 400 的错误，因为我们设置了图片的最大宽度是 1920 像素。

### 5.3.3 作业：添加其他参数的校验

请给 `ImageController` 类中的其他方法添加参数校验。

需求：

1. 图片的宽度和高度都约束在最小值为 12 像素，最大值为 1920 像素之间
2. 文本的长度约束在最小值为 1 个字符，最大值为 20 个字符之间
3. 背景颜色和前景颜色的值必须是 Hex 格式的颜色值，去掉 `#` 号之后的长度是 6 个字符

提示：

- `@Pattern` 注解可以用来对参数进行正则表达式的校验，其中 `regexp` 属性用来指定正则表达式，`message` 属性用来指定校验失败时的错误信息。hex 格式的颜色值的正则表达式是 `^[0-9a-fA-F]{6}$`。
- 文本的长度可以使用 `@Size` 注解来进行校验，其中 `min` 属性用来指定最小值，`max` 属性用来指定最大值，`message` 属性用来指定校验失败时的错误信息。

## 5.4. Swagger 交互式文档

在上一节中，我们实现了一个图片生成的 API，我们使用了 Postman 来测试这个 API，但是这样的方式有一些不方便。

在实际的开发中，我们经常会遇到这样的情况，我们需要把这个 API 发布到测试环境，然后让前端人员来测试这个 API，但是这样的话，我们就需要有一个文档来告诉前端人员这个 API 的参数是什么，返回的数据是什么。

但是静态的文档很容易过时，所以我们需要一个交互式的文档，这样就可以让前端人员在文档中直接测试这个 API。而且这样的文档对于后端人员来说也是很方便的，因为我们可以在文档中直接测试这个 API。

Swagger 文档目前是最流行的交互式文档，而且在 Spring Boot 开发中，集成 Swagger 文档也是非常简单的。我们这里使用 `SpringDoc` 这个第三方的库来集成 Swagger 文档。

首先在 `build.gradle` 文件中添加 `springdoc-openapi-ui` 依赖。

```groovy
ext {
    springdocVersion = '2.0.2'
    // ...
}
dependencies {
    implementation "org.springdoc:springdoc-openapi-starter-webmvc-ui:${springdocVersion}"
    // ...
}
```

rebuild 一下项目，然后访问 `http://localhost:8080/swagger-ui.html`，就可以看到 Swagger 文档了。

![图 2](http://ngassets.twigcodes.com/797c46b8fc02761c77c75d35938380a980605759016352f00f509598555281e2.png)

点击 `Try it out` 按钮，就会看到此时 `width` 参数的文本框处于可用状态，我们可以在这个文本框中输入参数，然后点击 `Execute` 按钮，就可以看到 API 的返回结果了。

![图 3](http://ngassets.twigcodes.com/e0fd3f19be4212170cadb879062e9c036b3dcc214f2f49b023974a7030afef2a.png)

### 5.4.1. 配置 Swagger 文档

我们在 `com.mooc.backend` 下面新建一个 `config` 包，然后在这个包下面新建一个 `SwaggerConfig` 类，用来配置 Swagger 文档。

```java
package com.mooc.backend.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI springShopOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("低代码平台 API 文档")
                        .description("这个 API 文档提供了后台管理和前端 APP 所需的接口")
                        .termsOfService("")
                        .license(new License().name("Apache").url(""))
                        .version("0.0.1"));
    }
}
```

上面的代码中，我们使用 `OpenAPI` 类来配置 Swagger 文档的信息，这个配置起到的效果就是在 Swagger 文档的左上角显示了我们配置的信息。

![图 4](http://ngassets.twigcodes.com/50831503f1f0ce8fa9f01d19cec4978be37a2a46f53a647f8aa59a391d26aaea.png)

这个信息其实只是文档的标题、描述等，对于一个 API 文档来说，我们需要的是对 API 本身的参数、返回值等的描述。

```java
// ...
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

@Tag(name = "图像", description = "动态生成图像")
@Validated
@RestController
@RequestMapping(value = "/api/v1/image")
public class ImageController {
    @Operation(summary = "根据宽度生成灰色图像")
    @GetMapping(value = "/{width}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图像的宽度", name = "width")
            @PathVariable @Min(12) @Max(1920) int width) throws IOException {
        return buildImageResponseEntity(width, width, width + "x" + width, Color.GRAY, Color.BLACK);
    }
    // ...
}
```

上面的代码中，我们使用 `@Tag` 注解来标记这个类，然后使用 `@Operation` 注解来标记这个方法，这样就可以在 Swagger 文档中看到这个类和方法的描述了。在方法的参数前面，我们使用 `@Parameter` 注解来标记这个参数，你可以看到参数这一块的描述也已经出现在 Swagger 文档中了。

![图 6](http://ngassets.twigcodes.com/c977f599fb0022adc2b4ab847aaf30345e0edbc18d1dc683d8dd6782f7fc8c2e.png)

如果希望有参数的默认值，可以使用 `@Parameter` 注解的 `example` 属性来设置。

```java
@Operation(summary = "根据宽度生成灰色图像")
@GetMapping(value = "/{width}")
public ResponseEntity<byte[]> generateImage(
        @Parameter(description = "图像的宽度", name = "width", example = "200")
        @PathVariable @Min(12) @Max(1920) int width) throws IOException {
    return buildImageResponseEntity(width, width, width + "x" + width, Color.GRAY, Color.BLACK);
}
```

此时并不需要你手动输入值，只需要点击 `Execute` 按钮，就可以看到 API 的返回结果了。

![图 7](http://ngassets.twigcodes.com/4d15ac1365e72c2db6c9ff0aefdbef8b5659e927a2722ace41cc69c07034bd23.png)

### 5.4.2 作业：给 API 添加描述和参数描述

请按我们之前的方式，给 `ImageController` 中的所有 API 添加描述和参数描述。

如果有任何问题，可以参考 `backend/src/main/java/com/mooc/backend/rest/app/ImageController.java` 中的代码。

## 5.5 异常处理

对于一个后端 API 来说，异常处理是非常重要的一部分，因为我们需要在异常发生的时候，返回一个合理的错误信息给前端，让前端能够正确的处理这个错误。

### 5.5.1 自定义异常

一般来说，自定义异常是非常常见的一种异常处理方式，我们可以在异常发生的时候，抛出一个自定义的异常，然后在全局异常处理器中捕获这个异常，然后返回一个合理的错误信息给前端。

下面的代码中，我们定义了一个 `CustomException` 类，这个类继承了 `RuntimeException`，并且实现了一个构造函数，这个构造函数接收三个参数，分别是错误信息、错误详情和错误码。

```java
@Getter
@RequiredArgsConstructor
public class CustomException extends RuntimeException {
    private final String message;
    private final String details;
    private final Integer code;
}
```

值得指出的是，我们使用了 `Lombok` 的两个注解：

- `@Getter` 为这个类的属性自动生成 `getter` 方法了。
- `@RequiredArgsConstructor` 生成一个构造函数，其参数为为所有标识为 `final` 的属性。

### 5.5.2 全局异常处理

但是如果每个地方都需要手动抛出异常，那么这样的代码就会显得非常冗余，因此我们可以使用 Spring Boot 提供的 `@RestControllerAdvice` 来实现异常的全局处理。

一个简单的全局异常处理器如下：

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception e) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setCode(500);
        errorResponse.setMessage(e.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }
}
```

上面的代码中，我们使用 `@RestControllerAdvice` 注解来标记这个类，这样就可以让这个类成为一个全局异常处理器了。然后我们使用 `@ExceptionHandler` 注解来标记一个方法，这样就可以让这个方法成为一个异常处理器了。在这个方法中，我们可以捕获到发生的异常，然后返回一个合理的错误信息给前端。

但这样的自定义返回结构，每个公司甚至每个团队都不一样，有没有这样一种标准的错误信息格式呢？答案是肯定的，这就是我们下面要讲的 RFC 7807 规范。

### 5.5.3 RFC 7807 规范

RFC 7807 是一个关于错误处理的国际标准规范，它定义了一个标准的错误信息格式，这样就可以让前端和后端都能够统一的处理错误信息了。这样一个标准规范的好处是它不限于某一种语言，不限于某一种框架。

```json
{
  "type": "https://example.com/probs/out-of-credit",
  "title": "You do not have enough credit.",
  "detail": "Your current balance is 30, but that costs 50.",
  "instance": "/account/12345/msgs/abc",
  "balance": 30,
  "accounts": ["/account/12345", "/account/67890"]
}
```

上面的 JSON 对象就是一个符合 RFC 7807 规范的错误信息，其中 `type` 字段是错误的类型，`title` 字段是错误的标题，`detail` 字段是错误的详细信息，`instance` 字段是错误的实例。

RFC 7807 中规定的必选字段有

- `type`：错误的类型，这个字段一般是一个 URI，用来标识错误的类型
- `title`：错误的标题，这个标题一般是一个简短的描述

可选字段有

- `detail`：错误的详细信息，这个字段一般是一个长的描述
- `instance`：错误的实例，这个字段一般是一个 URI，用来标识错误发生的位置

此外，可以自定义一些字段，比如上面的 `balance` 和 `accounts` 字段。

Spring Boot 3.x 中，已经内置了对 RFC 7807 规范的支持，它新增了 `ProblemDetail` 类来表示一个符合 RFC 7807 规范的错误信息。

下面就是一个使用 `ProblemDetail` 类来处理异常并返回符合 RFC 7807 规范的错误信息的例子：

```java
@ExceptionHandler(Exception.class)
public ProblemDetail handleException(Exception e, WebRequest request) {
    ProblemDetail body = ProblemDetail
            .forStatusAndDetail(HttpStatusCode.valueOf(500), e.getLocalizedMessage());
    body.setType(URI.create(hostname + "/errors/uncaught"));
    body.setTitle(messageSource.getMessage("error.uncaught", null, request.getLocale()));
    body.setDetail(e.getMessage());
    body.setProperty("hostname", hostname);
    body.setProperty("ua", Optional.ofNullable(request.getHeader("User-Agent")).orElse("Unknown"));
    body.setProperty("locale", request.getLocale().toString());
    return body;
}
```

上面的代码中，我们使用 `ProblemDetail.forStatusAndDetail` 方法来创建一个 `ProblemDetail` 对象，然后设置 `type`、`title`、`detail` 等字段的值，最后返回这个对象。

其中 `hostname`, `ua` 和 `locale` 这些字段都是自定义的字段，它们的值都是通过 `setProperty` 方法来设置的。

### 5.5.4 作业：完成异常处理

现在我们已经知道了如何使用 Spring Boot 来实现异常的全局处理，那么我们就可以使用这个知识来完成我们的作业了。

1. 在 `GlobalExceptionHandler` 中，添加一个异常处理器，用来处理 `CustomException` 异常，当发生这个异常的时候，返回一个符合 RFC 7807 规范的错误信息。

2. 在 `GlobalExceptionHandler` 中，添加一个异常处理器，处理 `ConstraintViolationException` 异常。需要注意这个异常会携带多个错误信息: `e.getConstraintViolations()` ，因此需要遍历这个集合，然后把所有的错误信息都返回给前端。

   ```java
   // 如果不清楚 `getConstraintViolations` 里面是什么
   // 可以使用下面的代码来打印出来
   e.getConstraintViolations().stream()
       .map(constraintViolation -> constraintViolation.getPropertyPath() + " " + constraintViolation.getMessage())
       .peek(System.out::println)
       .collect(Collectors.toList());
   ```

3. 在 `GlobalExceptionHandler` 中，添加一个异常处理器，处理 `HttpRequestMethodNotSupportedException` 异常。这个异常指的是请求的方法不被支持，比如我们的接口只支持 `GET` 和 `POST` 方法，但是前端发起了一个 `PUT` 请求，那么就会抛出这个异常。返回的状态码应该是 `405`，错误信息应该是 `Method Not Allowed`。

4. 在 `GlobalExceptionHandler` 中，添加一个异常处理器，处理 `HttpClientErrorException.BadRequest` 异常。这个异常指的是请求的参数不正确，比如我们的接口需要传入一个 `id` 参数，但是前端没有传入这个参数，那么就会抛出这个异常。返回的状态码应该是 `400`，错误信息应该是 `Bad Request`。这个参数缺失的情况指的是请求携带的 `json` 数据中缺少了某个字段，而不是路径参数缺失的情况。路径参数的缺失一般会抛出 404 异常。

#### 5.5.4.1 Java 的函数式编程知识点

在作业中，我们会使用到 Java 的函数式编程知识点，这里我们简单的介绍一下。

1. Stream

   `Stream` 是 Java 8 中新增的一个类，它可以让我们以函数式的方式来处理集合。比如我们有一个集合，我们想要把集合中的每个元素都加上一个前缀，然后把结果放到一个新的集合中，我们可以使用下面的代码来实现：

   ```java
   List<String> list = Arrays.asList("a", "b", "c");
   List<String> newList = list.stream()
       .map(s -> "prefix-" + s)
       .collect(Collectors.toList());
   ```

   上面的代码中，我们使用 `map` 方法来把集合中的每个元素都加上一个前缀，然后使用 `collect` 方法来把结果收集到一个新的集合中。有前端经验的同学可能会觉得这个代码和 JavaScript 中的 `map` 和 `reduce` 方法很像。

   Java 中的 `Stream` 类还有很多其他的方法，比如 `filter`、`reduce`、`forEach` 等，这里就不一一介绍了。

2. Optional

   `Optional` 是 Java 8 中新增的一个类，它可以用来表示一个值可能不存在的情况。比如我们有一个方法，它的返回值可能是一个字符串，也可能是 `null`，那么我们就可以使用 `Optional` 来表示这个返回值：

   ```java
   public Optional<String> get() {
        return Optional.ofNullable(null);
   }
   ```

   上面的代码中，我们使用 `Optional.ofNullable` 方法来创建一个 `Optional` 对象，这个对象可能包含一个字符串，也可能包含 `null`。

   `Optional` 类还有很多其他的方法，比如 `map`、`orElse`、`ifPresent` 等。

关于 Java 的函数式编程知识点，感兴趣的同学可以参考我在慕课网的免费课 [Java 函数式编程](https://www.imooc.com/learn/1284)。

## 5.6 Spring Boot 的配置文件

位于 `src/main/resources` 目录下的 `application.properties` 文件就是 Spring Boot 的配置文件，它是一个纯文本文件，我们可以在这个文件中配置一些属性，比如数据库的连接信息、日志的级别等。

但在介绍之前，我们必须要说 Spring Boot 其实是一个约定优于配置的框架，也就是说 Spring Boot 会根据一些约定来自动配置一些属性，比如我们在 `application.properties` 文件中没有配置 web 服务器的端口号，但是我们的应用启动之后，web 服务器的端口号却是 `8080`，这就是 Spring Boot 自动配置的结果。

当然我们可以通过修改 `application.properties` 文件来覆盖特定的配置，比如我们可以在 `application.properties` 文件中配置 web 服务器的端口号为 `8081`，那么我们的应用启动之后，web 服务器的端口号就是 `8081` 了。

```properties
server.port=8081
```

这个配置文件可以配置很多属性，这里我们只介绍一些常用的属性。

### 5.6.1 配置日志级别

我们可以在 `application.properties` 文件中配置日志的级别，比如我们可以把日志的级别设置为 `DEBUG`，那么我们的应用启动之后，所有级别为 `DEBUG` 的日志都会被打印出来。

```properties
logging.level.root=DEBUG
```

日志的级别有 6 个，分别是 `TRACE`、`DEBUG`、`INFO`、`WARN`、`ERROR` 和 `OFF`，其中 `TRACE` 是最低级别的日志，`OFF` 是最高级别的日志，也就是说 `OFF` 表示不打印任何日志。

设置的日志级别越低，打印的日志越多，设置的日志级别越高，打印的日志越少。而且，级别低的会包含级别高的信息，比如 `INFO` 级别的日志会打印 `INFO`、`WARN`、`ERROR` 级别的日志，但是不会打印 `DEBUG` 和 `TRACE` 级别的日志。

对于不同的包，我们可以设置不同的日志级别，比如我们可以把 `com.example` 包的日志级别设置为 `DEBUG`，而把 `com.example.controller` 包的日志级别设置为 `INFO`，那么我们的应用启动之后，`com.example` 包下的所有类的日志都会被打印出来，而 `com.example.controller` 包下的所有类的日志只会打印 `INFO`、`WARN`、`ERROR` 级别的日志。比如：

```properties
logging.level.com.mooc.backend=DEBUG
logging.level.com.mooc.backend.rest.app=INFO
```

#### 作业：配置日志级别

在 `application.properties` 文件中配置不同的日志级别，然后启动应用，查看日志的打印情况。

### 5.6.2 配置数据库连接信息

我们可以在 `application.properties` 文件中配置数据库的连接信息，比如我们可以把 H2 数据库的连接信息配置为：

```properties
# 数据源设置
spring.datasource.url=jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver
```

上面这个配置文件中，我们配置了数据库的连接 URL、用户名、密码和驱动类名。

数据库的连接 URL 依据不同数据库是不同的，比如 MySQL 的连接 URL 是类似 `jdbc:mysql://localhost:3306/test`，Oracle 的连接 URL 是类似 `jdbc:oracle:thin:@localhost:1521:orcl`，而 H2 内存模式的连接 URL 是类似 `jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE`。但不管怎么样，这些 URL 都会包含一些信息，比如数据库的地址、端口号、数据库名等。

在 Java 中，几乎所有的数据库都有一个驱动类，比如 MySQL 的驱动类是 `com.mysql.jdbc.Driver`，Oracle 的驱动类是 `oracle.jdbc.driver.OracleDriver`，而 H2 的驱动类是 `org.h2.Driver`。

一般来说一个数据库只需要配置以上 4 个属性就可以了，对于 h2 数据库，尤其简单，因为它是一个内存数据库，我们都不需要安装，只需要在 `build.gradle` 文件中添加依赖：

```groovy
dependencies {
    runtimeOnly 'com.h2database:h2'
}
```

然后我们在浏览器中访问 `http://localhost:8080/h2-console`，就可以看到 H2 的控制台了。

![图 8](http://ngassets.twigcodes.com/9a44ff140e4094c3c507cf5d9b8dd1dd14521d30a554b75c6dea2fac3af7fc4d.png)

点击，`Connect` 按钮，就可以连接到 H2 数据库了。

## 5.6.3 Profile

Profile 是 Spring Boot 中的一个概念，它可以让我们在不同的环境中使用不同的配置，比如我们可以在开发环境中使用 `application-dev.properties` 文件中的配置，而在生产环境中使用 `application-prod.properties` 文件中的配置。

我们可以在 `application.properties` 文件中配置 `spring.profiles.active` 属性，比如我们可以把 `spring.profiles.active` 属性设置为 `dev`，那么我们的应用启动之后，就会使用 `application-dev.properties` 文件中的配置。

```properties
spring.profiles.active=dev
```

默认情况下，Spring Boot 会加载 `application.properties` 文件中的配置，如果我们在 `application.properties` 文件中配置了 `spring.profiles.active` 属性，那么 Spring Boot 会加载 `application.properties` 文件中的配置和 `application-{spring.profiles.active}.properties` 文件中的配置。而且，`application-{spring.profiles.active}.properties` 文件中的配置会覆盖 `application.properties` 文件中的配置。

比如说，我们在 `application.properties` 文件中配置了 `server.port=8081`，而在 `application-dev.properties` 文件中配置了 `server.port=8082`，而且我们在 `application.properties` 文件中配置了 `spring.profiles.active=dev`，那么我们的应用启动之后，`server.port` 的值就是 `8082`。

当然这种覆盖只是在两个文件中的配置发生冲突的时候才会发生，如果两个文件中的配置不冲突，那么两个文件中的配置都会生效。

所以我们一般会把比较常用的配置都写在 `application.properties` 文件中，而把一些和环境相关的配置写在 `application-{spring.profiles.active}.properties` 文件中。

而且，我们还可以配置 `spring.profiles.include` 属性，比如我们可以把 `spring.profiles.include` 属性设置为 `prod`，那么我们的应用启动之后，就会使用 `application-prod.properties` 文件中的配置。

```properties
spring.profiles.include=prod
```

### 5.6.4 作业：配置 Profile

如果我们 `application.properties` 有如下配置：

```properties
# 服务端口
server.port=8080
# 启动时不显示banner
spring.main.banner-mode=off
# 日志设置
logging.level.root=error
logging.level.com.zaxxer.hikari=error
logging.level.com.mooc.backend=info
logging.level.com.qiniu=error
logging.level.jakarta.validation=error
logging.level.org.springframework.web.servlet=error
logging.level.org.springframework.data=info
logging.level.org.springframework.data.redis=info
logging.level.org.redisson=info
logging.level.org.redisson.hibernate=info
logging.level.org.springframework.cache=error
logging.level.org.flywaydb=error
logging.level.org.hibernate=error
logging.level.org.hibernate.cache=info
logging.level.org.hibernate.SQL_SLOW=info
# H2 数据库设置
spring.h2.console.enabled=false
```

请创建 3 个文件

- `application-dev.properties`
- `application-prod.properties`
- `application-test.properties`

其中在 `application-dev.properties` 文件中，我们需要配置所有的日志级别为 `debug`，并启用 H2 的控制台。在 `application-prod.properties` 文件中，更改端口号为 `8081` 。

然后在 IDEA 中编辑 **运行/调试配置** ，在 **有效配置文件** 处，填写 `dev`，然后运行程序，访问 `http://localhost:8080/h2-console`，看看是否可以连接到 H2 数据库。然后 **停止** 程序，然后在 **有效配置文件** 处，填写 `prod`，然后运行程序，访问 `http://localhost:8081/h2-console`，看看是否可以连接到 H2 数据库。

![图 9](http://ngassets.twigcodes.com/88a0eaf64412d06b3091a1712e7cb82c983f9c7ed4035b9fcfdd2a3eb8eb4eca.png)

## 5.7 测试的支持

对于后端的开发来说，测试是非常重要的，因为我们的代码一旦上线，就不能随意修改，所以我们必须保证我们的代码是正确的，而且我们的代码在修改之后，也不会影响到原来的功能。所以我们必须要有一套完善的测试用例，来保证我们的代码是正确的。

而 Spring Boot 为我们提供了很多测试的支持，比如说，我们可以使用 `@WebMvcTest` 注解来创建一个 Controller 的测试用例，然后使用 `@Test` 注解来编写测试用例，下面是一个简单的测试用例：

```java
@ActiveProfiles("test")
@WebMvcTest(controllers = ImageController.class)
public class ImageControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testGetImageByWidth() throws Exception {
        mockMvc.perform(get("/api/v1/image/{width}", 200))
                .andExpect(status().isOk())
                .andExpect(result -> {
                    var contentType = result.getResponse().getContentType();
                    assert contentType != null;
                    assert contentType.startsWith("image/png");
                    assert result.getResponse().getContentLength() > 0;
                });
    }
}
```

上面代码中，我们需要了解以下几点

1. `@ActiveProfiles("test")` 注解，它可以让我们在测试的时候使用 `application-test.properties` 文件中的配置。
2. `@WebMvcTest(controllers = ImageController.class)` 注解，它可以帮助我们快速的构建一个 `MockMvc` 对象，这个对象可以帮助我们快速的发起一个请求，然后对返回的结果进行断言。我们使用 `@Autowired` 注解来注入这个对象。
3. `mockMvc.perform(get("/api/v1/image/{width}", 200))` 表示我们要对 `/api/v1/image/{width}` 这个接口发起一个 `GET` 请求，其中 `{width}` 的值是 `200`。
4. `andExpect(status().isOk())` 表示我们期望返回的状态码是 `200`。
5. `andExpect(result -> { ... })` 表示我们期望返回的结果满足一些条件，比如说，我们期望返回的 `Content-Type` 是 `image/png`，我们期望返回的内容长度大于 `0`。

## 5.8 文件管理 API

### 5.8.1 需求分析

- 需求 1.2.3.1：图片行的数据可以配置图片的链接以及点击跳转的链接
- 需求 1.2.3.2：轮播图的数据可以配置图片的链接以及点击跳转的链接

我们之前的需求中对于涉及图片的地方，要求运营人员可以配置图片链接。理论上说，最简化的设计是提供一个地址的文本输入框即可。但如果我们和运营人员沟通之后，发现他们希望能够直接上传本地图片，可以浏览已经上传的图片资源，也可以删除已上传的图片。这就是一个新增的图片管理需求。

我们可以结合下面的图片来看看这个需求：

首先，我们需要一个图片管理的页面，这个页面需要有一个上传图片的按钮，然后需要有一个图片列表，这个列表需要有图片的预览图，右上角会有一个 **只读/编辑** 模式切换按钮。在只读模式下，点选图片，图片地址会填充到文本框中。

![只读模式](http://ngassets.twigcodes.com/f53a537136097263387cf2e1eea1776232b80ea3ec969ec9aabff4efa500dd5b.png)

编辑模式下，我们可以删除图片，也可以上传图片。编辑模式下每张图片右上角会有一个复选框，点击复选框，可以选择多张图片，对话框的右上角会出现一个删除按钮，然后点击 **删除** 按钮，可以批量删除图片。

![编辑模式](http://ngassets.twigcodes.com/2a37d65cadfcd43103c9c43178fdb8d3b30614f67effc80bb3db938fb874cddf.png)

![批量删除](http://ngassets.twigcodes.com/bdafbd3d1ca82886f43ace94899c5abe8871e171af987b85dab00f5bd961df7d.png)

点击上传图片按钮，会弹出一个对话框，可以选择本地图片，然后点击 **上传** 按钮，图片会上传到服务器，然后在图片列表中显示。

![上传文件](http://ngassets.twigcodes.com/1539763d80a8c1bffab04f3a8df5d631c2ed108a528e4f51d43bdaf7db936750.png)

所以对于后端来说，我们的需求是：

- 提供一个 API，可以上传图片，返回图片的 URL
- 提供一个 API，可以删除图片
- 提供一个 API，可以获取所有的图片链接

由于这个 API 上传的文件最终会使用在 App 中，所以图片不能保存在服务器本地，而是需要一个类似 CDN 的服务，来保存图片。这样的话，前端对于图片的访问和后端对于文件存储都是经过优化的。这其实是一个隐性的需求：我们需要使用一个 CDN 服务来存储图片。

在我们的课程中，我们给出一个使用 [七牛云](https://www.qiniu.com/) 作为 CDN 服务的方案。

### 5.8.2 七牛云

我们在这里使用七牛云的对象存储服务，来存储我们的图片。七牛云提供了 Java 的 SDK，我们可以使用这个 SDK 来上传图片。需要在 `build.gradle` 文件中添加以下依赖：

```groovy
ext {
    qiNiuVersion = '7.13.+' // + 表示使用最新的小版本
}
implementation "com.qiniu:qiniu-java-sdk:${qiNiuVersion}"
```

我们如果要使用七牛云的 SDK，需要以下几个参数：

- AccessKey
- SecretKey
- Bucket
- Domain

`AccessKey` 和 `SecretKey` 可以从 **个人中心/密钥管理** 中获得

![图 10](http://ngassets.twigcodes.com/9a6196b3bae6510501547fa3cab8f0e098334f67d1a6e421b6afc83a9f894a84.png)

`Bucket` : 可以从 **对象存储/空间管理** 中选择或新建一个空间，这个空间的名字就是 `Bucket`

![图 11](http://ngassets.twigcodes.com/3b5701eb066ad148d072cfc4cb5a62b263d47f828353b5da918e54b78329422e.png)

`Domain` 就是点击某一空间后，在里面可以绑定一个 CDN 加速域名，这个域名就是 `Domain` , 如果你没有自己的域名，可以使用七牛云提供的临时域名。

![图 12](http://ngassets.twigcodes.com/6f9d9f1e2d2ed03a3ff75534db8d3a76d5f975da2717506b022f0231c6c477dc.png)

### 5.8.3 领域模型

为了更通用，我们把图片看成一个更广泛意义上的文件，所以我们把图片的领域模型定义为 `FileDTO`，它需要至少有以下属性：

- `key`：文件的唯一标识：因为在选择或删除文件的时候，我们需要知道文件的唯一标识，所以这个属性是必须的。
- `url`：文件的 URL：图片或文件是需要显示或者下载的，所以这个属性是必须的。

```java
public record FileDTO(String url, String key) {
}
```

上面的代码中我们使用了一个新的 Java 语法：`record`，它可以帮助我们快速的定义一个类，它的属性是 `final` 的，同时它还会自动帮我们生成 `getter` 方法。和比较重的 `class` 相比，`record` 更轻量，更适合用来定义一些简单的数据结构。

访问 `record` 的属性，可以使用 `.` 操作符，但注意，`record` 的属性其实是个方法，所以需要加上 `()`：

```java
FileDTO fileDTO = new FileDTO("http://www.baidu.com", "123");
System.out.println(fileDTO.url());
```

### 5.8.4 七牛云配置

在前面我们获得了 4 个七牛云必要的参数，这些参数写死在程序中显然不是一个好的设计，所以我们需要把这些参数放到配置文件中，然后在程序中读取配置文件中的参数。

比如我们希望在 `application.properties` 文件中添加以下配置：

```properties
qiniu.access-key=xxxx
qiniu.secret-key=xxxx
qiniu.bucket=xxxx
qiniu.domain=xxxx
```

如果希望我们的属性配置和 Spring Boot 内置的属性配置一样的效果，我们只需要在 `config` 包下创建一个 `QiNiuProperties` 类，然后在这个类上添加 `@ConfigurationProperties(prefix = "qiniu")` 注解即可。

```java
@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "qiniu")
public class QiNiuProperties {
    private String accessKey;
    private String secretKey;
    private String bucket;
    private String domain;
}
```

- `@ConfigurationProperties` ：这个注解的作用是读取配置文件中的属性，然后把属性值注入到这个类中。而且对于这类注解的类，重新编译后，你在 `properties` 文件中甚至可以出现智能提示。注解中的 `prefix` 属性表示读取配置文件中以 `qiniu` 开头的属性。
- `@Configuration` ：这个注解的作用是把这个类作为一个配置类，这样的话，我们就可以在其他地方使用 `@Autowired` 注解来注入这个类了。
- `@Getter` ：这个注解的作用是为这个类自动生成 `getter` 方法。
- `@Setter` ：这个注解的作用是是为这个类自动生成 `setter` 方法。

如果在七牛云的官方[文档](https://developer.qiniu.com/kodo/1239/java)上，查看例子可以看到上传的示例代码，此外你也可以找到删除文件的和获取空间文件列表的示例代码，但是这些代码都是写死的，我们需要把这些参数从配置文件中读取出来，然后再使用。

通过学习这些示例代码，上传需要一个 `UploadManager`，而列表和删除文件需要一个 `BucketManager`，而这两个实例化时又都需要 `Auth` 的实例和 `Configuration` 的实例，遇到这种需要多个地方需要同样的配置的实例的情况，我们可以使用 `@Bean` 注解来实例化这些对象，然后把这些对象注入到其他类中。

所以我们在 `config` 下创建一个 `QiNiuConfig` 类，然后在这个类中添加以下代码：

```java
@Configuration
public class QiNiuConfig {
    @Bean
    public Auth auth(QiNiuProperties qiNiuProperties) {
        return Auth.create(qiNiuProperties.getAccessKey(), qiNiuProperties.getSecretKey());
    }

    @Bean
    public com.qiniu.storage.Configuration configuration() {
        var cfg = new com.qiniu.storage.Configuration(com.qiniu.storage.Region.autoRegion());
        cfg.useHttpsDomains = false;
        cfg.resumableUploadAPIVersion = com.qiniu.storage.Configuration.ResumableUploadAPIVersion.V2;
        return cfg;
    }

    @Bean
    public BucketManager bucketManager(com.qiniu.util.Auth auth, com.qiniu.storage.Configuration configuration) {
        return new BucketManager(auth, configuration);
    }

    @Bean
    public UploadManager uploadManager(com.qiniu.storage.Configuration configuration) {
        return new UploadManager(configuration);
    }
}
```

上面代码中，我们再次使用了 `@Bean` 这个注解，把函数的返回值注入到 Spring 容器中。值得特别指出的是：

- `auth` 函数的参数中，我们使用了 `QiNiuProperties` 类，这个类是我们在前面定义的，它的作用是读取配置文件中的七牛云的配置。而且这个 `QiNiuProperties` 类是通过 `@Configuration` 注解注入到 Spring 容器中的，所以我们可以在这个函数中直接使用。从这点可以体会一下依赖注入的好处。
- `configuration` 函数中，我们使用了 `com.qiniu.storage.Configuration` 这个类，这个类是七牛云提供的，它的作用是配置七牛云的上传策略，比如上传的域名、上传的区域等等。这个类的构造函数需要一个 `com.qiniu.storage.Region` 类的实例，这个类的作用是配置上传的区域，我们使用 `Region.autoRegion()` 方法来自动选择上传的区域。然后我们把 `useHttpsDomains` 属性设置为 `false`，这样就可以使用 HTTP 协议来上传文件了。断点续传的版本我们设置为 `V2`。
- `uploadManager` 和 `bucketManager` 函数中，我们使用了 `com.qiniu.storage.BucketManager` 这个类，这个类的作用是管理七牛云的空间，比如删除文件、获取空间文件列表等等。这个类的构造函数需要 `com.qiniu.util.Auth` 类的实例和 `com.qiniu.storage.Configuration` 类的实例，所以我们在这个函数中使用了 `auth` 和 `configuration` 函数的返回值。同样的，由于 `auth` 和 `configuration` 函数的返回值都是通过 `@Bean` 注解注入到 Spring 容器中的，所以我们可以在这个函数中直接使用。
- 那么为什么对于 `com.qiniu.storage.Configuration` 这种我们要指定它的完全限定名呢？这是因为`com.qiniu.storage.Configuration` 这个类的名字和 `@Configuration` 注解的导入 `org.springframework.context.annotation.Configuration` 相同，所以我们需要指定它的完全限定名。至于其他的类，比如 `com.qiniu.util.Auth` 这个类，就不需要指定它的完全限定名了。

### 5.8.5 上传文件

在 Java 中，一般我们把逻辑封装到一个类中，然后在这个类中定义一些方法，这些方法就是这个类的功能。所以我们在 `services` 包下创建一个 `QiNiuService` 类，然后在这个类中添加以下代码：

```java
@RequiredArgsConstructor
@Service
public class QiniuService {

    private final UploadManager uploadManager;
    private final Auth auth;
    @Value("${qiniu.bucket}")
    private String bucket;
    @Value("${qiniu.domain}")
    private String domain;
    /**
     * 上传文件
     *
     * @param uploadBytes 文件字节数组
     * @param key         文件名
     * @return 文件信息
     */
    public FileDTO upload(byte[] uploadBytes, String key) {
        ByteArrayInputStream byteInputStream = new ByteArrayInputStream(uploadBytes);
        String upToken = auth.uploadToken(bucket);
        try {
            // ObjectMapper 是 Jackson 的一个类，用来把 JSON 字符串转换为对象
            var mapper = new ObjectMapper();
            // 七牛云 SDK 的上传方法，返回的 response.bodyString() 是一个 JSON 字符串
            var response = uploadManager.put(byteInputStream, key, upToken, null, null);
            // 把 JSON 字符串转换为对象
            var putRet = mapper.readValue(
                response.bodyString(),
                com.qiniu.storage.model.DefaultPutRet.class);
            // 返回文件信息，由于返回的 key 不带域名，所以我们需要拼接上域名
            return new FileDTO(domain + "/" + putRet.key, putRet.key);
        } catch (QiniuException | JsonProcessingException e) {
            e.printStackTrace();
            throw new CustomException("文件上传错误", e.getMessage(), Errors.FileUploadException.code());
        }
    }
}
```

1. `@RequiredArgsConstructor` 注解的作用是生成一个包含所有 `final` 和 `@NonNull` 字段的构造函数。Spring 遇到构造的的参数，会去容器中查找是否有这个类型的 Bean，如果有就注入，如果没有就报错。而 `UploadManager` 和 `Auth` 这两个类都是在 `QiNiuConfig` 中以 `@Bean` 注解的形式注册到 Spring 容器中的，所以我们可以在这个类中直接使用。这个写法还等价于下面的代码：

   ```java
   // 如果不使用 Lombok 提供的 @RequiredArgsConstructor 注解
   @Service
   public class QiniuService {
       private final UploadManager uploadManager;
       private final Auth auth;
       // 需要手写构造函数
       // 且需要在构造函数中使用 @Autowired 注解
       public QiniuService(@Autowired UploadManager uploadManager, @Autowired Auth auth) {
           this.uploadManager = uploadManager;
           this.auth = auth;
       }
   }
   ```

2. `@Value` 注解的作用是从配置文件中读取配置。这里我们读取了 `qiniu.bucket` 和 `qiniu.domain` 这两个配置，分别是七牛云的空间名和域名。这两个配置在前面我们已经在 `application.yml` 中配置好了。当然，我们也可以采用直接把 `QiNiuProperties` 注入的方式，见下面代码。但是这样做的话，我们就需要在 `QiNiuService` 类中使用 `qiNiuProperties.getBucket()` 和 `qiNiuProperties.getDomain()` 来获取配置。

   ```java
   @RequiredArgsConstructor
   @Service
   public class QiniuService {
       private final UploadManager uploadManager;
       private final Auth auth;
       private final QiNiuProperties qiNiuProperties;
       // ...
   }
   ```

3. `@Service` 注解的作用是把这个类注册到 Spring 容器中，这个注解其实和 `@Component` 的作用是一样的。只不过由于 Java 中的最佳实践是程序要分层，所以 `@Service` 表示这个是服务层的。

### 5.8.6 作业：完成空间文件列表和删除文件功能

请参考 [七牛云 SDK 文档](https://developer.qiniu.com/kodo/1239/java) 中的 **删除空间中的文件** 和 **获取空间文件列表** 两节，完成 `QiNiuService` 类中的 `listFiles` 和 `deleteFile` 方法。此外还要实现一个批量删除的方法 `deleteFiles`。

### 5.8.7 上传文件接口

在 `rest.admin` 包下创建一个 `FileController` 类，然后在这个类中添加以下代码：

```java
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/admin")
public class FileController {
    private final QiniuService qiniuService;

    @PostMapping(value = "/file", consumes = "multipart/form-data")
    public FileDTO upload(@RequestParam("file") MultipartFile file) {
        try {
            return qiniuService.upload(file.getBytes(), UUID.randomUUID().toString());
        } catch (IOException e) {
            throw new CustomException("File Upload error", e.getMessage(), Errors.FileUploadException.code());
        }
    }
}
```

可以看到在 Spring Boot 中完成一个文件上传的接口是非常简单的

1. 文件上传必须是一个 `POST` 请求，而且请求头中必须包含 `Content-Type: multipart/form-data`，这是因为文件上传是通过 `multipart/form-data` 的方式来传输的。所以我们在 `@PostMapping` 注解中添加了 `consumes` 属性，表示这个接口只接受 `multipart/form-data` 的请求。
2. 我们需要一个查询参数 `file`，这个参数的类型是 `MultipartFile`，这个类型是 Spring Boot 提供的，用来表示文件上传的文件。我们在方法的参数中添加了 `@RequestParam("file")` 注解，表示这个参数是一个查询参数，而且参数名是 `file`。但它和一般的查询参数不同，它不是放在 URL 中的，而是放在请求体中的。
3. 在方法体中，我们调用了 `qiniuService.upload` 方法，把文件字节数组和文件名传递给了这个方法。这个方法会返回一个 `FileDTO` 对象，这个对象包含了文件的 URL 和文件名。我们把这个对象返回给前端。

### 5.8.8 测试上传文件接口

我们当然可以直接使用 Swagger 来测试这个接口，这个方式是方便的。

![图 1](http://ngassets.twigcodes.com/bc5710ec593cf083a5772e68162b48dac3e6fb9b1705cf1a60e234d8490e9ca7.png)

点击 file 右边的 **选择文件** 按钮，选择一个文件，然后点击 **Try it out!** 按钮，就可以看到文件上传成功了。

但是这种测试是一次性的，所以我们需要写一个单元测试来测试这个接口。

```java
@ActiveProfiles("test")
@WebMvcTest(controllers = {FileController.class})
public class FileControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private QiniuService qiniuService;

    @Test
    public void testUpload() throws Exception {
        // 构造一个 MultiPart 文件
        MockMultipartFile jsonFile = new MockMultipartFile(
            "test.json",
            "",
            "application/json",
            "{\"key1\": \"value1\"}".getBytes());
        var fileDto = new FileDTO("https://www.example.com/test.json", "test.json");
        // 模拟 QiniuService 的 upload 方法，不管传入什么参数，都返回 fileDto
        when(qiniuService.upload(any(), any())).thenReturn(fileDto);
        // 使用 MockMvc 发起文件上传请求
        mockMvc.perform(multipart("/api/v1/admin/file")
                        .file("file", jsonFile.getBytes())
                        .characterEncoding("UTF-8")
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.url").value(fileDto.url()))
                .andExpect(jsonPath("$.key").value(fileDto.key()));
    }
}
```

1. `@ActiveProfiles("test")` 注解的作用是指定当前测试类使用的配置文件。这里我们指定了 `test` 配置文件，这个配置文件在 `src/test/resources` 目录下。这个配置文件中的配置会覆盖 `application.properties` 中的配置。这里我们指定了 `spring.profiles.active` 的值为 `test`，这个配置的作用是指定当前使用的是测试环境，这样就会使用 `application-test.properties` 这个配置文件。这个配置文件中的配置会覆盖 `application.yml` 和 `application-dev.yml` 中的配置。这里我们指定了 `qiniu.access-key` 和 `qiniu.secret-key` 的值，这样就不会使用 `application-test.yml` 中的配置了。
2. `@WebMvcTest` 注解的作用是指定当前测试类只测试 `FileController` 这个类。这个注解会自动把 `FileController` 这个类注册到 Spring 容器中，但是它不会把其他的类注册到 Spring 容器中。这样就可以避免测试类中的代码依赖其他类，从而保证测试的独立性。
3. 对于文件上传请求，我们需要使用 `MockMultipartFile` 来构造一个 `multipart/form-data` 的请求体。这个类的构造方法有三个参数，第一个参数是文件名，第二个参数是文件的内容类型，第三个参数是文件的内容。我们可以使用 `MockMultipartFile` 的 `getBytes()` 方法来获取文件的字节数组。
4. 由于 `FileController` 依赖 `QiniuService`，所以我们需要使用 `@MockBean` 注解来模拟 `QiniuService` 这个类。这个注解的作用是把 `QiniuService` 这个类注册到 Spring 容器中，但是它不会把这个类的 **实现** 注册到 Spring 容器中，而是使用 Mockito 来模拟这个类的实现。这样就可以避免测试类中的代码依赖其他类，从而保证测试的独立性。具体 Mockito 的使用可以参考 [Mockito 官方文档](https://site.mockito.org/)。
5. 使用 `when(qiniuService.upload(any(), any())).thenReturn(fileDto);` 语句来模拟 `QiniuService` 的 `upload` 方法，不管传入什么参数，都返回 `fileDto`。
6. 使用 `MockMvc` 来发起文件上传请求。`MockMvc` 是 Spring Boot 提供的一个测试工具，它可以用来模拟 HTTP 请求。我们可以使用 `MockMvc` 的 `perform` 方法来发起一个 HTTP 请求，这个方法的参数是一个 `RequestBuilder` 对象。`RequestBuilder` 是一个接口，它有很多实现类，比如 `MockHttpServletRequestBuilder`，`MockMultipartHttpServletRequestBuilder` 等。这里我们使用 `MockMultipartHttpServletRequestBuilder` 来构造一个 `multipart/form-data` 的请求。`MockMultipartHttpServletRequestBuilder` 的 `file` 方法可以用来添加一个文件，它的第一个参数是文件的参数名，第二个参数是文件的字节数组。`MockMultipartHttpServletRequestBuilder` 的 `characterEncoding` 方法可以用来设置请求体的编码格式。

对于单元测试的意义，很多同学一开始可能不是很理解。但是随着项目的不断迭代，单元测试的意义就会越来越明显。比如，我们在开发过程中，修改了 `QiniuService` 的实现，但是忘记了修改 `FileController` 中的代码，这样就会导致 `FileController` 中的代码依赖 `QiniuService` 的实现，从而导致测试失败。如果我们有单元测试，那么这个问题就会在开发阶段就暴露出来，这样就可以及时修复这个问题。

另外一个常见的疑问是，我们通过模拟 QiNiuService 的实现来给出预期结果，那么测试的意义是什么呢？这个问题的答案是我们要单独测试 `FileController` 这个类，而不是测试 `QiniuService` 这个类。如果我们要测试 `QiniuService` 这个类，那么我们就不需要模拟 `QiniuService` 的实现了，而是直接使用真实的 `QiniuService` 的实现来测试。这样就可以避免测试类中的代码依赖其他类，从而保证测试的独立性。

### 5.8.9 作业：完成文件列表接口和删除文件接口，并编写单元测试

提示：

1. 文件列表接口：需要返回一个 `List<FileDTO>` 对象
2. 删除文件接口：由于 Delete 请求没有请求体，所以我们需要使用 `@PathVariable` 注解来接收请求参数
3. 批量删除的接口, 由于 `Delete` 请求无法携带 RequestBody，这里不需要对 RESTful 太原教旨主义，可以使用 `PUT` 请求。这里的 `PUT` 请求的请求体是一个 `List<String>` 对象，这个对象包含了所有需要删除的文件的 Key

针对单元测试：

1. 在文件列表的测试中，需要考虑列表为空和不为空两种情况
2. 在删除文件的测试中，由于 `QiniuService` 的 `delete` 方法没有返回值，所以我们需要使用 `doNothing().when(xxx).delete(yyy)` 方法来模拟 `QiniuService` 的 `delete` 方法

#### 5.8.9.1 Swagger 文档

有兴趣的同学可以自行添加 Swagger 文档，但文件列表的 API 由于返回的是 `List<FileDTO>` 对象，这种返回的对象有没有办法文档化呢？

你可以使用 `@Schema` 注解：

```java
@Schema(name = "FileDTO", description = "文件数据传输对象")
public record FileDTO(
        @Schema(description = "文件 URL", example = "https://example.com/123-abc-123")
        String url,
        @Schema(description = "文件唯一标识", example = "123-abc-123")
        String key) {
}
```

## 5.9 使用前端原型进行集成验证

文件的 API 已经完成了，但是我们还没有进行集成验证。在这一节中，我们将使用前端原型进行集成验证。

根据 5.8.1 中的需求分析，我们需要实现以下功能：

1. 一个用于显示文件列表的页面，网格布局，每个网格显示一个文件的缩略图
2. 列表页面右上方有一个切换 **只读/编辑** 模式的按钮
3. 编辑模式下，每个网格右上角有一个复选框，用于选择文件
4. 编辑模式下，右上角有一个删除按钮，用于删除选中的文件
5. 编辑模式下，左下角有一个全选按钮，用于全选/取消全选
6. 编辑模式下，再次点击 **只读/编辑** 按钮，可以退出编辑模式
7. 只读模式下， **只读/编辑** 按钮的图标为编辑图标，点击后进入编辑模式，图标变为只读图标
8. 编辑模式下，右上角多一个上传按钮，点击后进入上传页面
9. 选择文件上传后，自动返回文件列表页面，文件列表页面会自动刷新

由于这是一个相对独立的组件，我们将在一个单独的模块 `files` 中进行开发。

### 5.9.1 页面构成

我们先来看一下列表页面的原型：

![图 17](http://ngassets.twigcodes.com/61665dd63d1e539aaa8042af71a74ffffb14b432b9da552f4e4d8c1e23580de9.png)

我们可以将页面分为三部分

1. 顶部标题栏
2. 图片网格
3. 底部工具栏

我们的目标是做一个对话框来实现这个组件

```dart
final title = ...;
final content = ...;
final actions = [
  TextButton(
    onPressed: () => Navigator.of(context).pop(),
    child: const Text('取消'),
  ),
];
return AlertDialog(
  title: title,
  content: content,
  actions: actions,
);
```

所以底部工具栏其实就是对话框的 `actions` 部分，我们可以先不考虑这部分。

### 5.9.2 顶部标题栏

顶部标题栏我们希望设计成一个 `Row`，左边是一个 `Text`，右边是一组 `IconButton`。

这个组件本身不处理具体的事件，而是将事件传递给父组件，所以我们将这个组件设计成一个 `StatelessWidget`。

```dart
/// 文件对话框标题
/// [editable] 是否可编辑
/// [selectedKeys] 选中的文件
/// [onEditableChanged] 可编辑状态改变回调
/// [onUpload] 上传回调
/// [onDelete] 删除回调
class FileDialogTitle extends StatelessWidget {
  const FileDialogTitle({
    super.key,
    required this.editable,
    required this.selectedKeys,
    required this.onEditableChanged,
    required this.onUpload,
    required this.onDelete,
  });
  final bool editable;
  final List<String> selectedKeys;
  final void Function(bool) onEditableChanged;
  final void Function() onUpload;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    /// 编辑按钮
    final editableIcon = Icon(editable ? Icons.lock : Icons.lock_open).inkWell(
      onTap: () => onEditableChanged(!editable),
    );

    /// 上传按钮
    final uploadIcon = const Icon(Icons.upload_file).inkWell(
      onTap: onUpload,
    );

    /// 删除按钮
    final deleteIcon = const Icon(Icons.delete).inkWell(
      onTap: () async {
        if (selectedKeys.isEmpty) {
          return;
        }
        final cancelButton = TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        );
        final confirmButton = TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('确定'),
        );
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除图片'),
            content: const Text('确定要删除这些图片吗？'),
            actions: [cancelButton, confirmButton],
          ),
        );
        if (result ?? false) {
          onDelete();
        }
      },
    );
    return [
      const Text('图片资源'),
      const Spacer(),
      editableIcon,
      if (editable) uploadIcon,
      if (editable && selectedKeys.isNotEmpty) deleteIcon,
    ].toRow();
  }
}
```

### 5.9.3 图片网格

图片网格我们希望设计成一个 `GridView`，每个网格显示一个文件的缩略图。

```dart
/// 文件对话框内容
/// [images] 文件列表
/// [editable] 是否可编辑
/// [selectedKeys] 选中的文件 key 列表
/// [onSelected] 选中文件的回调
class FileDialogContent extends StatelessWidget {
  const FileDialogContent({
    super.key,
    required this.images,
    required this.editable,
    required this.selectedKeys,
    required this.onSelected,
  });
  final List<FileDto> images;
  final bool editable;
  final List<String> selectedKeys;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    /// 使用 GridView 显示图片
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];

        /// 非编辑模式下的图片
        final selectableItem = Image.network(
          image.url,
          fit: BoxFit.cover,
        ).inkWell(
          onTap: () => Navigator.of(context).pop(image),
        );

        /// 编辑模式下的图片
        final editableItem = _buildEditableItem(image);
        /// 根据是否可编辑返回不同的组件
        return editable ? editableItem : selectableItem;
      },
    ).constrained(
      width: 400,
      height: 600,
    );
  }

  /// 构建可编辑状态下的图片
  Widget _buildEditableItem(FileDto image) {
    final checkedIcon = Icon(selectedKeys.contains(image.key)
            ? Icons.check_box
            : Icons.check_box_outline_blank)
        .inkWell(
          onTap: () => onSelected(image.key),
        )
        .positioned(
          top: 0,
          right: 0,
        );
    return [Image.network(image.url), checkedIcon].toStack();
  }
}
```

上面的代码中，我们使用了 `GridView` 来显示图片，但是这个组件默认是无限高度的，所以我们需要使用 `shrinkWrap` 属性来限制高度。

### 5.9.4 构建图片浏览对话框

#### 5.9.4.1 客户端访问 API

在客户端访问 API，我们可以使用 `dio` 这个库，它是一个 `http` 请求库，它的使用方法和 `axios` 类似。

```dart
/// 使用 dio 发送请求
final dio = Dio();
/// 获取文件列表
Future<List<FileDto>> getFiles() async {
  final response = await dio.get('/api/files');
  return (response.data as List).map((e) => FileDto.fromJson(e)).toList();
}
```

但是我们并不是想直接在 `file` 这个包当中使用 `dio` 。我们打算利用 `Repository` 这个模式来管理 API 的访问。

那么什么是 `Repository` 呢？`Repository` 是一个管理数据的类，它的作用是从数据源获取数据，然后将数据转换成我们需要的格式，最后将数据返回给调用者。在我们的项目中，我们的数据源就是 API，所以我们的 `Repository` 就是用来管理 API 的访问的。

对于比较简单的 `Repository` 我们当然可以直接使用 `dio`:

```dart
class FileRepository {
  final String baseUrl;
  final Dio client;

  FileRepository({
    Dio? client,
    this.baseUrl = '',
  }) : client = client ?? FileClient();

  Future<List<FileDto>> getFiles() async {
    final response = await client.get('/files');
    return (response.data as List).map((e) => FileDto.fromJson(e)).toList();
  }
}
```

但实际工作中，我们经常会发现需要对网络层进行一些封装，比如添加一些公共的请求头，添加一些公共的请求参数，添加一些公共的错误处理逻辑等等。这些逻辑我们不希望在每个 `Repository` 中都重复写一遍，所以我们可以将这些逻辑抽离出来，放到一个单独的包中，这就是 `netwokring` 包。

对于文件上传来说，它需要的请求头是和一般的请求不一样的，所以我们需要对 `dio` 进行一些封装，这样我们就可以在 `networking` 包中创建一个 `FileClient` 来管理文件上传的 API。

```dart
class FileClient extends Dio {
  FileClient() {
    options.baseUrl = 'http://localhost:3000';
    options.headers['Content-Type'] = 'multipart/form-data';
  }
}
```

当然，我们在这个 `FileClient` 还可以添加一些拦截器，比如日志的拦截器，这有助于我们调试。

```dart
class FileClient extends Dio {
  FileClient() {
    options.baseUrl = 'http://localhost:3000';
    options.headers['Content-Type'] = 'multipart/form-data';
    interceptors.add(PrettyDioLogger());
  }
}
```

此外，还记得我们之前对于后端的异常做了统一处理吗？我们可以在这里添加一个拦截器，来处理后端返回的异常。由于后端异常会遵循 RFC7807 标准，所以我们可以定义一个 `Problem` 类来表示后端返回的异常。

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

然后我们就可以在拦截器中处理后端返回的异常了。

```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'problem.dart';

/// 自定义的 Dio 实例，用于访问文件接口
/// 该实例会自动添加日志拦截器和错误拦截器
/// 该实例会自动添加 Content-Type 和 Accept 头
/// 该实例会自动将后台返回的 Problem 对象转换为 DioError
class FileClient with DioMixin implements Dio {
  static final FileClient _instance = FileClient._();
  factory FileClient() => _instance;

  FileClient._() {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      connectTimeout: const Duration(seconds: 5), /// 连接超时时间
      receiveTimeout: const Duration(seconds: 5), /// 接收超时时间
      headers: Map.from({
        /// 文件上传需要使用 multipart/form-data
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      }),
    );
    /// 设置 HttpClientAdapter
    httpClientAdapter = HttpClientAdapter();
    /// 添加日志拦截器
    interceptors.add(PrettyDioLogger());
    /// 添加自定义的错误拦截器
    /// 这个拦截器是拦截 Response 的, 如果后端返回的是 Problem 对象
    /// 那么就会将 Problem 对象转换为 DioError
    interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        if (e.response?.data != null) {
          final problem = Problem.fromJson(e.response?.data);
          return handler.reject(DioError(
            requestOptions: e.requestOptions,
            error: problem,
            type: DioErrorType.badResponse,
            message: problem.title,
          ));
        }
        return handler.next(e);
      },
    ));
  }
}
```

类似的，我们对于文件管理类的 API 也可以创建一个 `FileAdminClient` 来管理，但文件管理类的请求和其他运营后台需要的请求没有什么差别，所以可以创建一个 `AdminClient`。

```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'problem.dart';

/// 自定义的 Dio 实例，用于访问后台管理接口
/// 该实例会自动添加日志拦截器和错误拦截器
/// 该实例会自动添加 Content-Type 和 Accept 头
/// 该实例会自动将后台返回的 Problem 对象转换为 DioError
///
/// DioMixin 是一个 Mixin，它会自动实现 Dio 的所有方法
/// Mixin 的好处是可以在不改变原有类的情况下，为类添加新的功能
/// 具体的实现原理可以参考：https://dart.dev/guides/language/language-tour#mixins
class AdminClient with DioMixin implements Dio {
  /// 单例模式，禁止外部创建实例
  static final AdminClient _instance = AdminClient._();

  /// 工厂构造函数，返回单例
  factory AdminClient() => _instance;

  /// 私有构造函数，禁止外部创建实例
  AdminClient._() {
    /// 配置参数
    options = BaseOptions(
      /// 后台管理接口的基础 URL
      baseUrl: 'http://localhost:8080/api/v1/admin',

      /// 添加 Content-Type 和 Accept 头
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );

    /// 添加 HttpClientAdapter, 用于发送 HTTP 请求
    httpClientAdapter = HttpClientAdapter();

    /// 添加日志拦截器
    interceptors.add(PrettyDioLogger());

    /// 添加错误拦截器
    /// InterceptorsWrapper 是一个拦截器包装器，它可以包装多个拦截器
    /// 可以处理 onError, onRequest, onResponse 事件
    interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        if (e.response?.data != null) {
          final problem = Problem.fromJson(e.response?.data);
          return handler.reject(DioError(
            requestOptions: e.requestOptions,
            error: problem,
            type: DioErrorType.badResponse,
            message: problem.title,
          ));
        }
        return handler.next(e);
      },
    ));
  }
}
```

上面代码中，我们使用了 `DioCacheInterceptor` 来实现缓存功能，它需要传入一个 `DioCacheOptions` 对象来配置缓存的选项。

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

封装了 `FileClient` 和 `AppClient` 之后，我们就可以在 `networking\networking.dart` 中导出这两个类了。

```dart
export 'file_client.dart';
export 'admin_client.dart';
```

然后就可以在 `repositories/lib` 下创建 `file_upload_repository.dart` 和 `file_admin_repository.dart` 两个文件，分别用来管理上传文件和管理文件的 API。

```dart
class FileUploadRepository {
  final String baseUrl;
  final Dio client;

  FileUploadRepository({
    Dio? client,
    this.baseUrl = '',
  }) : client = client ?? FileClient();

  Future<FileDto> uploadFile(UploadFile file) async {
    debugPrint('FileUploadRepository.upload($file)');

    final res = await client.post('/file', data: {
      'file': MultipartFile.fromBytes(
        file.file,
        filename: file.name,
      ),
    });
    if (res.data is! Map) {
      throw Exception(
          'FileUploadRepository.upload($file) - failed, res.data is not Map');
    }

    debugPrint('FileUploadRepository.upload($file) - success');
    final json = res.data as Map<String, dynamic>;
    final fileDto = FileDto.fromJson(json);
    return fileDto;
  }

  Future<List<FileDto>> uploadFiles(List<UploadFile> files) async {
    debugPrint('FileUploadRepository.upload($files)');

    FormData formData = FormData();
    for (var i = 0; i < files.length; i++) {
      formData.files.add(MapEntry(
          "files",
          MultipartFile.fromBytes(
            files[i].file,
            filename: files[i].name,
          )));
    }
    final res = await client.post('/files', data: formData);
    if (res.data is! List) {
      throw Exception(
          'FileUploadRepository.upload($files) - failed, res.data is not List');
    }

    debugPrint('FileUploadRepository.upload($files) - success');
    final json = res.data as List<dynamic>;
    final fileDtos = json.map((e) => FileDto.fromJson(e)).toList();
    return fileDtos;
  }
}
```

上面代码中，我们封装了两个方法，一个是上传单个文件，一个是上传多个文件。

然后对于文件管理的 API，我们可以在 `file_admin_repository.dart` 中封装，这里使用了 `AdminClient` 。

```dart
import 'package:dio/dio.dart';
import 'package:networking/networking.dart';

class FileAdminRepository {
  final String baseUrl;
  final Dio client;

  FileAdminRepository({
    Dio? client,
    this.baseUrl = '/files',
  }) : client = client ?? AdminClient();

  Future<List<FileDto>> getFiles() async {
    final url = baseUrl;
    final res = await client.get(url);
    if (res.data is! List) {
      throw Exception(
          'FileAdminRepository.getFiles() - failed, res.data is not List');
    }

    final json = res.data as List;
    final files = json.map((e) => FileDto.fromJson(e)).toList();
    return files;
  }

  Future<void> deleteFile(String key) async {
    final url = '$baseUrl/$key';
    await client.delete(url);
  }

  Future<void> deleteFiles(List<String> keys) async {
    final url = baseUrl;
    await client.put(url, data: keys);
  }
}

class FileDto {
  final String key;
  final String url;

  FileDto({
    required this.key,
    required this.url,
  });

  factory FileDto.fromJson(Map<String, dynamic> json) {
    return FileDto(
      key: json['key'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'url': url,
    };
  }
}
```

在这里，我们封装了三个方法，分别是获取文件列表、删除单个文件和删除多个文件。你可以看到和后端 API 类似的，对于不同的 HTTP 方法， `dio` 也提供了对应的方法，比如 `get`、`post`、`put`、`delete` 等。

#### 5.9.4.2 状态管理

由于这个图片浏览对话框的状态很多，这里我们给大家介绍一个 flutter 的状态管理框架 - `flutter_bloc` 。

`flutter_bloc` 是一个状态管理框架，它的核心思想是将状态抽象成一个个的 `Bloc`，每个 `Bloc` 只负责管理一个状态，然后通过 `Stream` 来将状态传递给 `Widget`。如果你熟悉 `Redux` 的话，那么你会发现 `flutter_bloc` 和 `Redux` 的思想是非常相似的。

我们可以通过 `flutter_bloc` 来管理图片浏览对话框的状态，这样我们就可以将状态和 UI 分离开来，让代码更加清晰。

我们可以用一个图来表示 `BLoC` 的流程：

![图 19](http://ngassets.twigcodes.com/f5b7576daa2382c738a33ea86723955f50910da9ca4db6ef855f2942b91f77c5.png)

1. 初始状态： `FileState`
2. 加载文件列表： `FileState` -> `FileState`，`loading` 为 `true`
3. 加载成功： `FileState` -> `FileState`，`loading` 为 `false`，`files` 为加载的文件列表，`error` 为空
4. 加载失败： `FileState` -> `FileState`，`loading` 为 `false`，`files` 为空，`error` 为错误信息

首先我们需要定义一个 `FileState` 定义文件状态，怎么理解 `State` 呢？我们可以把 `State` 理解成一个状态机，它有一个初始状态，然后通过一系列的操作，最终会变成一个新的状态。每个状态都是一个不可变的对象，我们可以通过 `copyWith` 方法来创建一个新的状态。

封装状态的时候，是以页面为单位还是某一组件为单位呢？这个就看业务的复杂度，如果一个页面承载的状态比较多，那么我们拆分成几个组件，每个组件有自己的状态。如果一个页面承载的状态比较少，那么我们可以把状态封装在页面中。

```dart
/// 文件状态
class FileState extends Equatable {
  /// 文件列表
  final List<FileDto> files;

  /// 是否正在加载文件列表
  final bool loading;

  /// 是否正在上传文件
  final bool uploading;

  /// 错误信息
  final String error;

  /// 是否处于编辑模式
  final bool editable;

  /// 选中的文件
  final List<String> selectedKeys;

  const FileState({
    this.files = const [],
    this.uploading = false,
    this.loading = false,
    this.error = '',
    this.editable = false,
    this.selectedKeys = const [],
  });

  @override
  List<Object?> get props =>
      [files, uploading, loading, error, editable, selectedKeys];

  FileState copyWith({
    List<FileDto>? files,
    bool? uploading,
    bool? loading,
    String? error,
    bool? editable,
    List<String>? selectedKeys,
  }) {
    return FileState(
      files: files ?? this.files,
      uploading: uploading ?? this.uploading,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      editable: editable ?? this.editable,
      selectedKeys: selectedKeys ?? this.selectedKeys,
    );
  }
}
```

然后我们需要定义一个 `FileEvent` 来管理图片浏览对话框的事件，`Event` 是用来通知 `Bloc` 做出相应的操作的，比如加载文件列表、上传文件、删除文件等。

通常来说，如果你在界面上的某个操作，如果它会导致状态的改变，那么这个操作就是一个 `Event`。

```dart
abstract class FileEvent extends Equatable {}

/// 加载文件列表
class FileEventLoad extends FileEvent {
  FileEventLoad() : super();

  @override
  List<Object?> get props => [];
}

/// 上传文件
class FileEventUpload extends FileEvent {
  FileEventUpload(this.file) : super();
  final UploadFile file;

  @override
  List<Object?> get props => [file];
}

/// 上传多个文件
class FileEventUploadMultiple extends FileEvent {
  FileEventUploadMultiple(this.files) : super();
  final List<UploadFile> files;

  @override
  List<Object?> get props => [files];
}

/// 删除文件
class FileEventDelete extends FileEvent {
  FileEventDelete() : super();

  @override
  List<Object?> get props => [];
}

/// 切换编辑模式
class FileEventToggleEditable extends FileEvent {
  FileEventToggleEditable() : super();

  @override
  List<Object?> get props => [];
}

/// 切换选中状态
class FileEventToggleSelected extends FileEvent {
  FileEventToggleSelected(this.key) : super();
  final String key;

  @override
  List<Object?> get props => [key];
}
```

最后我们需要定义一个 `FileBloc` 来进行状态管理，在这里面，我们监听 `Event`，然后根据 `Event` 来触发状态的变化。

我们使用 `on` 方法来监听 `Event`，然后根据 `Event` 来触发状态的变化。 `on` 方法的第一个参数是 `Event`，第二个参数是一个回调函数，它接收两个参数，第一个参数是 `Event`，第二个参数是一个 `Emitter`，它可以用来触发状态的变化。

```dart
/// 处理文件上传、删除、加载等事件
class FileBloc extends Bloc<FileEvent, FileState> {
  final FileUploadRepository fileRepo;
  final FileAdminRepository fileAdminRepo;

  FileBloc({
    required this.fileRepo,
    required this.fileAdminRepo,
  }) : super(const FileState()) {
    /// 监听事件
    on<FileEventUpload>(_onFileEventUpload);
    on<FileEventUploadMultiple>(_onFileEventUploadMultiple);
    on<FileEventLoad>(_onFileEventLoad);
    on<FileEventDelete>(_onFileEventDelete);
    on<FileEventToggleEditable>(_onFileEventToggleEditable);
    on<FileEventToggleSelected>(_onFileEventToggleSelected);
  }

  /// 选择文件
  void _onFileEventToggleSelected(
      FileEventToggleSelected event, Emitter<FileState> emit) {
    if (state.selectedKeys.contains(event.key)) {
      emit(state.copyWith(
          selectedKeys:
              state.selectedKeys.where((e) => e != event.key).toList()));
    } else {
      emit(state.copyWith(selectedKeys: [...state.selectedKeys, event.key]));
    }
  }

  /// 切换编辑模式
  void _onFileEventToggleEditable(
      FileEventToggleEditable event, Emitter<FileState> emit) {
    emit(state.copyWith(editable: !state.editable));
  }

  /// 删除文件
  void _onFileEventDelete(
      FileEventDelete event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await fileAdminRepo.deleteFiles(state.selectedKeys);
      emit(state.copyWith(
        files: state.files
            .where((e) => !state.selectedKeys.contains(e.key))
            .toList(),
        selectedKeys: [],
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  /// 加载文件
  void _onFileEventLoad(FileEventLoad event, Emitter<FileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final files = await fileAdminRepo.getFiles();
      emit(state.copyWith(files: files));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  /// 上传多个文件
  void _onFileEventUploadMultiple(
      FileEventUploadMultiple event, Emitter<FileState> emit) async {
    emit(state.copyWith(uploading: true));
    try {
      final files = await fileRepo.uploadFiles(event.files);
      emit(state.copyWith(files: [
        ...files,
        ...state.files,
      ]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(uploading: false));
    }
  }

  /// 上传单个文件
  void _onFileEventUpload(
      FileEventUpload event, Emitter<FileState> emit) async {
    emit(state.copyWith(uploading: true));
    try {
      final file = await fileRepo.uploadFile(event.file);
      emit(state.copyWith(files: [...state.files, file]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(uploading: false));
    }
  }
}
```

可以把状态的变化想象成一个管道，每次有新的状态变化，就会通过这个管道， `emit` 方法用来发射一个新的状态到这个管道。

#### 5.9.4.3 使用 flutter_bloc

那么我们已经定义了 `State` , `Event` 和 `Bloc` ，这几者之间的关系，简单来说，每个 `Event` 触发 `Bloc` 进行一些业务逻辑处理，然后向流中发射一个新的 `State`。

典型的一个 `flutter_bloc` 的使用流程是这样的：

1. 定义一个 `Bloc`，它负责管理状态
2. 定义一个 `BlocBuilder`，它负责构建 UI
3. 在 `BlocBuilder` 中使用 `Bloc` 的 `Stream` 来获取状态

```dart
class ImageExplorer extends StatelessWidget {
  const ImageExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    /// 注册 Repository 到容器
    /// MultiRepositoryProvider 支持多个 Repository
    return MultiRepositoryProvider(
      providers: _buildRepositoryProviders,
      /// 注册 Bloc 到容
      /// MultiBlocProvider 支持多个 Bloc
      child: MultiBlocProvider(
        providers: _buildBlocProviders,
        /// 使用 BlocBuilder 来构建 UI
        /// BlocBuilder 会监听 Bloc 的状态变化，然后根据状态变化来构建 UI
        child: BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            /// 这里 state 就是 FileState
            /// 由于每个新的状态都会导致这个 UI 重新构建
            /// 所以下面需要根据不同的状态来构建不同的 UI
            if (state.loading) {
              return const CircularProgressIndicator().center();
            }

            if (state.error.isNotEmpty) {
              return Text(state.error).center();
            }

            if (state.files.isEmpty) {
              return const Text('没有图片资源').center();
            }

            /// 由于在异步操作中，往往上下文会发生变化，所以需要在这里先把 bloc 拿出来
            /// 在下面的回调中使用，这样就不用关心上下文是否发生变化，如果每次都使用 context.read<FileBloc>()
            /// 那么在异步操作中，就会报错
            final bloc = context.read<FileBloc>();
            final images = state.files;
            final title = FileDialogTitle(
              editable: state.editable,
              selectedKeys: state.selectedKeys,
              /// 切换编辑模式的时候
              /// 会触发 FileEventToggleEditable 事件
              /// 我们可以通过 bloc.add 来发射这个事件
              onEditableChanged: (value) => bloc.add(FileEventToggleEditable()),
              /// 删除图片的时候发送 FileEventDelete 事件
              onDelete: () => bloc.add(FileEventDelete()),
              onUpload: () => _uploadImages(bloc),
            );
            final content = FileDialogContent(
              images: images,
              editable: state.editable,
              selectedKeys: state.selectedKeys,
              /// 选择图片的时候发送 FileEventToggleSelected 事件
              onSelected: (key) => bloc.add(FileEventToggleSelected(key)),
            );
            final actions = [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
            ];
            return AlertDialog(
              title: title,
              content: content,
              actions: actions,
            );
          },
        ),
      ),
    );
  }

  Future<void> _uploadImages(FileBloc bloc) async {
    final picker = ImagePicker();
    /// 跳出选择图片的对话框，等待用户选择图片
    final pickedImages = await picker.pickMultiImage();

    final List<UploadFile> images = [];
    for (var image in pickedImages) {
      final bytes = await image.readAsBytes();
      images.add(UploadFile(
        name: image.name,
        file: bytes,
      ));
    }

    if (images.isNotEmpty) {
      bloc.add(FileEventUploadMultiple(images));
    }
  }

  List<SingleChildWidget> get _buildBlocProviders {
    return [
      BlocProvider<FileBloc>(
        create: (context) => FileBloc(
          fileRepo: context.read<FileUploadRepository>(),
          fileAdminRepo: context.read<FileAdminRepository>(),
        )..add(FileEventLoad()),
      ),
    ];
  }

  List<SingleChildWidget> get _buildRepositoryProviders {
    return [
      RepositoryProvider<FileUploadRepository>(
        create: (context) => FileUploadRepository(),
      ),
      RepositoryProvider<FileAdminRepository>(
        create: (context) => FileAdminRepository(),
      ),
    ];
  }
}
```

上面代码中，我们在 `ImageExplorer` 中使用了 `MultiBlocProvider` 和 `MultiRepositoryProvider` 来注册 `Bloc` 和 `Repository`，这样在 `ImageExplorer` 中的子组件中就可以直接使用 `context.read` 来获取 `Bloc` 和 `Repository`。

在 `ImageExplorer` 中，我们使用了 `BlocBuilder` 来构建 UI，它的作用是根据 `Bloc` 的 `Stream` 来构建 UI，当 `Bloc` 的状态发生变化时，`BlocBuilder` 会重新构建 UI。

在 `BlocBuilder` 中，我们使用了 `context.read<FileBloc>()` 来获取 `Bloc`，这样在异步操作中，就不用关心上下文是否发生变化。
