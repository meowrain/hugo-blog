---
title: Go Flag库使用
subtitle:
date: 2024-05-15T19:28:48+08:00
slug: 2f5f3f2
draft: false
keywords:
license:
comment: true
weight: 0
tags:
  - Go
categories:
  - Go
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
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


# 使用详情见

https://pkg.go.dev/flag
https://www.liwenzhou.com/posts/Go/flag/

# 例子
写一个模拟git命令的
```go
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	// 定义子命令
	initCmd := flag.NewFlagSet("init", flag.ExitOnError)
	commitCmd := flag.NewFlagSet("commit", flag.ExitOnError)

	// 为 commit 子命令定义参数
	commitMessage := commitCmd.String("m", "", "Commit message")

	// 检查是否传递了子命令
	if len(os.Args) < 2 {
		fmt.Println("expected 'init' or 'commit' subcommands")
		printHelp()
		os.Exit(1)
	}

	// 解析子命令和参数
	switch os.Args[1] {
	case "init":
		handleInit(initCmd, os.Args[2:])
	case "commit":
		handleCommit(commitCmd, os.Args[2:], commitMessage)
	default:
		fmt.Println("expected 'init' or 'commit' subcommands")
		printHelp()
		os.Exit(1)
	}
}

// 处理 init 子命令
func handleInit(initCmd *flag.FlagSet, args []string) {
	initCmd.Parse(args)
	if len(args) > 0 && (args[0] == "-h" || args[0] == "--help") {
		initCmd.Usage()
		return
	}
	fmt.Println("Repository initialized")
}

// 处理 commit 子命令
func handleCommit(commitCmd *flag.FlagSet, args []string, commitMessage *string) {
	commitCmd.Parse(args)
	if len(args) > 0 && (args[0] == "-h" || args[0] == "--help") {
		commitCmd.Usage()
		return
	}
	if *commitMessage == "" {
		fmt.Println("commit message is required")
		commitCmd.Usage()
		os.Exit(1)
	}
	fmt.Printf("Commit with message: %s\n", *commitMessage)
}

// 打印帮助信息
func printHelp() {
	fmt.Println("Usage:")
	fmt.Println("  git init       Initialize a new repository")
	fmt.Println("  git commit -m  Commit changes with a message")
}

```

![](https://static.meowrain.cn/i/2024/05/15/st62kn-3.webp)


![](https://static.meowrain.cn/i/2024/05/15/stf9jg-3.webp)