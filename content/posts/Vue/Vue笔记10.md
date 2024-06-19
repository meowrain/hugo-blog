---
title: Vue笔记10-Vue组件值传递
subtitle:
date: 2024-05-18T14:16:18+08:00
slug: 7729ec4
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

# 父子组件传值
## 父组件向子组件传值
`defineProps`

父组件
```js
<script setup lang="ts">
import { onMounted, ref } from 'vue'
import TestView from '../views/TestView.vue'
let imgUrl = ref<string>()
onMounted(async ()=>{
    const response = await fetch('https://api.waifu.pics/sfw/waifu')
    const json = await response.json()
    imgUrl.value = json.url;
})
</script>

<template>
  <div>
    <TestView :url="imgUrl"/>
  </div>
</template>
<style></style>

```


子组件
```js
<script setup lang="ts">
import { defineProps, toRef, watch, watchEffect } from 'vue';
const props = defineProps({
    url:String
})

watch(()=>props.url,(newVal,oldVal)=>{
    console.log(newVal);
},{
    flush:'post'
})

// watchEffect(()=>{
//     console.log(props.url);
// })
</script>
<template>
    <img :src="url"  width="100px" height="100px"/>
    <div>{{ url }}</div>
    
</template>
<style scoped ></style>
```

> 上面用watch函数就是因为刚开始还没获取数据，props是undefined的，这时候如果在子组件中直接输出props内容，会显示undefined.在数据获取到后，props才会有值
> 也就是说，props是会发生一次变化的，那就正好符合watch函数的特性了，我们利用watch函数就能获取到这个props的新值了


---

## 子组件向父组件传值
`defineEmits`

**子组件**
```js
<script setup lang="ts">
const emit = defineEmits(['even','change'])
/**
 *  //这里的数组里面写的字符串是事件名,如下，低一个按钮利用even事件传递对象数组数据，第二个按钮利用change事件传递
 *  // 字符串数据，父组件使用感@even和@change 接收
 */
let send = () => {
  emit('even', [
    {
      name: 'meow',
      age: 12
    },
    {
      name: 'sss',
      age: 20
    },
    {
      name: 'sfasdfasdf',
      age: 3434
    }
  ])
}
let sned2 = ()=>{
    emit('change',"meowrian")
}
</script>
<template>
  <div>子集</div>
  <button @click="send">Send</button>
  <button @click="sned2">Send2</button>
</template>

<style scoped></style>

```


---

**父组件**

```js
<script setup lang="ts">
import TestView from '../views/TestView.vue'
const getName = (objsArray:Object[])=>{
    for(let obj of objsArray) {
        console.log(obj);
    }
}
const getName2 = (name:string)=>{
    console.log(name);
}
</script>

<template>
  <div>
    <TestView @even="getName" @change="getName2"/>
    
  </div>
</template>
<style></style>
```

![](https://static.meowrain.cn/i/2024/01/22/s9shri-3.webp)


## 子组件向父组件暴露方法和属性
`defineExpose`
子组件
```js
<script setup lang="ts">
defineExpose({name:"meowrain"})
</script>
<template>
    <div class="box">
        <p>子组件</p>
    </div>
</template>
<style scoped>
.box {
    width:200px;
    height:200px;
    background-color: aquamarine;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>
```


---

父组件
```js
<script setup lang="ts">
import {onMounted, ref} from 'vue'
import TestView from '../views/TestView.vue'
const testView = ref<InstanceType<typeof TestView>>();
onMounted(()=>{
    console.log(testView.value?.name);
})
</script>

<template>
  <div class="parentBox">
    <TestView ref="testView"/>
    
  </div>
</template>
<style>
.parentBox {
    
    width:400px;
    height:400px;
    background-color: tomato;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>

```

> 使用onMounted函数是为了获取值，因为我们必须在子组件mounted之后，才能拿到值

![](https://static.meowrain.cn/i/2024/01/22/shl4sq-3.webp)