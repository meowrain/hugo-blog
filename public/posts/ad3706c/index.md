# Go缓冲区例题


下面的代码有一个输入文件 goprogram，然后以每一行为单位读取，从读取的当前行中截取第 3 到第 5 的字节写入另一个文件。然而当你运行这个程序，输出的文件却是个空文件。找出程序逻辑中的 bug，修正它并测试。
```go
package main

import (
	&#34;bufio&#34;
	&#34;fmt&#34;
	&#34;os&#34;
	&#34;io&#34;
)

func main() {
	inputFile, _ := os.Open(&#34;goprogram&#34;)
	outputFile, _ := os.OpenFile(&#34;goprogramT&#34;, os.O_WRONLY|os.O_CREATE, 0666)
	defer inputFile.Close()
	defer outputFile.Close()
	inputReader := bufio.NewReader(inputFile)
	outputWriter := bufio.NewWriter(outputFile)
	for {
		inputString, _, readerError := inputReader.ReadLine()
		if readerError == io.EOF {
			fmt.Println(&#34;EOF&#34;)
			return
		}
		outputString := string(inputString[2:5]) &#43; &#34;\r\n&#34;
		_, err := outputWriter.WriteString(outputString)
		if err != nil {
			fmt.Println(err)
			return
		}
	}
	fmt.Println(&#34;Conversion done&#34;)
}
```

---

&gt; 上面的代码为什么会什么都没有写入呢？其实是因为outputWriter没有Flush，必须进行Flush以后，才能把缓冲区清空，把内容写入到对应文件中


```go
package main

import (
	&#34;bufio&#34;
	&#34;fmt&#34;
	&#34;io&#34;
	&#34;os&#34;
)

func main() {
	inputFile, _ := os.Open(&#34;goprogram&#34;)
	outputFile, _ := os.OpenFile(&#34;goprogramT&#34;, os.O_WRONLY|os.O_CREATE, 0666)
	defer inputFile.Close()
	defer outputFile.Close()
	inputReader := bufio.NewReader(inputFile)
	outputWriter := bufio.NewWriter(outputFile)
	defer outputWriter.Flush()
	for {
		inputString, _, readerError := inputReader.ReadLine()
		if readerError == io.EOF {
			fmt.Println(&#34;EOF&#34;)
			return
		}
		outputString := string(inputString[2:5]) &#43; &#34;\r\n&#34;
		_, err := outputWriter.WriteString(outputString)
		if err != nil {
			fmt.Println(err)
			return
		}
	}
	fmt.Println(&#34;Conversion done&#34;)
}

```

![](https://static.meowrain.cn/i/2024/05/16/vgf1u0-3.webp)

![](https://static.meowrain.cn/i/2024/05/16/vgh5pt-3.webp)

![](https://static.meowrain.cn/i/2024/05/16/vgiivd-3.webp)


---

> 作者: meowrain  
> URL: http://localhost:1313/posts/ad3706c/  

