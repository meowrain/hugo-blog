---
title: Vue笔记09-Vue生命周期
subtitle:
date: 2024-05-18T14:16:14+08:00
slug: 43d03f6
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

![](https://static.meowrain.cn/i/2024/01/22/sfmjfk-3.webp)
一：主要分为渲染、更新、销毁三个部分

1：渲染顺序 （先父后子，完成顺序：先子后父）

子组件先挂载，然后到父组件

父 beforeCreate->父 created->父 beforeMount->子 beforeCreate->子 created->子 beforeMount->子 mounted->父 mounted

2：更新顺序 （父更新导致子更新，子更新完成后父）

子组件更新过程

父 beforeUpdate->子 beforeUpdate->子 updated->父 updated

父组件更新过程

父 beforeUpdate->父 updated

3：销毁顺序（ 先父后子，完成顺序：先子后父）

父 beforeDestroy->子 beforeDestroy->子 destroyed->父 destroyed