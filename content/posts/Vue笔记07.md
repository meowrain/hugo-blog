---
title: Vue笔记07-Vue watch函数
subtitle:
date: 2024-05-18T14:15:27+08:00
slug: 72020db
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

![](https://static.meowrain.cn/i/2024/01/22/j3a9b9-3.webp)
```js
<script setup lang="ts">
import {watch,ref} from 'vue'
let source = ref('');
let length = ref(0);
watch(source,(newVal,oldVal)=>{
    console.log(oldVal+"发生变化\n");
    console.log("新值为："+newVal);
    length.value = source.value.length;
})
</script>
<template>
<input type="text" v-model="source" />
<span>{{ length }}</span>

</template>
<style></style>

```

> 也可以监听一个值，当发生变化时候进行异步请求，刷新数据

## watch监听属性
![](https://static.meowrain.cn/i/2024/01/22/r5c220-3.webp)