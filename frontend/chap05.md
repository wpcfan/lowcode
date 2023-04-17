# 第五章：App 接口 - 用 Spring Boot 3.x 构建 API

在我们在 API 角度实现需求之前，我们需要对一些基础知识做些了解。所以，我们在这一章中，会首先给大家介绍 API 和 HTTP 的基础知识，然后我们会通过实现设计一个图片生成的 API 来让大家了解如何使用 Spring Boot 来开发 RESTful API，包括 API 的参数校验、异常处理、交互式文档等。

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第五章：App 接口 - 用 Spring Boot 3.x 构建 API](#第五章app-接口---用-spring-boot-3x-构建-api)
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
