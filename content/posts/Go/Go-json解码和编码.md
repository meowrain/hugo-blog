---
title: Go Json解码和编码
subtitle:
date: 2024-05-18T13:00:48+08:00
slug: 35b4611
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - json编码解码
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
math: true
lightgallery: true
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

```go
vcard.go

package vcard

import (
	"time"
)

type Address struct {
	Street           string
	HouseNumber      uint32
	HouseNumberAddOn string
	POBox            string
	ZipCode          string
	City             string
	Country          string
}

type VCard struct {
	FirstName string
	LastName  string
	NickName  string
	BirtDate  time.Time
	Photo     string
	Addresses map[string]*Address
}

```
---

```go
jsonUtil.go
package utils

import (
	"encoding/json"
)

func ToJson(data any) string {
	js, _ := json.Marshal(data)
	return string(js)
}

```


---

```go
main.go

package main

import (
	. "awesomeProject/utils"
	. "awesomeProject/vcard"
	"encoding/json"
	"fmt"
	"os"
	"time"
)

func main() {
	pa := &Address{Street: "private", HouseNumber: 10086, HouseNumberAddOn: "Belgium"}
	wa := &Address{Street: "work", HouseNumber: 10008611, HouseNumberAddOn: "Belgium"}
	vc := VCard{FirstName: "Jan", LastName: "Kersschot", NickName: "Mike", BirtDate: time.Date(1956, 1, 17, 15, 4, 5, 0, time.Local)}
	str := ToJson(vc)
	fmt.Println(str)
	str = ToJson(wa)
	fmt.Println(str)
	str = ToJson(pa)
	fmt.Println(str)
	//写入到vcard.json文件
	file, err := os.Create("vcard.json")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	encoder := json.NewEncoder(file)
	err = encoder.Encode(vc)
	if err != nil {
		return
	}
	fmt.Println("vcard.json created")

	//读取vcard.json文件
	file, err = os.Open("vcard.json")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	decoder := json.NewDecoder(file)
	var vcard VCard
	err = decoder.Decode(&vcard)
	if err != nil {
		return
	}
	fmt.Println(vcard)
}

```

> 出于安全考虑，在 web 应用中最好使用 json.MarshalforHTML() 函数，其对数据执行HTML转码，所以文本可以被安全地嵌在 HTML` <script> `标签中。

> json.NewEncoder() 的函数签名是 func NewEncoder(w io.Writer) *Encoder，返回的Encoder类型的指针可调用方法 Encode(v interface{})，将数据对象 v 的json编码写入 io.Writer w 中。

---
  
  
  
![](https://static.meowrain.cn/i/2024/05/16/w48pic-3.webp)