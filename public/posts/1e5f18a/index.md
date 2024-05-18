# Go实现词法分析器


&lt;!--more--&gt;
```go
package main

import (
	&#34;bufio&#34;
	&#34;fmt&#34;
	&#34;os&#34;
	&#34;unicode&#34;
)

var keywords = map[string]int{
	&#34;begin&#34;: 1,
	&#34;if&#34;:    2,
	&#34;then&#34;:  3,
	&#34;while&#34;: 4,
	&#34;do&#34;:    5,
	&#34;end&#34;:   6,
}

func lexicalAnalysis(input string) { //词法分析程序
	var p int = 0
	scanner := func() (int, string) {
		var syn int
		var token string
		for p &lt; len(input) &amp;&amp; input[p] == &#39; &#39; {
			p&#43;&#43; //跳过空格
		}
		if unicode.IsLetter(rune(input[p])) {
			for p &lt; len(input) &amp;&amp; (unicode.IsLetter(rune(input[p])) || unicode.IsDigit(rune(input[p]))) { //如果当前是字符，那么把它加入到token中
				token &#43;= string(input[p])
				p&#43;&#43;
			}
			_, ok := keywords[token]
			if ok {
				syn = keywords[token]
			} else {
				syn = 10
			}
		} else {
			if unicode.IsDigit(rune(input[p])) {
				syn = 11
				token = string(input[p])
				p&#43;&#43;

			} else {
				switch input[p] {
				case &#39;&#43;&#39;:
					token = &#34;&#43;&#34;
					syn = 13
					p&#43;&#43;
				case &#39;-&#39;:
					token = &#34;-&#34;
					syn = 14
					p&#43;&#43;
				case &#39;*&#39;:
					token = &#34;*&#34;
					syn = 15
					p&#43;&#43;
				case &#39;/&#39;:
					token = &#34;/&#34;
					syn = 16
					p&#43;&#43;
				case &#39;:&#39;:
					if p&#43;1 &lt; len(input) &amp;&amp; input[p&#43;1] == &#39;=&#39; {
						syn = 18
						token = &#34;:=&#34;
						p &#43;= 2
					} else {
						token = &#34;:&#34;
						syn = 17
						p&#43;&#43;
					}
				case &#39;&lt;&#39;:
					if p&#43;1 &lt; len(input) &amp;&amp; input[p&#43;1] == &#39;&gt;&#39; {
						syn = 21
						token = &#34;&lt;&gt;&#34;
						p &#43;= 2
					} else if p&#43;1 &lt; len(input) &amp;&amp; input[p&#43;1] == &#39;=&#39; {
						syn = 22
						token = &#34;&lt;=&#34;
						p &#43;= 2
					} else {
						syn = 20
						token = &#34;&lt;&#34;
						p&#43;&#43;
					}
				case &#39;&gt;&#39;:
					if p&#43;1 &lt; len(input) &amp;&amp; input[p&#43;1] == &#39;=&#39; {
						syn = 24
						token = &#34;&gt;=&#34;
						p &#43;= 2
					} else {
						syn = 23
						token = &#34;&gt;&#34;
						p&#43;&#43;
					}
				case &#39;=&#39;:
					syn = 25
					token = &#34;=&#34;
					p&#43;&#43;
				case &#39;;&#39;:
					syn = 26
					token = &#34;;&#34;
					p&#43;&#43;
				case &#39;(&#39;:
					syn = 27
					token = &#34;(&#34;
					p&#43;&#43;
				case &#39;)&#39;:
					syn = 28
					token = &#34;)&#34;
					p&#43;&#43;
				case &#39;#&#39;:
					syn = 0
					token = &#34;#&#34;
					p&#43;&#43;
				default:
					syn = -1
					token = string(input[p])
					p&#43;&#43;
				}
			}
		}

		return syn, token
	}
	for p &lt; len(input) {
		syn, token := scanner()
		if syn == -1 {
			fmt.Println(&#34;错误：非法字符&#34;, token)
			break
		} else {
			res := fmt.Sprintf(&#34;(%d,%s)&#34;, syn, token)
			fmt.Print(res &#43; &#34; &#34;)
		}
	}

}

func main() {
	fmt.Printf(&#34;请输入代码段\n&#34;)
	reader := bufio.NewReader(os.Stdin)
	readBytes, _, _ := reader.ReadLine()
	var codeSegment string = string(readBytes)

	//input := &#34;begin x:=9;if x&gt;0 then x:=2*x&#43;1/3;end#&#34;
	lexicalAnalysis(codeSegment)

}

```

---

> 作者:   
> URL: http://localhost:1313/posts/1e5f18a/  

