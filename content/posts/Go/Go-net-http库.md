---
title: Go net/http库
subtitle:
date: 2024-06-19T10:43:47Z
slug: 51b9f8d
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Go
  - 函数库
  - http 
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

# Go net/http库

## Get()方法

### 函数原型

```go
func Get(url string) (resp *Response, err error)
```

使用示例：
```go
package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

func main() {
	response, err := http.Get("http://httpbin.org/get")

	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(response.Status)
	fmt.Println(response.Proto)
	fmt.Println("------------请求头----------------")
	for k, v := range response.Header {
		fmt.Printf("%s:%s\n", k, v[0])
	}
	body, err := io.ReadAll(response.Body)
	defer response.Body.Close()
	if response.StatusCode != http.StatusOK {
		log.Fatalf("Response failed with status code: %d\n", response.StatusCode)
	}
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("---------请求体--------")
	fmt.Println(string(body))
	fmt.Println("--------响应长度-------")
	fmt.Println(response.ContentLength)
}

```

![](https://static.meowrain.cn/i/2024/06/19/vhbdmj-3.webp)

## Head()函数
Head 请求表示只请求目标 URL 的响应头信息，不返回响应实体。
### 函数原型
```go
func Head(url string) (resp *Response, err error)
```

例子：

```go
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	response, err := http.Head("http://httpbin.org/get")
	if err != nil {
		log.Fatalln(err)
	}

	defer response.Body.Close()
	for k, v := range response.Header { // 打印头信息
		fmt.Println(k, ":", v)
	}
}

```


![](https://static.meowrain.cn/i/2024/06/19/vo70b9-3.webp)


## Post()方法
向指定URL发送POST请求。

### 函数原型

```go
func Post(url, contentType string, body io.Reader) (resp *Response, err error)
```
{{< admonition type=tip title="注意" open=true >}}
调用http.Post()方法需要依次传递3个参数

- **请求的目标URL**
- **数据资源类型**
- **数据的比特流([]byte 形式)**

{{< /admonition >}}

示例：
```go
package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"
)

func main() {
	data := make(map[string]string, 0)
	data["key"] = "001"
	buf, err := json.Marshal(data)
	if err != nil {
		log.Fatal(err)
	}
	reqBody := strings.NewReader(string(buf))
	res, err := http.Post("http://httpbin.org/post", "application/json", reqBody)
	if err != nil {
		log.Fatal(err)
	}
	body, err := io.ReadAll(res.Body)
	defer res.Body.Close()
	if res.StatusCode != http.StatusOK {
		log.Fatalf("Response failed with status code: %d\n", res.StatusCode)
	}
	fmt.Printf("%s", body)

}
```
![](https://static.meowrain.cn/i/2024/06/19/w8q4p4-3.webp)

## PostForm()方法

发送表单POST请求。

### 函数原型

```go
func PostForm(url string, data url.Values) (resp *Response, err error)
```

{{< admonition type=tip title="注意" open=true >}}
 PostForm() 方法中，Content-Type 头信息类型是 application/x-www-form-urlencoded
 POST 请求参数需要通过 `url.Values` 方法进行编码和封装。
{{< /admonition >}}

```go
package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
)

func main() {

	res, err := http.PostForm("http://httpbin.org/post", url.Values{"key1": {"001"}, "key2": {"002"}})
	if err != nil {
		log.Fatalln(err)
	}
	body, err := io.ReadAll(res.Body)
	defer res.Body.Close()
	if res.StatusCode != http.StatusOK {
		log.Fatalf("Response failed with status code: %d\n", res.StatusCode)
	}
	fmt.Printf("%s", body)
}

```

![](https://static.meowrain.cn/i/2024/06/19/12qlq8p-3.webp)


## NewRequest()方法
### 函数原型
```go
func NewRequest(method, url string, body io.Reader) (*Request, error)
```

{{< admonition type=tip title="注意" open=true >}}
创建一个新的HTTP请求通常使用**net/http包**中的`http.NewRequest`函数。这个函数允许你创建一个自定义的HTTP请求，你可以设置请求方法、URL、请求头和请求体等。
在Go语言中，`http.Client`是一个结构体，用于管理HTTP请求的发送和接收。你可以使用`http.Client`来执行HTTP请求，并处理响应。
{{< /admonition >}}


```go
package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"
)

func main() {
	data := make(map[string]string, 0)
	data["key1"] = "001"
	data["key2"] = "002"
	data["key3"] = "003"
	buf, err := json.Marshal(data)
	if err != nil {
		log.Fatal(err)
	}

	reqBody := strings.NewReader(string(buf))
	request, err := http.NewRequest("POST", "http://httpbin.org/post", reqBody)
	if err != nil {
		log.Fatalln(err)
	}
	request.Header.Set("Content-Type", "application/json")
	client := &http.Client{}
	res, err := client.Do(request)
	if err != nil {
		log.Fatalln(err)
	}
	body, _ := io.ReadAll(res.Body)
	defer res.Body.Close()
	if res.StatusCode != http.StatusOK {
		log.Fatalln(err)
	}
	fmt.Printf("%s", body)
}

```


## ReadRequest()方法

{{< admonition type=tip title="注意" open=true >}}
从非标准的输入源读取HTTP响应
{{< /admonition >}}


```go
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"net/http"
	"strings"
)

type ReqData struct {
	Raw     string
	Req     *http.Request
	Body    string
	Trailer http.Header
	Error   string
}

func main() {
	reqdata := &ReqData{
		Raw: "GET /get HTTP/1.1\r\n" +
			"Host: httpbin.org\r\n" +
			"User-Agent: Fake\r\n" +
			"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n" +
			"Accept-Language: en-us,en;q=0.5\r\n" +
			"Accept-Encoding: gzip,deflate\r\n" +
			"Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n" +
			"Keep-Alive: 300\r\n" +
			"Content-Length: 18\r\n" +
			"Proxy-Connection: keep-alive\r\n\r\n" +
			"帽儿山的枪手??",
	}

	req, err := http.ReadRequest(bufio.NewReader(strings.NewReader(reqdata.Raw)))
	if err != nil {
		panic(err)
	}
	defer req.Body.Close()

	var bout bytes.Buffer
	_, err = io.Copy(&bout, req.Body)
	if err != nil {
		panic(err)
	}
	body := bout.String()

	fmt.Println(req.Method) // 输出HTTP请求类型
	fmt.Println(body)       // 输出请求body内容
}

```

## ReadResponse()方法

> https://pkg.go.dev/net/http#ReadResponse