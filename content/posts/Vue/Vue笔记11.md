---
title: Vue笔记11-Vue keep-alive组件使用
subtitle:
date: 2024-05-18T14:16:44+08:00
slug: 0ad7053
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

# keep-alive组件作用

我们的要组件能在被“切走”的时候保留它们的状态。要解决这个问题，我们可以用 <KeepAlive> 内置组件将这些动态组件包装起来

```js
<!-- 非活跃的组件将会被缓存！ -->
<KeepAlive>
<component :is="activeComponent" />
</KeepAlive>
```

举例：

```vue
HomeView.vue
<template>
<div>
<el-button color="#626aef" @click="flag = !flag"> 切换组件</el-button>
<SonViewOne v-if="flag"/>
<SonViewTwo v-else/>

</div>
</template>
<script setup lang="ts">
import {ref} from 'vue'
import SonViewOne from './SonViewOne.vue';
import SonViewTwo from './SonViewTwo.vue';
let flag = ref<boolean>(false );
</script>
<style scoped></style>

```

```vue
SonViewOne.vue
<template>
  <div class="demo-date-picker">
    <div class="container">
      <div class="block">
        <span class="demonstration">Week</span>
        <el-date-picker
          v-model="value1"
          type="week"
          format="[Week] ww"
          placeholder="Pick a week"
        />
      </div>
      <div class="block">
        <span class="demonstration">Month</span>
        <el-date-picker
          v-model="value2"
          type="month"
          placeholder="Pick a month"
        />
      </div>
    </div>
    <div class="container">
      <div class="block">
        <span class="demonstration">Year</span>
        <el-date-picker
          v-model="value3"
          type="year"
          placeholder="Pick a year"
        />
      </div>
      <div class="block">
        <span class="demonstration">Dates</span>
        <el-date-picker
          v-model="value4"
          type="dates"
          placeholder="Pick one or more dates"
        />
      </div>
    </div>
  </div>
</template>
<script lang="ts" setup>
import { ref } from 'vue'

const value1 = ref('')
const value2 = ref('')
const value3 = ref('')
const value4 = ref('')
</script>
<style scoped>
.demo-date-picker {
  display: flex;
  width: 100%;
  padding: 0;
  flex-wrap: wrap;
}

.demo-date-picker .block {
  padding: 30px 0;
  text-align: center;
  border-right: solid 1px var(--el-border-color);
  flex: 1;
}
.demo-date-picker .block:last-child {
  border-right: none;
}

.demo-date-picker .container {
  flex: 1;
  border-right: solid 1px var(--el-border-color);
}
.demo-date-picker .container .block {
  border-right: none;
}
.demo-date-picker .container .block:last-child {
  border-top: solid 1px var(--el-border-color);
}
.demo-date-picker .container:last-child {
  border-right: none;
}

.demo-date-picker .demonstration {
  display: block;
  color: var(--el-text-color-secondary);
  font-size: 14px;
  margin-bottom: 20px;
}
</style>

```

```vue
SonViewTwo.vue
<template>
<el-form :model="form" label-width="120px">
  <el-form-item label="Activity name">
    <el-input v-model="form.name" />
  </el-form-item>
  <el-form-item label="Activity zone">
    <el-select v-model="form.region" placeholder="please select your zone">
      <el-option label="Zone one" value="shanghai" />
      <el-option label="Zone two" value="beijing" />
    </el-select>
  </el-form-item>
  <el-form-item label="Activity time">
    <el-col :span="11">
      <el-date-picker
        v-model="form.date1"
        type="date"
        placeholder="Pick a date"
        style="width: 100%"
      />
    </el-col>
    <el-col :span="2" class="text-center">
      <span class="text-gray-500">-</span>
    </el-col>
    <el-col :span="11">
      <el-time-picker v-model="form.date2" placeholder="Pick a time" style="width: 100%" />
    </el-col>
  </el-form-item>
  <el-form-item label="Instant delivery">
    <el-switch v-model="form.delivery" />
  </el-form-item>
  <el-form-item label="Activity type">
    <el-checkbox-group v-model="form.type">
      <el-checkbox label="Online activities" name="type" />
      <el-checkbox label="Promotion activities" name="type" />
      <el-checkbox label="Offline activities" name="type" />
      <el-checkbox label="Simple brand exposure" name="type" />
    </el-checkbox-group>
  </el-form-item>
  <el-form-item label="Resources">
    <el-radio-group v-model="form.resource">
      <el-radio label="Sponsor" />
      <el-radio label="Venue" />
    </el-radio-group>
  </el-form-item>
  <el-form-item label="Activity form">
    <el-input v-model="form.desc" type="textarea" />
  </el-form-item>
  <el-form-item>
    <el-button type="primary" @click="onSubmit">Create</el-button>
    <el-button>Cancel</el-button>
  </el-form-item>
</el-form>
</template>

<script lang="ts" setup>
import { reactive } from 'vue'

// do not use same name with ref
const form = reactive({
name: '',
region: '',
date1: '',
date2: '',
delivery: false,
type: [],
resource: '',
desc: ''
})

const onSubmit = () => {
console.log('submit!')
}
</script>

```

> ![](https://static.meowrain.cn/i/2024/01/23/spaz5x-3.webp) > ![](https://static.meowrain.cn/i/2024/01/23/sppuny-3.webp)
> 我们来填入表单一些内容，然后点击切换组件
> ![](https://static.meowrain.cn/i/2024/01/23/spv484-3.webp)
> 再切换回来
> ![](https://static.meowrain.cn/i/2024/01/23/spx41w-3.webp)
> 内容确实不见了

**下面我们来用keep-alive组件**

```vue
HomeView.vue
<template>
<div>
  <el-button color="#626aef" @click="flag = !flag"> 切换组件</el-button>
  <KeepAlive>
    <SonViewOne v-if="flag" />
    <SonViewTwo v-else />
  </KeepAlive>
</div>
</template>
<script setup lang="ts">
import { ref } from 'vue'
import SonViewOne from './SonViewOne.vue'
import SonViewTwo from './SonViewTwo.vue'
let flag = ref<boolean>(false)
</script>
<style scoped></style>

```

> 再次填入内容
> ![](https://static.meowrain.cn/i/2024/01/23/sqvfib-3.webp)
> 点击切换组件
> ![](https://static.meowrain.cn/i/2024/01/23/srjrx4-3.webp)
> 填入内容
> 再点击切换组件，看之前填的内容还在不在
> ![](https://static.meowrain.cn/i/2024/01/23/sryrmv-3.webp)
> ![](https://static.meowrain.cn/i/2024/01/23/ss2qiu-3.webp)
> 可以看到内容还在

# 一些参数

![](https://static.meowrain.cn/i/2024/01/23/ssl99q-3.webp)

# 新增生命周期

![](https://static.meowrain.cn/i/2024/01/23/ssv5he-3.webp)

![](https://static.meowrain.cn/i/2024/01/23/sspg97-3.webp)
