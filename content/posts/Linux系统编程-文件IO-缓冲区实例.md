---
title: Linux系统编程-文件IO-缓冲区实例
subtitle:
date: 2024-06-19T02:26:37Z
slug: e1ebd34
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Linux系统编程
  - 缓冲区
  - 文件IO
categories:
  - Linux系统编程
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


![](https://static.meowrain.cn/i/2024/01/16/sqxijv-3.webp)

# 行缓冲


在使用行缓冲的情况下，每当输入输出遇到换行或者缓冲区满了的情况下才会进行实际的IO操作，当涉及到终端输入输出的时候通常使用行缓冲。

当字符数超过1024个时，进行IO操作
![](https://static.meowrain.cn/i/2024/01/16/ssqct3-3.webp)

![](https://static.meowrain.cn/i/2024/01/16/ssu3ir-3.webp)

使用换行符时候进行IO
![](https://static.meowrain.cn/i/2024/01/16/spmaup-3.webp)

![](https://static.meowrain.cn/i/2024/01/16/spqhp6-3.webp)

# 全缓冲
在使用全缓冲的情况下，当数据填满整个缓冲区之后才进行实际的IO操作。对于驻留在磁盘上的文件的读写通常是使用全缓冲。通常如果不给文件流指定缓冲区的情况下，标准IO函数会首先调用malloc函数获取所需要的缓冲区。