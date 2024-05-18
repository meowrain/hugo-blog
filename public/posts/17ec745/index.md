# Go文件读写


&gt; 参考文档：https://www.liwenzhou.com/posts/Go/file/
## 读取文件


```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;io&#34;    &#34;os&#34;)  
  
func main() {  
    file, err := os.Open(&#34;./data.txt&#34;)  
    if err != nil {  
       fmt.Println(&#34;open file err:&#34;, err)  
       return  
    }  
    defer file.Close()  
    var tmp = make([]byte, 1024)  
    n, err := file.Read(tmp)  
    if err == io.EOF {  
       fmt.Println(&#34;文件读取完毕&#34;)  
       return  
    }  
    fmt.Printf(&#34;读取了%d字节数据\n&#34;, n)  
    fmt.Println(string(tmp))  
}
```
![](https://static.meowrain.cn/i/2024/03/07/sxlwih-3.webp)
&gt; 
&gt; 上面这个代码只是读取了文件中的1024个字节，并没有读取完文件内的所有内容，下面我们使用循环读取将文件全部读取

```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;io&#34;    &#34;os&#34;)  
  
func main() {  
    file, err := os.Open(&#34;./data.txt&#34;)  
    if err != nil {  
       fmt.Println(&#34;open file err:&#34;, err)  
       return  
    }  
    defer file.Close()  
    var content []byte  
    var tmp = make([]byte, 10)  
    var sumByte int  
    for {  
       n, err := file.Read(tmp)  
       if err == io.EOF {  
          fmt.Println(&#34;文件读取完毕&#34;)  
          break  
       }  
       if err != nil {  
          fmt.Println(&#34;read file failed&#34;, err)  
          return  
       }  
       sumByte &#43;= n  
       content = append(content, tmp[:n]...)  
    }  
    fmt.Println(string(content))  
    fmt.Println(&#34;读取了&#34;, sumByte, &#34;字节&#34;)  
  
}
```

![](https://static.meowrain.cn/i/2024/03/07/t0kdmy-3.webp)
### bufio读取文件
bufio是在file的基础上封装了一层API，支持更多的功能。

```go
package main  
  
import (  
    &#34;bufio&#34;  
    &#34;fmt&#34;    &#34;io&#34;    &#34;os&#34;)  
  
func main() {  
    file, err := os.Open(&#34;data.txt&#34;)  
    if err != nil {  
       fmt.Println(&#34;file open failed&#34;, err)  
       return  
  
    }  
    defer file.Close()  
    reader := bufio.NewReader(file)  
    for {  
       line, err := reader.ReadString(&#39;\n&#39;)  
       if err == io.EOF {  
          if len(line) != 0 {  
             fmt.Println(line)  
          }  
          fmt.Println(&#34;文件读完了&#34;)  
          break  
       }  
       if err != nil {  
          fmt.Println(&#34;read file err:&#34;, err)  
          return  
       }  
       fmt.Println(line)  
    }  
}
```

### os.ReadFIle读取整个文件
```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;os&#34;)  
  
func main() {  
    content, err := os.ReadFile(&#34;./data.txt&#34;)  
    if err != nil {  
       fmt.Println(&#34;read file failed:&#34;, err)  
       return  
    }  
    fmt.Println(string(content))  
}
```

![](https://static.meowrain.cn/i/2024/03/07/tvj1sp-3.webp)


## 文件写入
![](https://static.meowrain.cn/i/2024/03/07/two6en-3.webp)

### Write和WriteString
```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;os&#34;)  
  
func main() {  
    file, err := os.OpenFile(&#34;./data.txt&#34;, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)  
    if err != nil {  
       fmt.Println(&#34;file open failed err:&#34;, err)  
       return  
    }  
    defer file.Close()  
    str := &#34;good&#34;  
    file.Write([]byte(str))  
  
    //file.WriteString(str)  
}
```
![](https://static.meowrain.cn/i/2024/03/07/tz0veu-3.webp)

### 使用os.WriteFile函数
```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;os&#34;)  
  
func main() {  
    str := &#34;helloworld&#34;  
    err := os.WriteFile(&#34;./data.txt&#34;, []byte(str), 0666)  
    if err != nil {  
       fmt.Println(&#34;write file failed, err : &#34;, err)  
       return  
    }  
}
```


# Practice
复制一个文件中的内容到另一个文件
```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;io&#34;    &#34;os&#34;)  
  
func main() {  
    src, err := os.OpenFile(&#34;data.txt&#34;, os.O_RDONLY, 0666)  
    if err != nil {  
       fmt.Println(&#34;open file failed,err&#34;, err)  
       return  
    }  
    defer src.Close()  
    var content []byte  
    buf := make([]byte, 1024)  
    for {  
       n, err := src.Read(buf)  
       if err == io.EOF {  
          break  
       }  
       content = append(content, buf[:n]...)  
    }  
  
    dst, err := os.OpenFile(&#34;copy.txt&#34;, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)  
    if err != nil {  
       fmt.Println(&#34;open file failed,err&#34;, err)  
       return  
    }  
    dst.Write(content)  
    defer dst.Close()  
}
```

&gt; 其实可以用系统的io.Copy函数

```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;io&#34;    &#34;os&#34;)  
  
func CopyFile(source, destination string) {  
    src, err := os.OpenFile(source, os.O_RDONLY, 0666)  
    if err != nil {  
       fmt.Println(&#34;open file failed,err&#34;, err)  
       return  
    }  
    defer src.Close()  
  
    dst, err := os.OpenFile(destination, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)  
    if err != nil {  
       fmt.Println(&#34;open file failed,err&#34;, err)  
       return  
    }  
    defer dst.Close()  
    _, err = io.Copy(dst, src)  
    if err != nil {  
       fmt.Println(&#34;copy file failed,err: &#34;, err)  
       return  
    }  
}  
func main() {  
    var source string = &#34;data.txt&#34;  
    var destination string = &#34;copy.txt&#34;  
    CopyFile(source, destination)  
}
```

![](https://static.meowrain.cn/i/2024/03/07/u929uc-3.webp)


## 用go实现cat基本功能
```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;os&#34;)  
  
func main() {  
    if len(os.Args) &lt; 2 {  
       fmt.Println(&#34;Usage: cat &lt;filename&gt;&#34;)  
       return  
    }  
    filename := os.Args[1]  
    content, err := os.ReadFile(filename)  
    if err != nil {  
       fmt.Println(&#34;open file failed,err: &#34;, err)  
       return  
    }  
    fmt.Printf(&#34;%v&#34;, string(content))  
}
```

![](https://static.meowrain.cn/i/2024/03/07/ud48k1-3.webp)

## 用go实现拷贝文件到另一个文件
```go
package main

import (
	&#34;io&#34;
	&#34;os&#34;
)

func CopyFile(dstName, srcName string) error {
	src, err := os.Open(srcName)
	if err != nil {
		return err
	}
	defer src.Close()
	dst, err := os.Create(dstName)
	if err != nil {
		return err
	}
	defer dst.Close()
	_, err = io.Copy(dst, src)
	if err != nil {
		return err
	}
	return nil
}
func main() {
	CopyFile(&#34;./test.txt&#34;, &#34;./go.mod&#34;)
}

```

---

> 作者: meowrain  
> URL: http://localhost:1313/posts/17ec745/  

