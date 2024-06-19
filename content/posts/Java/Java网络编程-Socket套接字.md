---
title: Java网络编程 Socket套接字
subtitle:
date: 2024-05-23T12:10:41+08:00
slug: 45570b6
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Java网络编程
categories:
  - 网络编程
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

# Socket

![](https://static.meowrain.cn/i/2024/01/11/uhjt1b-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/ukd5w8-3.webp)

![](https://static.meowrain.cn/i/2024/01/11/ukgqn0-3.webp)

> Socket有两种编程方式
> - tcp编程
> - udp编程

![](https://static.meowrain.cn/i/2024/01/11/um5tsz-3.webp)


# Java Socket建立连接

Server.java
```java
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args) {
        try {
            ServerSocket server = new ServerSocket(8080); // 8080 is the port number
            System.out.println("Server is running... waiting for client to connect");
            Socket socket = server.accept();// wait for client to connect
            System.out.println("Client connected" + socket.getInetAddress().getHostAddress());// get the ip address of the client
            server.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

Cilent.java
```java
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
public class Cilent {
    public static void main(String[] args) {
    try(Socket socket = new Socket()) {
        socket.connect(new InetSocketAddress("localhost", 8080));
        System.out.println("Connected to server");
    }catch (IOException e) {
        e.printStackTrace(); //
    }
    }
}
```

# 通过Socket进行数据传输
SocketServer.java
```java
package com.meowrain.tcpserver;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class SocketTCP01Server {
    public static void main(String[] args) throws IOException {
        ServerSocket server = new ServerSocket(8080);
        System.out.println("Server is running... waiting for client to connect");
        Socket socket = server.accept();
        System.out.println("Connet successfully");
        InputStream inputStream = socket.getInputStream();
        byte[] bytes = new byte[1024];
        int readLen = 0;
        while ((readLen = inputStream.read(bytes)) != -1) {
            System.out.println(new String(bytes, 0, readLen));
        }
        server.close();
    }
}
```
![](https://static.meowrain.cn/i/2023/03/04/zkqquu-3.webp)


SocketCilent.java
```java
package com.meowrain.tcpserver;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.Socket;
public class SocketTCP01Cilent {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket(InetAddress.getLocalHost(), 8080);
        OutputStream outputStream = socket.getOutputStream();
        outputStream.write("Hello, I am client".getBytes());
        socket.close();
        System.out.println("Connet over");
    }
}
```

![](https://static.meowrain.cn/i/2023/03/04/zkt9oo-3.webp)
