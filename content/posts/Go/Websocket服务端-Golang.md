---
title: Websocket服务端 Golang
subtitle:
date: 2024-06-23T13:25:04+08:00
slug: 6d55928
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Go
  - Websocket
  - 聊天室服务
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

# 服务端1

> 收到客户端消息马上发回给客户端
 
```go
package main

import (
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader websocket.Upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func socketHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Fatalln("Error during connection upgration:", err)
	}
	defer conn.Close()

	for {
		messageType, message, err := conn.ReadMessage()
		if err != nil {
			log.Println("Error during message reading:", err)
			break
		}
		log.Printf("Received:%s", message)
		err = conn.WriteMessage(messageType, message)
		if err != nil {
			log.Println("Error during message writing:", err)
			break
		}
	}
}
func Home(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "index.html")
}

func main() {
	http.HandleFunc("/ws", socketHandler)
	http.HandleFunc("/", Home)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}

```

---

# 服务端2-增加文件传输功能

```go
package main

import (
	"log"
	"net/http"
	"sync"

	"github.com/gorilla/websocket"
)

var connections = make([]*websocket.Conn, 0)
var mu sync.Mutex // Mutex to protect the connections slice

var upgrader websocket.Upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func socketHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Error during connection upgrade:", err)
		return
	}

	mu.Lock()
	connections = append(connections, conn)
	mu.Unlock()

	defer func() {
		mu.Lock()
		for i, c := range connections {
			if c == conn {
				connections = append(connections[:i], connections[i+1:]...)
				break
			}
		}
		mu.Unlock()
		conn.Close()
		log.Println("Client disconnected:", conn.RemoteAddr().String())
	}()

	log.Println("Client connected:", conn.RemoteAddr().String())

	for {
		clientInfo := conn.RemoteAddr().String() + "\t"
		messageType, message, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsCloseError(err, websocket.CloseNormalClosure, websocket.CloseGoingAway) {
				log.Println("Connection closed by client:", conn.RemoteAddr().String())
			} else {
				log.Println("Error during message reading:", err)
			}
			break
		}

		if messageType == websocket.TextMessage {
			log.Printf("Received from %s message: %s", clientInfo, string(message))
		} else if messageType == websocket.BinaryMessage {
			log.Printf("Received binary message from %s", clientInfo)
		}

		mu.Lock()
		for _, client := range connections {
			if client != conn {
				err := client.WriteMessage(messageType, message)
				if err != nil {
					log.Println("Error during message writing:", err)
				}
			}
		}
		mu.Unlock()
	}
}

func Home(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "index.html")
}

func main() {
	http.HandleFunc("/ws", socketHandler)
	http.HandleFunc("/", Home)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}

```

前端代码：

```html
<!DOCTYPE html>
<html>
<head>
    <title>WebSocket Client</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #333;
        }
        #controls {
            margin-bottom: 20px;
        }
        button {
            padding: 10px 15px;
            margin-right: 10px;
            border: none;
            background-color: #007BFF;
            color: white;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        button:disabled {
            background-color: #CCCCCC;
            cursor: not-allowed;
        }
        button:hover:not(:disabled) {
            background-color: #0056b3;
        }
        #messageInput, #fileInput {
            padding: 10px;
            margin-right: 10px;
            border-radius: 5px;
            border: 1px solid #CCC;
            width: 300px;
        }
        #messages {
            margin-top: 20px;
            padding: 10px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        #messages div {
            padding: 5px 0;
            border-bottom: 1px solid #EEE;
        }
        #messages div:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
<h1>WebSocket Client</h1>
<div id="controls">
    <button id="connectButton">Connect</button>
    <button id="sendButton" disabled>Send Message</button>
    <button id="sendFileButton" disabled>Send File</button>
    <button id="closeButton" disabled>Close Connection</button>
    <input type="text" id="messageInput" placeholder="Type a message" disabled>
    <input type="file" id="fileInput" disabled>
</div>
<div id="messages"></div>

<script>
    let socket;

    document.getElementById('connectButton').addEventListener('click', () => {
        socket = new WebSocket('ws://localhost:8080/ws');

        socket.onopen = function() {
            document.getElementById('sendButton').disabled = false;
            document.getElementById('sendFileButton').disabled = false;
            document.getElementById('closeButton').disabled = false;
            document.getElementById('messageInput').disabled = false;
            document.getElementById('fileInput').disabled = false;
            appendMessage('Connected to the server');
        };

        socket.onmessage = function(event) {
            if (typeof event.data === 'string') {
                appendMessage('Received: ' + event.data);
            } else {
                event.data.arrayBuffer().then(buffer => {
                    const dataView = new DataView(buffer);
                    const nameLength = dataView.getUint16(0, true);
                    const name = new TextDecoder().decode(new Uint8Array(buffer.slice(2, 2 + nameLength)));
                    const fileData = buffer.slice(2 + nameLength);
                    const blob = new Blob([fileData]);
                    const url = URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = name;
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    appendMessage(`Received file: ${name}`);
                });
            }
        };

        socket.onclose = function() {
            document.getElementById('sendButton').disabled = true;
            document.getElementById('sendFileButton').disabled = true;
            document.getElementById('closeButton').disabled = true;
            document.getElementById('messageInput').disabled = true;
            document.getElementById('fileInput').disabled = true;
            appendMessage('Connection closed');
        };

        socket.onerror = function(error) {
            appendMessage('Error: ' + error.message);
        };
    });

    document.getElementById('sendButton').addEventListener('click', () => {
        const message = document.getElementById('messageInput').value;
        socket.send(message);
        appendMessage('Sent: ' + message);
    });

    document.getElementById('sendFileButton').addEventListener('click', () => {
        const file = document.getElementById('fileInput').files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                const arrayBuffer = event.target.result;
                const nameBuffer = new TextEncoder().encode(file.name);
                const nameLength = nameBuffer.byteLength;
                const buffer = new ArrayBuffer(2 + nameLength + arrayBuffer.byteLength);
                const dataView = new DataView(buffer);
                dataView.setUint16(0, nameLength, true);
                new Uint8Array(buffer).set(nameBuffer, 2);
                new Uint8Array(buffer).set(new Uint8Array(arrayBuffer), 2 + nameLength);
                socket.send(buffer);
                appendMessage('Sent file: ' + file.name);
            };
            reader.readAsArrayBuffer(file);
        }
    });

    document.getElementById('closeButton').addEventListener('click', () => {
        socket.close();
    });

    function appendMessage(message) {
        const messageDiv = document.createElement('div');
        messageDiv.textContent = message;
        document.getElementById('messages').appendChild(messageDiv);
    }
</script>
</body>
</html>
```

## 服务端代码解析
我们来分析一下这个怎么实现的：
```go
var connections = make([]*websocket.Conn, 0)
```
我们用这个代码存储连接，便于后面服务器收到一个客户端的消息后向连接到服务器的每个客户端的连接发送消息，实现聊天交互

```go
var mu sync.Mutex // Mutex to protect the connections slice
```
代码中使用互斥锁 (sync.Mutex) 的主要目的是保护 connections 切片，确保在多个协程并发访问和修改 connections 切片时不会出现竞态条件（Race Condition）。竞态条件可能导致数据损坏或不可预测的行为。

```go
var upgrader websocket.Upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

```
然后我们创建一个`websocket.Upgrader`，将普通的http升级为websocket，并且配置为检查origin

```go

func socketHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Error during connection upgrade:", err)
		return
	}

	mu.Lock()
	connections = append(connections, conn)
	mu.Unlock()

	defer func() {
		mu.Lock()
		for i, c := range connections {
			if c == conn {
				connections = append(connections[:i], connections[i+1:]...)
				break
			}
		}
		mu.Unlock()
		conn.Close()
		log.Println("Client disconnected:", conn.RemoteAddr().String())
	}()

	log.Println("Client connected:", conn.RemoteAddr().String())

	for {
		clientInfo := conn.RemoteAddr().String() + "\t"
		messageType, message, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsCloseError(err, websocket.CloseNormalClosure, websocket.CloseGoingAway) {
				log.Println("Connection closed by client:", conn.RemoteAddr().String())
			} else {
				log.Println("Error during message reading:", err)
			}
			break
		}

		if messageType == websocket.TextMessage {
			log.Printf("Received from %s message: %s", clientInfo, string(message))
		} else if messageType == websocket.BinaryMessage {
			log.Printf("Received binary message from %s", clientInfo)
		}

		mu.Lock()
		for _, client := range connections {
			if client != conn {
				err := client.WriteMessage(messageType, message)
				if err != nil {
					log.Println("Error during message writing:", err)
				}
			}
		}
		mu.Unlock()
	}
}
```
接下来我们编写`socketHandler`函数，

### http升级为websocket部分
这行我们实现对http的升级
```go
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Error during connection upgrade:", err)
		return
	}

```
https://meowrain.cn/archives/http-sheng-ji-wei-websocket
详情见上面的连接


### 将连接添加到切片部分
```go
	mu.Lock()
	connections = append(connections, conn)
	mu.Unlock()
  ```
使用append把connection添加到connections切片中


### 处理并读取客户端发来的消息
```go
		clientInfo := conn.RemoteAddr().String() + "\t"
		messageType, message, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsCloseError(err, websocket.CloseNormalClosure, websocket.CloseGoingAway) {
				log.Println("Connection closed by client:", conn.RemoteAddr().String())
			} else {
				log.Println("Error during message reading:", err)
			}
			break
		}

		if messageType == websocket.TextMessage {
			log.Printf("Received from %s message: %s", clientInfo, string(message))
		} else if messageType == websocket.BinaryMessage {
			log.Printf("Received binary message from %s", clientInfo)
		}

```
这部分我们通过conn读取客户端的ip和port，然后存储到`clientInfo`变量中，如果检查到错误是客户端断开连接，那么就打印客户端断开连接的消息
接下来判断`messageType`，也就是发送来消息的信息类型，如果是text类型，那么我们就打印接收到客户端发来的文本信息，如果是二进制类型的文件，比如图片，音乐，视频之类的，那么就打印接收到客户端的二进制信息


### 发送部分
```go
		mu.Lock()
		for _, client := range connections {
			if client != conn {
				err := client.WriteMessage(messageType, message)
				if err != nil {
					log.Println("Error during message writing:", err)
				}
			}
		}
		mu.Unlock()
```

这段代码被用来处理发送逻辑，我们上一个互斥锁，防止竞态条件，首先遍历我们之前的`connections`切片，从里面取出`connection`，然后用if client != conn来避免服务器再把消息发送给发给服务器的客户端，下面的代码会将消息发送到已经连接的客户端上（除了把这条消息发送到服务器的客户端）


### 退出部分
```go
	defer func() {
		mu.Lock()
		for i, c := range connections {
			if c == conn {
				connections = append(connections[:i], connections[i+1:]...)
				break
			}
		}
		mu.Unlock()
		conn.Close()
		log.Println("Client disconnected:", conn.RemoteAddr().String())
	}()
 ```
 
 首先defer把退出放在最后执行，然后我们从`connections`中清除`conn`，然后关闭这个`conn`，最后打印成功退出连接
 
 ### 竞态条件
 1. 连接的添加和移除
添加连接：
当一个新的WebSocket连接建立时，服务器需要将这个连接添加到全局的连接列表中。多个连接可能同时建立，从而导致多个并发操作试图修改连接列表。
移除连接：
当一个WebSocket连接断开时，服务器需要将这个连接从全局的连接列表中移除。如果多个连接同时断开，可能会导致并发修改连接列表。

2. 广播消息
当服务器接收到一条消息并试图广播给所有连接的客户端时，可能会有多个并发操作尝试遍历和修改连接列表。例如，一个连接在广播消息的同时断开。

3. 读写消息
在读写WebSocket消息时，也可能发生竞态条件。例如，一个线程正在读取消息，而另一个线程试图关闭连接。

竞态条件的解决方案
使用互斥锁（mutex）可以防止竞态条件。互斥锁确保在任何给定时间只有一个线程可以访问和修改共享资源。在Go中，可以使用sync.Mutex来实现互斥锁。




