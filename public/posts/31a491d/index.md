# Go语言 Web框架Gin


# Go语言 Web框架Gin

&gt; 参考
&gt; https://docs.fengfengzhidao.com
&gt;
&gt; https://www.liwenzhou.com/posts/Go/gin/#c-0-7-2

# 返回各种值

## 返回字符串

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func main() {

    router := gin.Default()

    router.GET(&#34;/&#34;, func(c *gin.Context) {

        c.String(http.StatusOK, &#34;helloworld&#34;)

    })

    router.Run(&#34;:8080&#34;)

}
```

## 返回json

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



type Student struct {

    Name string `json:&#34;name&#34;`

    Age int `json:&#34;age&#34;`

    Number string `json: &#34;number&#34;`

}



func main() {

    router := gin.Default()

    router.GET(&#34;/&#34;, func(c *gin.Context) {

        var student Student = Student{

            Name: &#34;meowrain&#34;,

            Age: 20,

            Number: &#34;10086&#34;,

        }

        c.JSON(http.StatusOK, student)

    })

    router.Run(&#34;:8080&#34;)

}
```



![](https://static.meowrain.cn/i/2024/03/07/vs14ff-3.webp)

## 返回map

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func main() {

    router := gin.Default()

    router.GET(&#34;/&#34;, func(c *gin.Context) {

        userMap := map[string]any{

            &#34;username&#34;: &#34;meowrain&#34;,

            &#34;age&#34;: 20,

            &#34;number&#34;: 10086,

        }

        c.JSON(http.StatusOK, userMap)

    })

    router.Run(&#34;:8080&#34;)

}
```

![](https://static.meowrain.cn/i/2024/03/07/vu58ct-3.webp)


## 返回原始json

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func main() {

    router := gin.Default()

    router.GET(&#34;/&#34;, func(c *gin.Context) {



        c.JSON(http.StatusOK, gin.H{

            &#34;username&#34;: &#34;meowrain&#34;,



            &#34;age&#34;: 20,



            &#34;number&#34;: 10086,

        })

    })

    router.Run(&#34;:8080&#34;)

}
```


![](https://static.meowrain.cn/i/2024/03/07/vuxhez-3.webp)

&gt; 
&gt;
&gt; ![](https://static.meowrain.cn/i/2024/03/07/vv144f-3.webp)


## 返回html并传递参数

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func _html(c *gin.Context) {

    type UserInfo struct {

        Username string `json:&#34;username&#34;`

        Age int `json:&#34;age&#34;`

        Password string `json:&#34;-&#34;`

    }

    user := UserInfo{

        Username: &#34;meowrain&#34;,

        Age: 20,

        Password: &#34;12345678&#34;,

    }

    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{&#34;obj&#34;: user})

}

func main() {

    router := gin.Default()

    router.LoadHTMLGlob(&#34;template/*&#34;)

    router.GET(&#34;/&#34;, _html)

    router.Run(&#34;:8080&#34;)

}
```

```html
&lt;!DOCTYPE html&gt;

&lt;html lang=&#34;en&#34;&gt;

    &lt;head&gt;

        &lt;meta charset=&#34;UTF-8&#34;&gt;

        &lt;meta name=&#34;viewport&#34; content=&#34;width=device-width, initial-scale=1.0&#34;&gt;

        &lt;title&gt;Document&lt;/title&gt;

    &lt;/head&gt;

    &lt;body&gt;

        &lt;h1&gt;User Information&lt;/h1&gt;

        &lt;p&gt;Username: {{.obj.Username}}&lt;/p&gt;

        &lt;p&gt;Age: {{.obj.Age}}&lt;/p&gt;

    &lt;/body&gt;

&lt;/html&gt;
```

![](https://static.meowrain.cn/i/2024/03/07/10gipeq-3.webp)


### 静态文件配置

`router.Static`和`router.StaticFS`都是用于处理静态文件的 Gin 框架路由处理方法，但它们有一些区别。

1. **`router.Static`**:
   - 使用 `router.Static` 时，Gin 会简单地将请求的 URL 路径与提供的本地文件系统路径进行映射。通常，这适用于将 URL 路径直接映射到一个静态文件或目录。
   - 示例：`router.Static(&#34;/static&#34;, &#34;./static&#34;)` 将 `/static` 映射到当前工作目录下的 `./static` 文件夹。

2. **`router.StaticFS`**:
   - `router.StaticFS` 则允许你使用 `http.FileSystem` 对象，这可以提供更多的灵活性。你可以使用 `http.Dir` 创建 `http.FileSystem`，并将其传递给 `router.StaticFS`。
   - 这允许你更灵活地处理静态文件，例如从不同的源（内存、数据库等）加载静态文件，而不仅限于本地文件系统。
   - 示例：`router.StaticFS(&#34;/static&#34;, http.Dir(&#34;/path/to/static/files&#34;))` 使用本地文件系统路径创建一个 `http.FileSystem` 对象，然后将 `/static` 映射到这个文件系统。

总体而言，`router.Static`更简单，适用于基本的静态文件服务，而`router.StaticFS`提供了更多的灵活性，允许你自定义静态文件的加载方式。选择使用哪一个取决于你的具体需求。

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func _html(c *gin.Context) {

    type UserInfo struct {

        Username string `json:&#34;username&#34;`

        Age int `json:&#34;age&#34;`

        Password string `json:&#34;-&#34;`

    }

    user := UserInfo{

        Username: &#34;meowrain&#34;,

        Age: 20,

        Password: &#34;12345678&#34;,

    }

    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{&#34;obj&#34;: user})

}

func main() {

    router := gin.Default()

    router.LoadHTMLGlob(&#34;template/*&#34;)

    router.Static(&#34;/static/&#34;, &#34;./static&#34;)

    router.GET(&#34;/&#34;, _html)

    router.Run(&#34;:8080&#34;)

}
```

![](https://static.meowrain.cn/i/2024/03/07/10q03tz-3.webp)

```html
&lt;!DOCTYPE html&gt;

&lt;html lang=&#34;en&#34;&gt;

    &lt;head&gt;

        &lt;meta charset=&#34;UTF-8&#34;&gt;

        &lt;meta name=&#34;viewport&#34; content=&#34;width=device-width, initial-scale=1.0&#34;&gt;

        &lt;title&gt;Document&lt;/title&gt;

    &lt;/head&gt;

    &lt;body&gt;

        &lt;h1&gt;User Information&lt;/h1&gt;

        &lt;p&gt;Username: {{.obj.Username}}&lt;/p&gt;

        &lt;p&gt;Age: {{.obj.Age}}&lt;/p&gt;

        &lt;img src=&#34;/static/c68a16221f5bdf5486749d0993052981178827471.jpg&#34; /&gt;

    &lt;/body&gt;

&lt;/html&gt;
```

![](https://static.meowrain.cn/i/2024/03/07/10qf6z6-3.webp)




# 重定向

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func _html(c *gin.Context) {

    type UserInfo struct {

        Username string `json:&#34;username&#34;`

        Age int `json:&#34;age&#34;`

        Password string `json:&#34;-&#34;`

    }

    user := UserInfo{

        Username: &#34;meowrain&#34;,

        Age: 20,

        Password: &#34;12345678&#34;,

    }

    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{&#34;obj&#34;: user})

}

func _redirect(c *gin.Context) {

    c.Redirect(301, &#34;https://www.baidu.com&#34;)

}

func main() {

    router := gin.Default()

    router.LoadHTMLGlob(&#34;template/*&#34;)

    router.Static(&#34;/static/&#34;, &#34;./static&#34;)

    router.GET(&#34;/&#34;, _html)

    router.GET(&#34;/baidu&#34;, _redirect)

    router.Run(&#34;:8080&#34;)

}
```

![](https://static.meowrain.cn/i/2024/03/07/10xi5tr-3.webp)


### 301和302的区别

HTTP状态码中的301和302分别表示重定向（Redirect）。它们之间的主要区别在于重定向的性质和原因：

1. **301 Moved Permanently（永久重定向）**:
   - 当服务器返回状态码301时，它告诉客户端请求的资源已经被永久移动到新的位置。
   - 客户端收到301响应后，应该更新书签、链接等，将这个新的位置作为将来所有对该资源的请求的目标。
   - 搜索引擎在遇到301时，通常会更新索引，将原始URL替换为新的URL。

2. **302 Found（临时重定向）**:
   - 当服务器返回状态码302时，它表示请求的资源暂时被移动到了另一个位置。
   - 客户端收到302响应后，可以在不更新书签和链接的情况下继续使用原始URL。
   - 搜索引擎在遇到302时，通常会保留原始URL在索引中，并不会立即更新为新的URL。

总体来说，使用301通常是在确定资源永久移动的情况下，而302通常用于暂时性的重定向，即资源可能在将来回到原始位置。选择使用哪种状态码取决于你希望客户端和搜索引擎如何处理被重定向的资源。

# 路由

## 默认路由

&gt; 当访问路径不被匹配的时候返回默认路由内容

目录结构

![image-20240308205926484](https://static.meowrain.cn/i/2024/03/08/y21i4t-3.webp)

```go
//main.go
package main

import (
	&#34;awesomeProject/pkg/controller&#34;
	&#34;github.com/gin-gonic/gin&#34;
)

func main() {
	router := gin.Default()
	router.LoadHTMLGlob(&#34;templates/*&#34;)
	router.GET(&#34;/&#34;, func(c *gin.Context) {
		c.String(200, &#34;helloworld&#34;)
	})
	router.NoRoute(controller.Default_route)
	router.Run(&#34;:80&#34;)
}

```



```go
//server.go
package controller

import (
	&#34;github.com/gin-gonic/gin&#34;
	&#34;net/http&#34;
)

func Default_route(c *gin.Context) {
	c.HTML(http.StatusNotFound, &#34;404.html&#34;, nil)
}

```

```html
&lt;!--404.html--&gt;
&lt;!DOCTYPE html&gt;
&lt;html lang=&#34;en&#34;&gt;
&lt;head&gt;
    &lt;meta charset=&#34;UTF-8&#34;&gt;
    &lt;title&gt;404 NOT FOUND&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;h1&gt;404 Not Found&lt;/h1&gt;
&lt;/body&gt;
&lt;/html&gt;
```

&gt; 效果

![](https://static.meowrain.cn/i/2024/03/08/y25trv-3.webp)



![image-20240308210004320](https://static.meowrain.cn/i/2024/03/08/yqb64w-3.webp)

## 路由组

&gt; 参考：https://www.liwenzhou.com/posts/Go/gin/#c-0-7-2

我们可以将拥有共同URL前缀的路由划分为一个路由组。习惯性一对`{}`包裹同组的路由，这只是为了看着清晰，你用不用`{}`包裹功能上没什么区别。

![](https://static.meowrain.cn/i/2024/03/08/z7tbui-3.webp)

```go
//main.go
package main

import (
	&#34;awesomeProject/pkg/controller&#34;
	&#34;github.com/gin-gonic/gin&#34;
)

func main() {

	router := gin.Default()
	userGroup := router.Group(&#34;/user&#34;)
	{
		userGroup.GET(&#34;/all&#34;, controller.GetUserList)
		userGroup.GET(&#34;/detail&#34;, controller.GetUserDetail)
	}
	router.LoadHTMLGlob(&#34;templates/*&#34;)
	router.NoRoute(controller.Default_route)
	router.Run(&#34;:80&#34;)
}

```

```go
//controller/userController.go
package controller

import (
	. &#34;awesomeProject/pkg/entity&#34;
	&#34;github.com/gin-gonic/gin&#34;
	&#34;net/http&#34;
	&#34;strconv&#34;
)

func GetUserList(c *gin.Context) {
	c.JSON(http.StatusOK, Response{
		Code: http.StatusOK,
		Data: UserList,
		Msg:  &#34;返回成功&#34;,
	})
}
func GetUserDetail(c *gin.Context) {
	id := c.Query(&#34;id&#34;)
	for _, res := range UserList {
		if strconv.Itoa(res.ID) == id {
			c.JSON(http.StatusOK, Response{
				Code: http.StatusOK,
				Data: res,
				Msg:  &#34;get successfully&#34;,
			})
		}
	}
}

```

```go
//user.go
package entity

type User struct {
	ID   int    `json:&#34;id&#34;`
	Name string `json:&#34;name&#34;`
	Age  int    `json:&#34;age&#34;`
}

type Response struct {
	Code int    `json:&#34;code&#34;`
	Data any    `json:&#34;data&#34;`
	Msg  string `json:&#34;msg&#34;`
}

var UserList []User = []User{
	{
		ID:   1,
		Name: &#34;meowrian&#34;,
		Age:  20,
	},
	{
		ID:   2,
		Name: &#34;Mike&#34;,
		Age:  30,
	},
	{
		ID:   3,
		Name: &#34;Amy&#34;,
		Age:  23,
	},
	{
		ID:   4,
		Name: &#34;John&#34;,
		Age:  24,
	},
}


```

```go
//server.go
package controller

import (
	&#34;github.com/gin-gonic/gin&#34;
	&#34;net/http&#34;
)

func Default_route(c *gin.Context) {
	c.HTML(http.StatusNotFound, &#34;404.html&#34;, nil)
}

```

![image-20240308213055236](https://static.meowrain.cn/i/2024/03/08/z8h8cb-3.webp)

![image-20240308213116279](https://static.meowrain.cn/i/2024/03/08/z8u72c-3.webp)

&gt; 路由组也是支持嵌套的



# 参数



## 查询参数

```go
package main



import (

    &#34;net/http&#34;



    &#34;github.com/gin-gonic/gin&#34;

)



func _query(c *gin.Context) {

    user := c.Query(&#34;user&#34;)

    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{

        &#34;user&#34;: user,

    })

}

func main() {

    router := gin.Default()

    router.LoadHTMLGlob(&#34;template/*&#34;)

    router.Static(&#34;/static&#34;, &#34;./static&#34;)

    router.GET(&#34;/&#34;, _query)

    router.Run(&#34;:8080&#34;)

}
```


![](https://static.meowrain.cn/i/2024/03/07/112i3vb-3.webp)


```go
package main  

import (  
    &#34;fmt&#34;  
    &#34;net/http&#34;  
    &#34;github.com/gin-gonic/gin&#34;)  

func _query(c *gin.Context) {  
    user, ok := c.GetQuery(&#34;user&#34;)  
    ids := c.QueryArray(&#34;id&#34;) //拿到多个相同的查询参数  
    maps := c.QueryMap(&#34;id&#34;)  
    fmt.Println(maps)  
    if ok {  
        c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{  
            &#34;user&#34;: user,  
            &#34;id&#34;:   ids,  
        })  
    } else {  
        c.String(http.StatusOK, &#34;No query!&#34;)  
    }  
}  

func main() {  
    router := gin.Default()  
    router.LoadHTMLGlob(&#34;template/*&#34;)  
    router.Static(&#34;static&#34;, &#34;./static&#34;)  
    router.GET(&#34;/&#34;, _query)  
    router.Run(&#34;:8080&#34;)  
}
```

&gt; 请求为： http://127.0.0.1:8080/?user=good&amp;id=1&amp;id=2&amp;id=3&amp;id[good]=meowrain
&gt; ![](https://static.meowrain.cn/i/2024/03/07/12532gz-3.webp)
&gt; ![](https://static.meowrain.cn/i/2024/03/07/1267bmh-3.webp)



##  动态参数

```go
package main  

import (  
    &#34;fmt&#34;  
    &#34;github.com/gin-gonic/gin&#34;    &#34;net/http&#34;)  

func _param(c *gin.Context) {  
    param := c.Param(&#34;user_id&#34;)  
    fmt.Println(param)  
    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{  
        &#34;param&#34;: param,  
    })  

}  
func main() {  
    router := gin.Default()  
    router.LoadHTMLGlob(&#34;template/*&#34;)  
    router.Static(&#34;static&#34;, &#34;./static&#34;)  
    router.GET(&#34;/param/:user_id&#34;, _param)  
    router.Run(&#34;:8080&#34;)  
}
```

![](https://static.meowrain.cn/i/2024/03/07/12ac8nv-3.webp)



## 表单参数PostForm

```go
package main  
  
import (  
    &#34;github.com/gin-gonic/gin&#34;  
    &#34;net/http&#34;)  
  
func postForm(c *gin.Context) {  
    name := c.PostForm(&#34;name&#34;)  
    password := c.PostForm(&#34;password&#34;)  
    c.JSON(http.StatusOK, gin.H{  
       &#34;name&#34;:     name,  
       &#34;password&#34;: password,  
    })  
}  
func index(c *gin.Context) {  
    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{})  
}  
func main() {  
    router := gin.Default()  
    router.LoadHTMLGlob(&#34;template/*&#34;)  
    router.Static(&#34;static&#34;, &#34;./static&#34;)  
    router.GET(&#34;/&#34;, index)  
    router.POST(&#34;/post&#34;, postForm)  
    router.Run(&#34;:8080&#34;)  
}
```

```html
&lt;!DOCTYPE html&gt;  
&lt;html lang=&#34;en&#34;&gt;  
&lt;head&gt;  
    &lt;meta charset=&#34;UTF-8&#34;&gt;  
    &lt;meta name=&#34;viewport&#34; content=&#34;width=device-width, initial-scale=1.0&#34;&gt;  
    &lt;title&gt;Post Form Test&lt;/title&gt;  
&lt;/head&gt;  
&lt;body&gt;  
&lt;h1&gt;Post Form Test&lt;/h1&gt;  
&lt;form id=&#34;myForm&#34; action=&#34;/post&#34; method=&#34;post&#34;&gt;  
    &lt;label for=&#34;name&#34;&gt;Name:&lt;/label&gt;  
    &lt;input type=&#34;text&#34; id=&#34;name&#34; name=&#34;name&#34; required&gt;  
    &lt;br&gt;    &lt;label for=&#34;password&#34;&gt;Password: &lt;/label&gt;  
    &lt;input type=&#34;password&#34; id=&#34;password&#34; name=&#34;password&#34; required&gt;  
    &lt;br&gt;    &lt;button type=&#34;button&#34; onclick=&#34;postData()&#34;&gt;Submit&lt;/button&gt;  
&lt;/form&gt;  
&lt;h3 id=&#34;response&#34;&gt;Response: &lt;/h3&gt;  
&lt;script&gt;  
    function postData() {  
        var form = document.getElementById(&#34;myForm&#34;);  
        var formData = new FormData(form);  
        var resp = document.getElementById(&#34;response&#34;);  
        fetch(&#39;http://127.0.0.1:8080/post&#39;, {  
            method: &#39;POST&#39;,  
            body: formData  
        })  
            .then(response =&gt; response.json())  
            .then(data =&gt; {  
                console.log(&#39;Success:&#39;, data);  
                resp.innerText = &#34;Response: &#34; &#43; JSON.stringify(data)  
            })  
            .catch((error) =&gt; {  
                console.error(&#39;Error:&#39;, error);  
                resp.innerText = &#34;Response Error: &#34; &#43; JSON.stringify(error)  
            });  
    }  
&lt;/script&gt;  
&lt;/body&gt;  
&lt;/html&gt;
```

![](https://static.meowrain.cn/i/2024/03/07/12lcebn-3.webp)


postFormArray函数

```go
package main  
  
import (  
    &#34;github.com/gin-gonic/gin&#34;  
    &#34;net/http&#34;)  
  
func postForm(c *gin.Context) {  
    name := c.PostForm(&#34;name&#34;)  
    password := c.PostForm(&#34;password&#34;)  
    respArr := c.PostFormArray(&#34;name&#34;)  
    c.JSON(http.StatusOK, gin.H{  
       &#34;name&#34;:      name,  
       &#34;password&#34;:  password,  
       &#34;respArray&#34;: respArr,  
    })  
}  
func index(c *gin.Context) {  
    c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{})  
}  
func main() {  
    router := gin.Default()  
    router.LoadHTMLGlob(&#34;template/*&#34;)  
    router.Static(&#34;static&#34;, &#34;./static&#34;)  
    router.GET(&#34;/&#34;, index)  
    router.POST(&#34;/post&#34;, postForm)  
    router.Run(&#34;:8080&#34;)  
}
```

![](https://static.meowrain.cn/i/2024/03/07/12n0072-3.webp)


## 原始参数

```go
/*  
原始参数  
*/  
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;github.com/gin-gonic/gin&#34;)  
  
func _raw(c *gin.Context) {  
    buf, err := c.GetRawData()  
    if err != nil {  
       fmt.Println(&#34;error:&#34;, err)  
       return  
    }  
    fmt.Println(string(buf))  
}  
func main() {  
    router := gin.Default()  
    router.POST(&#34;/&#34;, _raw)  
    router.Run(&#34;:8080&#34;)  
}
```


![](https://static.meowrain.cn/i/2024/03/08/extkqj-3.webp)


![](https://static.meowrain.cn/i/2024/03/08/exvpa7-3.webp)


### 解析json数据

```go
/*  
原始参数  
*/  
package main  
  
import (  
    &#34;encoding/json&#34;  
    &#34;fmt&#34;    &#34;github.com/gin-gonic/gin&#34;)  
  
func bindJSON(c *gin.Context, obj any) error {  
    body, err := c.GetRawData()  
    contentType := c.GetHeader(&#34;Content-Type&#34;)  
    fmt.Println(&#34;ContentType:&#34;, contentType)  
    if err != nil {  
       fmt.Println(&#34;error:&#34;, err)  
       return err  
    }  
    switch contentType {  
    case &#34;application/json&#34;:  
       err := json.Unmarshal(body, obj)  
       if err != nil {  
          fmt.Println(err.Error())  
          return err  
       }  
    }  
    return nil  
}  
  
func raw(c *gin.Context) {  
    type User struct {  
       Name     string `json:&#34;name&#34;`  
       Age      int    `json:&#34;age&#34;`  
       Password string `json:&#34;-&#34;`  
    }  
    var user User  
    err := bindJSON(c, &amp;user)  
    if err != nil {  
       fmt.Println(&#34;Error binding JSON:&#34;, err)  
       return  
    }  
    fmt.Println(user)  
}  
  
func main() {  
    router := gin.Default()  
    router.POST(&#34;/&#34;, raw)  
    router.Run(&#34;:8080&#34;)  
}
```

![](https://static.meowrain.cn/i/2024/03/08/fkacjn-3.webp)


![](https://static.meowrain.cn/i/2024/03/08/fki60h-3.webp)



# 四大请求方式

![](https://static.meowrain.cn/i/2024/03/08/fnulpk-3.webp)

## 简单实现以下CRUD

```go
package main  
  
import (  
    &#34;github.com/gin-gonic/gin&#34;  
    &#34;net/http&#34;    &#34;strconv&#34;)  
  
type Article struct {  
    Id      int    `json:&#34;id&#34;`  
    Title   string `json:&#34;title&#34;`  
    Content string `json:&#34;content&#34;`  
    Author  string `json:&#34;author&#34;`  
}  
  
type Response struct {  
    Code int    `json:&#34;code&#34;`  
    Data any    `json:&#34;data&#34;`  
    Msg  string `json:&#34;msg&#34;`  
}  
  
var articleList []Article = []Article{  
    {  
       1,  
       &#34;Go语言从入门到精通&#34;,  
       &#34;Learn better&#34;,  
       &#34;Mike Jason&#34;,  
    },  
    {  
       2,  
       &#34;Java从入门到精通&#34;,  
       &#34;Java is good&#34;,  
       &#34;Jack Smith&#34;,  
    },  
    {  
       3,  
       &#34;Javascript从入门到精通&#34;,  
       &#34;Javascript is a nice programming language!&#34;,  
       &#34;Amy Gorden&#34;,  
    },  
    {  
       4,  
       &#34;Python从入门到精通&#34;,  
       &#34;Python is a simple language!&#34;,  
       &#34;Jack Buffer&#34;,  
    },  
}  
  
/*简单增删改查*/  
func _getList(c *gin.Context) {  
  
    c.JSON(http.StatusOK, Response{Code: 200, Data: articleList, Msg: &#34;获取成功&#34;})  
}  
func _getDetail(c *gin.Context) {  
    id := c.Param(&#34;id&#34;)  
    flag := false  
    for _, res := range articleList {  
       if strconv.Itoa(res.Id) == id {  
          flag = true  
          c.JSON(http.StatusOK, Response{  
             Code: 200,  
             Data: res,  
             Msg:  &#34;获取成功！&#34;,  
          })  
       }  
    }  
    if flag == false {  
       c.JSON(404, Response{  
          Code: 404,  
          Data: &#34;Not Found the data&#34;,  
          Msg:  &#34;获取失败，因为数据不存在&#34;,  
       })  
    }  
}  
func _create(c *gin.Context) {  
    id, _ := strconv.ParseInt(c.PostForm(&#34;id&#34;), 10, 0)  
    title := c.PostForm(&#34;title&#34;)  
    content := c.PostForm(&#34;content&#34;)  
    author := c.PostForm(&#34;author&#34;)  
    var article Article = Article{  
       Id:      int(id),  
       Title:   title,  
       Content: content,  
       Author:  author,  
    }  
    articleList = append(articleList, article)  
    c.JSON(200, Response{Code: 200, Data: article, Msg: &#34;添加成功！&#34;})  
}  
func _delete(c *gin.Context) {  
    id := c.Param(&#34;id&#34;)  
    index := -1  
    for i, res := range articleList {  
       if strconv.Itoa(res.Id) == id {  
          index = i  
          break  
       }  
    }  
    if index != -1 {  
       articleList = append(articleList[:index], articleList[index&#43;1:]...)  
       c.JSON(http.StatusOK, Response{Code: 200, Data: nil, Msg: &#34;删除成功&#34;})  
    } else {  
       c.JSON(http.StatusNotFound, Response{Code: 404, Data: &#34;Not Found the data&#34;, Msg: &#34;删除失败，数据不存在&#34;})  
    }  
}  
func _update(c *gin.Context) {  
    id, _ := strconv.Atoi(c.Param(&#34;id&#34;))  
    title := c.PostForm(&#34;title&#34;)  
    content := c.PostForm(&#34;content&#34;)  
    author := c.PostForm(&#34;author&#34;)  
    found := false  
    for i, res := range articleList {  
       if res.Id == id {  
          found = true  
          articleList[i] = Article{  
             id,  
             title,  
             content,  
             author,  
          }  
          break  
       }  
    }  
    if found {  
       c.JSON(http.StatusOK, Response{  
          Code: 200,  
          Data: nil,  
          Msg:  &#34;更新成功&#34;,  
       })  
       return  
    } else {  
       c.JSON(http.StatusNotFound, Response{  
          Code: 404,  
          Data: &#34;Not found the data&#34;,  
          Msg:  &#34;更新失败，因为数据不存在&#34;,  
       })  
    }  
  
}  
  
func main() {  
    router := gin.Default()  
    router.GET(&#34;/articles&#34;, _getList)  
    router.GET(&#34;/articles/:id&#34;, _getDetail)  
    router.POST(&#34;/articles&#34;, _create)  
    router.PUT(&#34;/articles/:id&#34;, _update)  
    router.DELETE(&#34;/articles/:id&#34;, _delete)  
    router.Run(&#34;:8080&#34;)  
  
}
```

## 文件上传

### 上传单个文件

```go
package main

import (
	&#34;awesomeProject/pkg/controller&#34;
	&#34;github.com/gin-gonic/gin&#34;
)

func main() {

	router := gin.Default()
	router.LoadHTMLGlob(&#34;templates/*&#34;)
	router.GET(&#34;/&#34;, func(c *gin.Context) {
		c.HTML(200, &#34;upload.html&#34;, nil)
	})
	router.POST(&#34;/upload&#34;,controller.Upload_file)
	router.NoRoute(controller.Default_route)
	router.Run(&#34;:80&#34;)
}

```

```go
package controller

import (
	&#34;fmt&#34;
	&#34;github.com/gin-gonic/gin&#34;
	&#34;log&#34;
	&#34;net/http&#34;
)

func Default_route(c *gin.Context) {
	c.HTML(http.StatusNotFound, &#34;404.html&#34;, nil)
}
//文件上传
func Upload_file(c *gin.Context) {
	file, err := c.FormFile(&#34;f1&#34;)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			&#34;message&#34;: err.Error(),
		})
		return
	}
	log.Println(file.Filename)
	dst := fmt.Sprintf(&#34;./tmp/%s&#34;, file.Filename)
	c.SaveUploadedFile(file, dst)
	c.JSON(http.StatusOK, gin.H{
		&#34;message&#34;: fmt.Sprintf(&#34;&#39;%s&#39; uploaded&#34;, file.Filename),
	})
}

```



```html
&lt;!DOCTYPE html&gt;
&lt;html lang=&#34;zh-CN&#34;&gt;
&lt;head&gt;
    &lt;title&gt;上传文件示例&lt;/title&gt;
    &lt;style&gt;
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        form {
            background-color: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        input[type=&#34;file&#34;] {
            margin-bottom: 20px;
        }

        input[type=&#34;submit&#34;] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        input[type=&#34;submit&#34;]:hover {
            background-color: #45a049;
        }
    &lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;form id=&#34;uploadForm&#34;&gt;
    &lt;input type=&#34;file&#34; id=&#34;fileInput&#34; name=&#34;f1&#34;&gt;
    &lt;input type=&#34;button&#34; value=&#34;上传&#34; onclick=&#34;uploadFile()&#34;&gt;
&lt;/form&gt;

&lt;script&gt;
    function uploadFile() {
        let fileInput = document.getElementById(&#39;fileInput&#39;);
        let file = fileInput.files[0];

        if (file) {
            let formData = new FormData();
            formData.append(&#39;f1&#39;, file);

            fetch(&#39;/upload&#39;, {
                method: &#39;POST&#39;,
                body: formData
            })
                .then(response =&gt; response.json())
                .then(result =&gt; {
                    console.log(result);
                })
                .catch(error =&gt; {
                    console.error(&#39;Error:&#39;, error);
                });
        } else {
            console.error(&#39;No file selected.&#39;);
        }
    }
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;

```



![image-20240308214643811](https://static.meowrain.cn/i/2024/03/08/zhxp6e-3.webp)

![image-20240308220222511](https://static.meowrain.cn/i/2024/03/08/10f5j2o-3.webp)

### 上传多个文件

```go
package main

import (
	&#34;awesomeProject/pkg/controller&#34;
	&#34;github.com/gin-gonic/gin&#34;
)

func main() {

	router := gin.Default()
	router.LoadHTMLGlob(&#34;templates/*&#34;)
	router.GET(&#34;/&#34;, func(c *gin.Context) {
		c.HTML(200, &#34;upload.html&#34;, nil)
	})
	router.POST(&#34;/upload&#34;, controller.UploadFiles)
	router.NoRoute(controller.Default_route)
	router.Run(&#34;:80&#34;)
}

```



```go
package controller

import (
	&#34;fmt&#34;
	&#34;github.com/gin-gonic/gin&#34;
	&#34;log&#34;
	&#34;net/http&#34;
)

func Default_route(c *gin.Context) {
	c.HTML(http.StatusNotFound, &#34;404.html&#34;, nil)
}
func UploadFiles(c *gin.Context) {
	err := c.Request.ParseMultipartForm(100 &lt;&lt; 20) // 100 MB limit
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			&#34;message&#34;: err.Error(),
		})
		return
	}

	form := c.Request.MultipartForm
	if form == nil || form.File == nil {
		c.JSON(http.StatusBadRequest, gin.H{
			&#34;message&#34;: &#34;No files provided in the request&#34;,
		})
		return
	}

	files := form.File[&#34;f1&#34;]

	for _, file := range files {
		dst := fmt.Sprintf(&#34;./tmp/%s&#34;, file.Filename)
		if err := c.SaveUploadedFile(file, dst); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				&#34;message&#34;: fmt.Sprintf(&#34;Failed to save file %s: %s&#34;, file.Filename, err.Error()),
			})
			return
		}
		log.Println(file.Filename)
	}

	c.JSON(http.StatusOK, gin.H{
		&#34;message&#34;: &#34;Files uploaded successfully&#34;,
	})
}

```

```html
&lt;!DOCTYPE html&gt;
&lt;html lang=&#34;zh-CN&#34;&gt;
&lt;head&gt;
    &lt;title&gt;上传文件示例&lt;/title&gt;
    &lt;style&gt;
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        form {
            background-color: #fff;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        input[type=&#34;file&#34;] {
            margin-bottom: 20px;
        }

        input[type=&#34;submit&#34;] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        input[type=&#34;submit&#34;]:hover {
            background-color: #45a049;
        }
    &lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;form id=&#34;uploadForm&#34;&gt;
    &lt;input type=&#34;file&#34; id=&#34;fileInput&#34; name=&#34;f1&#34; multiple&gt;
    &lt;input type=&#34;button&#34; value=&#34;上传&#34; onclick=&#34;uploadFile()&#34;&gt;
&lt;/form&gt;

&lt;script&gt;
    function uploadFile() {
        let fileInput = document.getElementById(&#39;fileInput&#39;);
        let formData = new FormData();

        for (const file of fileInput.files) {
            formData.append(&#39;f1&#39;, file);
        }

        fetch(&#39;/upload&#39;, {
            method: &#39;POST&#39;,
            body: formData
        })
            .then(response =&gt; response.json())
            .then(result =&gt; {
                console.log(result);
            })
            .catch(error =&gt; {
                console.error(&#39;Error:&#39;, error);
            });
    }
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;

```

![image-20240308220131880](https://static.meowrain.cn/i/2024/03/08/10em1sq-3.webp)



![](https://static.meowrain.cn/i/2024/03/08/10enova-3.webp)

![image-20240308220155287](https://static.meowrain.cn/i/2024/03/08/10er6r4-3.webp)

### 判断上传文件的类型

在Gin框架中,可以使用`binding`模块提供的`FormFile`函数来获取上传的文件,然后检查文件的MIME类型。具体步骤如下:

1. 在处理函数中使用`c.FormFile`获取上传的文件:

```go
file, err := c.FormFile(&#34;file&#34;)
if err != nil {
    c.String(http.StatusBadRequest, &#34;获取文件失败&#34;)
    return
}
```

2. 打开文件并读取文件头部的几个字节,以识别文件的MIME类型:

```go
f, err := file.Open()
if err != nil {
    c.String(http.StatusInternalServerError, &#34;打开文件失败&#34;)
    return
}
defer f.Close()

buffer := make([]byte, 512)
_, err = f.Read(buffer)
if err != nil {
    c.String(http.StatusInternalServerError, &#34;读取文件失败&#34;)
    return
}
```

3. 使用`http.DetectContentType`函数检测文件的MIME类型:

```go
contentType := http.DetectContentType(buffer)
```

4. 判断文件类型是否允许:

```go
allowedTypes := []string{&#34;image/jpeg&#34;, &#34;image/png&#34;, &#34;application/pdf&#34;}
allowed := false
for _, t := range allowedTypes {
    if t == contentType {
        allowed = true
        break
    }
}

if !allowed {
    c.String(http.StatusBadRequest, &#34;不支持的文件类型&#34;)
    return
}
```

完整的示例代码如下:

```go
func uploadFile(c *gin.Context) {
    file, err := c.FormFile(&#34;file&#34;)
    if err != nil {
        c.String(http.StatusBadRequest, &#34;获取文件失败&#34;)
        return
    }

    f, err := file.Open()
    if err != nil {
        c.String(http.StatusInternalServerError, &#34;打开文件失败&#34;)
        return
    }
    defer f.Close()

    buffer := make([]byte, 512)
    _, err = f.Read(buffer)
    if err != nil {
        c.String(http.StatusInternalServerError, &#34;读取文件失败&#34;)
        return
    }

    contentType := http.DetectContentType(buffer)
    allowedTypes := []string{&#34;image/jpeg&#34;, &#34;image/png&#34;, &#34;application/pdf&#34;}
    allowed := false
    for _, t := range allowedTypes {
        if t == contentType {
            allowed = true
            break
        }
    }

    if !allowed {
        c.String(http.StatusBadRequest, &#34;不支持的文件类型&#34;)
        return
    }

    // 处理文件...
}
```

在上面的示例中，我们定义了一个允许的MIME类型列表`allowedTypes`，包括`image/jpeg`、`image/png`和`application/pdf`。如果上传的文件类型不在允许列表中，就会返回错误响应。你可以根据需求修改允许的文件类型列表。



### 使用gin编写文件服务器

```go
package controller

import (
	&#34;fmt&#34;
	&#34;github.com/gin-gonic/gin&#34;
	&#34;log&#34;
	&#34;net/http&#34;
	&#34;os&#34;
)

func Default_route(c *gin.Context) {
	c.HTML(http.StatusNotFound, &#34;404.html&#34;, nil)
}
func UploadFiles(c *gin.Context) {
	err := c.Request.ParseMultipartForm(100 &lt;&lt; 20) // 100 MB limit
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			&#34;message&#34;: err.Error(),
		})
		return
	}

	form := c.Request.MultipartForm
	if form == nil || form.File == nil {
		c.JSON(http.StatusBadRequest, gin.H{
			&#34;message&#34;: &#34;No files provided in the request&#34;,
		})
		return
	}

	files := form.File[&#34;f1&#34;]

	for _, file := range files {
		dst := fmt.Sprintf(&#34;./tmp/%s&#34;, file.Filename)
		if err := c.SaveUploadedFile(file, dst); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				&#34;message&#34;: fmt.Sprintf(&#34;Failed to save file %s: %s&#34;, file.Filename, err.Error()),
			})
			return
		}
		log.Println(file.Filename)
	}

	c.JSON(http.StatusOK, gin.H{
		&#34;message&#34;: &#34;Files uploaded successfully&#34;,
	})
}
func ListFiles(c *gin.Context) {
	// 读取 ./tmp 目录下的所有文件
	files, err := os.ReadDir(&#34;./tmp&#34;)
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		return
	}

	// 渲染模板
	c.HTML(http.StatusOK, &#34;download.html&#34;, gin.H{
		&#34;Files&#34;: files,
	})
}

```

```go
package main

import (
	&#34;awesomeProject/pkg/controller&#34;
	&#34;github.com/gin-gonic/gin&#34;
)

func main() {
	r := gin.Default()

	// 设置静态文件路径为 ./tmp
	r.Static(&#34;/tmp&#34;, &#34;./tmp&#34;)

	// 设置模板目录
	r.LoadHTMLGlob(&#34;templates/*&#34;)

	// 定义路由
	r.GET(&#34;/&#34;, func(c *gin.Context) {
		c.HTML(200, &#34;upload.html&#34;, nil)
	})
	r.POST(&#34;/upload&#34;, controller.UploadFiles)

	//文件列表服务器
	r.GET(&#34;/files&#34;, controller.ListFiles)

	// 启动HTTP服务器
	r.Run(&#34;:8080&#34;)
}

```



```html
&lt;!--download.html --&gt;
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
    &lt;title&gt;File List&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;h1&gt;File List&lt;/h1&gt;
&lt;ul&gt;
    {{ range .Files }}
    &lt;li&gt;&lt;a href=&#34;/tmp/{{ .Name }}&#34;&gt;{{ .Name }}&lt;/a&gt;&lt;/li&gt;
    {{ end }}
&lt;/ul&gt;
&lt;/body&gt;
&lt;/html&gt;
```

```html
&lt;!--美化版--&gt;
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
    &lt;title&gt;File List&lt;/title&gt;
    &lt;style&gt;
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }

        h1 {
            color: #333;
            text-align: center;
        }

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        li {
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin: 10px;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }

        a {
            text-decoration: none;
            color: #333;
        }

        a:hover {
            color: #666;
        }
    &lt;/style&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;h1&gt;File List&lt;/h1&gt;
&lt;ul&gt;
    {{ range .Files }}
    &lt;li&gt;&lt;a href=&#34;/tmp/{{ .Name }}&#34;&gt;{{ .Name }}&lt;/a&gt;&lt;/li&gt;
    {{ end }}
&lt;/ul&gt;
&lt;/body&gt;
&lt;/html&gt;
```



![image-20240308222026615](https://static.meowrain.cn/i/2024/03/08/10pw52c-3.webp)

![image-20240308222225060](https://static.meowrain.cn/i/2024/03/08/10r2oqf-3.webp)

![image-20240308222527025](https://static.meowrain.cn/i/2024/03/08/10svloq-3.webp)

# 请求头相关

## 获取所有请求头

![](https://static.meowrain.cn/i/2024/03/08/iu6r5m-3.webp)

```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;github.com/gin-gonic/gin&#34;    &#34;net/http&#34;)  
  
func main() {  
    router := gin.Default()  
    router.LoadHTMLGlob(&#34;template/*&#34;)  
    router.Static(&#34;static&#34;, &#34;./static&#34;)  
    router.GET(&#34;/&#34;, func(c *gin.Context) {  
       c.HTML(http.StatusOK, &#34;index.html&#34;, gin.H{  
          &#34;header&#34;: c.Request.Header,  
       })  
       fmt.Println(c.Request.Header)  
    })  
    router.Run(&#34;:8080&#34;)  
}
```

```html
&lt;!DOCTYPE html&gt;  
&lt;html lang=&#34;en&#34;&gt;  
&lt;head&gt;  
    &lt;meta charset=&#34;UTF-8&#34;&gt;  
    &lt;meta name=&#34;viewport&#34; content=&#34;width=device-width, initial-scale=1.0&#34;&gt;  
    &lt;title&gt;Post Form Test&lt;/title&gt;  
&lt;/head&gt;  
&lt;body&gt;  
&lt;h1&gt;Header Test&lt;/h1&gt;  
&lt;h3&gt;Header: {{.header}}&lt;/h3&gt;  
&lt;/body&gt;  
&lt;/html&gt;
```

## 绑定参数bind

&gt; 绑定post发送的json数据转换为Student结构体的成员变量值，然后再把这个结构体转换为json对象

```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;github.com/gin-gonic/gin&#34;    &#34;net/http&#34;)  
  
type Student struct {  
    Name string `json:&#34;name&#34;`  
    Age  int    `json:&#34;age&#34;`  
}  
  
func main() {  
    router := gin.Default()  
    router.POST(&#34;/&#34;, func(c *gin.Context) {  
       var stu Student  
       err := c.BindJSON(&amp;stu)  
       if err != nil {  
          fmt.Println(&#34;error: &#34;, err)  
          c.JSON(http.StatusBadGateway, err)  
          return  
       }  
       c.JSON(http.StatusOK, stu)  
    })  
    router.Run(&#34;:8080&#34;)  
}
```

![](https://static.meowrain.cn/i/2024/03/08/shcott-3.webp)

&gt; 绑定查询参数

```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;github.com/gin-gonic/gin&#34;    &#34;net/http&#34;)  
  
type Student struct {  
    Name string `json:&#34;name&#34; form:&#34;name&#34;`  
    Age  int    `json:&#34;age&#34; form:&#34;age&#34;`  
}  
  
func main() {  
    router := gin.Default()  
    router.GET(&#34;/&#34;, func(c *gin.Context) {  
       var stu Student  
       err := c.BindQuery(&amp;stu)  
       if err != nil {  
          fmt.Println(&#34;error: &#34;, err)  
          c.JSON(http.StatusBadGateway, err)  
          return  
       }  
       c.JSON(http.StatusOK, stu)  
    })  
    router.Run(&#34;:8080&#34;)  
}
```

![](https://static.meowrain.cn/i/2024/03/08/sjnhl2-3.webp)



&gt;  bind URI

```go
package main  
  
import (  
    &#34;fmt&#34;  
    &#34;github.com/gin-gonic/gin&#34;    &#34;net/http&#34;)  
  
type Student struct {  
    Name string `json:&#34;name&#34; form:&#34;name&#34; uri:&#34;name&#34;`  
    Age  int    `json:&#34;age&#34; form:&#34;age&#34; uri:&#34;age&#34;`  
}  
  
func main() {  
    router := gin.Default()  
    router.GET(&#34;/uri/:name/:age&#34;, func(c *gin.Context) {  
       var stu Student  
       err := c.ShouldBindUri(&amp;stu)  
       if err != nil {  
          fmt.Println(&#34;error: &#34;, err)  
          c.JSON(http.StatusBadGateway, err)  
          return  
       }  
       c.JSON(http.StatusOK, stu)  
    })  
    router.Run(&#34;:8080&#34;)  
}
```


![](https://static.meowrain.cn/i/2024/03/08/sm69pi-3.webp)


## 常用验证器

```
// 不能为空，并且不能没有这个字段
required： 必填字段，如：binding:&#34;required&#34;  

// 针对字符串的长度
min 最小长度，如：binding:&#34;min=5&#34;
max 最大长度，如：binding:&#34;max=10&#34;
len 长度，如：binding:&#34;len=6&#34;

// 针对数字的大小
eq 等于，如：binding:&#34;eq=3&#34;
ne 不等于，如：binding:&#34;ne=12&#34;
gt 大于，如：binding:&#34;gt=10&#34;
gte 大于等于，如：binding:&#34;gte=10&#34;
lt 小于，如：binding:&#34;lt=10&#34;
lte 小于等于，如：binding:&#34;lte=10&#34;

// 针对同级字段的
eqfield 等于其他字段的值，如：PassWord string `binding:&#34;eqfield=Password&#34;`
nefield 不等于其他字段的值


- 忽略字段，如：binding:&#34;-&#34;
```

```go
package main  
  
import (  
    &#34;github.com/gin-gonic/gin&#34;  
    &#34;net/http&#34;)  
  
type User struct {  
    Name        string `json:&#34;name&#34; binding:&#34;required&#34;`  
    Password    string `json:&#34;password&#34; binding:&#34;eqfield=Re_Password&#34;`  
    Re_Password string `json:&#34;re_password&#34;`  
}  
type Response struct {  
    Code int    `json:&#34;code&#34;`  
    Data any    `json:&#34;data&#34;`  
    Msg  string `json:&#34;msg&#34;`  
}  
  
func main() {  
    router := gin.Default()  
    router.POST(&#34;/login&#34;, func(c *gin.Context) {  
       var user User  
       err := c.ShouldBindJSON(&amp;user)  
       if err != nil {  
          c.JSON(http.StatusBadGateway, Response{  
             Code: http.StatusBadGateway,  
             Data: err.Error(),  
             Msg:  &#34;bad response&#34;,  
          })  
          return  
       }  
       c.JSON(http.StatusOK, Response{  
          Code: http.StatusOK,  
          Data: user,  
          Msg:  &#34;post successfully&#34;,  
       })  
    })  
    router.Run(&#34;:8080&#34;)  
}
```

&gt; 密码相同
&gt; ![](https://static.meowrain.cn/i/2024/03/08/t2zolw-3.webp)


&gt; 密码不同
&gt; ![](https://static.meowrain.cn/i/2024/03/08/t3ebk2-3.webp)


&gt; 我们看到报错对用户不是很友好，我们可以自定义验证的错误信息
&gt;
&gt; TODO


##  [gin内置验证器](https://docs.fengfengzhidao.com/#/docs/Gin%E6%A1%86%E6%9E%B6%E6%96%87%E6%A1%A3/4.bind%E7%BB%91%E5%AE%9A%E5%99%A8?id=gin%e5%86%85%e7%bd%ae%e9%aa%8c%e8%af%81%e5%99%a8)

```
// 枚举  只能是red 或green
oneof=red green 

// 字符串  
contains=fengfeng  // 包含fengfeng的字符串
excludes // 不包含
startswith  // 字符串前缀
endswith  // 字符串后缀

// 数组
dive  // dive后面的验证就是针对数组中的每一个元素

// 网络验证
ip
ipv4
ipv6
uri
url
// uri 在于I(Identifier)是统一资源标示符，可以唯一标识一个资源。
// url 在于Locater，是统一资源定位符，提供找到该资源的确切路径

// 日期验证  1月2号下午3点4分5秒在2006年
datetime=2006-01-02
```





---



# Gin中间件

&gt; https://www.liwenzhou.com/posts/Go/gin/#c-0-8-3

Gin中的中间件必须是一个`gin.HandlerFunc`类型。

Gin框架允许开发者在处理请求的过程中，加入用户自己的钩子（Hook）函数。这个钩子函数就叫中间件，中间件适合处理一些公共的业务逻辑，比如登录认证、权限校验、数据分页、记录日志、耗时统计等。



#### 记录接口耗时的中间件

```go

```


---

> 作者: meowrain  
> URL: http://localhost:1313/posts/31a491d/  

