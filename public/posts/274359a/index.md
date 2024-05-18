# Go实现递归向下分析




```go
package main

import (
	&#34;bufio&#34;
	&#34;fmt&#34;
	&#34;os&#34;
	&#34;strings&#34;
)

var (
	str         []byte
	pointer     int
	error_str   string = &#34;Error: 非法的符号串&#34;
	withNoSharp string = &#34;Error: 符号串必须以#结尾&#34;
)

// 打印颜色设置
const Red = &#34;\033[31m&#34;
const Green = &#34;\033[32m&#34;
const Reset = &#34;\033[0m&#34;
const Yellow = &#34;\033[33m&#34;

func match(token byte) {
	if pointer &gt;= len(str) {
		errors(error_str)
		return
	}
	if str[pointer] == token {
		pointer&#43;&#43;
	} else {
		errors(error_str)
	}
}

func errors(info string) {
	fmt.Println(Red, info, Reset)
	os.Exit(0)
}

func E() {
	fmt.Println(&#34;E() -&gt; T() -&gt; G()&#34;)
	T()
	G()
}

func T() {
	fmt.Println(&#34;T() -&gt; F() -&gt; S()&#34;)
	F()
	S()
}

func G() {

	if str[pointer] == &#39;&#43;&#39; {
		match(&#39;&#43;&#39;)
		fmt.Println(&#34;G() -&gt; &#43; -&gt; T() -&gt; G()&#34;)
		T()
		G()
	} else if str[pointer] == &#39;-&#39; {
		match(&#39;-&#39;)
		fmt.Println(&#34;G() -&gt; - -&gt; T() -&gt; G()&#34;)
		T()
		G()
	} else {
		fmt.Println(&#34;G() -&gt; epsilon&#34;)
	}
}

func F() {

	if str[pointer] == &#39;i&#39; {
		match(&#39;i&#39;)
		fmt.Println(&#34;F() -&gt; i&#34;)
	} else if str[pointer] == &#39;(&#39; {
		match(&#39;(&#39;)
		fmt.Println(&#34;F() -&gt; ( -&gt; E()&#34;)
		E()
		if pointer &lt; len(str) &amp;&amp; str[pointer] == &#39;)&#39; {
			match(&#39;)&#39;)
			fmt.Println(&#34;F() -&gt; ( -&gt; E() -&gt; )&#34;)
		} else {
			errors(&#34;Error: 缺少右括号&#34;)
		}
	} else {
		errors(&#34;Error: 与i或者(不匹配&#34;)
	}
}

func S() {

	if str[pointer] == &#39;*&#39; {
		match(&#39;*&#39;)
		fmt.Println(&#34;S() -&gt; * -&gt; F() -&gt; S()&#34;)
		F()
		S()
	} else if str[pointer] == &#39;/&#39; {
		match(&#39;/&#39;)
		fmt.Println(&#34;S() -&gt; / -&gt; F() -&gt; S()&#34;)
		F()
		S()
	} else {
		fmt.Println(&#34;S() -&gt; epsilon&#34;)
	}
}

func checkSuccess() {
	if pointer == len(str)-1 &amp;&amp; str[pointer] == &#39;#&#39; {
		fmt.Println(Green, string(str), &#34;Success: 符号串匹配成功&#34;, Reset)
	} else {
		errors(error_str)
	}
	os.Exit(0)
}

func main() {
	fmt.Println(Yellow, &#34;编制人: &#34;, Reset)
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println(Yellow, &#34;请输入符号串:&#34;, Reset)
	if scanner.Scan() {
		input := scanner.Text()
		if !strings.HasSuffix(input, &#34;#&#34;) { //判断是否以#结尾
			errors(withNoSharp)
			return
		}
		str = []byte(input)
		fmt.Println(&#34;读入的字符串为:&#34;, string(str))
		E()
		checkSuccess()
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, &#34;读取输入时发生错误:&#34;, err)
	}
}

```


---

> 作者: meowrain  
> URL: http://localhost:1313/posts/274359a/  

