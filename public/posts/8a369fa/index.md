# Go 错误处理


# panic,recover
在 Go 语言中，panic 和 recover 是用于处理程序错误和恢复的两个关键机制。

panic：

panic 是一个内建函数，用于表示程序发生了无法处理的错误。当发生 panic 时，程序会立即停止执行当前函数的剩余代码，并开始在调用栈中向上逐层执行 deferred 函数，直到达到当前协程的最顶层（即程序的入口函数），然后程序将终止并输出 panic 信息。
panic 通常用于表示不可恢复的错误，比如空指针引用、数组越界等，或者是程序运行过程中的一些不合法操作。
recover：

recover 也是一个内建函数，用于在 defer 延迟执行的函数中捕获 panic 引起的错误，使程序能够继续执行而不会被终止。
recover 只能在 defer 中调用，并且只在发生 panic 时才会生效。如果在没有 panic 的情况下调用 recover，它将返回 nil。
当 recover 在 defer 中调用时，如果有 panic 发生，它将会返回被传递给 panic 的值，并且程序将继续执行而不会终止。

```go
package main

import (
	&#34;fmt&#34;
)

func recoverFromPanic() {
	if r := recover(); r != nil {
		fmt.Println(&#34;Recovered from panic:&#34;, r)
	}
}

func divide(a, b int) int {
	// defer语句用于注册在当前函数返回时调用的函数
	defer recoverFromPanic()

	if b == 0 {
		panic(&#34;Cannot divide by zero!&#34;)
	}

	return a / b
}

func processDivision(x, y int) {
	result := divide(x, y)
	fmt.Println(&#34;Result of division:&#34;, result)
}

func main() {
	// Case 1: Valid division
	processDivision(10, 2)

	// Case 2: Division by zero
	processDivision(10, 0)

	fmt.Println(&#34;Program continues after division.&#34;)
}

```


---

> 作者: meowrain  
> URL: https://example.org/posts/8a369fa/  

