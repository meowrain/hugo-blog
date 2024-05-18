# Go数组和切片联系


# Go数组和切片练习



# 数组

## 练习1：证明当数组赋值时，发生了数组内存拷贝。

```go
package main

import &#34;fmt&#34;

func main() {
	arr1 := new([5]int)
	arr2 := arr1
	arr2[1] = 3
	fmt.Println(arr1) //&amp;[0 3 0 0 0]
	fmt.Println(arr2) //&amp;[0 3 0 0 0]

	arr3 := [5]int{1, 2, 3, 4, 5}
	arr4 := &amp;arr3 //使用&amp;获取地址，修改arr4也会修改arr3
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

import &#34;fmt&#34;

func main() {
	var arr [16]int
	for i := 0; i &lt; 16; i&#43;&#43; {
		arr[i] = i
	}
	for _, v := range arr {
		fmt.Print(v, &#34; &#34;)
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

import &#34;fmt&#34;

func fibonacci(n int) []int {
    fib := make([]int, n&#43;1)
    fib[0], fib[1] = 0, 1
    for i := 2; i &lt;= n; i&#43;&#43; {
       fib[i] = fib[i-1] &#43; fib[i-2]
    }
    return fib
}
func main() {
    n := 50
    var fibSeq []int = fibonacci(n)
    for _, v := range fibSeq {
       fmt.Print(v, &#34; &#34;)
    }
}
```

# 切片

## 练习4： 给定切片 `sl`，将一个 `[]byte` 数组追加到 `sl` 后面。写一个函数 `Append(slice, data []byte) []byte`，该函数在 `sl` 不能存储更多数据的时候自动扩容。



```go
package main

import &#34;fmt&#34;

// 给定切片 sl，将一个 []byte 数组追加到 sl 后面。写一个函数 Append(slice, data []byte) []byte，该函数在 sl 不能存储更多数据的时候自动扩容。
func Append(originByteSlice, data []byte) []byte {
	originLen := len(originByteSlice)
	originCap := cap(originByteSlice)
	appendLen := len(data)

	var newByteSlice []byte

	// 判断原切片容量是否足够
	if originLen&#43;appendLen &gt; originCap {
		// 不够时，计算新切片的容量
		newCapacity := (originLen &#43; appendLen) * 2
		// 创建新切片并复制原切片内容
		newByteSlice = make([]byte, originLen&#43;appendLen, newCapacity)
		copy(newByteSlice, originByteSlice)
	} else {
		// 容量足够时，只需引用原切片
		newByteSlice = originByteSlice[:originLen&#43;appendLen]
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
	if originLen&#43;appendLen &gt; originCap {
		// 不够时，计算新切片的容量（这里简单地设置为两倍于原切片长度加上追加长度）
		newCapacity := (originLen &#43; appendLen) * 2
		// 创建新切片并复制原切片内容
		newByteSlice := make([]byte, originLen&#43;appendLen, newCapacity)
		copy(newByteSlice, originByteSlice)
		originByteSlice = newByteSlice
	}
	// 更新切片的长度
	originByteSlice = originByteSlice[:originLen&#43;appendLen]
	// 将data切片的内容复制到原切片的后面，实现追加
	copy(originByteSlice[originLen:], data)
	return originByteSlice
}
func main() {
	slice := []byte{&#39;a&#39;, &#39;c&#39;, &#39;e&#39;, &#39;g&#39;, &#39;i&#39;}
	res := Append2(slice, []byte{&#39;m&#39;, &#39;m&#39;})
	res1 := Append2(res, []byte{&#39;f&#39;, &#39;n&#39;})
	for _, b := range res1 {
		fmt.Printf(&#34;%q &#34;, b)
	}

}

```

&gt;  &#39;a&#39; &#39;c&#39; &#39;e&#39; &#39;g&#39; &#39;i&#39; &#39;m&#39; &#39;m&#39; &#39;f&#39; &#39;n&#39; 

## 练习5：把一个缓存 `buf` 分片成两个切片：第一个是前 `n` 个 bytes，后一个是剩余的，用一行代码实现。

```go
package main

import (
	&#34;bytes&#34;
	&#34;fmt&#34;
)

func main() {
	var buffer bytes.Buffer
	var n int = 3
	buffer.WriteString(&#34;helloworld&#34;)
	bytesBeforeN, bytesAfterN := buffer.Bytes()[:n], buffer.Bytes()[n:]
	for _, v := range bytesBeforeN {
		fmt.Printf(&#34;%c&#34;, v)
	}
	fmt.Println()
	for _, v := range bytesAfterN {
		fmt.Printf(&#34;%c&#34;, v)
	}
}

```

&gt; hel
&gt; loworld

## 练习5：遍历多维切片，使用for-range

```go
package main

import &#34;fmt&#34;

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

import &#34;fmt&#34;

func add(array ...int) int {
	var res int = 0
	for _, b := range array {
		res &#43;= b
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

import &#34;fmt&#34;

func enlarge(s *[]int, factor int) {
	ns := make([]int, len(*s)*factor)
	copy(ns, *s)
	*s = ns
}
func main() {
	var s []int = []int{1, 2, 3}
	fmt.Println(&#34;The length of s before enlarging is:&#34;, len(s))
	fmt.Println(s)
	enlarge(&amp;s, 5)
	fmt.Println(&#34;The length of s after enlarging is:&#34;, len(s))
	fmt.Println(s)
}

```

## 练习8:用顺序函数过滤容器：`s` 是前 10 个整型的切片。构造一个函数 `Filter`，第一个参数是 `s`，第二个参数是一个 `fn func(int) bool`，返回满足函数 `fn` 的元素切片。通过 `fn` 测试方法测试当整型值是偶数时的情况



```go
package main

import &#34;fmt&#34;

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

import &#34;fmt&#34;

func InsertIntSlice(src *[]int, dst *[]int, index int) {
	newSlice := make([]int, len(*src)&#43;len(*dst))
	at := copy(newSlice, (*src)[:index])
	at &#43;= copy(newSlice[at:], (*dst)[:])
	copy(newSlice[at:], (*src)[index:])
	//for i, v := range *src {
	//	newSlice[i] = v
	//}
	//for i := len(*src) &#43; len(*dst) - 1; i &gt;= index&#43;len(*dst); i-- {
	//	newSlice[i] = newSlice[i-len(*dst)]
	//}
	//copy(newSlice[index:], *dst)
	*src = newSlice
}

func InsertStringSlice(src *[]string, dst *[]string, index int) {
	newSlice := make([]string, len(*src)&#43;len(*dst))
	at := copy(newSlice, (*src)[:index])
	at &#43;= copy(newSlice[at:], (*dst)[:])
	copy(newSlice[at:], (*src)[index:])
	*src = newSlice
}
func main() {
	src := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
	dst := []int{12, 13}

	InsertIntSlice(&amp;src, &amp;dst, 2)
	fmt.Println(src)

	s := []string{&#34;M&#34;, &#34;N&#34;, &#34;O&#34;, &#34;P&#34;, &#34;Q&#34;, &#34;R&#34;}
	in := []string{&#34;A&#34;, &#34;B&#34;, &#34;C&#34;}
	InsertStringSlice(&amp;s, &amp;in, 3) // at the front
	fmt.Println(s)
}

```

&gt; [1 2 12 13 3 4 5 6 7 8 9]

## 练习10:写一个函数 `RemoveStringSlice()` 将从 `start` 到 `end` 索引的元素从切片中移除。

```go
// 写一个函数 RemoveStringSlice() 将从 start 到 end 索引的元素从切片中移除。
package main

import &#34;fmt&#34;

func RemoveStringSlice(source *[]string, start, end int) {

	tempSlice := make([]string, len(*source))
	at := copy(tempSlice, (*source)[0:start])
	copy(tempSlice[at:], (*source)[end&#43;1:])
	tempSlice = tempSlice[:(len(*source) - end &#43; start - 1)]
	*source = tempSlice
}
func main() {
	src := []string{&#34;meowrain&#34;, &#34;hello&#34;, &#34;world&#34;, &#34;thanks&#34;, &#34;meow&#34;, &#34;miku&#34;, &#34;aww&#34;}
	RemoveStringSlice(&amp;src, 0, 4)
	fmt.Println(src)
}

```

## 练习11：从字符串生成切片

```go
package main

import &#34;fmt&#34;

func main() {
	var s string = &#34;helloworld&#34;
	Stringslice := []byte(s)
	fmt.Println(Stringslice)
}

```

## 练习12：修改字符串中的某个字符

```go
package main

import &#34;fmt&#34;

func main() {
	var str string = &#34;helloworld&#34;
	slice := []byte(str)
	slice[2] = &#39;e&#39;
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
	if i &lt; 0 || i &gt;= len(str) {
		return &#34;&#34;, &#34;&#34;
	}
	return str[:i], str[i:]
}
func main() {
	str := &#34;helloworld&#34;
	i := 5
	s1, s2 := splitString(str, i)
	println(s1, s2)
}

```

## 练习14：假设有字符串 str，那么 str[len(str)/2:] &#43; str[:len(str)/2] 的结果是什么？
```go
package main

func main() {
	str := &#34;helloworld&#34;
	strslice := str[len(str)/2:] &#43; str[:len(str)/2]
	println(strslice) //worldhello
}

```

## 练习15:编写一个程序，要求能够反转字符串，即将 &#34;Google&#34; 转换成 &#34;elgooG&#34;（提示：使用 []byte 类型的切片）。

如果您使用两个切片来实现反转，请再尝试使用一个切片（提示：使用交换法）。

如果您想要反转 Unicode 编码的字符串，请使用 []int32 类型的切片。

```go
// 编写一个程序，要求能够反转字符串，即将 &#34;Google&#34; 转换成 &#34;elgooG&#34;（提示：使用 []byte 类型的切片）。
//
// 如果您使用两个切片来实现反转，请再尝试使用一个切片（提示：使用交换法）。
//
// 如果您想要反转 Unicode 编码的字符串，请使用 []int32 类型的切片。
package main

import (
	&#34;fmt&#34;
	&#34;strings&#34;
)

func reverseString(s string) string {

	b := []byte(s)

	for i, j := 0, len(b)-1; i &lt; j; i, j = i&#43;1, j-1 {
		b[i], b[j] = b[j], b[i]
	}

	return string(b)
}
func reverseStringVersion2(s string) string {
	str := strings.Builder{}
	for i := len(s) - 1; i &gt;= 0; i-- {
		str.WriteByte(s[i])
	}
	return str.String()
}
func main() {
	s := &#34;Google&#34;
	//s = reverseString(s)
	s = reverseStringVersion2(s)
	fmt.Println(s)
}

```

## 练习16：编写一个程序，要求能够遍历一个字符数组，并将当前字符和前一个字符不相同的字符拷贝至另一个数组。
```go
// Q29_uniq.go
package main

import &#34;fmt&#34;

var arr []byte = []byte{&#39;a&#39;, &#39;b&#39;, &#39;a&#39;, &#39;a&#39;, &#39;a&#39;, &#39;c&#39;, &#39;d&#39;, &#39;e&#39;, &#39;f&#39;, &#39;g&#39;}

func main() {
	arru := make([]byte, len(arr)) // this will contain the unique items
	idx := 0
	for i, j := 0, 1; i &lt; len(arr) &amp;&amp; j &lt; len(arr); i, j = i&#43;1, j&#43;1 {
		// 在这里执行循环体的操作
		if arr[i] != arr[j] {
			arru[idx] = arr[i]
			idx&#43;&#43;
		}
	}
	for i := 0; i &lt; idx; i&#43;&#43; {
		fmt.Printf(&#34;%c &#34;, arru[i]) //a b a c d e f 
	}
}

```
## 练习17:写一个程序，使用冒泡排序的方法排序一个包含整数的切片（算法的定义可参考 维基百科）。
```go
package main

import &#34;fmt&#34;

func bubbleSort(arr []int) []int {
	for i := 0; i &lt; len(arr)-1; i&#43;&#43; {
		for j := 0; j &lt; len(arr)-i-1; j&#43;&#43; {
			if arr[j] &gt; arr[j&#43;1] {
				arr[j], arr[j&#43;1] = arr[j&#43;1], arr[j]
			}
		}
	}
	return arr
}
func bubbleSortPointerVersion(arr *[]int) {
	for i := 0; i &lt; len(*arr)-1; i&#43;&#43; {
		for j := 0; j &lt; len(*arr)-i-1; j&#43;&#43; {
			if (*arr)[j] &gt; (*arr)[j&#43;1] {
				(*arr)[j], (*arr)[j&#43;1] = (*arr)[j&#43;1], (*arr)[j]
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
	bubbleSortPointerVersion(&amp;arr)
	fmt.Println(arr)
}

```



---

> 作者: meowrain  
> URL: https://example.org/posts/4e31f59/  

