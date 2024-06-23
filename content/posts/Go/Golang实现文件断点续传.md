---
title: Golang实现文件断点续传
subtitle:
date: 2024-06-23T13:24:19+08:00
slug: c66c786
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - 断点续传
  - HTTP
  - 范围请求
categories:
  - Go
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

# Golang实现文件断点续传

## HTTP 范围请求

> https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Range_requests
>
> https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Range
>
> https://juejin.cn/post/7381455296658751551?searchId=202406222022394BE0D5BA1F1DB137CFF5
>
> https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status/206

![image-20240623130020723](https://static.meowrain.cn/i/2024/06/23/li43ry-3.webp)

我们首先用golang写一个不具备范围请求的代码

```go
package main

import (
	"mime"
	"net/http"
	"os"
	"path/filepath"
	"strconv"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/files/*filepath", fileHandler)
	port := "8080"
	router.Run(":" + port)
}

func fileHandler(c *gin.Context) {
	// Get the requested file path
	filePath := "." + c.Param("filepath")
	log.Printf("Requested file path: %s\n", filePath)

	// Open the file
	file, err := os.Open(filePath)
	if err != nil {
		log.Printf("Error opening file: %v\n", err)
		c.String(http.StatusNotFound, "File not found: %s", filePath)
		return
	}
	defer file.Close()

	// Get file info
	fileInfo, err := file.Stat()
	if err != nil {
		log.Printf("Error getting file info: %v\n", err)
		c.String(http.StatusInternalServerError, "Could not obtain file information: %s", filePath)
		return
	}

	// Automatically detect the file's MIME type
	mimeType := mime.TypeByExtension(filepath.Ext(filePath))
	if mimeType == "" {
		mimeType = "application/octet-stream"
	}

	log.Printf("MIME type: %s\n", mimeType)
	log.Printf("File size: %d\n", fileInfo.Size())

	c.Header("Content-Type", mimeType)
	c.Header("Content-Length", strconv.FormatInt(fileInfo.Size(), 10))
	c.Header("Content-Disposition", "inline")
	c.Header("Accept-Ranges", "none") // Disable range requests

	// Check for Range header and reject partial content requests
	rangeHeader := c.GetHeader("Range")
	if rangeHeader != "" {
		log.Println("Rejecting range request")
		c.String(http.StatusRequestedRangeNotSatisfiable, "Range requests are not supported")
		return
	}

	// Handle HEAD request
	if c.Request.Method == http.MethodHead {
		log.Println("Handling HEAD request")
		c.Status(http.StatusOK)
		return
	}

	// Handle GET request
	log.Println("Handling GET request")
	c.Status(http.StatusOK)
	c.File(filePath)
}

```



上面的代码不仅明确声明禁用范围请求 (`Accept-Ranges: none`)，还禁用 `Range` 请求（主动拒绝范围请求），这样我们不能在线看视频，因为视频是通过范围请求进行播放的

![image-20240623125433387](https://static.meowrain.cn/i/2024/06/23/kqsuv3-3.webp)

![image-20240623125447724](https://static.meowrain.cn/i/2024/06/23/kqvyl2-3.webp)

如果想看视频，那就需要取消对Range的限制，并取消禁用范围请求限制

> 但是因为没有实现断点续传部分功能，所以只是能范围请求了而已，断点续传还做不到

![image-20240623125642103](https://static.meowrain.cn/i/2024/06/23/ks1plt-3.webp)

![image-20240623125653326](https://static.meowrain.cn/i/2024/06/23/ks3unl-3.webp)

### 区别

![image-20240623125859854](https://static.meowrain.cn/i/2024/06/23/ktkwjp-3.webp)

![image-20240623125943490](https://static.meowrain.cn/i/2024/06/23/ktu7b3-3.webp)



## 断点续传

要实现断点续传，首当其冲的是要让服务器支持HTTP范围请求，而且不禁用客户端的Range请求

![dcbec889992cd2ec0f0f338d8c49438](https://static.meowrain.cn/i/2024/06/23/ljcp8v-3.webp)



我们来了解一下Range请求头

![image-20240623130357632](https://static.meowrain.cn/i/2024/06/23/lk4bk9-3.webp)

![image-20240623130504746](https://static.meowrain.cn/i/2024/06/23/lkzy7j-3.webp)

![image-20240623130426704](https://static.meowrain.cn/i/2024/06/23/lkj4qt-3.webp)

我们用golang实现这个

```go
func fileHandler(c *gin.Context) {
	filePath := "." + c.Param("filepath")

	// 打开文件
	file, err := os.Open(filePath)
	if err != nil {
		c.String(http.StatusNotFound, "File not found")
		return
	}
	defer file.Close()

	// 获取文件信息
	fileInfo, err := file.Stat()
	if err != nil {
		c.String(http.StatusInternalServerError, "Could not obtain file information")
		return
	}

	fileSize := fileInfo.Size()

	// 处理 Range 头
	rangeHeader := c.GetHeader("Range")
	if rangeHeader == "" {
		// 没有 Range 头，直接返回整个文件
		c.Header("Content-Length", strconv.FormatInt(fileSize, 10))
		c.File(filePath)
		return
	}

	// 解析 Range 头
	ranges := strings.Split(rangeHeader, "=")
	if len(ranges) != 2 || ranges[0] != "bytes" {
		c.String(http.StatusBadRequest, "Invalid Range header")
		return
	}

	// 解析多个范围
	rangeParts := strings.Split(ranges[1], ",")
	var rangesList [][2]int64
	for _, part := range rangeParts {
		bounds := strings.Split(strings.TrimSpace(part), "-")
		if len(bounds) != 2 {
			c.String(http.StatusBadRequest, "Invalid Range header")
			return
		}

		start, err := strconv.ParseInt(bounds[0], 10, 64)
		if err != nil {
			c.String(http.StatusBadRequest, "Invalid Range header")
			return
		}

		var end int64
		if bounds[1] == "" {
			end = fileSize - 1
		} else {
			end, err = strconv.ParseInt(bounds[1], 10, 64)
			if err != nil {
				c.String(http.StatusBadRequest, "Invalid Range header")
				return
			}
		}

		if start < 0 || end >= fileSize || start > end {
			c.String(http.StatusRequestedRangeNotSatisfiable, "Invalid Range header")
			return
		}

		rangesList = append(rangesList, [2]int64{start, end})
	}

	// 设置响应头
	c.Header("Accept-Ranges", "bytes")

	// 单个范围请求
	if len(rangesList) == 1 {
		start := rangesList[0][0]
		end := rangesList[0][1]
		c.Header("Content-Range", fmt.Sprintf("bytes %d-%d/%d", start, end, fileSize))
		c.Header("Content-Length", strconv.FormatInt(end-start+1, 10))
		c.Header("Content-Type", "application/octet-stream")
		c.Status(http.StatusPartialContent)

		// 返回指定范围的文件内容
		buf := make([]byte, end-start+1)
		_, err = file.ReadAt(buf, start)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to read file")
			return
		}

		_, err = c.Writer.Write(buf)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to write response")
			return
		}
		return
	}

	// 多个范围请求
	c.Header("Content-Type", "multipart/byteranges; boundary=BOUNDARY")
	c.Status(http.StatusPartialContent)

	for _, r := range rangesList {
		start := r[0]
		end := r[1]

		// 设置范围响应头
		c.Writer.Write([]byte(fmt.Sprintf("\r\n--BOUNDARY\r\n")))
		c.Writer.Write([]byte(fmt.Sprintf("Content-Range: bytes %d-%d/%d\r\n\r\n", start, end, fileSize)))

		// 返回指定范围的文件内容
		buf := make([]byte, end-start+1)
		_, err := file.ReadAt(buf, start)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to read file")
			return
		}

		_, err = c.Writer.Write(buf)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to write response")
			return
		}
	}

	c.Writer.Write([]byte("\r\n--BOUNDARY--\r\n"))
}

```







当然，可以解析一下这个代码，以帮助你理解各部分的功能。

### ChatGPT代码解析

#### 导入包

```go
import (
	"fmt"
	"log"
	"mime"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)
```

这些包提供了处理 HTTP 请求、文件操作、字符串操作和日志记录所需的功能。

#### 主函数

```go
func main() {
	router := gin.Default()
	router.GET("/files/*filepath", fileHandler)
	router.HEAD("/files/*filepath", fileHandler)
	port := "8080"
	log.Printf("Starting server on port %s\n", port)
	err := router.Run(":" + port)
	if err != nil {
		log.Fatalf("Server failed to start: %v\n", err)
	}
}
```

- `gin.Default()`：创建一个默认的 Gin 路由器。
- `router.GET("/files/*filepath", fileHandler)`：注册一个处理 GET 请求的路由，当访问 `/files/*filepath` 时，会调用 `fileHandler` 处理。
- `router.HEAD("/files/*filepath", fileHandler)`：注册一个处理 HEAD 请求的路由，当访问 `/files/*filepath` 时，也会调用 `fileHandler` 处理。
- 启动服务器并监听端口 `8080`。

#### 文件处理器函数

```go
func fileHandler(c *gin.Context) {
	filePath := "." + c.Param("filepath")

	// 打开文件
	file, err := os.Open(filePath)
	if err != nil {
		c.String(http.StatusNotFound, "File not found")
		return
	}
	defer file.Close()
```

- `filePath := "." + c.Param("filepath")`：获取请求的文件路径并在其前加上当前目录。
- `os.Open(filePath)`：尝试打开文件，如果文件不存在或无法打开，返回 404 错误。
- `defer file.Close()`：确保函数结束时关闭文件。

```go
	// 获取文件信息
	fileInfo, err := file.Stat()
	if err != nil {
		c.String(http.StatusInternalServerError, "Could not obtain file information")
		return
	}

	fileSize := fileInfo.Size()
```

- `file.Stat()`：获取文件信息，如文件大小。如果无法获取文件信息，返回 500 错误。
- `fileInfo.Size()`：获取文件大小。

```go
	// 处理 Range 头
	rangeHeader := c.GetHeader("Range")
	if rangeHeader == "" {
		// 没有 Range 头，直接返回整个文件
		c.Header("Content-Length", strconv.FormatInt(fileSize, 10))
		c.File(filePath)
		return
	}
```

- `c.GetHeader("Range")`：获取请求头中的 `Range` 字段。如果没有 `Range` 头，返回整个文件。

```go
	// 解析 Range 头
	ranges := strings.Split(rangeHeader, "=")
	if len(ranges) != 2 || ranges[0] != "bytes" {
		c.String(http.StatusBadRequest, "Invalid Range header")
		return
	}
```

- `strings.Split(rangeHeader, "=")`：解析 `Range` 头，确保其格式为 `bytes=...`。如果格式不正确，返回 400 错误。

```go
	// 解析多个范围
	rangeParts := strings.Split(ranges[1], ",")
	var rangesList [][2]int64
	for _, part := range rangeParts {
		bounds := strings.Split(strings.TrimSpace(part), "-")
		if len(bounds) != 2 {
			c.String(http.StatusBadRequest, "Invalid Range header")
			return
		}

		start, err := strconv.ParseInt(bounds[0], 10, 64)
		if err != nil {
			c.String(http.StatusBadRequest, "Invalid Range header")
			return
		}

		var end int64
		if bounds[1] == "" {
			end = fileSize - 1
		} else {
			end, err = strconv.ParseInt(bounds[1], 10, 64)
			if err != nil {
				c.String(http.StatusBadRequest, "Invalid Range header")
				return
			}
		}

		if start < 0 || end >= fileSize || start > end {
			c.String(http.StatusRequestedRangeNotSatisfiable, "Invalid Range header")
			return
		}

		rangesList = append(rangesList, [2]int64{start, end})
	}
```

- 解析 `Range` 头的各个部分，并将每个范围存储在 `rangesList` 列表中。
- 验证每个范围的起始和结束位置是否合法。如果不合法，返回相应的错误。

```go
	// 设置响应头
	c.Header("Accept-Ranges", "bytes")

	// 单个范围请求
	if len(rangesList) == 1 {
		start := rangesList[0][0]
		end := rangesList[0][1]
		c.Header("Content-Range", fmt.Sprintf("bytes %d-%d/%d", start, end, fileSize))
		c.Header("Content-Length", strconv.FormatInt(end-start+1, 10))
		c.Header("Content-Type", "application/octet-stream")
		c.Status(http.StatusPartialContent)

		// 返回指定范围的文件内容
		buf := make([]byte, end-start+1)
		_, err = file.ReadAt(buf, start)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to read file")
			return
		}

		_, err = c.Writer.Write(buf)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to write response")
			return
		}
		return
	}
```

- 如果请求包含一个范围，设置 `Content-Range` 和 `Content-Length` 响应头，并返回该范围内的文件内容。

```go
	// 多个范围请求
	c.Header("Content-Type", "multipart/byteranges; boundary=BOUNDARY")
	c.Status(http.StatusPartialContent)

	for _, r := range rangesList {
		start := r[0]
		end := r[1]

		// 设置范围响应头
		c.Writer.Write([]byte(fmt.Sprintf("\r\n--BOUNDARY\r\n")))
		c.Writer.Write([]byte(fmt.Sprintf("Content-Range: bytes %d-%d/%d\r\n\r\n", start, end, fileSize)))

		// 返回指定范围的文件内容
		buf := make([]byte, end-start+1)
		_, err := file.ReadAt(buf, start)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to read file")
			return
		}

		_, err = c.Writer.Write(buf)
		if err != nil {
			c.String(http.StatusInternalServerError, "Failed to write response")
			return
		}
	}

	c.Writer.Write([]byte("\r\n--BOUNDARY--\r\n"))
}
```

- 如果请求包含多个范围，设置 `Content-Type` 为 `multipart/byteranges`，并为每个范围返回相应的内容。

