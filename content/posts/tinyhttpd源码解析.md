---
title: Tinyhttpd源码解析
subtitle:
date: 2024-06-18T04:58:45Z
slug: 913f95d
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - 网络编程
  - http服务器
  - tinyhttpd
categories:
  - 网络编程
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
summary:
resources:
  - name: featured-image
    src: featured-image.jpg
  - name: featured-image-preview
    src: featured-image-preview.jpg
toc: true
math: true
lightgallery: true
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

# HTTP

## HTTP请求头

当然，下面是一个带有 `\r\n` 行结尾的 HTTP 请求头示例：

```
GET /index.html HTTP/1.1\r\n
Host: www.example.com\r\n
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36\r\n
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n
Accept-Language: en-US,en;q=0.5\r\n
Accept-Encoding: gzip, deflate\r\n
Connection: keep-alive\r\n
Upgrade-Insecure-Requests: 1\r\n
\r\n
```

### 解释

- 每一行都是一个 HTTP 头字段，使用 `\r\n`（回车符和换行符）来表示行结束。
- 最后一行的 `\r\n` 表示头部结束，之后的内容（如果有）是请求的主体。

### 分解示例

1. **请求行**:
   ```
   GET /index.html HTTP/1.1\r\n
   ```
   - `GET` 是 HTTP 方法。
   - `/index.html` 是请求的路径。
   - `HTTP/1.1` 是 HTTP 版本。

2. **头字段**:
   ```
   Host: www.example.com\r\n
   User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36\r\n
   Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n
   Accept-Language: en-US,en;q=0.5\r\n
   Accept-Encoding: gzip, deflate\r\n
   Connection: keep-alive\r\n
   Upgrade-Insecure-Requests: 1\r\n
   ```
   - `Host`: 指定请求的主机名（必须字段）。
   - `User-Agent`: 指定发出请求的客户端软件信息。
   - `Accept`: 指定客户端可接受的响应内容类型。
   - `Accept-Language`: 指定客户端可接受的响应语言。
   - `Accept-Encoding`: 指定客户端可接受的响应内容编码（如压缩）。
   - `Connection`: 指定是否保持连接。
   - `Upgrade-Insecure-Requests`: 指定客户端是否要求安全的连接升级。

3. **空行**:
   ```
   \r\n
   ```
   - 空行表示 HTTP 请求头的结束，接下来如果有数据就是请求的主体。



## HTTP响应头
当然，下面是一个包含 `\r\n` 作为行结束符的 HTTP 响应头示例：

```
HTTP/1.1 200 OK\r\n
Date: Tue, 18 Jun 2024 12:28:53 GMT\r\n
Server: jdbhttpd/0.1.0\r\n
Last-Modified: Tue, 18 Jun 2024 12:28:53 GMT\r\n
Content-Type: text/html\r\n
Content-Length: 1234\r\n
Connection: keep-alive\r\n
\r\n
```

### 解释

- 每一行都是一个 HTTP 头字段，使用 `\r\n`（回车符和换行符）来表示行结束。
- 最后一行的 `\r\n` 表示头部结束，之后的内容（如果有）是响应的主体。

### 分解示例

1. **状态行**:
   ```
   HTTP/1.1 200 OK\r\n
   ```
   - `HTTP/1.1`：HTTP 版本。
   - `200 OK`：状态码和状态描述，表示请求成功。

2. **头字段**:
   ```
   Date: Tue, 18 Jun 2024 12:28:53 GMT\r\n
   Server: jdbhttpd/0.1.0\r\n
   Last-Modified: Tue, 18 Jun 2024 12:28:53 GMT\r\n
   Content-Type: text/html\r\n
   Content-Length: 1234\r\n
   Connection: keep-alive\r\n
   ```
   - `Date`：响应的日期和时间。
   - `Server`：服务器软件的信息。
   - `Last-Modified`：响应内容的最后修改时间。
   - `Content-Type`：响应内容的类型（这里是 HTML）。
   - `Content-Length`：响应内容的长度（以字节为单位）。
   - `Connection`：控制连接的管理方式（这里是保持连接）。

3. **空行**:
   ```
   \r\n
   ```
   - 空行表示 HTTP 响应头的结束，接下来是响应的主体（如果有）。

# badrequest() 函数 notfound()函数  unimplemented()函数

```c
void bad_request(int client)
{
    char buf[1024];

    sprintf(buf, "HTTP/1.0 400 BAD REQUEST\r\n");
    send(client, buf, sizeof(buf), 0);
    sprintf(buf, "Content-type: text/html\r\n");
    send(client, buf, sizeof(buf), 0);
    sprintf(buf, "\r\n");
    send(client, buf, sizeof(buf), 0);
    sprintf(buf, "<P>Your browser sent a bad request, ");
    send(client, buf, sizeof(buf), 0);
    sprintf(buf, "such as a POST without a Content-Length.\r\n");
    send(client, buf, sizeof(buf), 0);
}

```

这个就简单了，直接往buf里面写入字符串，包括响应头，响应类型和内容，然后发给客户端


```c
// 如果资源没有找到得返回给客户端下面的信息
void not_found(int client)
{
    char buf[1024];

    sprintf(buf, "HTTP/1.0 404 NOT FOUND\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, SERVER_STRING);
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "Content-Type: text/html\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "<HTML><TITLE>Not Found</TITLE>\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "<BODY><P>The server could not fulfill\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "your request because the resource specified\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "is unavailable or nonexistent.\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "</BODY></HTML>\r\n");
    send(client, buf, strlen(buf), 0);
}

```

这个也是，把NOTFOUND的内容发过去


```c
// 如果方法没有实现，就返回此信息
void unimplemented(int client)
{
    char buf[1024];

    sprintf(buf, "HTTP/1.0 501 Method Not Implemented\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, SERVER_STRING);
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "Content-Type: text/html\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "<HTML><HEAD><TITLE>Method Not Implemented\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "</TITLE></HEAD>\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "<BODY><P>HTTP request method not supported.\r\n");
    send(client, buf, strlen(buf), 0);
    sprintf(buf, "</BODY></HTML>\r\n");
    send(client, buf, strlen(buf), 0);
}
```

如果方法没有实现，就返回此信息

# cat()函数

```c
void cat(int client, FILE *resource)
{
    char buf[1024]; // 定义一个缓冲区，大小为 1024 字节

    // 从文件中读取一行内容到缓冲区 buf 中
    fgets(buf, sizeof(buf), resource);

    // 循环读取文件内容，直到文件结束
    while (!feof(resource))
    {
        // 将缓冲区 buf 中的内容发送给客户端
        send(client, buf, strlen(buf), 0);

        // 再次从文件中读取一行内容到缓冲区 buf 中
        fgets(buf, sizeof(buf), resource);
    }
}

```

这个代码的作用是，从`FILE*`中读取内容到buf缓冲区中，每次读取1024字节，读进来就发送给客户端，然后循环往复，直到读完这个文件为止

# servefile()函数

```c

// 如果不是CGI文件，直接读取文件返回给请求的http客户端
void serve_file(int client, const char *filename)
{
    FILE *resource = NULL;
    int numchars = 1;
    char buf[1024];

    // 默认字符
    buf[0] = 'A';
    buf[1] = '\0';
    while ((numchars > 0) && strcmp("\n", buf)) /* read & discard headers */
        numchars = get_line(client, buf, sizeof(buf));

    resource = fopen(filename, "r");
    if (resource == NULL)
        not_found(client);
    else
    {
        headers(client, filename);
        cat(client, resource);
    }
    fclose(resource);
}

```

`serve_file()` 函数的主要作用是处理 HTTP 请求并返回一个文件的内容给客户端。如果请求的文件存在且不是 CGI 脚本，则会将文件内容发送给客户端。下面是对这个函数的详细解释：


### 主要步骤和详细解释：

1. **初始化变量**：
   ```c
   FILE *resource = NULL;
   int numchars = 1;
   char buf[1024];
   ```

   - `resource`：用于存储打开的文件指针。
   - `numchars`：用于记录读取的字符数，初始化为1。
   - `buf`：缓冲区，用于存储从客户端读取的数据。

2. **默认字符设置**：
   ```c
   buf[0] = 'A';
   buf[1] = '\0';
   ```

   - 这段代码将 `buf` 的第一个字符设置为 `'A'`，并将第二个字符设置为终止符 `'\0'`，以确保缓冲区不为空。

3. **读取并丢弃请求头部**：
   ```c
   while ((numchars > 0) && strcmp("\n", buf)) /* read & discard headers */
       numchars = get_line(client, buf, sizeof(buf));
   ```

   - 通过循环调用 `get_line()` 函数，从客户端读取一行数据并存储在 `buf` 中。
   - 该循环持续读取，直到读取到一个空行（即仅包含 `'\n'` 的行），表示 HTTP 请求头部结束。
   - 读取的每一行都被丢弃，因为 `serve_file()` 只关心请求的文件内容。

4. **尝试打开文件**：
   ```c
   resource = fopen(filename, "r");
   if (resource == NULL)
       not_found(client);
   ```

   - 尝试以只读模式打开请求的文件。
   - 如果文件不存在或无法打开，则调用 `not_found()` 函数向客户端返回 404 错误。

5. **发送文件内容**：
   ```c
   else
   {
       headers(client, filename);
       cat(client, resource);
   }
   ```

   - 如果文件成功打开，则首先调用 `headers()` 函数发送 HTTP 响应头部。
   - 然后调用 `cat()` 函数，将文件内容逐行读取并发送给客户端。

6. **关闭文件**：
   ```c
   fclose(resource);
   ```

   - 在完成文件发送后，关闭文件指针以释放资源。

### 相关函数解释：

- **get_line()**：
  - 从客户端读取一行数据，直到遇到换行符 `'\n'`，并将其存储在缓冲区 `buf` 中。

- **not_found()**：
  - 向客户端发送 404 错误，表示请求的文件未找到。

- **headers()**：
  - 发送 HTTP 响应头部，告知客户端响应的文件类型和状态。

- **cat()**：
  - 将文件内容逐行读取，并通过 `send()` 函数发送给客户端。

这个函数的设计确保了在处理非 CGI 请求时，能够正确读取并返回文件内容给客户端，同时处理可能的错误情况，如文件未找到等。喵~

# getline()函数

## 源码部分

```c
int get_line(int sock, char *buf, int size)
{
    int i = 0;     // 缓冲区的索引
    char c = '\0'; // 从套接字读取的字符
    int n;         // recv() 函数读取的字符数

    // 循环读取字符，直到缓冲区满或遇到换行符
    while ((i < size - 1) && (c != '\n'))
    {
        // 从套接字读取一个字符
        n = recv(sock, &c, 1, 0);

        if (n > 0)
        {
            // 如果字符是回车符（'\r'），需要检查下一个字符
            if (c == '\r')
            {
                // 偷窥下一个字符，但不从输入队列中移除它
                n = recv(sock, &c, 1, MSG_PEEK);

                // 如果下一个字符是换行符（'\n'），从套接字读取它
                if ((n > 0) && (c == '\n'))
                    recv(sock, &c, 1, 0);
                else
                    // 如果下一个字符不是换行符，将回车符视为换行符
                    c = '\n';
            }

            // 将字符存储在缓冲区中
            buf[i] = c;
            i++;
        }
        else
            // 如果没有读取到字符，视为换行符以结束行
            c = '\n';
    }

    // 空字符终止缓冲区，使其成为有效的 C 字符串
    buf[i] = '\0';

    // 返回存储在缓冲区中的字符数，不包括空字符
    return (i);
}
```

## 代码作用和流程

这段代码的主要作用是从套接字中循环读取字符，处理 HTTP 请求头部信息。它具体的流程如下：

1. **循环读取字符**：
   - 从套接字中读取一个字符到变量 `c` 中。
   - 如果成功读取到字符，继续处理。

2. **处理回车符号 `'\r'`**：
   - 如果读取到的字符是回车符号 `'\r'`，接下来检查它的下一个字符。
   - 使用 `MSG_PEEK` 标志从套接字中偷窥下一个字符（但不将其移出输入队列）。
   - 如果下一个字符是换行符 `'\n'`，则从套接字中真正读取该字符，使 `c` 变为 `'\n'`。
   - 如果下一个字符不是换行符，直接将 `c` 设置为 `'\n'`。

3. **存储字符**：
   - 将处理后的字符 `c` 存储到缓冲区 `buf` 中。
   - 更新缓冲区索引 `i`，指向下一个存储位置。

4. **处理读取失败或结束情况**：
   - 如果没有成功读取到字符（可能是连接关闭或出错），将 `c` 设置为换行符 `'\n'`，结束行读取。

5. **结束读取并终止缓冲区**：
   - 循环结束后，在缓冲区末尾添加一个空字符 `'\0'`，以形成有效的 C 字符串。
   - 返回存储在缓冲区中的字符数，不包括空字符。

## 清晰的表述

这段代码的作用是循环读取字符，具体流程如下：

1. 先从套接字读取一个字符到 `c` 中。
2. 如果成功读取到字符：
   - 检查该字符是否为回车符 `'\r'`：
     - 如果是回车符 `'\r'`，继续检查下一个字符：
       - 使用 `MSG_PEEK` 标志偷窥下一个字符：
         - 如果下一个字符是换行符 `'\n'`，则从套接字中读取该字符到 `c` 中，此时 `c` 为 `'\n'`。
         - 如果下一个字符不是换行符，则将 `c` 设置为 `'\n'`。
     - 如果不是回车符 `'\r'`，则将读取到的字符存储到缓冲区 `buf` 中。
3. 如果没有成功读取到字符（可能是连接关闭或出错），将 `c` 设置为换行符 `'\n'`，结束行读取。
4. 每次读取到字符后，将其存储到缓冲区 `buf` 中，并更新缓冲区索引 `i`。
5. 循环结束后，在缓冲区末尾添加一个空字符 `'\0'`，表示字符串结束。

最终，函数返回存储在缓冲区 `buf` 中的字符数，不包括结尾的空字符 `'\0'`。
