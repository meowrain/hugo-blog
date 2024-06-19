---
title: Vue笔记06-Vue toRaw函数使用
subtitle:
date: 2024-05-18T14:14:59+08:00
slug: a138da2
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Vue
  - 前端web
categories:
  - 前端
    - Vue
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


```js
<script setup lang="ts">
import { reactive, toRaw } from 'vue'
let obj = reactive({
  name: 'meowrain',
  like: 'jk'
})

let change = () => {
  console.log(obj)
  console.log(toRaw(obj)) //解除响应式
}
</script>
<template>
  <div>
    <button @click="change">change</button>
    <p>obj-{{ obj }}</p>
  </div>
</template>
<style></style>

```
![](https://static.meowrain.cn/i/2024/01/21/zbu5zn-3.webp)