---
title: Go语言打印进度
subtitle:
date: 2024-05-18T13:03:40+08:00
slug: fc29587
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

就是一直刷新当前行
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 模拟一些操作，比如循环计数
	for i := 0; i <= 100; i++ {
		// 返回到行首
		fmt.Print("\r")
		// 输出其他内容
		fmt.Printf("Prefix: ")
		// 输出进度
		fmt.Printf("Progress: %d%%", i)
		// 强制刷新输出缓冲区
		fmt.Print("\033[0m") // 重置 ANSI 颜色，防止影响后续输出
		time.Sleep(100 * time.Millisecond)
	}
	fmt.Println("\nDone!") // 完成后换行
}

```
