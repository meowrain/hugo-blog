# Go接口


# Go 接口

## 接口定义

&gt; Go语言提倡面向接口编程。

## 指针接收者实现接口

```GO
package main

import &#34;fmt&#34;

// 接口定义
type USB interface {
	Connect()
	Disconnect()
}
type Laptop struct {
	name    string
	version string
}

type Desktop struct {
	name    string
	version string
}

// 实现USB接口
func (laptop *Laptop) Connect() {
	fmt.Println(&#34;USB Connecting to&#34;, laptop.name)
}
func (laptop *Laptop) Disconnect() {
	fmt.Println(&#34;USB Disconnecting from&#34;, laptop.name)
}
func (desktop *Desktop) Connect() {
	fmt.Println(&#34;USB Connecting to&#34;, desktop.name)
}
func (desktop *Desktop) Disconnect() {
	fmt.Println(&#34;USB Disconnecting from&#34;, desktop.name)
}
func main() {
	var legion_laptop Laptop = Laptop{
		name:    &#34;Legion Y7000P&#34;,
		version: &#34;2022&#34;,
	}
	var legion_desktop2 *Desktop = &amp;Desktop{
		name:    &#34;Legion Y9000P&#34;,
		version: &#34;2023&#34;,
	}
	var legion_desktop Desktop = Desktop{
		name:    &#34;Legion Desktop Computer&#34;,
		version: &#34;2023&#34;,
	}
	var x USB = legion_laptop
	x.Disconnect()
	x.Connect()
	x = legion_desktop2
	x.Connect()
	x.Disconnect()
	x = legion_desktop
	x.Connect()
	x.Disconnect()
}

```

&gt; 当我们写成这样的时候，可以看到![image-20240417144720008](https://static.meowrain.cn/i/2024/04/17/nxo6bh-3.webp)
&gt;
&gt; 也就是说，当我们使用指针接收者的时候，是不能传递结构体变量给接口变量的

## 值接收者实现接口

```go
package main

import &#34;fmt&#34;

// 接口定义
type USB interface {
	Connect()
	Disconnect()
}
type Laptop struct {
	name    string
	version string
}

type Desktop struct {
	name    string
	version string
}

// 实现USB接口
func (laptop Laptop) Connect() {
	fmt.Println(&#34;USB Connecting to&#34;, laptop.name)
}
func (laptop Laptop) Disconnect() {
	fmt.Println(&#34;USB Disconnecting from&#34;, laptop.name)
}
func (desktop Desktop) Connect() {
	fmt.Println(&#34;USB Connecting to&#34;, desktop.name)
}
func (desktop Desktop) Disconnect() {
	fmt.Println(&#34;USB Disconnecting from&#34;, desktop.name)
}
func main() {
	var legion_laptop Laptop = Laptop{
		name:    &#34;Legion Y7000P&#34;,
		version: &#34;2022&#34;,
	}
	var legion_desktop2 *Desktop = &amp;Desktop{
		name:    &#34;Legion Y9000P&#34;,
		version: &#34;2023&#34;,
	}
	var legion_desktop Desktop = Desktop{
		name:    &#34;Legion Desktop Computer&#34;,
		version: &#34;2023&#34;,
	}
	var x USB = legion_laptop
	x.Disconnect()
	x.Connect()
	x = legion_desktop2
	x.Connect()
	x.Disconnect()
	x = legion_desktop
	x.Connect()
	x.Disconnect()
}

```



&gt; 我们可以发现，使用值接收者实现接口之后，不管是Laptop的结构体还是其结构体指针，都可以赋值给接口变量



## 一个类型实现多个接口

一个类型可以同时实现多个接口，而接口间彼此独立，不知道对方的实现

```go
package main

import &#34;fmt&#34;

type Payer interface {
	Pay()
}
type Talker interface {
	Talk()
}
type AliPay struct {
}
type Wechat struct {
}

func (w Wechat) Pay() {
	fmt.Println(&#34;Wechat Pay&#34;)
}
func (w Wechat) Talk() {
	fmt.Println(&#34;Wechat Talk&#34;)
}
func (a AliPay) Pay() {
	fmt.Println(&#34;AliPay Pay&#34;)
}
func (a AliPay) Talk() {
	fmt.Println(&#34;AliPay Talk&#34;)
}
func main() {
	var payer Payer = AliPay{}
	payer.Pay()
	payer = Wechat{}
	payer.Pay()

	var talker Talker = Wechat{}
	talker.Talk()
	talker = AliPay{}
	talker.Talk()
}

```

## 接口嵌套

接口与接口间可以通过嵌套创造出新的接口。

```go
package main

import &#34;fmt&#34;

type Payer interface {
	Pay()
}
type Talker interface {
	Talk()
}
type AliPay struct {
}
type Wechat struct {
}
type Tooler interface {
	Payer
	Talker
}

func (w Wechat) Pay() {
	fmt.Println(&#34;Wechat Pay&#34;)
}
func (w Wechat) Talk() {
	fmt.Println(&#34;Wechat Talk&#34;)
}
func (a AliPay) Pay() {
	fmt.Println(&#34;AliPay Pay&#34;)
}
func (a AliPay) Talk() {
	fmt.Println(&#34;AliPay Talk&#34;)
}
func main() {
	var tool Tooler = AliPay{}
	tool.Talk()
	tool.Pay()
	tool = Wechat{}
	tool.Talk()
	tool.Pay()
}

```

## 空接口

空接口是指没有定义任何方法的接口。因此任何类型都实现了空接口。

空接口类型的变量可以存储任意类型的变量。

```go
package main

import &#34;fmt&#34;

func show(anything interface{}) {
	fmt.Println(anything)
}

type Animal struct {
	name string
	age  int
}

func main() {
	show(&#34;fdsafdasf&#34;)
	show(123)

	show(Animal{
		&#34;neko&#34;,
		12,
	})
}

```

&gt; 可以用**any**来替代



空接口还可以作为map的value值

```go
package main

import &#34;fmt&#34;

func main() {
	var studentInfo = make(map[string]interface{})
	//var studentInfo = make(map[string]any)
	studentInfo[&#34;name&#34;] = &#34;meowrain&#34;
	studentInfo[&#34;age&#34;] = 12
	studentInfo[&#34;hobby&#34;] = &#34;play computer&#34;
	fmt.Println(studentInfo)
}

```



## 类型断言

### 接口值

一个接口的值（简称接口值）是由一个具体类型和具体类型的值两部分组成的。这两部分分别称为接口的动态类型和动态值。

判断空接口中的这个值可以用类型断言

`x.(T)`



```go
package main

import &#34;fmt&#34;

func show(anything interface{}) {
	v, ok := anything.(string)
	if ok {
		fmt.Println(v)
	} else {
		fmt.Println(&#34;not string&#34;)
	}
}
func main() {
	show(&#34;fdsfdsafa&#34;)
	show(23)
}

```

![](https://static.meowrain.cn/i/2024/04/17/ovkmwx-3.webp)





---

> 作者: meowrain  
> URL: http://localhost:1313/posts/b3efa23/  

