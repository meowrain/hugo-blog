---
title: Go网络编程
subtitle:
date: 2024-05-18T18:14:40+08:00
slug: fb7e90b
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Go
  - 网络编程
categories:
  - Go
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
summary:
resources:
  - name: featured-image
    src: featured-image.jpg
  - name: featured-image-preview
    src: featured-image-preview.jpg
toc: true
math: true
lightgallery: true
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

# Go网络编程

## IP
"net"包定义了许多类型, 函数，方法用于 Go 网络编程。IPIPIPIP 类型被定义为一个字节数组。--> `type IP []byte`

有几个函数来处理一个 IP 类型的变量, 但是在实践中你很可能只用到其中的一些。例如, 
`ParseIP(String)`函数将获取逗号分隔的 IPv4 或者冒号分隔的 IPv6 地址, 而 IP 类型的`String()方法`将返回一个字符串。

```go
package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s ipaddr\n", os.Args[0])
		os.Exit(1)
	}
	ipAddress := os.Args[1]
	ip := net.ParseIP(ipAddress)
	if ip != nil {
		fmt.Println(ip)
	} else {
		fmt.Fprintf(os.Stderr, "Error ip Address")
	}

}

```

> 上面的fmt.Println的时候，会自动调用net.IP的String方法

结果如下：
![](https://static.meowrain.cn/i/2024/05/18/u67ifq-3.webp)

## IP 掩码

```go
// An IPMask is a bitmask that can be used to manipulate
// IP addresses for IP addressing and routing.
//
// See type [IPNet] and func [ParseCIDR] for details.
type IPMask []byte

```

```go
package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s ipaddr\n", os.Args[0])
		os.Exit(1)
	}
	ipAddress := os.Args[1]
	ip := net.ParseIP(ipAddress)
	if ip != nil {
		if ip.To4() != nil {
			// IPv4 address
			defaultMask := ip.DefaultMask()
			res := ip.Mask(defaultMask)          //通过ip.Mask方法获取这个网络的起始网络号
			mask := net.IP(defaultMask).String() //将获取到的十六进制子网掩码转换为十进制的ipv4
			ones, bits := defaultMask.Size()     //ones：子网掩码中前导1的数量。
			//bits：子网掩码的总位数。

			// ip.DefaultMask()获取这个ip的子网掩码
			fmt.Println("网络起始为:", res)
			fmt.Println("mask:", mask)
			fmt.Printf("网络号长度:%d,总位数:%d", ones, bits)
		} else {
			// IPv6 address
			fmt.Println("IPv6 address does not have a mask like IPv4.")
		}
	} else {
		fmt.Fprintf(os.Stderr, "Error: Invalid IP Address\n")
	}
}

```

![](https://static.meowrain.cn/i/2024/05/18/upxcxs-3.webp)

## IPAddr
```go
// IPAddr represents the address of an IP end point.
type IPAddr struct {
	IP   IP
	Zone string // IPv6 scoped addressing zone
}
```


使用`ResolveIPAddr`解析地址
```go
package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s ip-address\n", os.Args[0])
		os.Exit(1)
	}
	name := os.Args[1]
	res, err := net.ResolveIPAddr("ip4", name)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error:%v", err)
	}
	fmt.Printf("resolve domain name:%s,ip: %s\n", name, res)
	fmt.Println("mask:", net.IP(res.IP.DefaultMask()))
}


```

![](https://static.meowrain.cn/i/2024/05/18/vrcm3j-3.webp)

![](https://static.meowrain.cn/i/2024/05/18/vseqmr-3.webp)

使用LookupHost()查找域名的所有ip（有cdn）
```go
package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s ip-address\n", os.Args[0])
		os.Exit(1)
	}
	name := os.Args[1]
	res, err := net.LookupHost(name)
	if err != nil {
		fmt.Println("error", err)
	}
	fmt.Printf("resolve domain name:%s,ip: %s\n", name, res)

}
```
![](https://static.meowrain.cn/i/2024/05/18/vzivcf-3.webp)


## Port
```go
package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Fprintf(os.Stderr, "Usage: %s network-type service ", os.Args[0])
		os.Exit(1)
	}
	networkType := os.Args[1]
	service := os.Args[2]
	port, err := net.LookupPort(networkType, service)
	if err != nil {
		fmt.Fprintf(os.Stderr, err.Error())
		os.Exit(1)
	}
	fmt.Println("Service port:", port)
	os.Exit(0)
}

```

![](https://static.meowrain.cn/i/2024/05/19/umv30e-3.webp)

![](https://static.meowrain.cn/i/2024/05/19/uoomsv-3.webp)


## TCPAddr

```go
// TCPAddr represents the address of a TCP end point.
type TCPAddr struct {
	IP   IP
	Port int
	Zone string // IPv6 scoped addressing zone
}
```

```go
package main

import (
	"fmt"
	"net"
)

func main() {
	addr2, err := net.ResolveTCPAddr("tcp", "baidu.com:443")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Printf("addr domain:%s,port:%d", addr2.IP, addr2.Port)

	// fmt.Println(addr)
}

```


![](https://static.meowrain.cn/i/2024/05/19/vpk00w-3.webp)

## 编写一个TCP客户端
```go
package main

import (
	"fmt"
	"io"
	"net"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s host:port", os.Args[0])
		os.Exit(1)
	}
	service := os.Args[1]
	tcpAddr, err := net.ResolveTCPAddr("tcp4", service)
	if err != nil {
		fmt.Fprintf(os.Stderr, "resolve input failed %v", err)
		os.Exit(1)
	}
	conn, err := net.DialTCP("tcp", nil, tcpAddr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "connection failed: %v", err)
		os.Exit(1)
	}
	defer conn.Close()
	_, err = conn.Write([]byte("HEAD / HTTP/1.0\r\n\r\n"))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Write failed:%v", err)
		os.Exit(1)
	}
	result, err := io.ReadAll(conn)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Read from connection failed:%v", err)
		os.Exit(1)
	}

	fmt.Println(string(result))
	os.Exit(0)
}

```

![](https://static.meowrain.cn/i/2024/05/19/w5osxr-3.webp)

