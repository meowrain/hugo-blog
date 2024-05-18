---
title: Vue笔记12-Vue插槽使用
subtitle:
date: 2024-05-18T14:17:12+08:00
slug: 56af5d5
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

# 简单使用
**TestView.vue**
```js
<script setup lang="ts">
</script>
<template>
<div class="parent">
    <slot>
    </slot>
</div>
</template>
<style scoped>
.parent {
    width: 100px;
    height: 100px;
    background-color: aquamarine;
}
</style>
```

**HomeView.vue**
```js
<script setup lang="ts">
import TestView from '../views/TestView.vue'
</script>
<template>
  <div>
<TestView>
  <template v-slot>
    <p>HelloWOrld</p>
  </template>
</TestView>
  </div>
</template>
<style scoped>

</style>

```

# 具名插槽
TestView.vue
```js
<script setup lang="ts"></script>
<template>
  <div class="parent">
    <slot name="header"></slot>
    <slot> </slot>
    <slot name="footer"></slot>
  </div>
</template>
<style scoped>
.parent {
  width: 100px;
  height: 100px;
  background-color: aquamarine;
}
</style>

```

HomeVIew
```js
<script setup lang="ts">
import TestView from '../views/TestView.vue'
</script>
<template>
  <div>
<TestView>
  <template v-slot:header>
    <p>header</p>
  </template>
  <template v-slot>
    <p>body</p>
  </template>
  <template v-slot:footer>
    <p>footer</p>
  </template>
</TestView>
  </div>
</template>
<style scoped>

</style>

```
# 作用域插槽
HomeView.vue
```js
<script setup lang="ts">
import TestView from '../views/TestView.vue'
</script>
<template>
  <div>
<TestView>
  <template v-slot:header>
    <p>header</p>
  </template>
  <template v-slot="{data}">
    <p>body{{ data }}</p>
  </template>
  <template v-slot:footer>
    <p>footer</p>
  </template>
</TestView>
  </div>
</template>
<style scoped>

</style>

```


TestView.vue
```js
<script setup lang="ts">
import {ref} from 'vue';
let data = ref("meowrain");
</script>
<template>
  <div class="parent">
    <slot name="header"></slot>
    <slot :data="data"> </slot>
    <slot name="footer"></slot>
  </div>
</template>
<style scoped>
.parent {
  width: 100px;
  height: 100px;
  background-color: aquamarine;
}
</style>

```

![](https://static.meowrain.cn/i/2024/01/22/1170g4s-3.webp)