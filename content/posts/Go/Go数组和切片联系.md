---
title: Go数组和切片联系
subtitle:
date: 2024-05-15T19:07:17+08:00
slug: 4e31f59
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

# Go数组和切片练习



# 数组

## 练习1：证明当数组赋值时，发生了数组内存拷贝。

```go
package main

import "fmt"

func main() {
	arr1 := new([5]int)
	arr2 := arr1
	arr2[1] = 3
	fmt.Println(arr1) //&[0 3 0 0 0]
	fmt.Println(arr2) //&[0 3 0 0 0]

	arr3 := [5]int{1, 2, 3, 4, 5}
	arr4 := &arr3 //使用&获取地址，修改arr4也会修改arr3
	arr4[2] = 6
	fmt.Println(arr3) //[1 2 6 4 5]
	fmt.Println(arr4) //[1 2 6 4 5]

	arr5 := [5]int{1, 2, 3, 4, 5}
	arr6 := arr5 //会进行拷贝
	arr6[1] = 9
	fmt.Println(arr5) //[1 2 3 4 5]
	fmt.Println(arr6) //[1 9 3 4 5]
}

```



## 练习2:写一个循环并用下标给数组赋值（从 0 到 15）并且将数组打印在屏幕上。

```go
package main

import "fmt"

func main() {
	var arr [16]int
	for i := 0; i < 16; i++ {
		arr[i] = i
	}
	for _, v := range arr {
		fmt.Print(v, " ")
	}
	/*

		0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
		进程 已完成，退出代码为 0

	*/
}

```



## 练习3：通过数组我们可以更快的计算出 Fibonacci 数。完成该方法并打印出前 50 个 Fibonacci 数字。

```go
package main

import "fmt"

func fibonacci(n int) []int {
    fib := make([]int, n+1)
    fib[0], fib[1] = 0, 1
    for i := 2; i <= n; i++ {
       fib[i] = fib[i-1] + fib[i-2]
    }
    return fib
}
func main() {
    n := 50
    var fibSeq []int = fibonacci(n)
    for _, v := range fibSeq {
       fmt.Print(v, " ")
    }
}
```

# 切片

## 练习4： 给定切片 `sl`，将一个 `[]byte` 数组追加到 `sl` 后面。写一个函数 `Append(slice, data []byte) []byte`，该函数在 `sl` 不能存储更多数据的时候自动扩容。



```go
package main

import "fmt"

// 给定切片 sl，将一个 []byte 数组追加到 sl 后面。写一个函数 Append(slice, data []byte) []byte，该函数在 sl 不能存储更多数据的时候自动扩容。
func Append(originByteSlice, data []byte) []byte {
	originLen := len(originByteSlice)
	originCap := cap(originByteSlice)
	appendLen := len(data)

	var newByteSlice []byte

	// 判断原切片容量是否足够
	if originLen+appendLen > originCap {
		// 不够时，计算新切片的容量
		newCapacity := (originLen + appendLen) * 2
		// 创建新切片并复制原切片内容
		newByteSlice = make([]byte, originLen+appendLen, newCapacity)
		copy(newByteSlice, originByteSlice)
	} else {
		// 容量足够时，只需引用原切片
		newByteSlice = originByteSlice[:originLen+appendLen]
	}

	// 将data切片的内容复制到新切片的后面，实现追加
	copy(newByteSlice[originLen:], data)

	return newByteSlice
}
func Append2(originByteSlice, data []byte) []byte {
	originLen := len(originByteSlice)
	originCap := cap(originByteSlice)
	appendLen := len(data)

	// 判断原切片容量是否足够
	if originLen+appendLen > originCap {
		// 不够时，计算新切片的容量（这里简单地设置为两倍于原切片长度加上追加长度）
		newCapacity := (originLen + appendLen) * 2
		// 创建新切片并复制原切片内容
		newByteSlice := make([]byte, originLen+appendLen, newCapacity)
		copy(newByteSlice, originByteSlice)
		originByteSlice = newByteSlice
	}
	// 更新切片的长度
	originByteSlice = originByteSlice[:originLen+appendLen]
	// 将data切片的内容复制到原切片的后面，实现追加
	copy(originByteSlice[originLen:], data)
	return originByteSlice
}
func main() {
	slice := []byte{'a', 'c', 'e', 'g', 'i'}
	res := Append2(slice, []byte{'m', 'm'})
	res1 := Append2(res, []byte{'f', 'n'})
	for _, b := range res1 {
		fmt.Printf("%q ", b)
	}

}

```

>  'a' 'c' 'e' 'g' 'i' 'm' 'm' 'f' 'n' 

## 练习5：把一个缓存 `buf` 分片成两个切片：第一个是前 `n` 个 bytes，后一个是剩余的，用一行代码实现。

```go
package main

import (
	"bytes"
	"fmt"
)

func main() {
	var buffer bytes.Buffer
	var n int = 3
	buffer.WriteString("helloworld")
	bytesBeforeN, bytesAfterN := buffer.Bytes()[:n], buffer.Bytes()[n:]
	for _, v := range bytesBeforeN {
		fmt.Printf("%c", v)
	}
	fmt.Println()
	for _, v := range bytesAfterN {
		fmt.Printf("%c", v)
	}
}

```

> hel
> loworld

## 练习5：遍历多维切片，使用for-range

```go
package main

import "fmt"

func main() {
	slice := make([][]int, 4)
	slice[0] = []int{1, 2, 3}
	slice[1] = []int{4, 5, 6}
	slice[2] = []int{7, 8, 9}
	slice[3] = []int{10, 11, 12}
	for row := range slice {
		for col := range slice[row] {
			fmt.Print(slice[row][col])
		}
	}
}

```

## 练习6：通过使用省略号操作符 `...` 来实现累加方法。

```go
package main

import "fmt"

func add(array ...int) int {
	var res int = 0
	for _, b := range array {
		res += b
	}
	return res
}
func main() {
	var res int = add(1, 2, 3, 4, 5, 6)
	fmt.Println(res)
}

```

## 练习7：给定一个切片 `s []int` 和一个 `int` 类型的因子 `factor`，扩展 `s` 使其长度为 `len(s) * factor`。

```go
// 给定一个切片 `s []int` 和一个 `int` 类型的因子 `factor`，扩展 `s` 使其长度为 `len(s) * factor`。
package main

import "fmt"

func enlarge(s *[]int, factor int) {
	ns := make([]int, len(*s)*factor)
	copy(ns, *s)
	*s = ns
}
func main() {
	var s []int = []int{1, 2, 3}
	fmt.Println("The length of s before enlarging is:", len(s))
	fmt.Println(s)
	enlarge(&s, 5)
	fmt.Println("The length of s after enlarging is:", len(s))
	fmt.Println(s)
}

```

## 练习8:用顺序函数过滤容器：`s` 是前 10 个整型的切片。构造一个函数 `Filter`，第一个参数是 `s`，第二个参数是一个 `fn func(int) bool`，返回满足函数 `fn` 的元素切片。通过 `fn` 测试方法测试当整型值是偶数时的情况



```go
package main

import "fmt"

func Filter(s []int, fn func(int) bool) []int {
	var result []int
	for _, v := range s {
		if fn(v) {
			result = append(result, v)
		}
	}
	return result
}

func main() {
	s := []int{1, 2, 3, 4, 5, 6}
	fn := func(i int) bool {
		return i%2 == 0
	}
	res := Filter(s, fn)
	fmt.Println(res)
}

```





## 练习9:写一个函数 `InsertStringSlice()` 将切片插入到另一个切片的指定位置。

```go
// 写一个函数 InsertStringSlice() 将切片插入到另一个切片的指定位置。
package main

import "fmt"

func InsertIntSlice(src *[]int, dst *[]int, index int) {
	newSlice := make([]int, len(*src)+len(*dst))
	at := copy(newSlice, (*src)[:index])
	at += copy(newSlice[at:], (*dst)[:])
	copy(newSlice[at:], (*src)[index:])
	//for i, v := range *src {
	//	newSlice[i] = v
	//}
	//for i := len(*src) + len(*dst) - 1; i >= index+len(*dst); i-- {
	//	newSlice[i] = newSlice[i-len(*dst)]
	//}
	//copy(newSlice[index:], *dst)
	*src = newSlice
}

func InsertStringSlice(src *[]string, dst *[]string, index int) {
	newSlice := make([]string, len(*src)+len(*dst))
	at := copy(newSlice, (*src)[:index])
	at += copy(newSlice[at:], (*dst)[:])
	copy(newSlice[at:], (*src)[index:])
	*src = newSlice
}
func main() {
	src := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
	dst := []int{12, 13}

	InsertIntSlice(&src, &dst, 2)
	fmt.Println(src)

	s := []string{"M", "N", "O", "P", "Q", "R"}
	in := []string{"A", "B", "C"}
	InsertStringSlice(&s, &in, 3) // at the front
	fmt.Println(s)
}

```

> [1 2 12 13 3 4 5 6 7 8 9]

## 练习10:写一个函数 `RemoveStringSlice()` 将从 `start` 到 `end` 索引的元素从切片中移除。

```go
// 写一个函数 RemoveStringSlice() 将从 start 到 end 索引的元素从切片中移除。
package main

import "fmt"

func RemoveStringSlice(source *[]string, start, end int) {

	tempSlice := make([]string, len(*source))
	at := copy(tempSlice, (*source)[0:start])
	copy(tempSlice[at:], (*source)[end+1:])
	tempSlice = tempSlice[:(len(*source) - end + start - 1)]
	*source = tempSlice
}
func main() {
	src := []string{"meowrain", "hello", "world", "thanks", "meow", "miku", "aww"}
	RemoveStringSlice(&src, 0, 4)
	fmt.Println(src)
}

```

## 练习11：从字符串生成切片

```go
package main

import "fmt"

func main() {
	var s string = "helloworld"
	Stringslice := []byte(s)
	fmt.Println(Stringslice)
}

```

## 练习12：修改字符串中的某个字符

```go
package main

import "fmt"

func main() {
	var str string = "helloworld"
	slice := []byte(str)
	slice[2] = 'e'
	str = string(slice)
	fmt.Println(str)
}

```

# 字符串
## 练习13：编写一个函数，要求其接受两个参数，原始字符串 str 和分割索引 i，然后返回两个分割后的字符串。
```go
package main

// 练习13：编写一个函数，要求其接受两个参数，原始字符串 str 和分割索引 i，然后返回两个分割后的字符串。
func splitString(str string, i int) (string, string) {
	if i < 0 || i >= len(str) {
		return "", ""
	}
	return str[:i], str[i:]
}
func main() {
	str := "helloworld"
	i := 5
	s1, s2 := splitString(str, i)
	println(s1, s2)
}

```

## 练习14：假设有字符串 str，那么 str[len(str)/2:] + str[:len(str)/2] 的结果是什么？
```go
package main

func main() {
	str := "helloworld"
	strslice := str[len(str)/2:] + str[:len(str)/2]
	println(strslice) //worldhello
}

```

## 练习15:编写一个程序，要求能够反转字符串，即将 "Google" 转换成 "elgooG"（提示：使用 []byte 类型的切片）。

如果您使用两个切片来实现反转，请再尝试使用一个切片（提示：使用交换法）。

如果您想要反转 Unicode 编码的字符串，请使用 []int32 类型的切片。

```go
// 编写一个程序，要求能够反转字符串，即将 "Google" 转换成 "elgooG"（提示：使用 []byte 类型的切片）。
//
// 如果您使用两个切片来实现反转，请再尝试使用一个切片（提示：使用交换法）。
//
// 如果您想要反转 Unicode 编码的字符串，请使用 []int32 类型的切片。
package main

import (
	"fmt"
	"strings"
)

func reverseString(s string) string {

	b := []byte(s)

	for i, j := 0, len(b)-1; i < j; i, j = i+1, j-1 {
		b[i], b[j] = b[j], b[i]
	}

	return string(b)
}
func reverseStringVersion2(s string) string {
	str := strings.Builder{}
	for i := len(s) - 1; i >= 0; i-- {
		str.WriteByte(s[i])
	}
	return str.String()
}
func main() {
	s := "Google"
	//s = reverseString(s)
	s = reverseStringVersion2(s)
	fmt.Println(s)
}

```

## 练习16：编写一个程序，要求能够遍历一个字符数组，并将当前字符和前一个字符不相同的字符拷贝至另一个数组。
```go
// Q29_uniq.go
package main

import "fmt"

var arr []byte = []byte{'a', 'b', 'a', 'a', 'a', 'c', 'd', 'e', 'f', 'g'}

func main() {
	arru := make([]byte, len(arr)) // this will contain the unique items
	idx := 0
	for i, j := 0, 1; i < len(arr) && j < len(arr); i, j = i+1, j+1 {
		// 在这里执行循环体的操作
		if arr[i] != arr[j] {
			arru[idx] = arr[i]
			idx++
		}
	}
	for i := 0; i < idx; i++ {
		fmt.Printf("%c ", arru[i]) //a b a c d e f 
	}
}

```
## 练习17:写一个程序，使用冒泡排序的方法排序一个包含整数的切片（算法的定义可参考 维基百科）。
```go
package main

import "fmt"

func bubbleSort(arr []int) []int {
	for i := 0; i < len(arr)-1; i++ {
		for j := 0; j < len(arr)-i-1; j++ {
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j]
			}
		}
	}
	return arr
}
func bubbleSortPointerVersion(arr *[]int) {
	for i := 0; i < len(*arr)-1; i++ {
		for j := 0; j < len(*arr)-i-1; j++ {
			if (*arr)[j] > (*arr)[j+1] {
				(*arr)[j], (*arr)[j+1] = (*arr)[j+1], (*arr)[j]
			}
		}
	}
}
func main() {
	arr := []int{5, 2, 8, 3, 9, 1}
	// 2 5 8 3 9 1
	// 2 5 3 8 9 1
	// 2 5 3 8 1 9
	// -----
	// 2 3 5 8 1 9
	// 2 3 5 1 8 9
	// ----
	// 2 3 1 5 8 9
	//---
	// 2 1 3 5 8 9
	//----
	// 1 2 3 5 8 9
	sortedArr := bubbleSort(arr)
	fmt.Println(sortedArr)
	bubbleSortPointerVersion(&arr)
	fmt.Println(arr)
}

```

