---
title: Go文件读写
subtitle:
date: 2024-05-15T19:03:48+08:00
slug: 17ec745
draft: false
description:
keywords:
license:
comment: true
weight: 0
tags:
  - Go
  - Go文件读写
categories:
  - Go
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
summary:
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

> 参考文档：https://www.liwenzhou.com/posts/Go/file/
## 读取文件


```go
package main  
  
import (  
    "fmt"  
    "io"    "os")  
  
func main() {  
    file, err := os.Open("./data.txt")  
    if err != nil {  
       fmt.Println("open file err:", err)  
       return  
    }  
    defer file.Close()  
    var tmp = make([]byte, 1024)  
    n, err := file.Read(tmp)  
    if err == io.EOF {  
       fmt.Println("文件读取完毕")  
       return  
    }  
    fmt.Printf("读取了%d字节数据\n", n)  
    fmt.Println(string(tmp))  
}
```
![](https://static.meowrain.cn/i/2024/03/07/sxlwih-3.webp)
> 
> 上面这个代码只是读取了文件中的1024个字节，并没有读取完文件内的所有内容，下面我们使用循环读取将文件全部读取

```go
package main  
  
import (  
    "fmt"  
    "io"    "os")  
  
func main() {  
    file, err := os.Open("./data.txt")  
    if err != nil {  
       fmt.Println("open file err:", err)  
       return  
    }  
    defer file.Close()  
    var content []byte  
    var tmp = make([]byte, 10)  
    var sumByte int  
    for {  
       n, err := file.Read(tmp)  
       if err == io.EOF {  
          fmt.Println("文件读取完毕")  
          break  
       }  
       if err != nil {  
          fmt.Println("read file failed", err)  
          return  
       }  
       sumByte += n  
       content = append(content, tmp[:n]...)  
    }  
    fmt.Println(string(content))  
    fmt.Println("读取了", sumByte, "字节")  
  
}
```

![](https://static.meowrain.cn/i/2024/03/07/t0kdmy-3.webp)
### bufio读取文件
bufio是在file的基础上封装了一层API，支持更多的功能。

```go
package main  
  
import (  
    "bufio"  
    "fmt"    "io"    "os")  
  
func main() {  
    file, err := os.Open("data.txt")  
    if err != nil {  
       fmt.Println("file open failed", err)  
       return  
  
    }  
    defer file.Close()  
    reader := bufio.NewReader(file)  
    for {  
       line, err := reader.ReadString('\n')  
       if err == io.EOF {  
          if len(line) != 0 {  
             fmt.Println(line)  
          }  
          fmt.Println("文件读完了")  
          break  
       }  
       if err != nil {  
          fmt.Println("read file err:", err)  
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
    "fmt"  
    "os")  
  
func main() {  
    content, err := os.ReadFile("./data.txt")  
    if err != nil {  
       fmt.Println("read file failed:", err)  
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
    "fmt"  
    "os")  
  
func main() {  
    file, err := os.OpenFile("./data.txt", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)  
    if err != nil {  
       fmt.Println("file open failed err:", err)  
       return  
    }  
    defer file.Close()  
    str := "good"  
    file.Write([]byte(str))  
  
    //file.WriteString(str)  
}
```
![](https://static.meowrain.cn/i/2024/03/07/tz0veu-3.webp)

### 使用os.WriteFile函数
```go
package main  
  
import (  
    "fmt"  
    "os")  
  
func main() {  
    str := "helloworld"  
    err := os.WriteFile("./data.txt", []byte(str), 0666)  
    if err != nil {  
       fmt.Println("write file failed, err : ", err)  
       return  
    }  
}
```


# Practice
复制一个文件中的内容到另一个文件
```go
package main  
  
import (  
    "fmt"  
    "io"    "os")  
  
func main() {  
    src, err := os.OpenFile("data.txt", os.O_RDONLY, 0666)  
    if err != nil {  
       fmt.Println("open file failed,err", err)  
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
  
    dst, err := os.OpenFile("copy.txt", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)  
    if err != nil {  
       fmt.Println("open file failed,err", err)  
       return  
    }  
    dst.Write(content)  
    defer dst.Close()  
}
```

> 其实可以用系统的io.Copy函数

```go
package main  
  
import (  
    "fmt"  
    "io"    "os")  
  
func CopyFile(source, destination string) {  
    src, err := os.OpenFile(source, os.O_RDONLY, 0666)  
    if err != nil {  
       fmt.Println("open file failed,err", err)  
       return  
    }  
    defer src.Close()  
  
    dst, err := os.OpenFile(destination, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)  
    if err != nil {  
       fmt.Println("open file failed,err", err)  
       return  
    }  
    defer dst.Close()  
    _, err = io.Copy(dst, src)  
    if err != nil {  
       fmt.Println("copy file failed,err: ", err)  
       return  
    }  
}  
func main() {  
    var source string = "data.txt"  
    var destination string = "copy.txt"  
    CopyFile(source, destination)  
}
```

![](https://static.meowrain.cn/i/2024/03/07/u929uc-3.webp)


## 用go实现cat基本功能
```go
package main  
  
import (  
    "fmt"  
    "os")  
  
func main() {  
    if len(os.Args) < 2 {  
       fmt.Println("Usage: cat <filename>")  
       return  
    }  
    filename := os.Args[1]  
    content, err := os.ReadFile(filename)  
    if err != nil {  
       fmt.Println("open file failed,err: ", err)  
       return  
    }  
    fmt.Printf("%v", string(content))  
}
```

![](https://static.meowrain.cn/i/2024/03/07/ud48k1-3.webp)

## 用go实现拷贝文件到另一个文件
```go
package main

import (
	"io"
	"os"
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
	CopyFile("./test.txt", "./go.mod")
}

```