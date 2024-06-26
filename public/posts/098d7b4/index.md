# HTTP状态码


## 1xx 状态码

API 不需要1xx状态码，下面介绍其他四类状态码的精确含义。

## 2xx 状态码

200状态码表示操作成功，但是不同的方法可以返回更精确的状态码。

GET:    200 OK
POST:   201 Created
PUT:    200 OK
PATCH:  200 OK
DELETE: 204 No Content
上面代码中，POST返回201状态码，表示生成了新的资源；DELETE返回204状态码，表示资源已经不存在。

## 3xx 状态码

API 用不到301状态码（永久重定向）和302状态码（暂时重定向，307也是这个含义），因为它们可以由应用级别返回，浏览器会直接跳转，API 级别可以不考虑这两种情况。

API 主要是用303 See Other，表示参考另一个 URL。它与302和307的含义一样，也是”暂时重定向”，区别在于302和307用于GET请求，而303用于POST、PUT和DELETE请求。收到303以后，浏览器不会自动跳转，而会让用户自己决定下一步怎么办。下面是一个例子。

HTTP/1.1 303 See Other
Location: /api/orders/12345

## 4xx 状态码

4xx 状态码表示客户端错误，主要有下面几种：

400 Bad Request：服务器不理解客户端的请求，未做任何处理。
401 Unauthorized：用户未提供身份验证凭据，或者没有通过身份验证。
403 Forbidden：用户通过了身份验证，但是不具有访问资源所需的权限。
404 Not Found：所请求的资源不存在，或不可用。
405 Method Not Allowed：用户已经通过身份验证，但是所用的 HTTP 方法不在他的权限之内。
410 Gone：所请求的资源已从这个地址转移，不再可用。
415 Unsupported Media Type：客户端要求的返回格式不支持。比如，API 只能返回 JSON 格式，但是客户端要求返回 XML 格式。
422 Unprocessable Entity ：客户端上传的附件无法处理，导致请求失败。
429 Too Many Requests：客户端的请求次数超过限额。
## 5xx 状态码

5xx状态码表示服务端错误。一般来说，API 不会向用户透露服务器的详细信息，所以只要两个状态码就够了。

500 Internal Server Error：客户端请求有效，服务器处理时发生了意外。
503 Service Unavailable：服务器无法处理请求，一般用于网站维护状态。

---

> 作者: meowrain  
> URL: https://example.org/posts/098d7b4/  

