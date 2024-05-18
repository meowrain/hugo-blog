---
title: Go Gophercises
subtitle:
date: 2024-05-18T13:04:56+08:00
slug: 33dc7d7
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Go-exercises
  - Go
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

> https://courses.calhoun.io/courses/cor_gophercises

# 1. Quiz

https://github.com/gophercises/quiz

```
第一部分：
编写一个程序，该程序能够读取通过CSV文件提供的测验（详细信息如下），并向用户展示此测验。程序需记录用户答对和答错的题目数量。无论答案正确与否，都应立即提出下一题。

默认情况下，CSV文件名为problems.csv，但用户应能通过标志自定义文件名。

CSV文件的格式如下：第一列是问题，同一行的第二列则是该问题的答案。


你可以假设测验相对较短（少于100题），且答案为单个词或数字。

测验结束时，程序应输出答对的问题总数和总问题数。对于给出无效答案的问题，视为回答错误。

第二部分：
根据第一部分的要求调整你的程序以添加计时器功能。默认时间限制应为30秒，但也可通过标志进行自定义设置。

一旦超过时间限制，测验应立即停止。也就是说，不应等待用户回答最后一个问题，而应在理想情况下完全停止测验，即使当时正在等待用户的答案也应如此处理。

在计时开始前，应提示用户按下回车键（或其他键）启动计时器；然后题目应逐一出示在屏幕上直至用户提供答案为止。无论答案正确与否都将继续下一题的提问过程直到全部完成测试内容为止！最后依然需要统计出本次答题过程中总共答对了多少道题目以及一共出现了多少道题目信息并展示给参与者查看结果情况哦~同时也要注意那些没有被有效解答过的或者是根本就没有来得及去作答的部分也都算作是错误的哟！
```

```go
package main

import (
	"context"
	"encoding/csv"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"time"
)

func CommandLine() (string, int) {
	csvFileName := flag.String("csv", "problems.csv", "put the filename after this")
	limitValue := flag.Int("limit", 4, "the time limit for the quiz in seconds")
	flag.Parse()
	return *csvFileName, *limitValue
}

func main() {
	csvFileName, timeLimit := CommandLine()
	ctx, cancel := context.WithTimeout(context.Background(), time.Duration(timeLimit)*time.Second)
	defer cancel()

	file, err := os.Open(csvFileName)
	if err != nil {
		log.Fatalf("Error opening file: %v", err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	lines, err := reader.ReadAll()
	if err != nil {
		log.Fatalf("Error reading CSV: %v", err)
	}

	var correct, incorrect int

	for idx, line := range lines {
		select {
		case <-ctx.Done():
			fmt.Println("\nTime's up!")
			printResults(correct, incorrect)
			return
		default:
			formula := line[0]
			answerChan := make(chan int)

			go func() {
				var result int
				fmt.Printf("Question:%d/%d\tFormula: %v = ", idx+1, len(lines), formula)
				fmt.Scanln(&result)
				answerChan <- result
			}()

			answer, err := strconv.Atoi(line[1])
			if err != nil {
				log.Fatalf("Invalid answer in CSV: %v", err)
			}

			select {
			case <-ctx.Done():
				fmt.Println("\nTime's up!")
				printResults(correct, incorrect)
				return
			case result := <-answerChan:
				if result == answer {
					correct++
				} else {
					incorrect++
				}
			}
		}
	}

	printResults(correct, incorrect)
}

func printResults(correct, incorrect int) {
	fmt.Printf("\nYou got %d correct and %d incorrect.\n", correct, incorrect)
}

```
