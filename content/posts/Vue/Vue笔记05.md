---
title: Vue笔记05-Vue toRef和toRefs妙用
subtitle:
date: 2024-05-18T14:14:38+08:00
slug: 3d3a1d4
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

# Vue toRef和toRefs妙用

> 当我们对reactive对象进行解构的时候，解构出来的数据是基本类型，不再具备响应式，没办法更改视图中的

按下按钮后，什么也没变

![](https://static.meowrain.cn/i/2024/01/21/z0o75f-3.webp)

我们使用`toRefs`，就能把里面的数据一个个转换为响应式对象返回，再被解构，所有属性依然拥有响应式，还能修改

```js
<script setup lang="ts">
import { reactive, toRef, toRefs } from 'vue'
let obj = reactive({
  name: 'meowrain',
  like: 'jk'
})
let {name,like} = toRefs(obj);


let change = () => {
    name.value = "meows";
    like.value = "luolita"
    console.log(name,like);
}
</script>
<template>
  <div>
    <button @click="change">change</button>
    <p>obj-{{ obj }}</p>
    <p>Name-{{ name }}</p>
    <p>Like-{{ like }}</p>
  </div>
</template>
<style></style>
```

![](https://static.meowrain.cn/i/2024/01/21/z1v7s7-3.webp)
按下按钮，可以发现内容改变了
> 注意以下，obj内容也会被同时修改


> `toRef`函数接受一个响应式对象，一个需要解构出来依然拥有响应式的属性值
举例：
```js
<script setup lang="ts">
import { reactive, toRef, toRefs } from 'vue'
let obj = reactive({
  name: 'meowrain',
  like: 'jk'
})
let name = toRef(obj,'name');


let change = () => {
    name.value = "meowraintttt"
    console.log(name);
}
</script>
<template>
  <div>
    <button @click="change">change</button>
    <p>obj-{{ obj }}</p>
    <p>name-{{ name }}</p>
  </div>
</template>
<style></style>

```

![](https://static.meowrain.cn/i/2024/01/21/z44cp9-3.webp)