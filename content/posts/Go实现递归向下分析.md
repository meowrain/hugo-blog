---
title: Go实现递归向下分析
subtitle:
date: 2024-05-15T19:08:42+08:00
slug: 274359a
draft: false
description:
keywords:
license:
comment: true
weight: 0
tags:
  - 编译原理
  - Go
categories:
  - 编译原理
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



```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var (
	str         []byte
	pointer     int
	error_str   string = "Error: 非法的符号串"
	withNoSharp string = "Error: 符号串必须以#结尾"
)

// 打印颜色设置
const Red = "\033[31m"
const Green = "\033[32m"
const Reset = "\033[0m"
const Yellow = "\033[33m"

func match(token byte) {
	if pointer >= len(str) {
		errors(error_str)
		return
	}
	if str[pointer] == token {
		pointer++
	} else {
		errors(error_str)
	}
}

func errors(info string) {
	fmt.Println(Red, info, Reset)
	os.Exit(0)
}

func E() {
	fmt.Println("E() -> T() -> G()")
	T()
	G()
}

func T() {
	fmt.Println("T() -> F() -> S()")
	F()
	S()
}

func G() {

	if str[pointer] == '+' {
		match('+')
		fmt.Println("G() -> + -> T() -> G()")
		T()
		G()
	} else if str[pointer] == '-' {
		match('-')
		fmt.Println("G() -> - -> T() -> G()")
		T()
		G()
	} else {
		fmt.Println("G() -> epsilon")
	}
}

func F() {

	if str[pointer] == 'i' {
		match('i')
		fmt.Println("F() -> i")
	} else if str[pointer] == '(' {
		match('(')
		fmt.Println("F() -> ( -> E()")
		E()
		if pointer < len(str) && str[pointer] == ')' {
			match(')')
			fmt.Println("F() -> ( -> E() -> )")
		} else {
			errors("Error: 缺少右括号")
		}
	} else {
		errors("Error: 与i或者(不匹配")
	}
}

func S() {

	if str[pointer] == '*' {
		match('*')
		fmt.Println("S() -> * -> F() -> S()")
		F()
		S()
	} else if str[pointer] == '/' {
		match('/')
		fmt.Println("S() -> / -> F() -> S()")
		F()
		S()
	} else {
		fmt.Println("S() -> epsilon")
	}
}

func checkSuccess() {
	if pointer == len(str)-1 && str[pointer] == '#' {
		fmt.Println(Green, string(str), "Success: 符号串匹配成功", Reset)
	} else {
		errors(error_str)
	}
	os.Exit(0)
}

func main() {
	fmt.Println(Yellow, "编制人: ", Reset)
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println(Yellow, "请输入符号串:", Reset)
	if scanner.Scan() {
		input := scanner.Text()
		if !strings.HasSuffix(input, "#") { //判断是否以#结尾
			errors(withNoSharp)
			return
		}
		str = []byte(input)
		fmt.Println("读入的字符串为:", string(str))
		E()
		checkSuccess()
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "读取输入时发生错误:", err)
	}
}

```
