---
title: Go接口
subtitle:
date: 2024-05-15T19:06:01+08:00
slug: b3efa23
draft: false
description:
keywords:
license:
comment: true
weight: 0
tags:
  - Go
  - Go接口
categories:
  - Go
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
math: false
lightgallery: false
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

# Go 接口

## 接口定义

> Go语言提倡面向接口编程。

## 指针接收者实现接口

```GO
package main

import "fmt"

// 接口定义
type USB interface {
	Connect()
	Disconnect()
}
type Laptop struct {
	name    string
	version string
}

type Desktop struct {
	name    string
	version string
}

// 实现USB接口
func (laptop *Laptop) Connect() {
	fmt.Println("USB Connecting to", laptop.name)
}
func (laptop *Laptop) Disconnect() {
	fmt.Println("USB Disconnecting from", laptop.name)
}
func (desktop *Desktop) Connect() {
	fmt.Println("USB Connecting to", desktop.name)
}
func (desktop *Desktop) Disconnect() {
	fmt.Println("USB Disconnecting from", desktop.name)
}
func main() {
	var legion_laptop Laptop = Laptop{
		name:    "Legion Y7000P",
		version: "2022",
	}
	var legion_desktop2 *Desktop = &Desktop{
		name:    "Legion Y9000P",
		version: "2023",
	}
	var legion_desktop Desktop = Desktop{
		name:    "Legion Desktop Computer",
		version: "2023",
	}
	var x USB = legion_laptop
	x.Disconnect()
	x.Connect()
	x = legion_desktop2
	x.Connect()
	x.Disconnect()
	x = legion_desktop
	x.Connect()
	x.Disconnect()
}

```

> 当我们写成这样的时候，可以看到![image-20240417144720008](https://static.meowrain.cn/i/2024/04/17/nxo6bh-3.webp)
>
> 也就是说，当我们使用指针接收者的时候，是不能传递结构体变量给接口变量的

## 值接收者实现接口

```go
package main

import "fmt"

// 接口定义
type USB interface {
	Connect()
	Disconnect()
}
type Laptop struct {
	name    string
	version string
}

type Desktop struct {
	name    string
	version string
}

// 实现USB接口
func (laptop Laptop) Connect() {
	fmt.Println("USB Connecting to", laptop.name)
}
func (laptop Laptop) Disconnect() {
	fmt.Println("USB Disconnecting from", laptop.name)
}
func (desktop Desktop) Connect() {
	fmt.Println("USB Connecting to", desktop.name)
}
func (desktop Desktop) Disconnect() {
	fmt.Println("USB Disconnecting from", desktop.name)
}
func main() {
	var legion_laptop Laptop = Laptop{
		name:    "Legion Y7000P",
		version: "2022",
	}
	var legion_desktop2 *Desktop = &Desktop{
		name:    "Legion Y9000P",
		version: "2023",
	}
	var legion_desktop Desktop = Desktop{
		name:    "Legion Desktop Computer",
		version: "2023",
	}
	var x USB = legion_laptop
	x.Disconnect()
	x.Connect()
	x = legion_desktop2
	x.Connect()
	x.Disconnect()
	x = legion_desktop
	x.Connect()
	x.Disconnect()
}

```



> 我们可以发现，使用值接收者实现接口之后，不管是Laptop的结构体还是其结构体指针，都可以赋值给接口变量



## 一个类型实现多个接口

一个类型可以同时实现多个接口，而接口间彼此独立，不知道对方的实现

```go
package main

import "fmt"

type Payer interface {
	Pay()
}
type Talker interface {
	Talk()
}
type AliPay struct {
}
type Wechat struct {
}

func (w Wechat) Pay() {
	fmt.Println("Wechat Pay")
}
func (w Wechat) Talk() {
	fmt.Println("Wechat Talk")
}
func (a AliPay) Pay() {
	fmt.Println("AliPay Pay")
}
func (a AliPay) Talk() {
	fmt.Println("AliPay Talk")
}
func main() {
	var payer Payer = AliPay{}
	payer.Pay()
	payer = Wechat{}
	payer.Pay()

	var talker Talker = Wechat{}
	talker.Talk()
	talker = AliPay{}
	talker.Talk()
}

```

## 接口嵌套

接口与接口间可以通过嵌套创造出新的接口。

```go
package main

import "fmt"

type Payer interface {
	Pay()
}
type Talker interface {
	Talk()
}
type AliPay struct {
}
type Wechat struct {
}
type Tooler interface {
	Payer
	Talker
}

func (w Wechat) Pay() {
	fmt.Println("Wechat Pay")
}
func (w Wechat) Talk() {
	fmt.Println("Wechat Talk")
}
func (a AliPay) Pay() {
	fmt.Println("AliPay Pay")
}
func (a AliPay) Talk() {
	fmt.Println("AliPay Talk")
}
func main() {
	var tool Tooler = AliPay{}
	tool.Talk()
	tool.Pay()
	tool = Wechat{}
	tool.Talk()
	tool.Pay()
}

```

## 空接口

空接口是指没有定义任何方法的接口。因此任何类型都实现了空接口。

空接口类型的变量可以存储任意类型的变量。

```go
package main

import "fmt"

func show(anything interface{}) {
	fmt.Println(anything)
}

type Animal struct {
	name string
	age  int
}

func main() {
	show("fdsafdasf")
	show(123)

	show(Animal{
		"neko",
		12,
	})
}

```

> 可以用**any**来替代



空接口还可以作为map的value值

```go
package main

import "fmt"

func main() {
	var studentInfo = make(map[string]interface{})
	//var studentInfo = make(map[string]any)
	studentInfo["name"] = "meowrain"
	studentInfo["age"] = 12
	studentInfo["hobby"] = "play computer"
	fmt.Println(studentInfo)
}

```



## 类型断言

### 接口值

一个接口的值（简称接口值）是由一个具体类型和具体类型的值两部分组成的。这两部分分别称为接口的动态类型和动态值。

判断空接口中的这个值可以用类型断言

`x.(T)`



```go
package main

import "fmt"

func show(anything interface{}) {
	v, ok := anything.(string)
	if ok {
		fmt.Println(v)
	} else {
		fmt.Println("not string")
	}
}
func main() {
	show("fdsfdsafa")
	show(23)
}

```

![](https://static.meowrain.cn/i/2024/04/17/ovkmwx-3.webp)



