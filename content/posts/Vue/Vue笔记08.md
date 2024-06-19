---
title: Vue笔记08-Vue computed函数实战
subtitle:
date: 2024-05-18T14:15:24+08:00
slug: 3981eaf
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
import { ref, computed, reactive } from 'vue'
type Data = {
  name: string
  price: number
  num: number
}
const data = reactive<Data[]>([
  {
    name: 'banana',
    price: 12,
    num: 20
  },
  {
    name: 'apple',
    price: 20,
    num: 100
  },
  {
    name: 'orange',
    price: 10,
    num: 200
  },
  {
    name: 'watermelon',
    price: 40,
    num: 20
  }
])
const del = (index: number) => {
  data.splice(index, 1)
}

let keyWord = ref<string>('')
let serachData = computed(() => {
    return data.filter((item:Data)=>{
        return item.name.includes(keyWord.value)
    })
})
let total = computed({
  get: () => {
    return serachData.value.reduce((prev: number, next: Data) => {
      return prev + next.num * next.price
    }, 0)
  },
  set: (val) => {
    console.log(val)
  }
})

</script>
<template>
  <div style="display: flex; align-items: center; justify-content: center; flex-direction: column">
    <input placeholder="搜索" type="text" v-model="keyWord" />
    <table border cellpadding="0" cellspacing="0">
      <thead>
        <th>商品名称</th>
        <th>商品单价</th>
        <th>物品数量</th>
        <th>物品总价</th>
        <th>操作</th>
      </thead>
      <tbody>
        <tr v-for="(item, index) in serachData" :key="index">
          <td align="center">{{ item.name }}</td>
          <td align="center">{{ item.price }}</td>
          <td align="center">
            <button type="button" @click="item.num >= 1 ? item.num-- : null">-</button>{{ item.num
            }}<button type="button" @click="item.num++">+</button>
          </td>
          <td align="center">{{ item.num * item.price }}</td>
          <td align="center">
            <button @click="del(index)">删除</button>
          </td>
        </tr>
      </tbody>
      <tfoot>
        总价：{{
          total
        }}
      </tfoot>
    </table>
  </div>
</template>
<style></style>

```

![](https://static.meowrain.cn/i/2024/01/22/hcar18-3.webp)

![](https://static.meowrain.cn/i/2024/01/22/hcn84i-3.webp)