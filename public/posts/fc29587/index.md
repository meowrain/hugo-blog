# Go语言打印进度


就是一直刷新当前行
```go
package main

import (
	&#34;fmt&#34;
	&#34;time&#34;
)

func main() {
	// 模拟一些操作，比如循环计数
	for i := 0; i &lt;= 100; i&#43;&#43; {
		// 返回到行首
		fmt.Print(&#34;\r&#34;)
		// 输出其他内容
		fmt.Printf(&#34;Prefix: &#34;)
		// 输出进度
		fmt.Printf(&#34;Progress: %d%%&#34;, i)
		// 强制刷新输出缓冲区
		fmt.Print(&#34;\033[0m&#34;) // 重置 ANSI 颜色，防止影响后续输出
		time.Sleep(100 * time.Millisecond)
	}
	fmt.Println(&#34;\nDone!&#34;) // 完成后换行
}

```


---

> 作者: meowrain  
> URL: http://localhost:1313/posts/fc29587/  

