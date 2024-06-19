---
title: JavaPO,BO,VO,DTO,POJO,DAO概念
subtitle:
date: 2024-05-23T12:12:28+08:00
slug: 31c8a8c
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - 后端开发
  - Java
categories:
  - Java
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

# Java PO,BO,VO,DTO,POJO,DAO概念

> [一篇文章讲清楚VO，BO，PO，DO，DTO的区别 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/102389552)

![](https://static.meowrain.cn/i/2023/11/16/h1d0pz-3.webp)
## POJO (Plain Old Java Object)
Java POJO  (Plain Old Java Object) 是指一个最基本的、普通的Java对象。POJO通常具有以下特点:

只包含私有属性,没有public、protected的属性。属性通常用private修饰。
提供getter和setter方法来访问和修改属性。
不继承或实现任何特定的接口和类。
不包含任何注解。
不依赖外部jar包和类库。
除了基本的构造方法、`getter/setter`方法、`equals/hashCode/toString`方法之外,没有任何其他方法。
POJO主要用于表示简单的数据结构,其设计符合面向对象的基本原则,可以很方便地进行序列化和反序列化。在Java Web应用中,POJO常用来接收和传递数据,例如作为Model对象。Spring框架也大量采用POJO设计模式。所以简单来说,POJO就是一个最基本的Java类,没有复杂的依赖关系,用来表示简单的数据模型。

## **DTO（Data Transfer Object）数据传输对象**

DTO是一个比较特殊的对象，他有两种存在形式：

在后端，他的存在形式是java对象，也就是在controller里面定义的那个东东，通常在后端不需要关心怎么从json转成java对象的，这个都是由一些成熟的框架帮你完成啦，比如spring框架

在前端，他的存在形式通常是js里面的对象（也可以简单理解成json），也就是通过ajax请求的那个数据体

这也是为什么把他画成横跨两层的原因

这里可能会遇到个问题，现在微服务盛行，服务和服务之间调用的传输对象能叫DTO吗？  
我的理解是看情况  
DTO本身的一个隐含的意义是要能够完整的表达一个业务模块的输出  
如果服务和服务之间相对独立，那就可以叫DTO  
如果服务和服务之间不独立，每个都不是一个完整的业务模块，拆开可能仅仅是因为计算复杂度或者性能的问题，那这就不能够叫做DTO，只能是BO

## VO (View Object)

VO就是展示用的数据，不管展示方式是网页，还是客户端，还是APP，只要是这个东西是让人看到的，这就叫VO  
VO主要的存在形式就是js里面的对象（也可以简单理解成json）

## VO和DTO的区别

![](https://static.meowrain.cn/i/2023/11/16/h2riqy-3.webp)

## PO(bean,entity等命名)

`Persisitant Object` 持久对象，数据库表中的记录在java对象中的显示状态

一个PO的数据结构对应着库中表的结构，表中的一条记录就是一个PO对象

通常PO里面除了get，set之外没有别的方法  
对于PO来说，数量是相对固定的，一定不会超过数据库表的数量  
等同于Entity，这俩概念是一致的

**BO（Business Object）业务对象**  
BO就是PO的组合  
简单的例子比如说PO是一条交易记录，BO是一个人全部的交易记录集合对象  
复杂点儿的例子PO1是交易记录，PO2是登录记录，PO3是商品浏览记录，PO4是添加购物车记录，PO5是搜索记录，BO是个人网站行为对象  
BO是一个业务对象，一类业务就会对应一个BO，数量上没有限制，而且BO会有很多业务操作，也就是说除了get，set方法以外，BO会有很多针对自身数据进行计算的方法  
为什么BO也画成横跨两层呢？原因是现在很多持久层框架自身就提供了数据组合的功能，因此BO有可能是在业务层由业务来拼装PO而成，也有可能是在数据库访问层由框架直接生成  
很多情况下为了追求查询的效率，框架跳过PO直接生成BO的情况非常普遍，PO只是用来增删改使用

## **BO和DTO的区别**  
这两个的区别主要是就是字段的删减  
BO对内，为了进行业务计算需要辅助数据，或者是一个业务有多个对外的接口，BO可能会含有很多接口对外所不需要的数据，因此DTO需要在BO的基础上，只要自己需要的数据，然后对外提供  
在这个关系上，通常不会有数据内容的变化，内容变化要么在BO内部业务计算的时候完成，要么在解释VO的时候完成


## DAO(Data Access Object) 数据访问对象
> DAO(Data Access Object) 是数据访问对象的简称,是JavaWeb应用中用于封装对数据源的访问的组件。

DAO主要具有以下特征:

封装了对数据源(通常是关系型数据库)的访问,屏蔽了数据源的访问细节。
定义了操作数据所需要的接口方法,例如 CRUD(创建、读取、更新、删除)接口。
与具体的数据源解耦,如果需要改变底层的数据源,只需要改变DAO层的实现,不影响调用它的Service层。
通常与POJO和Model对象交互,将Model对象持久化到数据库,或者从数据库读取数据到Model对象。
不同的DAO负责不同的数据模型对象,DAO可以分为UserDAO、ProductDAO等。
DAO被Service层调用,Service层依赖DAO执行数据访问和持久化操作。
所以DAO层主要作用是为高层应用屏蔽数据库的访问细节,提供简单的CRUD接口来操作POJO对象,实现业务逻辑和数据访问的分离。它是表现层和持久层之间的桥梁和中介。