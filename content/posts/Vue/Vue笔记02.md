---
title: Vue笔记02-模板语法
subtitle:
date: 2024-05-18T14:10:34+08:00
slug: f3a212f
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

# 模板语法

## 文本插值
最基本的数据绑定形式是文本插值，它使用的是“Mustache”语法 (即双大括号)：

```vue
<span>Message: {{ msg }}</span>
```

例子：
```vue
App.vue
<script setup>
const msg = 10;
</script>
<template>
<div>
  <p>HelloWorld</p>
  <br>
  <p>{{ msg }}</p>
</div>
</template>
<style scoped>
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/lu47ok-3.webp)

## 原始 HTML

双大括号会将数据解释为纯文本，而不是 HTML。若想插入 HTML，你需要使用 v-html 指令：

```vue
<p>Using text interpolation: {{ rawHtml }}</p>
<p>Using v-html directive: <span v-html="rawHtml"></span></p>
```

例子：
```vue
<script setup>
const rawHtml = `<span style="color: red">This should be red.</span>`;
</script>
<template>
<div>
  <p>HelloWorld</p>
  <br>
  <p>{{ rawHtml }}</p>

  <p v-html="rawHtml"></p>
</div>
</template>
<style scoped>
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/lvdeck-3.webp)

> 在网站上动态渲染任意 HTML 是非常危险的，因为这非常容易造成 XSS 漏洞。请仅在内容安全可信时再使用 v-html，并且永远不要使用用户提供的 HTML 内容。

## Attribute 绑定

双大括号不能在 HTML attributes 中使用。想要响应式地绑定一个 attribute，应该使用 v-bind 指令：

```vue
<div v-bind:id="dynamicId"></div>
```

v-bind 指令指示 Vue 将元素的 id attribute 与组件的 dynamicId 属性保持一致。如果绑定的值是 null 或者 undefined，那么该 attribute 将会从渲染的元素上移除。


例子：
```vue

<script setup>
const dynamicId = "name";
</script>
<template>
<div>
  <p v-bind:id="dynamicId">HelloWorld</p>
  <br>

</div>
</template>
<style scoped>
#name {
  color: red;
  font-size: 100px;
}
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/m3mgyv-3.webp)

### 简写​
因为 v-bind 非常常用，我们提供了特定的简写语法：
`<div :id="dynamicId"></div>`

例子：
```vue

<script setup>
const dynamicId = "name";
</script>
<template>
<div>
  <p :id="dynamicId">HelloWorld</p>
  <br>

</div>
</template>
<style scoped>
#name {
  color: red;
  font-size: 100px;
}
</style>
```

## 布尔型 Attribute
布尔型 attribute 依据 true / false 值来决定 attribute 是否应该存在于该元素上。disabled 就是最常见的例子之一。


`<button :disabled="isButtonDisabled">Button</button>`

例子：
```vue
<script setup>
const isDisabled = false;
</script>
<template>
<div>
  <p>HelloWorld</p>
  <br>

  <button :disabled="isDisabled">Button</button>
</div>
</template>
<style scoped>
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/mbbunv-3.webp)

> 如果设置`isDisabled`为false,这个按钮就在页面上消失了



> 当 isDisabled 为真值或一个空字符串 (即 <button disabled="">) 时，元素会包含这个 disabled attribute。而当其为其他假值时 attribute 将被忽略。


## 动态绑定多个值

定义一个对象，其中为标签属性，例如

```js
const attributes = {
    id: "btn",
    class: "btn_fonts"
}
```

例子：
```vue
<script setup>
const attributes = {
  id: "btn",
  class: "btn_fonts"
};
</script>
<template>
<div>
  <p>HelloWorld</p>
  <br>
  <button v-bind="attributes">Button</button>
</div>
</template>
<style scoped>
#btn {
  width: 100px;
  height: 200px;
  background-color: aquamarine;
}
.btn_fonts {
  color: red;
  font-size: 34px;
}
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/mgosir-3.webp)

## 使用 JavaScript 表达式
Vue 实际上在所有的数据绑定中都支持完整的 JavaScript 表达式：

```jsx
{{ number + 1 }}

{{ ok ? 'YES' : 'NO' }}

{{ message.split('').reverse().join('') }}

<div :id="`list-${id}`"></div>

```

在 Vue 模板内，JavaScript 表达式可以被使用在如下场景上：

- 在文本插值中 (双大括号)
- 在任何 Vue 指令 (以 v- 开头的特殊 attribute) attribute 的值中

例子：
```vue

<script setup>
const useClass2 = false;
const message = "helloworld";
</script>
<template>
<div>
  <p :class="useClass2 ? 'class2':'class1'">{{ message.split('').reverse().join('~') }}</p>
  <br>
</div>
</template>
<style scoped>
.class1 {
  color: aliceblue;
  font-size: 100px;
  font-weight: lighter;
}
.class2 {
  color: red;
  font-size: 40px;
  font-weight: bolder;
}
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/n8ocfm-3.webp)

## 仅支持表达式

每个绑定仅支持单一表达式，也就是一段能够被求值的 JavaScript 代码。一个简单的判断方法是是否可以合法地写在 return 后面。

```vue

<!-- 这是一个语句，而非表达式 -->
{{ var a = 1 }}

<!-- 条件控制也不支持，请使用三元表达式 -->
{{ if (ok) { return message } }}

```


## 调用函数

可以在绑定的表达式中使用一个组件暴露的方法：

```vue
<p :title="toUp('meowrain')">{{ toUp("meowrain") }}</p>
```

例子：
```vue
<script setup>
function toUp(value){
  return value.toUpperCase();
}
</script>
<template>
<div>
  <p :title="toUp('meowrain')">{{ toUp("meowrain") }}</p>
  <br>
</div>
</template>
<style scoped>
</style>
```

![](https://static.meowrain.cn/i/2024/01/11/ngcn1b-3.webp)

> 绑定在表达式中的方法在组件每次更新时都会被重新调用，因此不应该产生任何副作用，比如改变数据或触发异步操作。

## 指令 Directives

https://cn.vuejs.org/api/built-in-directives.html

指令是带有 v- 前缀的特殊 attribute。Vue 提供了许多内置指令，包括上面我们所介绍的 v-bind 和 v-html。


指令 attribute 的期望值为一个 JavaScript 表达式 (除了少数几个例外，即之后要讨论到的 v-for、v-on 和 v-slot)。一个指令的任务是在其表达式的值变化时响应式地更新 DOM。以 v-if 为例：

`<p v-if="seen">Now you see me</p>`

这里，v-if 指令会基于表达式 seen 的值的真假来移除/插入该 <p> 元素。

![](https://static.meowrain.cn/i/2024/01/11/pb0wke-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/pb2xrw-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/pb4rfr-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/pb6h08-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/pbixm2-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/pbl36k-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/pbqan4-3.webp)

https://cn.vuejs.org/api/built-in-directives.html#v-on
![](https://static.meowrain.cn/i/2024/01/11/pczpo7-3.webp)

...
> 还有几个具体的自己看文档吧，文档写的很详细


## 参数 Arguments

某些指令会需要一个“参数”，在指令名后通过一个冒号隔开做标识。例如用 v-bind 指令来响应式地更新一个 HTML attribute：

```vue
<a v-bind:href="url"> ... </a>

<!-- 简写 -->
<a :href="url"> ... </a>
```

这里 href 就是一个参数，它告诉 v-bind 指令将表达式 url 的值绑定到元素的 href attribute 上。在简写中，参数前的一切 (例如 v-bind:) 都会被缩略为一个 : 字符。
另一个例子是 v-on 指令，它将监听 DOM 事件：

```vue

<a v-on:click="doSomething"> ... </a>

<!-- 简写 -->
<a @click="doSomething"> ... </a>
```


这里的参数是要监听的事件名称：click。v-on 有一个相应的缩写，即 @ 字符。我们之后也会讨论关于事件处理的更多细节。


### 动态参数

同样在指令参数上也可以使用一个 JavaScript 表达式，需要包含在一对方括号内：

```vue
<!--
注意，参数表达式有一些约束，
参见下面“动态参数值的限制”与“动态参数语法的限制”章节的解释
-->
<a v-bind:[attributeName]="url"> ... </a>

<!-- 简写 -->
<a :[attributeName]="url"> ... </a>
```

这里的 attributeName 会作为一个 JavaScript 表达式被动态执行，计算得到的值会被用作最终的参数。举例来说，如果你的组件实例有一个数据属性 attributeName，其值为 "href"，那么这个绑定就等价于 v-bind:href。

相似地，你还可以将一个函数绑定到动态的事件名称上：
```vue

<a v-on:[eventName]="doSomething"> ... </a>

<!-- 简写 -->
<a @[eventName]="doSomething">
```

在此示例中，当 eventName 的值是 "focus" 时，v-on:[eventName] 就等价于 v-on:focus。

### 动态参数值的限制​
> 动态参数中表达式的值应当是一个字符串，或者是 null。特殊值 null 意为显式移除该绑定。其他非字符串的值会触发警告。

### 动态参数语法的限制

动态参数表达式因为某些字符的缘故有一些语法限制，比如空格和引号，在 HTML attribute 名称中都是不合法的。例如下面的示例：

```vue
<!-- 这会触发一个编译器警告 -->
<a :['foo' + bar]="value"> ... </a>
```


当使用 DOM 内嵌模板 (直接写在 HTML 文件里的模板) 时，我们需要避免在名称中使用大写字母，因为浏览器会强制将其转换为小写：
`<a :[someAttr]="value"> ... </a>`

上面的例子将会在 DOM 内嵌模板中被转换为 `:[someattr]`。如果你的组件拥有 “someAttr” 属性而非 “someattr”，这段代码将不会工作。单文件组件内的模板不受此限制。

## 修饰符 Modifiers

修饰符是以点开头的特殊后缀，表明指令需要以一些特殊的方式被绑定。例如 .prevent 修饰符会告知 v-on 指令对触发的事件调用 event.preventDefault()：

```vue
<form @submit.prevent="onSubmit">...</form>
```
![](https://static.meowrain.cn/i/2024/01/11/pkjk6y-3.webp)


