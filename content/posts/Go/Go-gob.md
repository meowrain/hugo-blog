---
title: Go Gob
subtitle:
date: 2024-05-18T13:02:07+08:00
slug: a47021b
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Go
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

# 介绍
Go的gob是Go语言标准库中的一种序列化/反序列化格式，主要用于在编码和解码时传输和存储Go数据结构。Gob格式专为Go语言设计，提供了一种高效的二进制编码方式，特别适合在网络通信和文件存储中使用。

以下是Go的gob包的一些关键特性和使用方法：

特性
高效的二进制编码：Gob格式比JSON和XML等文本格式更为紧凑和高效，因为它使用二进制表示数据。
面向Go语言：Gob格式支持Go语言中的复杂数据结构，包括嵌套结构、切片、映射等。
自动化的编码和解码：使用gob包可以自动处理编码和解码过程，无需手动序列化和反序列化。

# 例子

```go
package main

import (
	"bytes"
	"encoding/gob"
	"fmt"
	"log"
	"os"
)

type Person struct {
	Name string
	Age  int
}

func main() {
	// 创建一个Person实例
	person := Person{Name: "Alice", Age: 30}
	// 创建一个缓冲区来存储编码后的数据
	var buf bytes.Buffer

	// 创建一个新的编码器并对缓冲区进行编码
	encoder := gob.NewEncoder(&buf)
	err := encoder.Encode(person)
	if err != nil {
		fmt.Println("编码错误:", err)
	}

	// 打印编码后的数据
	fmt.Println("编码后的数据:", buf.Bytes())

	// 把编码后的数据写入文件中
	file, err := os.OpenFile("data.gob", os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
	if err != nil {
		log.Fatal("打开文件错误:", err)
	}
	defer file.Close() // 确保文件在程序结束时关闭

	encoder2 := gob.NewEncoder(file)
	err = encoder2.Encode(person)
	if err != nil {
		log.Fatal("编码错误:", err)
	}

	// 解码
	file2, err := os.Open("data.gob")
	if err != nil {
		log.Fatal("打开文件错误:", err)
	}
	defer file2.Close() // 确保文件在程序结束时关闭

	decoder2 := gob.NewDecoder(file2)
	var person2 Person
	err = decoder2.Decode(&person2)
	if err != nil {
		log.Fatal("解码错误:", err)
	}

	// 打印解码后的数据
	fmt.Println("解码后的数据:", person2)

	// 将解码后的数据写入 "test.txt" 文件
	file3, err := os.OpenFile("test.txt", os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0666)
	if err != nil {
		log.Fatal("打开文件错误:", err)
	}
	defer file3.Close() // 确保文件在程序结束时关闭

	_, err = fmt.Fprintf(file3, "Name: %s, Age: %d\n", person2.Name, person2.Age)
	if err != nil {
		log.Fatal("写入文件错误:", err)
	}
}

```
代码解释
创建和编码Person实例：创建 Person 实例并编码成字节缓冲区。
打印编码后的数据：打印编码后的数据字节切片（注意：这是二进制数据，不是人类可读的格式）。
将编码数据写入文件：将编码后的数据写入 "data.gob" 文件。
解码数据：从 "data.gob" 文件中读取数据并解码回 Person 实例。
打印解码后的数据：打印解码后的 Person 实例数据。
写入解码数据到test.txt：将解码后的 Person 实例数据写入 "test.txt" 文件，以人类可读的格式输出。
