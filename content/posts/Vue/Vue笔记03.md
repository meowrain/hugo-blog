---
title: Vue笔记03-声明响应式状态
subtitle:
date: 2024-05-18T14:11:27+08:00
slug: 58ef168
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

# 声明响应式状态
## `ref()​`
在组合式 API 中，推荐使用 ref() 函数来声明响应式状态：

```vue
import { ref } from 'vue'

const count = ref(0)
```

ref() 接收参数，并将其包裹在一个带有 `.value `属性的 ref 对象中返回：

```js
const count = ref(0)

console.log(count) // { value: 0 }
console.log(count.value) // 0

count.value++
console.log(count.value) // 1
```

要在组件模板中访问 ref，请从组件的 setup() 函数中声明并返回它们：

```js
import { ref } from 'vue'

export default {
  // `setup` 是一个特殊的钩子，专门用于组合式 API。
  setup() {
    const count = ref(0)

    // 将 ref 暴露给模板
    return {
      count
    }
  }
}
```


> 注意，在模板中使用 ref 时，我们不需要附加 .value。为了方便起见，当在模板中使用时，ref 会自动解包 (有一些注意事项)。

```vue
<script setup>
import {ref} from 'vue';
const count = ref(0);
function increment(){
  count.value++;
  return count;
}
</script>
<template>
<div>
  <button v-on:click="count++">{{ count }}</button>
  <hr>
  <button v-on:click="increment">{{ count }}</button>
</div>
</template>
<style scoped>
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/po1udo-3.webp)

### 为什么要使用 ref？

你可能会好奇：为什么我们需要使用带有 .value 的 ref，而不是普通的变量？为了解释这一点，我们需要简单地讨论一下 Vue 的响应式系统是如何工作的。

当你在模板中使用了一个 ref，然后改变了这个 ref 的值时，Vue 会自动检测到这个变化，并且相应地更新 DOM。这是通过一个基于依赖追踪的响应式系统实现的。当一个组件首次渲染时，Vue 会追踪在渲染过程中使用的每一个 ref。然后，当一个 ref 被修改时，它会触发追踪它的组件的一次重新渲染。

另一个 ref 的好处是，与普通变量不同，你可以将 ref 传递给函数，同时保留对最新值和响应式连接的访问。当将复杂的逻辑重构为可重用的代码时，这将非常有用。

## 深层响应性
`Ref` 可以持有任何类型的值，包括深层嵌套的对象、数组或者 JavaScript 内置的数据结构，比如 Map。
