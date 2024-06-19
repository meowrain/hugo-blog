---
title: Vue笔记04-Vue3利用ref函数获取dom元素内容
subtitle:
date: 2024-05-18T14:12:03+08:00
slug: 9677752
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
import { ref } from 'vue'
const dom = ref<HTMLDivElement>()
function change() {
  console.log(dom.value?.innerText)
}
</script>
<template>
  <div>
    <button @click="change">change</button>
    <div ref="dom">Hello Meowrain</div>
  </div>
</template>
<style></style>

```
在元素上添加`ref="变量名"`,script中写`const dom = ref<HTMLDivElement>()`，因为采用了setup语法糖，如果直接写在script标签中，得到的结果就是undefined,只有在函数中才能调用.
![](https://static.meowrain.cn/i/2024/01/21/xaqpp7-3.webp)

---

# 问题：vue3中reactive对象赋值，不能响应式变化
> 在使用vue3中，使用reactive创建的对象或者数组进行赋值时，可以正常赋值，但是不会触发响应式变化。

例子：
```js
<script setup lang="ts">
import { ref,reactive } from 'vue'
let list = reactive<string[]>([]);
let obj = reactive({});
function add(){
    setTimeout(()=>{
        obj = {
            name:'meowrain',
            age:20
        }
        console.log(obj);
    },2000)
}
</script>
<template>
  <div>
    <button @click="add">add</button>
    
    <div>{{ obj }}</div>
  </div>
</template>
<style></style>

```

![](https://static.meowrain.cn/i/2024/01/21/xph1o1-3.webp)

我们按下按钮，等待2秒
![](https://static.meowrain.cn/i/2024/01/21/xpnkmf-3.webp)

可以看到obj的值已经发生了变化，但是页面没有进行渲染,与此同时，obj的响应式对象被破坏(本来应该是`Proxy(Object) {}`类型的，现在成了纯粹的普通对象了

# 解决办法
## 方法1
直接添加对象的属性
```js
<script setup lang="ts">
import { ref,reactive } from 'vue'
let list = reactive<string[]>([]);

let obj = reactive({});
console.log(obj);
function add(){
    setTimeout(()=>{
        obj.name = 'meowrain'
        obj.age = '120'
        console.log(obj);
    },2000)
}
</script>
<template>
  <div>
    <button @click="add">add</button>
    
    <div>{{ obj }}</div>
  </div>
</template>
<style></style>

```
![](https://static.meowrain.cn/i/2024/01/21/xslsdm-3.webp)
按下按钮
![](https://static.meowrain.cn/i/2024/01/21/xsozdk-3.webp)

> 数组的话就是调用push,然后把异步获取的数据解构传入就行了

## 方法2
使用`ref`
不必多说，直接ref包起来给xxx.value赋值就行