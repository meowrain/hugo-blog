# Go Json解码和编码


```go
vcard.go

package vcard

import (
	&#34;time&#34;
)

type Address struct {
	Street           string
	HouseNumber      uint32
	HouseNumberAddOn string
	POBox            string
	ZipCode          string
	City             string
	Country          string
}

type VCard struct {
	FirstName string
	LastName  string
	NickName  string
	BirtDate  time.Time
	Photo     string
	Addresses map[string]*Address
}

```
---

```go
jsonUtil.go
package utils

import (
	&#34;encoding/json&#34;
)

func ToJson(data any) string {
	js, _ := json.Marshal(data)
	return string(js)
}

```


---

```go
main.go

package main

import (
	. &#34;awesomeProject/utils&#34;
	. &#34;awesomeProject/vcard&#34;
	&#34;encoding/json&#34;
	&#34;fmt&#34;
	&#34;os&#34;
	&#34;time&#34;
)

func main() {
	pa := &amp;Address{Street: &#34;private&#34;, HouseNumber: 10086, HouseNumberAddOn: &#34;Belgium&#34;}
	wa := &amp;Address{Street: &#34;work&#34;, HouseNumber: 10008611, HouseNumberAddOn: &#34;Belgium&#34;}
	vc := VCard{FirstName: &#34;Jan&#34;, LastName: &#34;Kersschot&#34;, NickName: &#34;Mike&#34;, BirtDate: time.Date(1956, 1, 17, 15, 4, 5, 0, time.Local)}
	str := ToJson(vc)
	fmt.Println(str)
	str = ToJson(wa)
	fmt.Println(str)
	str = ToJson(pa)
	fmt.Println(str)
	//写入到vcard.json文件
	file, err := os.Create(&#34;vcard.json&#34;)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	encoder := json.NewEncoder(file)
	err = encoder.Encode(vc)
	if err != nil {
		return
	}
	fmt.Println(&#34;vcard.json created&#34;)

	//读取vcard.json文件
	file, err = os.Open(&#34;vcard.json&#34;)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	decoder := json.NewDecoder(file)
	var vcard VCard
	err = decoder.Decode(&amp;vcard)
	if err != nil {
		return
	}
	fmt.Println(vcard)
}

```

&gt; 出于安全考虑，在 web 应用中最好使用 json.MarshalforHTML() 函数，其对数据执行HTML转码，所以文本可以被安全地嵌在 HTML` &lt;script&gt; `标签中。

&gt; json.NewEncoder() 的函数签名是 func NewEncoder(w io.Writer) *Encoder，返回的Encoder类型的指针可调用方法 Encode(v interface{})，将数据对象 v 的json编码写入 io.Writer w 中。

---
  
  
  
![](https://static.meowrain.cn/i/2024/05/16/w48pic-3.webp)

---

> 作者: meowrain  
> URL: https://example.org/posts/35b4611/  

