---
title: Vue笔记13-Vue transition组件
subtitle:
date: 2024-05-18T14:18:42+08:00
slug: d2d05db
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

> 官方文档： https://cn.vuejs.org/guide/built-ins/transition.html


> 使用v-if处理盒子显示和消失
![](https://static.meowrain.cn/i/2024/01/23/t0kzlz-3.gif)

> 🤓 看上去很生硬，不是吗？我们来用transition组件处理一下

```js
<template>
  <div>
    <el-button color="#626aef" @click="flag = !flag"> 切换组件</el-button>
    <Transition name="fade">
      <div class="box" v-if="flag">box</div>
    </Transition>
  </div>
</template>
<script setup lang="ts">
import { ref, Transition } from 'vue'

let flag = ref<boolean>(true)
</script>
<style scoped>
.box {
  background-color: aqua;
  width: 200px;
  height: 200px;
}

.fade-enter-from,
.fade-leave-to {
  width: 0;
  height: 0;
}
.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s ease;
}
.fade-enter-to,
.faode-leave-from {
  background-color: aqua;
  width: 200px;
  height: 200px;
}
</style>

```
![](https://static.meowrain.cn/i/2024/01/23/txdj6m-3.gif)