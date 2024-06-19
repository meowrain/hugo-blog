---
title: Go实现词法分析器
subtitle:
date: 2024-05-15T19:11:35+08:00
slug: 1e5f18a
draft: false
author:
  name:
  link:
  email:
  avatar:
description:
keywords:
license:
comment: false
weight: 0
tags:
  - Go
  - 编译原理
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

<!--more-->
```go
package main

import (
	"bufio"
	"fmt"
	"os"
	"unicode"
)

var keywords = map[string]int{
	"begin": 1,
	"if":    2,
	"then":  3,
	"while": 4,
	"do":    5,
	"end":   6,
}

func lexicalAnalysis(input string) { //词法分析程序
	var p int = 0
	scanner := func() (int, string) {
		var syn int
		var token string
		for p < len(input) && input[p] == ' ' {
			p++ //跳过空格
		}
		if unicode.IsLetter(rune(input[p])) {
			for p < len(input) && (unicode.IsLetter(rune(input[p])) || unicode.IsDigit(rune(input[p]))) { //如果当前是字符，那么把它加入到token中
				token += string(input[p])
				p++
			}
			_, ok := keywords[token]
			if ok {
				syn = keywords[token]
			} else {
				syn = 10
			}
		} else {
			if unicode.IsDigit(rune(input[p])) {
				syn = 11
				token = string(input[p])
				p++

			} else {
				switch input[p] {
				case '+':
					token = "+"
					syn = 13
					p++
				case '-':
					token = "-"
					syn = 14
					p++
				case '*':
					token = "*"
					syn = 15
					p++
				case '/':
					token = "/"
					syn = 16
					p++
				case ':':
					if p+1 < len(input) && input[p+1] == '=' {
						syn = 18
						token = ":="
						p += 2
					} else {
						token = ":"
						syn = 17
						p++
					}
				case '<':
					if p+1 < len(input) && input[p+1] == '>' {
						syn = 21
						token = "<>"
						p += 2
					} else if p+1 < len(input) && input[p+1] == '=' {
						syn = 22
						token = "<="
						p += 2
					} else {
						syn = 20
						token = "<"
						p++
					}
				case '>':
					if p+1 < len(input) && input[p+1] == '=' {
						syn = 24
						token = ">="
						p += 2
					} else {
						syn = 23
						token = ">"
						p++
					}
				case '=':
					syn = 25
					token = "="
					p++
				case ';':
					syn = 26
					token = ";"
					p++
				case '(':
					syn = 27
					token = "("
					p++
				case ')':
					syn = 28
					token = ")"
					p++
				case '#':
					syn = 0
					token = "#"
					p++
				default:
					syn = -1
					token = string(input[p])
					p++
				}
			}
		}

		return syn, token
	}
	for p < len(input) {
		syn, token := scanner()
		if syn == -1 {
			fmt.Println("错误：非法字符", token)
			break
		} else {
			res := fmt.Sprintf("(%d,%s)", syn, token)
			fmt.Print(res + " ")
		}
	}

}

func main() {
	fmt.Printf("请输入代码段\n")
	reader := bufio.NewReader(os.Stdin)
	readBytes, _, _ := reader.ReadLine()
	var codeSegment string = string(readBytes)

	//input := "begin x:=9;if x>0 then x:=2*x+1/3;end#"
	lexicalAnalysis(codeSegment)

}

```