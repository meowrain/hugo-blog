---
title: Java网络编程 TCP网络通信编程字符流
subtitle:
date: 2024-05-23T12:09:12+08:00
slug: 4893d97
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Java
  - 网络编程
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

# TCP字符流编程

![](https://static.meowrain.cn/i/2024/01/11/zavbjb-3.webp)


![](https://static.meowrain.cn/i/2024/01/11/zfb2dk-3.webp)



---

# 代码
```java
package org.example.socket;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class SocketTcp03Server {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(9999);
        Socket socket = serverSocket.accept();
        System.out.println("服务端启动，正在监听9999端口");

        InputStream inputStream = socket.getInputStream();
        InputStreamReader reader = new InputStreamReader(inputStream);
        BufferedReader bufferedReader = new BufferedReader(reader);
        String s = bufferedReader.readLine();
        System.out.println(s);
        socket.shutdownInput();

        OutputStream outputStream = socket.getOutputStream();
        OutputStreamWriter writer = new OutputStreamWriter(outputStream);
        BufferedWriter bufferedWriter = new BufferedWriter(writer);
        bufferedWriter.write("hello,client字符流");
        bufferedWriter.newLine();
        bufferedWriter.flush();
        socket.shutdownOutput();

        //关闭外层流即可
        bufferedReader.close();
        bufferedWriter.close();
        serverSocket.close();
        socket.close();
    }
}

```


---

```java

package org.example.socket;

import java.io.*;
import java.net.InetAddress;
import java.net.Socket;


public class SocketTcp03Client {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket(InetAddress.getLocalHost(),9999);
        System.out.println("客户端启动，准备向9999端口发送信息");
        OutputStream outputStream = socket.getOutputStream();
        OutputStreamWriter writer = new OutputStreamWriter(outputStream);
        BufferedWriter bufferedWriter = new BufferedWriter(writer);
        bufferedWriter.write("hello,server字符流");
        bufferedWriter.newLine(); //写用newLIne方法，read也要用readLine方法
        bufferedWriter.flush(); //需要刷新
        socket.shutdownOutput();


        InputStream inputStream = socket.getInputStream();
        InputStreamReader reader = new InputStreamReader(inputStream);
        BufferedReader bufferedReader = new BufferedReader(reader);
        String s = bufferedReader.readLine();
        System.out.println(s);

        socket.close();
        bufferedWriter.close();
        bufferedReader.close();
    }
}

```


![](https://static.meowrain.cn/i/2024/01/12/f9keo9-3.webp)


![](https://static.meowrain.cn/i/2024/01/12/f9n9wv-3.webp)

