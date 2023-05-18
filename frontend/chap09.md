# 第九章：部署上线

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第九章：部署上线](#第九章部署上线)
  - [9.1 容器部署](#91-容器部署)
    - [9.1.1 准备工作：前端配置环境变量](#911-准备工作前端配置环境变量)
    - [9.1.2 打包前端部分部署到 Nginx 容器](#912-打包前端部分部署到-nginx-容器)
    - [9.1.3 准备工作：后端的环境变量](#913-准备工作后端的环境变量)
    - [9.1.4 打包后端部分部署到 Docker](#914-打包后端部分部署到-docker)
    - [9.1.5 容器编排文件](#915-容器编排文件)
  - [9.2 构建运维辅助工具](#92-构建运维辅助工具)
    - [9.2.1 数据库管理工具 adminer](#921-数据库管理工具-adminer)
    - [9.2.2 日志工具 graylog](#922-日志工具-graylog)

<!-- /code_chunk_output -->

## 9.1 容器部署

我们在课程中会使用容器（Docker）进行部署，这样可以避免环境的差异性，同时也可以避免一些安全问题。Docker 是一个开源的应用容器引擎，基于 Go 语言并遵从 Apache2.0 协议开源。Docker 可以让开发者打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。

我们的容器化部署分为几个部分：

- 前端部分：使用 Nginx 作为 Web 服务器，部署前端代码
- 后端部分：使用 Spring Boot 提供的 Fat Jar 进行部署
- 数据库部分：使用 MySQL 作为数据库，使用 Docker 镜像进行部署
- 缓存部分：使用 Redis 作为缓存，使用 Docker 镜像进行部署
- 运维部分：我们提供 `Adminer` 作为数据库管理工具，提供 `redis-insight` 作为 Redis 管理工具

### 9.1.1 准备工作：前端配置环境变量

我们在前端部分的网络访问我们直接使用了 `localhost`，这在测试或者正式发布的时候是不可行的，所以我们需要在前端部分配置环境变量，这样我们就可以在不同的环境中使用不同的配置。

所以我们在 `networking/lib` 目录下新建一个 `constants.dart` 文件，内容如下：

```dart
/// Environment variables and shared app constants.
abstract class Constants {
  static const String lowcodeBaseUrl = String.fromEnvironment(
    'LOWCODE_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );
}
```

在 dart 中我们可以使用 `String.fromEnvironment` 来获取环境变量，如果没有设置环境变量，我们可以使用 `defaultValue` 来设置默认值。

然后我们改造 `admin_client.dart` 文件，内容如下：

```dart
class AdminClient with DioMixin implements Dio {
  // ... 其他代码

  /// 私有构造函数，禁止外部创建实例
  AdminClient._() {
    /// 配置参数
    options = BaseOptions(
      /// 后台管理接口的基础 URL
      baseUrl: '${Constants.lowcodeBaseUrl}/admin',

      /// 添加 Content-Type 和 Accept 头
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );

    // ... 其他配置
  }
}
```

我们在 `options` 中使用了 `Constants.lowcodeBaseUrl`，这样我们就可以在不同的环境中使用不同的配置了。

类似的，`file_client.dart` 和 `app_client.dart` 也需要做同样的改造。大家可以作为练习来完成。

### 9.1.2 打包前端部分部署到 Nginx 容器

基于 flutter 的 web 应用，我们在 `frontend/admin` 目录下使用下面的命令进行打包：

```bash
flutter build web --dart-define=LOWCODE_BASE_URL=/api/v1
```

注意我们使用了 `--dart-define` 参数来设置环境变量，这样我们就可以在打包的时候设置环境变量了。在正式环境中我们希望服务器 API 和前端在同一个域名下，所以我们使用了 `/api/v1` 作为 API 的前缀。

打包完成后，会在 `build/web` 目录下生成打包后的文件，就是我们需要部署的文件。你看到的文件可能是下面这样的：

```bash
frontend/admin/build/web
├── assets
│   ├── AssetManifest.bin
│   ├── AssetManifest.json
│   ├── FontManifest.json
│   ├── NOTICES
│   ├── assets
│   │   ├── fonts
│   │   │   └── Roboto
│   │   │       ├── Roboto-Bold.ttf
│   │   │       ├── Roboto-Medium.ttf
│   │   │       └── Roboto-Regular.ttf
│   │   └── images
│   │       ├── error_150_150.png
│   │       ├── error_400_120.png
│   │       ├── iphone.png
│   │       └── logo.png
│   ├── fonts
│   │   └── MaterialIcons-Regular.otf
│   ├── packages
│   │   ├── cupertino_icons
│   │   │   └── assets
│   │   │       └── CupertinoIcons.ttf
│   │   └── flex_color_picker
│   │       └── assets
│   │           └── opacity.png
│   └── shaders
│       └── ink_sparkle.frag
├── canvaskit
│   ├── canvaskit.js
│   ├── canvaskit.wasm
│   ├── chromium
│   │   ├── canvaskit.js
│   │   └── canvaskit.wasm
│   ├── skwasm.js
│   ├── skwasm.wasm
│   └── skwasm.worker.js
├── favicon.png
├── flutter.js
├── flutter_service_worker.js
├── icons
│   ├── Icon-192.png
│   ├── Icon-512.png
│   ├── Icon-maskable-192.png
│   └── Icon-maskable-512.png
├── index.html
├── main.dart.js
├── manifest.json
└── version.json
```

所以我们在 `admin` 下面可以新建一个 `Dockerfile` 文件，内容如下：

```dockerfile
FROM nginx:1.23-alpine
COPY ./build/web /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

这个 `Dockerfile` 文件的内容比较简单，我们使用了 `nginx:1.23-alpine` 作为基础镜像，然后将打包后的文件拷贝到 `/usr/share/nginx/html` 目录下，最后将 `nginx.conf` 文件拷贝到 `/etc/nginx/nginx.conf` 目录下，这样我们就可以使用自定义的 `nginx.conf` 文件了。

这个 `nginx.conf` 文件是我们自己定义的，内容如下：

```nginx
worker_processes 1;

events { worker_connections 1024; }

http {
  include                 mime.types;
  default_type            application/octet-stream;
  sendfile                on;
  keepalive_timeout       65;
  ## 配置 GZip 压缩
  gzip                    on;
  gzip_comp_level         6;
  gzip_vary               on;
  ## 只有大于此长度的进行压缩
  gzip_min_length         1000;
  gzip_proxied            any;
  ## 支持压缩的资源格式
  gzip_types              text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;
  gzip_buffers            32 8k;
  ## 设置 Web API 服务器
  upstream api_server {
    server backend:8080;
  }

  # 需要在 server 区块之外定义
  log_format upstreamlog '[$time_local] $remote_addr - $remote_user - $server_name $host to: $upstream_addr: $request $status upstream_response_time $upstream_response_time msec $msec request_time $request_time';

  server {
    listen       80;
    server_name  localhost;
    charset utf-8;
    ## 反向代理，前端访问 /api/* 的请求
    ## 会被转发到 api_server
    ## 上面定义的 xx.xx.xx.xx:8080
    ## 这样我们就避免了跨域问题
    location ~ ^/api/(.*)$ {
      access_log /var/log/nginx/access.log upstreamlog;
      proxy_pass http://api_server/api/$1;
      proxy_redirect     off;
      proxy_set_header   Host $host;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Host $server_name;
    }

    location / {
      root   /usr/share/nginx/html;
      index  index.html;
      expires -1;
      add_header Pragma "no-cache";
      add_header Cache-Control "no-store, no-cache, must-revalidate, post-check=0, pre-check=0";
      ## 重定向 404 到 index.html
      ## 这个设置对于前端应用可以支持浏览器刷新非常重要
      try_files $uri$args $uri$args/ $uri $uri/ /index.html =404;
    }
  }
}
```

我们在这个 `nginx.conf` 文件中，主要是配置了反向代理，将 `/api/*` 的请求转发到后端服务器，这样我们就可以避免跨域问题。

由于前端有路由，但其实真实的页面只有一个 `index.html`，所以我们需要在 `nginx.conf` 中配置 `try_files`，将所有的 404 请求都转发到 `index.html`，这样就可以支持浏览器刷新了。

然后我们可以使用下面的命令进行构建：

```bash
docker build -t frontend:latest .
```

`docker build` 命令会根据 `Dockerfile` 文件进行构建，`-t` 参数指定了构建后的镜像名称，`.` 表示当前目录。 `frontend:latest` 表示构建后的镜像名称为 `frontend`，标签为 `latest`。可以指定多个标签，例如

```bash
docker build -t frontend:latest -t frontend:1.0.0 .
```

### 9.1.3 准备工作：后端的环境变量

之前在 `application-prod.properties` 中定义的数据库连接是写死的，同样的我们需要将其改为环境变量，这样我们就可以在 Docker 启动时进行配置。

```properties
# 数据源设置
spring.datasource.url=jdbc:mysql://${MYSQL_HOST:localhost}:3306/low_code?useUnicode=true&characterEncoding=utf-8&useSSL=false&allowPublicKeyRetrieval=true
```

这里我们使用了 `${MYSQL_HOST:localhost}` 的形式，表示如果没有设置 `MYSQL_HOST` 环境变量，就使用 `localhost` 作为默认值。

### 9.1.4 打包后端部分部署到 Docker

我们在 `backend` 目录下新建一个 `Dockerfile` 文件，内容如下：

```dockerfile
FROM openjdk:17
COPY build/libs/*.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

我们先使用 gradle 编译：

```bash
./gradlew clean build
```

然后你应该可以看到 `build` 目录下有如下类似的结构：

```bash
backend/build
├── classes
│   └── java
│       └── main
│           ├── META-INF
│           │   └── spring-configuration-metadata.json
│           └── com
│               └── mooc
│                   └── backend
│                       ├── BackendApplication.class
│                       ├── advices
│                       │   └── StreamingResponseBodyHandler.class
│                       ├── config
│                       │   ├── AuditConfig.class
│                       │   ├── CacheConfig.class
│                       │   ├── JacksonConfig.class
│                       │   ├── PageProperties.class
│                       │   ├── QiNiuConfig.class
│                       │   ├── QiNiuProperties.class
│                       │   ├── RedissonConfig.class
│                       │   ├── SchedulingConfig.class
│                       │   ├── SwaggerConfig.class
│                       │   ├── WebMvcConfig.class
│                       │   └── converters
│                       │       ├── BlockTypeConverter.class
│                       │       ├── LinkTypeConverter.class
│                       │       └── PageTypeConverter.class
│                       ├── dtos
│                       │   ├── CategoryDTO$CategoryDTOBuilder.class
│                       │   ├── CategoryDTO.class
│                       │   ├── CategoryRecord.class
│                       │   ├── CreateOrUpdateCategoryDTO.class
│                       │   ├── CreateOrUpdatePageBlockDTO.class
│                       │   ├── CreateOrUpdatePageBlockDataDTO.class
│                       │   ├── CreateOrUpdatePageDTO.class
│                       │   ├── CreateOrUpdateProductDTO.class
│                       │   ├── FileDTO.class
│                       │   ├── PageDTO$PageDTOBuilder.class
│                       │   ├── PageDTO.class
│                       │   ├── PageWrapper.class
│                       │   ├── ProductAdminDTO.class
│                       │   ├── ProductDTO$ProductDTOBuilder.class
│                       │   ├── ProductDTO.class
│                       │   ├── PublishPageDTO.class
│                       │   └── SliceWrapper.class
│                       ├── entities
│                       │   ├── Auditable.class
│                       │   ├── Category$CategoryBuilder.class
│                       │   ├── Category.class
│                       │   ├── PageBlock$PageBlockBuilder.class
│                       │   ├── PageBlock.class
│                       │   ├── PageBlockData$PageBlockDataBuilder.class
│                       │   ├── PageBlockData.class
│                       │   ├── PageLayout$PageLayoutBuilder.class
│                       │   ├── PageLayout.class
│                       │   ├── Product$ProductBuilder.class
│                       │   ├── Product.class
│                       │   ├── ProductImage$ProductImageBuilder.class
│                       │   ├── ProductImage.class
│                       │   └── blocks
│                       │       ├── BlockConfig$BlockConfigBuilder.class
│                       │       ├── BlockConfig.class
│                       │       ├── BlockData.class
│                       │       ├── ImageDTO.class
│                       │       ├── Link$LinkBuilder.class
│                       │       ├── Link.class
│                       │       ├── PageConfig$PageConfigBuilder.class
│                       │       ├── PageConfig.class
│                       │       └── ProductDataDTO.class
│                       ├── enumerations
│                       │   ├── BlockDataType.class
│                       │   ├── BlockType.class
│                       │   ├── CategoryRepresentation.class
│                       │   ├── Errors.class
│                       │   ├── LinkType.class
│                       │   ├── PageStatus.class
│                       │   ├── PageType.class
│                       │   └── Platform.class
│                       ├── error
│                       │   ├── CustomException.class
│                       │   └── GlobalExceptionHandler.class
│                       ├── json
│                       │   ├── BigDecimalSerializer.class
│                       │   ├── BlockDataDeserializer.class
│                       │   └── MathUtils.class
│                       ├── projections
│                       │   └── PageLayoutInfo.class
│                       ├── repositories
│                       │   ├── CategoryRepository.class
│                       │   ├── CustomProductRepository.class
│                       │   ├── CustomProductRepositoryImpl.class
│                       │   ├── PageBlockDataRepository.class
│                       │   ├── PageBlockRepository.class
│                       │   ├── PageLayoutRepository.class
│                       │   ├── ProductImageRepository.class
│                       │   └── ProductRepository.class
│                       ├── rest
│                       │   ├── admin
│                       │   │   ├── CategoryAdminController.class
│                       │   │   ├── FileController.class
│                       │   │   ├── PageAdminController.class
│                       │   │   └── ProductAdminController.class
│                       │   └── app
│                       │       ├── ImageController.class
│                       │       ├── PageController.class
│                       │       └── ProductController.class
│                       ├── schedules
│                       │   └── ScheduledTasks.class
│                       ├── services
│                       │   ├── CategoryAdminService.class
│                       │   ├── CategoryQueryService.class
│                       │   ├── PageCreateService.class
│                       │   ├── PageDeleteService.class
│                       │   ├── PageQueryService.class
│                       │   ├── PageUpdateService.class
│                       │   ├── ProductAdminService.class
│                       │   ├── ProductQueryService.class
│                       │   └── QiniuService.class
│                       ├── specifications
│                       │   ├── CategorySpecification.class
│                       │   ├── CategorySpecs.class
│                       │   ├── PageFilter.class
│                       │   └── PageSpecs.class
│                       └── validators
│                           ├── DateRangeValidator.class
│                           └── ValidateDateRange.class
├── generated
│   └── sources
│       ├── annotationProcessor
│       │   └── java
│       │       └── main
│       └── headers
│           └── java
│               └── main
├── libs
│   └── backend-1.0.0.jar
├── resolvedMainClassName
├── resources
│   └── main
│       ├── application-dev.properties
│       ├── application-prod.properties
│       ├── application.properties
│       ├── db
│       │   └── migration
│       │       ├── h2
│       │       │   ├── V1.0__schema.sql
│       │       │   ├── V1.1__initial_data.sql
│       │       │   ├── V1.2__add_title_column_to_pages.sql
│       │       │   ├── V1.3__add_start_time_and_end_time_columns_to_pages.sql
│       │       │   ├── V1.4__add_status_column_to_pages.sql
│       │       │   ├── V1.5__add_page_block_data.sql
│       │       │   ├── V1.6__add_sku_column_to_product.sql
│       │       │   └── V1.7__add_original_price_to_product.sql
│       │       └── mysql
│       │           ├── V1.0__schema.sql
│       │           ├── V1.1__initial_data.sql
│       │           ├── V1.2__add_title_column_to_pages.sql
│       │           ├── V1.3__add_start_time_and_end_time_columns_to_pages.sql
│       │           ├── V1.4__add_status_column_to_pages.sql
│       │           ├── V1.5__add_sku_column_to_product.sql
│       │           └── V1.6__add_original_price_to_product.sql
│       ├── logback-spring.xml
│       ├── messages.properties
│       ├── messages_en.properties
│       ├── messages_zh.properties
│       ├── redisson.yml
│       ├── static
│       └── templates
└── tmp
    ├── bootJar
    │   └── MANIFEST.MF
    └── compileJava
        └── previous-compilation-data.bin
```

其中 `build/lib` 目录下的 `backend-1.0.0.jar` 就是我们需要的可执行 jar 包。在上面的 `Dockerfile` 中，我们使用了 `COPY` 命令将 jar 包复制到了容器中。然后我们使用 `ENTRYPOINT` 命令指定了 jar 包的启动命令。

之后我们可以使用下面的命令进行构建：

```bash
docker build -t backend:latest .
```

### 9.1.5 容器编排文件

我们这个课程有前端和后端，后端还有数据库的依赖，分别使用容器启动比较麻烦。我们可以使用 `docker-compose` 进行容器编排。在课程根目录下创建 `docker-compose.yml` 文件：

```yaml
version: "3.7"

services:
  mysql:
    image: mysql:8
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: low_code
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    restart: always
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 1s
      timeout: 3s
      retries: 20
      start_period: 5s

  backend:
    image: low_code_api
    build:
      context: backend
      dockerfile: Dockerfile
      tags:
        - "low_code_api:1"
        - "low_code_api:1.0"
        - "low_code_api:1.0.0"
        - "low_code_api:latest"
    container_name: backend
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - MYSQL_HOST=mysql
    ports:
      - 8080:8080
    depends_on:
      - mysql

  frontend:
    build:
      context: ./frontend/admin
      dockerfile: Dockerfile
      tags:
        - "low_code_admin:1"
        - "low_code_admin:1.0"
        - "low_code_admin:1.0.0"
        - "low_code_admin:latest"
    container_name: frontend
    ports:
      - 80:80
    depends_on:
      - backend

volumes:
  mysql_data:
    driver: local
```

在上面的 `docker-compose.yml` 文件中，我们定义了三个服务，分别是 `mysql`、`backend` 和 `frontend`。

其中 `mysql` 服务使用了 `mysql:8` 镜像，我们指定了 `root` 用户的密码，以及默认数据库的名称、用户和密码。我们还指定了容器的端口映射，将容器的 `3306` 端口映射到主机的 `3306` 端口。我们还指定了容器的数据卷，将容器的 `/var/lib/mysql` 目录映射到主机的 `mysql_data` 卷中。最后我们还指定了容器的健康检查，每隔 1 秒钟检查一次，超时时间为 3 秒钟，重试 20 次，每次重试间隔 5 秒钟。

`backend` 服务使用了我们刚刚构建的 `low_code_api` 镜像，我们指定了容器的环境变量，包括 `SPRING_PROFILES_ACTIVE`、`MYSQL_HOST` ，其中 `SPRING_PROFILES_ACTIVE` 指定了 Spring Boot 的配置文件，`MYSQL_HOST` 指定了数据库主机的地址。我们还指定了容器的端口映射，将容器的 `8080` 端口映射到主机的 `8080` 端口。最后我们还指定了容器的依赖，`backend` 服务依赖于 `mysql` 服务。

`frontend` 服务使用了我们刚刚构建的 `low_code_admin` 镜像，我们指定了容器的端口映射，将容器的 `80` 端口映射到主机的 `80` 端口。最后我们还指定了容器的依赖，`frontend` 服务依赖于 `backend` 服务。

我们可以使用下面的命令启动这些容器：

```bash
docker compose up -d
```

启动完成后，我们可以使用下面的命令查看容器的运行状态：

```bash
docker compose ps
```

你可以看到以下输出：

```bash
❯ docker compose ps
NAME                IMAGE                                                      COMMAND                  SERVICE             CREATED             STATUS                            PORTS
backend             low_code_api                                               "java -jar /app.jar"     backend             9 seconds ago       Up 7 seconds (healthy)            0.0.0.0:8080->8080/tcp, :::8080->8080/tcp
frontend            low_code-frontend                                          "/docker-entrypoint.…"   frontend            9 seconds ago       Up 6 seconds (healthy)            0.0.0.0:80->80/tcp, :::80->80/tcp
mysql               mysql:8                                                    "docker-entrypoint.s…"   mysql               9 seconds ago       Up 8 seconds (healthy)            0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp
```

这里需要说明一下端口映射，在 `docker-compose.yml` 中的每个服务都有一个 `ports` 属性，这个属性的格式为 `主机端口:容器端口`。例如 `backend` 服务的 `ports` 属性为 `8080:8080`，这就表示将主机的 `8080` 端口映射到容器的 `8080` 端口。这样我们就可以通过 `http://localhost:8080` 访问 `backend` 服务了。主机端口可以指定为主机上可用的任意端口，例如 `8080`、`80`、`8000` 等等。但是容器端口必须是容器中正在监听的端口，否则容器无法接收到请求。

另外对于数据库，我们使用了卷映射，将容器的 `/var/lib/mysql` 目录映射到主机的 `mysql_data` 卷中。这样我们就可以在容器重启后，数据不会丢失。这个主机的卷是在 `docker-compose.yml` 文件中的 `volumes` 属性中定义的，这个属性的格式为 `卷名称:卷配置`。例如 `mysql_data` 卷的配置为：

```yaml
volumes:
  mysql_data:
    driver: local
```

但这个卷的实际位置在哪里呢？我们可以使用下面的命令查看：

```bash
docker volume ls
```

你可以看到这个卷的实际名字 `low_code_mysql_data`：

```bash
❯ docker volume ls
DRIVER    VOLUME NAME
local     low_code_mysql_data
```

但可能有的时候，我们希望指定这个卷的存放位置，这时我们可以在 `docker-compose.yml` 中的 `volumes` 属性中指定 `driver_opts` 属性，例如：

```yaml
volumes:
  mysql_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/low_code/mysql_data
```

这里我们指定了 `type` 为 `none`，表示这个卷的类型为 `none`，`o` 为 `bind`，表示这个卷的挂载方式为 `bind`，`device` 为 `/home/low_code/mysql_data`，表示这个卷的实际位置为 `/home/low_code/mysql_data`。这样我们就可以将容器的 `/var/lib/mysql` 目录挂载到 `/home/low_code/mysql_data` 目录了。

当然在我们课程中就不特别指定了，如果你有需要，可以自行修改。

关闭容器可以使用下面的命令：

```bash
docker compose down
```

后续如果我们修改了 `Dockerfile` ，我们也可以通过 `docker compose` 命令来重新构建镜像，例如：

```bash
docker compose build
```

## 9.2 构建运维辅助工具

### 9.2.1 数据库管理工具 adminer

我们的容器中有数据库，一般来说我们需要一个图形化界面来管理数据库，这里我们使用 `adminer` 来管理数据库。`adminer` 是一个开源的数据库管理工具，支持多种数据库，包括 `MySQL`、`PostgreSQL`、`SQLite`、`Oracle`、`SimpleDB`、`Elasticsearch`、`MongoDB`、`CockroachDB`、`ClickHouse`、`Redis`、`Memcached`、`Firebird`、`HSQLDB`、`H2`、`Vertica`、`Cassandra`、`SQLite`、`MSSQL`、`Sybase`、`DB2`、`Teradata`、`Informix` 等等。

我们可以在 `docker-compose.yml` 中添加一个 `adminer` 服务：

```yaml
version: "3.7"

services:
  # ... 省略其他服务
  adminer:
    image: adminer:4
    container_name: adminer
    restart: always
    ports:
      - "8081:8080" # host:container
    environment:
      ADMINER_DEFAULT_SERVER: mysql
    depends_on:
      - mysql
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8081"]
      interval: 1s
      timeout: 3s
      retries: 20

volumes:
  mysql_data:
    driver: local
```

这里我们指定了 `adminer` 服务使用的镜像为 `adminer:4`，这个镜像是 `adminer` 的 `4` 版本。我们指定了容器的端口映射，将容器的 `8080` 端口映射到主机的 `8081` 端口。我们指定了容器的依赖，`adminer` 服务依赖于 `mysql` 服务。最后我们还指定了容器的健康检查，这里我们使用了 `curl` 命令来检查容器是否健康。

我们可以打开浏览器，访问 `http://localhost:8081`，你可以看到 `adminer` 的登录界面：

![图 1](http://ngassets.twigcodes.com/e99dc461091e5485c3fe028cbdb933e64bbe2c0d72b140ee8de5266db2ef5e5c.png)

然后数据库填写 `low_code`，用户名填写 `user`，密码填写 `password`，点击登录，你就可以看到数据库的管理界面了：

![图 2](http://ngassets.twigcodes.com/b85e6d36457a9d3a9d0237579919397229e2edaaef114357506df112e87a9f2b.png)

通过这个工具，我们可以方便的管理数据库。

### 9.2.2 日志工具 graylog

我们的容器中有日志，一般来说我们需要一个图形化界面来管理日志，这里我们使用 `graylog` 来管理日志。`graylog` 是一个开源的日志管理工具，支持多种日志。

我们可以在 `docker-compose.yml` 中添加一个 `graylog` 服务：

```yaml
version: "3.7"

services:
  # ... 省略其他服务
  mongo:
    image: mongo:5
    container_name: mongo

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2
    container_name: elasticsearch
    environment:
      - http.host=0.0.0.0
      - transport.host=localhost
      - network.host=0.0.0.0
      - "ES_JAVA_OPTS=-Dlog4j2.formatMsgNoLookups=true -Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    deploy:
      resources:
        limits:
          memory: 1g

  graylog:
    image: graylog/graylog:5.0
    container_name: graylog
    environment:
      - GRAYLOG_PASSWORD_SECRET=somepasswordpepper
      - GRAYLOG_ROOT_PASSWORD_SHA2=8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
      - GRAYLOG_HTTP_EXTERNAL_URI=http://localhost:9000/
    ports:
      - "9000:9000"
      - "12201:12201/udp"
      - "1514:1514"
      - "1514:1514/udp"
    restart: always
    depends_on:
      - mongo
      - elasticsearch
```

注意 `graylog` 会依赖 MongoDB 和 Elasticsearch，所以我们需要先启动这两个服务。

要让 `backend` 服务将日志发送到 `graylog`，我们需要在 `resources` 目录下创建一个 `logback-spring.xml` 文件，内容如下：

```xml
<configuration>

    <property name="port" value="12201" />
    <property name="host" value="127.0.0.1" />

    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%green(%date) %highlight(%-5level) %yellow([%file:%line]) %blue(: %msg%n)</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>

    <appender name="GELF" class="de.siegmar.logbackgelf.GelfUdpAppender">
        <graylogHost>${host}</graylogHost>
        <graylogPort>${port}</graylogPort>
        <maxChunkSize>508</maxChunkSize>
        <useCompression>true</useCompression>
        <encoder class="de.siegmar.logbackgelf.GelfEncoder">
            <originHost>${host}</originHost>
            <includeRawMessage>false</includeRawMessage>
            <includeMarker>true</includeMarker>
            <includeMdcData>true</includeMdcData>
            <includeCallerData>true</includeCallerData>
            <includeRootCauseData>true</includeRootCauseData>
            <includeLevelName>true</includeLevelName>
            <shortPatternLayout class="ch.qos.logback.classic.PatternLayout">
                <pattern>%m%nopex</pattern>
            </shortPatternLayout>
            <fullPatternLayout class="ch.qos.logback.classic.PatternLayout">
                <pattern>%m%n</pattern>
            </fullPatternLayout>
            <staticField>app_name:graylog-spring</staticField>
        </encoder>
    </appender>

    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>

    <logger name="com.dagli.graylog" additivity="false">
        <level value="DEBUG"/>
        <appender-ref ref="GELF" />
        <appender-ref ref="STDOUT"/>
    </logger>

</configuration>
```

然后在 `build.gradle` 中添加依赖：

```groovy
// 项目依赖版本号定义
ext {
    // ... 省略其他依赖版本号
    logbackGelfVersion = '4.0.+'
}
dependencies {
    // ... 省略其他依赖
    implementation "de.siegmar:logback-gelf:${logbackGelfVersion}"
}
```

然后在 `docker-compose.yml` 中给 `backend` 服务添加 `logging` 配置：

```yaml
version: "3.7"

services:
  # ... 省略其他服务
  backend:
    # ... 省略其他配置
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
        tag: "low_code_api"
```

需要指出的是 `logging` 中的 `gelf-address` 需要是主机地址，而不是容器的机器名或地址。

然后我们就可以启动 `graylog` 服务了：

```bash
docker-compose up -d
```

打开浏览器，访问 <http://localhost:9000> ，输入用户名 `admin` 和密码 `admin` 登录。

![图 3](http://ngassets.twigcodes.com/98a8a32d0b2771a778fcaa4a2b248cea312aa945a185ee031e4eef79a12ce572.png)

选择 `System` -> `Inputs` 菜单添加一个 `GELF UDP` 输入：

![图 4](http://ngassets.twigcodes.com/8176553f0afa98d747f6f6446f8e3af8755353e09d3e0d2f814c3f7acf4723e3.png)

点击 `Launch new input` 按钮，输入 `Title`

![图 5](http://ngassets.twigcodes.com/b5cfeeb50529499db869e973c3ec822a71467393f6ad65cd82f26da05196a631.png)

点击 `Launch Input` 按钮：

![图 6](http://ngassets.twigcodes.com/a7194bdec7516e5bf0cb82a1f0e2cd1d99f439b86dd3c8ffd456272ec435589a.png)

然后可以看到下面的界面

![图 7](http://ngassets.twigcodes.com/77336ce6f20da09aa50bb2fb36f3586499ec8285ed5558d7cc3a866cd2707879.png)

点击右侧 `Show received messages` 按钮，可以看到 `backend` 服务发送的日志：

![图 8](http://ngassets.twigcodes.com/80dbff191be3bd2b7be769d9ea846f764719be330f1f792e9b79a3b521dbe881.png)

在线上系统的调试中，日志是一个必不可少的分析手段，利用这个工具可以方便的搜索日志。
