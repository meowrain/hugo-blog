---
title: Vue笔记01-创建一个 Vue 应用 & 了解vue
subtitle:
date: 2024-05-18T14:08:56+08:00
slug: 755e4bd
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

# 创建一个 Vue 应用 & 了解vue
```
npm create vue@latest
```

![](https://static.meowrain.cn/i/2024/01/11/krgh3l-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/ksgarw-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/ktsqhb-3.webp)

# 默认目录结构
![](https://static.meowrain.cn/i/2024/01/11/li1e3y-3.webp)

# vscode环境安装
![](https://static.meowrain.cn/i/2024/01/11/ljs70n-3.webp)

# 第一个项目

> 删除无用文件，重新改下`App.vue`和`router/index.js`里面的内容

![](https://static.meowrain.cn/i/2024/01/11/ll2lsb-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/ll4m8j-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/ll73jn-3.webp)


# 了解`main.js`

```js
import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')

```

每个 Vue 应用都是通过 createApp 函数创建一个新的 应用实例：

## 根组件
我们传入 createApp 的对象实际上是一个组件，每个应用都需要一个“根组件”，其他组件将作为其子组件。

![](https://static.meowrain.cn/i/2024/01/11/lqesgu-3.webp)

## 挂载应用

![](https://static.meowrain.cn/i/2024/01/11/lr1flj-3.webp)

应用实例必须在调用了 .mount() 方法后才会渲染出来。该方法接收一个“容器”参数，可以是一个实际的 DOM 元素或是一个 CSS 选择器字符串：

`app.mount('#app')`



