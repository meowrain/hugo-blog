# Go Flag库使用



# 使用详情见

https://pkg.go.dev/flag
https://www.liwenzhou.com/posts/Go/flag/

# 例子
写一个模拟git命令的
```go
package main

import (
	&#34;flag&#34;
	&#34;fmt&#34;
	&#34;os&#34;
)

func main() {
	// 定义子命令
	initCmd := flag.NewFlagSet(&#34;init&#34;, flag.ExitOnError)
	commitCmd := flag.NewFlagSet(&#34;commit&#34;, flag.ExitOnError)

	// 为 commit 子命令定义参数
	commitMessage := commitCmd.String(&#34;m&#34;, &#34;&#34;, &#34;Commit message&#34;)

	// 检查是否传递了子命令
	if len(os.Args) &lt; 2 {
		fmt.Println(&#34;expected &#39;init&#39; or &#39;commit&#39; subcommands&#34;)
		printHelp()
		os.Exit(1)
	}

	// 解析子命令和参数
	switch os.Args[1] {
	case &#34;init&#34;:
		handleInit(initCmd, os.Args[2:])
	case &#34;commit&#34;:
		handleCommit(commitCmd, os.Args[2:], commitMessage)
	default:
		fmt.Println(&#34;expected &#39;init&#39; or &#39;commit&#39; subcommands&#34;)
		printHelp()
		os.Exit(1)
	}
}

// 处理 init 子命令
func handleInit(initCmd *flag.FlagSet, args []string) {
	initCmd.Parse(args)
	if len(args) &gt; 0 &amp;&amp; (args[0] == &#34;-h&#34; || args[0] == &#34;--help&#34;) {
		initCmd.Usage()
		return
	}
	fmt.Println(&#34;Repository initialized&#34;)
}

// 处理 commit 子命令
func handleCommit(commitCmd *flag.FlagSet, args []string, commitMessage *string) {
	commitCmd.Parse(args)
	if len(args) &gt; 0 &amp;&amp; (args[0] == &#34;-h&#34; || args[0] == &#34;--help&#34;) {
		commitCmd.Usage()
		return
	}
	if *commitMessage == &#34;&#34; {
		fmt.Println(&#34;commit message is required&#34;)
		commitCmd.Usage()
		os.Exit(1)
	}
	fmt.Printf(&#34;Commit with message: %s\n&#34;, *commitMessage)
}

// 打印帮助信息
func printHelp() {
	fmt.Println(&#34;Usage:&#34;)
	fmt.Println(&#34;  git init       Initialize a new repository&#34;)
	fmt.Println(&#34;  git commit -m  Commit changes with a message&#34;)
}

```

![](https://static.meowrain.cn/i/2024/05/15/st62kn-3.webp)


![](https://static.meowrain.cn/i/2024/05/15/stf9jg-3.webp)

---

> 作者: meowrain  
> URL: http://localhost:1313/posts/2f5f3f2/  

