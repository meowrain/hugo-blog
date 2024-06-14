---
title: Linux C网络编程
subtitle:
date: 2024-06-14T08:03:26Z
slug: 12b8a48
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - 网络编程
  - Linux
  - C
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

# 转换ip

## inet_pton()

`inet_pton` 函数用于将字符串表示的 IP 地址转换为网络字节序的二进制格式。与 `inet_ntop` 相反，`inet_pton` 的用途是从人类可读的字符串格式转换到机器可读的二进制格式。

### 函数原型

```c
#include <arpa/inet.h>

int inet_pton(int af, const char *src, void *dst);
```

### 参数

- **af**：地址家族，可以是 `AF_INET`（表示 IPv4）或 `AF_INET6`（表示 IPv6）。
- **src**：指向以字符串形式表示的地址（如 `"192.168.1.1"` 或 `"2001:db8::1"`）。
- **dst**：指向存储转换后地址的缓冲区。

### 返回值

- 成功时返回 1。
- 如果输入的字符串不是有效的网络地址，返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 使用示例

以下是使用 `inet_pton` 的示例，展示如何将 IPv4 和 IPv6 地址从字符串格式转换为二进制格式：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>

int main() {
    struct sockaddr_in ipv4_addr;
    struct sockaddr_in6 ipv6_addr;
    const char *ipv4_str = "192.168.1.1";
    const char *ipv6_str = "2001:db8::1";

    // 将字符串形式的 IPv4 地址转换为二进制格式
    if (inet_pton(AF_INET, ipv4_str, &ipv4_addr.sin_addr) <= 0) {
        perror("inet_pton");
        exit(EXIT_FAILURE);
    }
    printf("IPv4 address: %s converted successfully.\n", ipv4_str);

    // 将字符串形式的 IPv6 地址转换为二进制格式
    if (inet_pton(AF_INET6, ipv6_str, &ipv6_addr.sin6_addr) <= 0) {
        perror("inet_pton");
        exit(EXIT_FAILURE);
    }
    printf("IPv6 address: %s converted successfully.\n", ipv6_str);

    return 0;
}
```

### 详细说明

1. **IPv4 地址转换：**
   ```c
   struct sockaddr_in ipv4_addr;
   const char *ipv4_str = "192.168.1.1";
   
   if (inet_pton(AF_INET, ipv4_str, &ipv4_addr.sin_addr) <= 0) {
       perror("inet_pton");
       exit(EXIT_FAILURE);
   }
   printf("IPv4 address: %s converted successfully.\n", ipv4_str);
   ```
   这里我们将一个字符串形式的 IPv4 地址 `"192.168.1.1"` 转换为二进制格式，并存储在 `ipv4_addr.sin_addr` 中。如果转换失败，`inet_pton` 返回 0 或 -1，并打印错误信息。

2. **IPv6 地址转换：**
   ```c
   struct sockaddr_in6 ipv6_addr;
   const char *ipv6_str = "2001:db8::1";
   
   if (inet_pton(AF_INET6, ipv6_str, &ipv6_addr.sin6_addr) <= 0) {
       perror("inet_pton");
       exit(EXIT_FAILURE);
   }
   printf("IPv6 address: %s converted successfully.\n", ipv6_str);
   ```
   这里我们将一个字符串形式的 IPv6 地址 `"2001:db8::1"` 转换为二进制格式，并存储在 `ipv6_addr.sin6_addr` 中。如果转换失败，`inet_pton` 返回 0 或 -1，并打印错误信息。

### 错误处理

- **0 返回值**：如果输入的字符串不是有效的网络地址，`inet_pton` 返回 0。这时你可以检查输入的字符串格式是否正确。
- **-1 返回值**：如果出现其他错误（如地址家族无效），`inet_pton` 返回 -1，并设置 `errno`。

通过这些示例和说明，你可以了解如何使用 `inet_pton` 函数将字符串形式的 IP 地址转换为二进制格式，以便在网络编程中使用。

## inet_ntop

`inet_ntop` 函数用于将网络字节序的二进制格式的 IP 地址转换为人类可读的字符串格式。该函数支持 IPv4 和 IPv6 地址转换。

### 函数原型

```c
#include <arpa/inet.h>

const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
```

### 参数

- **af**：地址家族，可以是 `AF_INET`（表示 IPv4）或 `AF_INET6`（表示 IPv6）。
- **src**：指向存储二进制格式地址的缓冲区。
- **dst**：指向存储转换后字符串格式地址的缓冲区。
- **size**：`dst` 缓冲区的大小。

### 返回值

- 成功时返回指向 `dst` 的指针。
- 失败时返回 `NULL`，并设置 `errno` 来指示错误。

### 使用示例

以下是一个使用 `inet_ntop` 将 IPv4 和 IPv6 地址转换为字符串格式的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>

int main() {
    struct sockaddr_in ipv4_addr;
    struct sockaddr_in6 ipv6_addr;
    char ipv4_str[INET_ADDRSTRLEN];
    char ipv6_str[INET6_ADDRSTRLEN];

    // 设置一个 IPv4 地址
    ipv4_addr.sin_family = AF_INET;
    ipv4_addr.sin_addr.s_addr = inet_addr("192.168.1.1");

    // 将 IPv4 地址转换为字符串格式
    if (inet_ntop(AF_INET, &ipv4_addr.sin_addr, ipv4_str, INET_ADDRSTRLEN) == NULL) {
        perror("inet_ntop");
        exit(EXIT_FAILURE);
    }
    printf("IPv4 address: %s\n", ipv4_str);

    // 设置一个 IPv6 地址
    inet_pton(AF_INET6, "2001:db8::1", &ipv6_addr.sin6_addr);

    // 将 IPv6 地址转换为字符串格式
    if (inet_ntop(AF_INET6, &ipv6_addr.sin6_addr, ipv6_str, INET6_ADDRSTRLEN) == NULL) {
        perror("inet_ntop");
        exit(EXIT_FAILURE);
    }
    printf("IPv6 address: %s\n", ipv6_str);

    return 0;
}
```

### 详细说明

1. **设置 IPv4 地址：**
   ```c
   struct sockaddr_in ipv4_addr;
   ipv4_addr.sin_family = AF_INET;
   ipv4_addr.sin_addr.s_addr = inet_addr("192.168.1.1");
   ```

2. **将 IPv4 地址转换为字符串格式：**
   ```c
   char ipv4_str[INET_ADDRSTRLEN];
   if (inet_ntop(AF_INET, &ipv4_addr.sin_addr, ipv4_str, INET_ADDRSTRLEN) == NULL) {
       perror("inet_ntop");
       exit(EXIT_FAILURE);
   }
   printf("IPv4 address: %s\n", ipv4_str);
   ```

3. **设置 IPv6 地址：**
   ```c
   struct sockaddr_in6 ipv6_addr;
   inet_pton(AF_INET6, "2001:db8::1", &ipv6_addr.sin6_addr);
   ```

4. **将 IPv6 地址转换为字符串格式：**
   ```c
   char ipv6_str[INET6_ADDRSTRLEN];
   if (inet_ntop(AF_INET6, &ipv6_addr.sin6_addr, ipv6_str, INET6_ADDRSTRLEN) == NULL) {
       perror("inet_ntop");
       exit(EXIT_FAILURE);
   }
   printf("IPv6 address: %s\n", ipv6_str);
   ```

### 错误处理

- **EINVAL**：提供的地址家族 `af` 不正确。
- **ENOSPC**：提供的 `dst` 缓冲区大小不足以存储转换后的地址。

## INET_ADDRSTRLEN

`INET_ADDRSTRLEN` 是一个宏，它定义了一个足够大的缓冲区大小，用于存储点分十进制表示的 IPv4 地址字符串。具体来说，它的值为 16，因为一个完整的 IPv4 地址（包括终止的 null 字符）最多需要 16 个字符。



### 使用示例改进

我们可以改进前面的示例，使其更完整，包括处理错误和展示 `inet_ntop` 函数的实际使用场景：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>

#define PORT 12345
#define BACKLOG 10
#define BUFFERSIZE 1024

int main() 
{
    int sockfd, new_sockfd;
    struct sockaddr_in server_addr, client_addr;
    struct sockaddr_in peer_addr;
    socklen_t addr_len, peer_addr_len;
    char buffer[BUFFERSIZE];
    ssize_t bytes_received;
    char client_ip[INET_ADDRSTRLEN];
    char peer_ip[INET_ADDRSTRLEN];

    sockfd = socket(PF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    if (listen(sockfd, BACKLOG) == -1) {
        perror("listen");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port: %d\n", PORT);

    addr_len = sizeof(client_addr);
    new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
    if (new_sockfd == -1) {
        perror("accept");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 将客户端地址转换为字符串格式
    if (inet_ntop(AF_INET, &client_addr.sin_addr, client_ip, INET_ADDRSTRLEN) == NULL) {
        perror("inet_ntop");
        close(new_sockfd);
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    printf("Accepted connection from %s:%d\n", client_ip, ntohs(client_addr.sin_port));

    peer_addr_len = sizeof(peer_addr);
    if (getpeername(new_sockfd, (struct sockaddr *)&peer_addr, &peer_addr_len) == -1) {
        perror("getpeername");
        close(new_sockfd);
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 将远程地址转换为字符串格式
    if (inet_ntop(AF_INET, &peer_addr.sin_addr, peer_ip, INET_ADDRSTRLEN) == NULL) {
        perror("inet_ntop");
        close(new_sockfd);
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    printf("Peer address (from getpeername): %s, port: %d\n", peer_ip, ntohs(peer_addr.sin_port));

    close(new_sockfd);
    close(sockfd);

    return 0;
}
```

在这个示例中，服务器创建一个监听端口，并接受客户端连接。使用 `inet_ntop` 函数将客户端和远程端的 IP 地址从二进制格式转换为可读的字符串格式并打印出来。这可以帮助调试和验证服务器是否正确接收和处理连接。



```c
#include <stdio.h>
#include <arpa/inet.h>
int main() {
    struct sockaddr_in addr;
    struct sockaddr_in6 addr6;
    const char* ipv4_addr = "192.168.31.2";
    const char* ipv6_addr = "2001:0db8:85a3:0000:0000:8a2e:0370:7334";
    // convert ipv4 address from text to binary form
    if(inet_pton(AF_INET,ipv4_addr,&(addr.sin_addr))!=1) {
        fprintf(stderr,"Invalid IPv4 address\n");
        return 1;
    }
    if(inet_pton(AF_INET6,ipv6_addr,&(addr6.sin6_addr))!=1){
        fprintf(stderr,"Invalid IPV6 address\n");
        return 1;
    }
    printf("IPv4 address in binary form: 0x%x\n",addr.sin_addr.s_addr);
    printf("Now the ipv6 address has been saved in addr6.sin6_addr");
    //Now the ipv6 address has been saved in addr6.sin6_addr
    puts("");
    //convert binary form of ipv4 address to text form
    char ipv4_addr_text[INET_ADDRSTRLEN];
    char ipv6_addr_text[INET6_ADDRSTRLEN];
    if(inet_ntop(AF_INET,&(addr.sin_addr),ipv4_addr_text,INET_ADDRSTRLEN)==NULL){
        fprintf(stderr,"Error in converting IPv4 address to text form\n");
        return 1;
    }
    if(inet_ntop(AF_INET6,&(addr6.sin6_addr),ipv6_addr_text,INET6_ADDRSTRLEN)==NULL){
        fprintf(stderr,"Error in converting IPv6 address to text form\n");
    }
    printf("IPv4 address in text form: %s\n",ipv4_addr_text);
    printf("IPv6 address in text form: %s\n",ipv6_addr_text);
    return 0;
    
}
```


# 默认ip
```c
#include <stdio.h>
#include <arpa/inet.h>
int main() {
    struct sockaddr_in ipv4_addr;
    ipv4_addr.sin_addr.s_addr = INADDR_ANY;
    struct sockaddr_in6 ipv6_addr;
    ipv6_addr.sin6_addr = in6addr_any;
    char dst_ipv4[INET_ADDRSTRLEN];
    char dst_ipv6[INET6_ADDRSTRLEN];
    if(inet_ntop(AF_INET,&(ipv4_addr.sin_addr),dst_ipv4,INET_ADDRSTRLEN)==NULL) {
        fprintf(stderr,"Error in converting IPv4 address to text form\n");
        return 1;
    }
    if(inet_ntop(AF_INET6,&(ipv6_addr.sin6_addr),dst_ipv6,INET6_ADDRSTRLEN) == NULL) {
        fprintf(stderr,"Error in converting ipv6 address to text form\n");
        return 1;
    }
    printf("%s\n",dst_ipv4);
    printf("%s\n",dst_ipv6);
    return 0;
}
```


---

# errno变量

`errno` 是一个全局变量，用于指示最近一次系统调用或库函数调用是否出错以及出错的类型。在 C 语言中，当一个系统调用或库函数返回一个错误值（通常为 -1 或 NULL）时，可以通过检查 `errno` 来获取具体的错误类型。

### `errno` 的定义

`errno` 通常定义在 `<errno.h>` 头文件中。它是一个整数变量，每个线程都有自己独立的 `errno` 值（在线程安全的实现中）。

### 常见的错误代码

`errno` 变量可以设置为许多不同的错误代码，每个错误代码都有一个对应的宏定义。例如：

- `EACCES`：权限被拒绝
- `EAGAIN`：资源暂时不可用
- `EBADF`：文件描述符无效
- `EEXIST`：文件已存在
- `EINTR`：系统调用被中断
- `EINVAL`：无效的参数
- `ENOMEM`：内存不足
- `ENOTDIR`：不是一个目录

### 使用示例

以下是一个使用 `errno` 的示例，演示如何在调用系统函数时检查错误并获取错误信息：

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    int fd;

    // 尝试打开一个不存在的文件
    fd = open("nonexistentfile.txt", O_RDONLY);
    if (fd == -1) {
        // 打印错误代码
        printf("Error number: %d\n", errno);
        // 打印错误信息
        perror("open");
        // 也可以使用 strerror 函数获取错误信息
        printf("Error opening file: %s\n", strerror(errno));
    } else {
        printf("File opened successfully\n");
        close(fd);
    }

    return 0;
}
```

在这个示例中，我们尝试打开一个不存在的文件。这会导致 `open` 函数返回 -1，并设置 `errno` 为 `ENOENT`（表示文件或目录不存在）。然后我们使用 `perror` 和 `strerror` 函数打印错误信息。

### `perror` 和 `strerror`

- **`perror`**：`perror` 函数用于根据 `errno` 值打印一个描述错误的字符串，并在该字符串前添加一个用户指定的字符串。例如，`perror("open")` 可能输出 `open: No such file or directory`。

- **`strerror`**：`strerror` 函数根据 `errno` 值返回一个指向描述错误的字符串的指针。例如，`strerror(ENOENT)` 将返回 `"No such file or directory"`。

### 注意事项

1. **线程安全**：在多线程程序中，每个线程都有独立的 `errno` 值，这通常通过将 `errno` 实现为线程本地存储（TLS）来实现。
2. **设置和重置**：`errno` 只在函数出错时设置，因此在调用可能会设置 `errno` 的函数前，最好先将 `errno` 设置为 0，以便在出错时能够准确判断错误来源。
3. **检查返回值**：许多系统调用和库函数在出错时不会设置 `errno`，而是直接返回错误码。因此，在这些情况下应检查函数的返回值，而不是 `errno`。

通过使用 `errno`，程序员可以更好地处理和调试系统调用和库函数中的错误，从而编写出更健壮的代码。

# struct in_addr

`struct in_addr` 是一个用于存储 IPv4 地址的结构体。它通常在网络编程中使用，尤其是在处理套接字编程中的 IPv4 地址时。

### 定义

`struct in_addr` 通常定义如下：

```c
struct in_addr {
    uint32_t s_addr; // 32位的IPv4地址
};

```

# struct sockaddr

`struct sockaddr` 是一个通用的套接字地址结构体，用于在套接字编程中表示各种类型的套接字地址。它通常用于函数参数中，通过类型转换来适应具体的地址类型（如 `struct sockaddr_in` 或 `struct sockaddr_in6`）。

### 定义

`struct sockaddr` 通常定义如下：

```c
struct sockaddr {
    sa_family_t sa_family;  // 地址家族（Address family）
    char sa_data[14];       // 地址数据（Address data）
};
```

### 用法

`struct sockaddr` 本身很少直接使用。相反，通常使用它的派生结构体，如 `struct sockaddr_in`（用于 IPv4 地址）和 `struct sockaddr_in6`（用于 IPv6 地址）。这些派生结构体提供了更多特定于地址类型的信息。

### 常见的派生结构体

#### `struct sockaddr_in`

用于表示 IPv4 地址：

```c
struct sockaddr_in {
    sa_family_t    sin_family;  // 地址家族：AF_INET
    in_port_t      sin_port;    // 端口号
    struct in_addr sin_addr;    // IPv4 地址
    char           sin_zero[8]; // 填充以使结构体大小与 `struct sockaddr` 对齐
};

struct in_addr {
    uint32_t s_addr;  // 32位 IPv4 地址
};
```

#### `struct sockaddr_in6`

用于表示 IPv6 地址：

```c
struct sockaddr_in6 {
    sa_family_t     sin6_family;   // 地址家族：AF_INET6
    in_port_t       sin6_port;     // 端口号
    uint32_t        sin6_flowinfo; // 流信息
    struct in6_addr sin6_addr;     // IPv6 地址
    uint32_t        sin6_scope_id; // 作用域 ID
};

struct in6_addr {
    unsigned char s6_addr[16]; // 128位 IPv6 地址
};
```

### 使用示例

下面是一个使用 `struct sockaddr` 和 `struct sockaddr_in` 的示例，演示如何设置和获取 IPv4 地址：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    struct sockaddr_in client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[1024];

    // 创建一个 UDP 套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(12345);

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 接收来自客户端的数据
    ssize_t recv_len = recvfrom(sockfd, buffer, sizeof(buffer) - 1, 0, (struct sockaddr *)&client_addr, &addr_len);
    if (recv_len < 0) {
        perror("recvfrom");
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    buffer[recv_len] = '\0';

    // 打印客户端的 IP 地址和端口
    printf("收到来自 %s:%d 的数据\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
    printf("收到的信息: %s\n", buffer);

    close(sockfd);
    return 0;
}
```

在这个示例中，服务器创建了一个 UDP 套接字，绑定到一个特定的地址和端口，然后等待接收来自客户端的数据。客户端的地址信息存储在 `struct sockaddr_in` 结构体中，通过类型转换为 `struct sockaddr` 传递给 `recvfrom` 函数。

# struct sockaddr_storage

`sockaddr_storage` 是一个结构体，用于存储任意类型的 socket 地址。它在网络编程中提供了一种通用的方式来处理不同类型的 socket 地址（如 IPv4 和 IPv6 地址），而无需预先知道将使用哪种类型的地址。该结构体定义在 `<sys/socket.h>` 头文件中。

### 定义

`sockaddr_storage` 结构体定义如下：

```c
struct sockaddr_storage {
    sa_family_t ss_family;  // 地址家族
    char __ss_pad1[_SS_PAD1SIZE];
    int64_t __ss_align;
    char __ss_pad2[_SS_PAD2SIZE];
};
```

### 用法

1. **声明：**
   当你需要处理不同类型的 socket 地址时，可以声明一个 `sockaddr_storage` 变量。

   ```c
   struct sockaddr_storage addr;
   ```

2. **接收地址：**
   当接收一个 socket 地址（例如从 `recvfrom()` 函数中），可以使用 `sockaddr_storage` 来通用地处理地址。

   ```c
   socklen_t addr_len = sizeof(struct sockaddr_storage);
   recvfrom(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&addr, &addr_len);
   ```

3. **处理具体的地址类型：**
   接收到 socket 地址后，可以根据 `ss_family` 字段将 `sockaddr_storage` 转换为合适的地址类型。

   ```c
   if (addr.ss_family == AF_INET) {
       struct sockaddr_in *addr_in = (struct sockaddr_in *)&addr;
       // 处理 IPv4 地址
   } else if (addr.ss_family == AF_INET6) {
       struct sockaddr_in6 *addr_in6 = (struct sockaddr_in6 *)&addr;
       // 处理 IPv6 地址
   }
   ```

### 示例

下面是一个使用 `sockaddr_storage` 的 UDP 服务器示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    struct sockaddr_storage addr;
    socklen_t addr_len = sizeof(addr);
    char buffer[1024];

    // 创建一个 UDP 套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 绑定套接字到一个地址和端口
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(12345);

    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 从客户端接收数据
    ssize_t recv_len = recvfrom(sockfd, buffer, sizeof(buffer) - 1, 0, (struct sockaddr *)&addr, &addr_len);
    if (recv_len < 0) {
        perror("recvfrom");
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    buffer[recv_len] = '\0';

    // 处理接收到的地址
    if (addr.ss_family == AF_INET) {
        struct sockaddr_in *addr_in = (struct sockaddr_in *)&addr;
        printf("从 IPv4 地址接收: %s\n", inet_ntoa(addr_in->sin_addr));
    } else if (addr.ss_family == AF_INET6) {
        char ip_str[INET6_ADDRSTRLEN];
        struct sockaddr_in6 *addr_in6 = (struct sockaddr_in6 *)&addr;
        inet_ntop(AF_INET6, &addr_in6->sin6_addr, ip_str, sizeof(ip_str));
        printf("从 IPv6 地址接收: %s\n", ip_str);
    }

    // 打印接收到的消息
    printf("接收到的消息: %s\n", buffer);

    close(sockfd);
    return 0;
}
```

在这个示例中，服务器绑定到一个端口，并等待从客户端接收数据。使用 `sockaddr_storage` 结构体来存储客户端的地址，并根据地址的家族（IPv4 或 IPv6）进行适当的处理。

# struct addrinfo

`struct addrinfo` 是一个结构体，用于存储与主机名和服务相关的地址信息。它主要在使用 `getaddrinfo` 函数时使用，该函数将主机名和服务名转换为套接字地址结构体，并返回一个指向 `addrinfo` 结构体链表的指针。

### 定义

`struct addrinfo` 通常定义如下：

```c
struct addrinfo {
    int              ai_flags;     // 输入标志
    int              ai_family;    // 地址家族（AF_INET、AF_INET6 等）
    int              ai_socktype;  // 套接字类型（SOCK_STREAM、SOCK_DGRAM 等）
    int              ai_protocol;  // 协议（通常为 0 或 IPPROTO_TCP、IPPROTO_UDP）
    size_t           ai_addrlen;   // 套接字地址的长度
    struct sockaddr *ai_addr;      // 套接字地址（struct sockaddr）
    char            *ai_canonname; // 官方主机名
    struct addrinfo *ai_next;      // 指向下一个 addrinfo 结构体的指针
};
```

### 用法

1. **获取地址信息：**
   使用 `getaddrinfo` 函数获取主机名和服务的地址信息。该函数将主机名和服务名转换为一组地址结构体，并返回一个指向 `addrinfo` 结构体链表的指针。

   ```c
   struct addrinfo hints, *res;
   memset(&hints, 0, sizeof(hints));
   hints.ai_family = AF_UNSPEC;  // IPv4 或 IPv6
   hints.ai_socktype = SOCK_STREAM; // TCP
   
   int status = getaddrinfo("www.example.com", "http", &hints, &res);
   if (status != 0) {
       fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
       return 1;
   }
   ```

2. **处理地址信息：**
   遍历 `addrinfo` 结构体链表，处理每个地址信息。

   ```c
   for (struct addrinfo *p = res; p != NULL; p = p->ai_next) {
       // 打印地址信息
       char ipstr[INET6_ADDRSTRLEN];
       void *addr;
       char *ipver;
   
       // 处理 IPv4 和 IPv6 地址
       if (p->ai_family == AF_INET) { // IPv4
           struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
           addr = &(ipv4->sin_addr);
           ipver = "IPv4";
       } else { // IPv6
           struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
           addr = &(ipv6->sin6_addr);
           ipver = "IPv6";
       }
   
       // 将 IP 地址转换为字符串并打印
       inet_ntop(p->ai_family, addr, ipstr, sizeof(ipstr));
       printf("%s: %s\n", ipver, ipstr);
   }
   ```

3. **释放地址信息：**
   使用完 `addrinfo` 结构体链表后，调用 `freeaddrinfo` 函数释放内存。

   ```c
   freeaddrinfo(res);
   ```

### 示例

下面是一个完整的示例，演示如何使用 `getaddrinfo` 获取地址信息并打印：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: showip hostname\n");
        return 1;
    }

    struct addrinfo hints, *res, *p;
    int status;
    char ipstr[INET6_ADDRSTRLEN];

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC; // AF_INET 或 AF_INET6
    hints.ai_socktype = SOCK_STREAM;

    if ((status = getaddrinfo(argv[1], NULL, &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
        return 2;
    }

    printf("IP addresses for %s:\n\n", argv[1]);

    for (p = res; p != NULL; p = p->ai_next) {
        void *addr;
        char *ipver;

        // 获取地址（IPv4 或 IPv6）
        if (p->ai_family == AF_INET) { // IPv4
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = "IPv4";
        } else { // IPv6
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
            addr = &(ipv6->sin6_addr);
            ipver = "IPv6";
        }

        // 将 IP 地址转换为字符串并打印
        inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
        printf("  %s: %s\n", ipver, ipstr);
    }

    freeaddrinfo(res);

    return 0;
}
```

在这个示例中，程序接受一个主机名作为命令行参数，使用 `getaddrinfo` 函数获取该主机的地址信息，并打印所有 IP 地址。\
## getaddrinfo()

`getaddrinfo()` 是一个用于网络编程的函数，用于将主机名和服务名转换为可用于 `socket`、`bind` 和 `connect` 等函数的地址信息。

### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

int getaddrinfo(const char *node, const char *service,
                const struct addrinfo *hints, struct addrinfo **res);
```

### 参数

- **node**：主机名（如 "www.example.com"）或 IP 地址（如 "192.168.1.1"）。
- **service**：服务名（如 "http"）或端口号（如 "80"）。
- **hints**：指向一个 `addrinfo` 结构体的指针，用于指定查询的限制条件。可以为 NULL。
- **res**：指向一个 `addrinfo` 结构体指针的指针，函数成功时会指向结果链表的头。

### 返回值

- 成功时返回 0。
- 失败时返回一个非零错误代码，可以使用 `gai_strerror()` 函数获取错误信息。

### `struct addrinfo` 结构体

```c
struct addrinfo {
    int              ai_flags;     // 输入标志
    int              ai_family;    // 地址家族（AF_INET、AF_INET6 等）
    int              ai_socktype;  // 套接字类型（SOCK_STREAM、SOCK_DGRAM 等）
    int              ai_protocol;  // 协议（通常为 0 或 IPPROTO_TCP、IPPROTO_UDP）
    size_t           ai_addrlen;   // 套接字地址的长度
    struct sockaddr *ai_addr;      // 套接字地址（struct sockaddr）
    char            *ai_canonname; // 官方主机名
    struct addrinfo *ai_next;      // 指向下一个 addrinfo 结构体的指针
};
```

### 示例

以下是一个使用 `getaddrinfo()` 获取地址信息并打印的完整示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "usage: showip hostname\n");
        return 1;
    }

    struct addrinfo hints, *res, *p;
    int status;
    char ipstr[INET6_ADDRSTRLEN];

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC; // AF_INET 或 AF_INET6
    hints.ai_socktype = SOCK_STREAM;

    if ((status = getaddrinfo(argv[1], NULL, &hints, &res)) != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
        return 2;
    }

    printf("IP addresses for %s:\n\n", argv[1]);

    for (p = res; p != NULL; p = p->ai_next) {
        void *addr;
        char *ipver;

        // 获取地址（IPv4 或 IPv6）
        if (p->ai_family == AF_INET) { // IPv4
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = "IPv4";
        } else { // IPv6
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
            addr = &(ipv6->sin6_addr);
            ipver = "IPv6";
        }

        // 将 IP 地址转换为字符串并打印
        inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
        printf("  %s: %s\n", ipver, ipstr);
    }

    freeaddrinfo(res);

    return 0;
}
```

### 说明

1. **初始化 `hints` 结构体：**
   ```c
   memset(&hints, 0, sizeof hints);
   hints.ai_family = AF_UNSPEC; // AF_INET 或 AF_INET6
   hints.ai_socktype = SOCK_STREAM;
   ```
   这里我们设置 `hints` 结构体，以指示我们对 IPv4 和 IPv6 地址以及流式套接字（TCP）感兴趣。

2. **调用 `getaddrinfo`：**
   ```c
   if ((status = getaddrinfo(argv[1], NULL, &hints, &res)) != 0) {
       fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
       return 2;
   }
   ```
   我们调用 `getaddrinfo` 函数，并检查其返回值以确定是否成功。

3. **遍历返回的地址链表并打印每个地址：**
   ```c
   for (p = res; p != NULL; p = p->ai_next) {
       // ...
   }
   ```
   我们遍历返回的地址链表，并使用 `inet_ntop` 函数将地址转换为字符串格式，以便打印出来。

4. **释放地址信息链表：**
   ```c
   freeaddrinfo(res);
   ```
   最后，我们调用 `freeaddrinfo` 函数来释放 `getaddrinfo` 分配的内存。

通过上述示例，你可以看到如何使用 `getaddrinfo` 获取主机名的 IP 地址，并处理这些地址以进行进一步的网络通信。

# socket



## socket函数



`socket()` 函数用于创建一个新的套接字，并返回一个套接字描述符。套接字描述符是一个整数，用于标识套接字。该函数是网络编程的基础，几乎所有的网络操作都需要使用它。

### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

int socket(int domain, int type, int protocol);
```

### 参数

- **domain**：指定套接字的协议家族。常见的值包括：
  - `PF_INET`：IPv4 协议
  - `PF_INET6`：IPv6 协议
  - `PF_UNIX`：本地通信（Unix 域套接字）
- **type**：指定套接字的类型。常见的值包括：
  - `SOCK_STREAM`：提供面向连接的稳定数据传输（TCP）
  - `SOCK_DGRAM`：提供数据报文服务（UDP）
  - `SOCK_RAW`：提供原始网络协议访问
- **protocol**：指定套接字使用的协议。通常可以指定为 0，以选择默认协议。常见的协议包括：
  
  - `IPPROTO_TCP`：TCP 协议
  - `IPPROTO_UDP`：UDP 协议
  
  在调用 `socket()` 函数时，将 `protocol` 参数设置为 0 表示选择默认的协议。这个默认协议是由所选择的 `domain`（协议家族）和 `type`（套接字类型）共同决定的。通常，对于常用的协议家族和套接字类型组合，默认协议是我们所期望的协议。
  
  ### 详细解释
  
  - `AF_INET`（IPv4）和 `SOCK_STREAM`（流式套接字）：
    - 默认协议是 `IPPROTO_TCP`，即传输控制协议 (TCP)。
  - `AF_INET`（IPv4）和 `SOCK_DGRAM`（数据报套接字）：
    - 默认协议是 `IPPROTO_UDP`，即用户数据报协议 (UDP)。
  
  通过将 `protocol` 参数设置为 0，我们可以让系统根据 `domain` 和 `type` 自动选择合适的协议，而不需要明确指定协议类型。这样既简化了代码，又减少了人为错误的可能性。

### 返回值

- 成功时返回一个套接字描述符（非负整数）。
- 失败时返回 -1，并设置 `errno` 来指示错误。



### 示例

以下是创建一个 TCP 套接字的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    
    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    printf("Socket created successfully. Socket descriptor: %d\n", sockfd);

    // 在此可以继续使用套接字进行连接、绑定、发送和接收数据等操作

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

### 更复杂的示例

下面是一个创建 UDP 套接字并绑定到指定端口的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr;

    // 创建一个 IPv4, 数据报(UDP)套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(12345);

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Socket bound to port 12345\n");

    // 在此可以继续使用套接字进行发送和接收数据等操作

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

在这个示例中，服务器创建了一个 UDP 套接字，并绑定到端口 12345。之后，服务器可以使用该套接字进行数据的发送和接收操作。完成后，套接字被关闭。

## bind函数



`bind()` 函数用于将套接字与特定的地址（通常是本地地址）和端口绑定在一起。它通常用于服务器程序，以便在指定的地址和端口上监听客户端的连接或数据。

### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

### 参数

- **sockfd**：由 `socket()` 函数返回的套接字描述符。
- **addr**：指向包含要绑定的地址信息的 `sockaddr` 结构体的指针。
- **addrlen**：`addr` 结构体的大小（字节数）。

### 返回值

- 成功时返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 常见错误

- **EACCES**：权限被拒绝，通常是因为试图绑定到一个受保护的端口（例如，小于 1024 的端口）。
- **EADDRINUSE**：指定的地址已经在使用中。
- **EBADF**：`sockfd` 不是有效的文件描述符。
- **EINVAL**：`sockfd` 已经绑定到一个地址。
- **ENOTSOCK**：`sockfd` 不是一个套接字文件描述符。

### 示例

以下是一个使用 `bind()` 函数绑定一个 IPv4 地址和端口的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(12345);      // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Socket bound to port 12345\n");

    // 继续进行其他操作，例如 listen() 和 accept()

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

### 详细步骤

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```
   这段代码创建了一个 IPv4, 流式(TCP)套接字。如果创建失败，`socket()` 返回 -1，并设置 `errno`。

2. **设置服务器地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
   server_addr.sin_port = htons(12345);      // 绑定到端口 12345
   ```
   这里我们设置 `server_addr` 结构体，用于指定绑定的地址和端口。`INADDR_ANY` 表示绑定到所有本地 IP 地址。

3. **绑定套接字：**
   ```c
   if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("bind");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `bind()` 函数将套接字与指定的地址和端口绑定。如果绑定失败，`bind()` 返回 -1，并设置 `errno`。

4. **后续操作：**
   在成功绑定套接字后，通常会进行其他操作，如调用 `listen()` 函数监听连接，然后使用 `accept()` 函数接受客户端连接。

5. **关闭套接字：**
   ```c
   close(sockfd);
   ```
   当不再需要套接字时，调用 `close()` 函数关闭套接字。

### UDP 示例

以下是一个使用 `bind()` 函数绑定一个 UDP 套接字的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    char buffer[1024];
    socklen_t addr_len = sizeof(client_addr);

    // 创建一个 IPv4, 数据报(UDP)套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(12345);

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Socket bound to port 12345\n");

    // 接收来自客户端的数据
    ssize_t recv_len = recvfrom(sockfd, buffer, sizeof(buffer) - 1, 0, (struct sockaddr *)&client_addr, &addr_len);
    if (recv_len == -1) {
        perror("recvfrom");
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    buffer[recv_len] = '\0';
    printf("Received message: %s\n", buffer);

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

在这个 UDP 示例中，我们创建了一个 UDP 套接字，并绑定到端口 12345，然后使用 `recvfrom()` 函数接收来自客户端的数据。完成后关闭套接字。

## listen函数



`listen()` 函数用于将套接字设置为被动模式，即用于接受来自客户端的连接请求。它通常在服务器程序中使用，`listen()` 函数配置的套接字可以接受连接请求，并通过 `accept()` 函数来处理这些请求。

### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

int listen(int sockfd, int backlog);
```

### 参数

- **sockfd**：由 `socket()` 函数返回的套接字描述符。
- **backlog**：指定挂起连接队列的最大长度。当队列已满时，服务器将拒绝新的连接请求。

### 返回值

- 成功时返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 常见错误

- **EADDRINUSE**：指定的地址已经在使用中。
- **EBADF**：`sockfd` 不是有效的文件描述符。
- **ENOTSOCK**：`sockfd` 不是一个套接字文件描述符。
- **EOPNOTSUPP**：套接字类型不支持 `listen` 操作（例如，数据报套接字不能使用 `listen`）。

### 使用示例

以下是一个简单的 TCP 服务器示例，展示如何使用 `listen()` 函数：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd, new_sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len;
    char buffer[1024];
    int backlog = 10;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(12345);      // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(sockfd, backlog) == -1) {
        perror("listen");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port 12345...\n");

    while (1) {
        // 接受客户端连接
        addr_len = sizeof(client_addr);
        new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
        if (new_sockfd == -1) {
            perror("accept");
            continue;
        }

        printf("Accepted connection from %s\n", inet_ntoa(client_addr.sin_addr));

        // 处理客户端连接
        ssize_t bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
        if (bytes_received == -1) {
            perror("recv");
        } else {
            buffer[bytes_received] = '\0';
            printf("Received: %s\n", buffer);
        }

        // 关闭客户端连接
        close(new_sockfd);
    }

    // 关闭服务器套接字
    close(sockfd);

    return 0;
}
```

### 详细说明

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```
   创建一个 IPv4，流式 (TCP) 套接字。如果创建失败，`socket()` 返回 -1，并设置 `errno`。

2. **设置服务器地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
   server_addr.sin_port = htons(12345);      // 绑定到端口 12345
   ```
   设置 `server_addr` 结构体，用于指定绑定的地址和端口。

3. **绑定套接字：**
   ```c
   if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("bind");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `bind()` 函数将套接字与指定的地址和端口绑定。如果绑定失败，`bind()` 返回 -1，并设置 `errno`。

4. **监听连接请求：**
   ```c
   if (listen(sockfd, backlog) == -1) {
       perror("listen");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `listen()` 函数将套接字设置为被动模式，准备接受连接请求。`backlog` 参数指定挂起连接队列的最大长度。

5. **接受客户端连接：**
   ```c
   while (1) {
       addr_len = sizeof(client_addr);
       new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
       if (new_sockfd == -1) {
           perror("accept");
           continue;
       }
       printf("Accepted connection from %s\n", inet_ntoa(client_addr.sin_addr));
       // 处理客户端连接...
       close(new_sockfd);
   }
   ```
   在一个无限循环中，调用 `accept()` 函数接受客户端连接。如果接受成功，`accept()` 返回一个新的套接字描述符，用于与客户端通信。

6. **处理客户端连接：**
   ```c
   ssize_t bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
   if (bytes_received == -1) {
       perror("recv");
   } else {
       buffer[bytes_received] = '\0';
       printf("Received: %s\n", buffer);
   }
   ```
   使用 `recv()` 函数从客户端接收数据，并打印接收到的数据。

7. **关闭套接字：**
   ```c
   close(new_sockfd);
   close(sockfd);
   ```
   当不再需要连接时，调用 `close()` 函数关闭套接字。

通过上述步骤，一个简单的 TCP 服务器可以接受客户端的连接请求，并处理这些请求。

## connect函数



`connect()` 函数用于将套接字连接到指定的地址。在客户端程序中，`connect()` 函数用于与服务器建立连接。在建立连接后，可以使用 `send()` 和 `recv()` 函数进行数据传输。

### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

### 参数

- **sockfd**：由 `socket()` 函数返回的套接字描述符。
- **addr**：指向包含要连接的目标地址信息的 `sockaddr` 结构体的指针。
- **addrlen**：`addr` 结构体的大小（字节数）。

### 返回值

- 成功时返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 常见错误

- **EACCES**：尝试连接到广播地址，但权限被拒绝。
- **EADDRINUSE**：本地地址已在使用中。
- **EAFNOSUPPORT**：地址家族不被支持。
- **EALREADY**：操作正在进行中。
- **EBADF**：`sockfd` 不是有效的文件描述符。
- **ECONNREFUSED**：目标地址拒绝连接。
- **EINPROGRESS**：操作正在进行中。
- **ETIMEDOUT**：连接超时。

### 示例

以下是一个使用 `connect()` 函数连接到服务器的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(12345); // 服务器端口
    if (inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 连接到服务器
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Connected to the server\n");

    // 在此可以进行数据传输，例如使用 send() 和 recv()

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

### 详细说明

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```
   这段代码创建了一个 IPv4, 流式(TCP)套接字。如果创建失败，`socket()` 返回 -1，并设置 `errno`。

2. **设置服务器地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_port = htons(12345); // 服务器端口
   if (inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr) <= 0) {
       perror("inet_pton");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   这里我们设置 `server_addr` 结构体，用于指定连接的服务器地址和端口。`inet_pton` 函数将 IPv4 地址从点分十进制转换为网络字节序。

3. **连接到服务器：**
   ```c
   if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("connect");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `connect()` 函数将套接字连接到指定的服务器地址。如果连接失败，`connect()` 返回 -1，并设置 `errno`。

4. **数据传输：**
   在成功连接到服务器后，可以使用 `send()` 和 `recv()` 函数进行数据传输。

5. **关闭套接字：**
   ```c
   close(sockfd);
   ```
   当不再需要连接时，调用 `close()` 函数关闭套接字。

### UDP 示例

在使用 UDP 时，`connect()` 函数有些不同。尽管 UDP 是无连接协议，`connect()` 函数仍然可以用来设置默认的目标地址，使得之后的 `send()` 和 `recv()` 操作默认使用这个地址。

以下是一个使用 `connect()` 函数在 UDP 套接字上设置默认目标地址的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char *message = "Hello, Server!";
    char buffer[1024];
    ssize_t bytes_sent, bytes_received;

    // 创建一个 IPv4, 数据报(UDP)套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(12345); // 服务器端口
    if (inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 连接到服务器
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Connected to the server\n");

    // 发送数据到服务器
    bytes_sent = send(sockfd, message, strlen(message), 0);
    if (bytes_sent == -1) {
        perror("send");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 接收来自服务器的数据
    bytes_received = recv(sockfd, buffer, sizeof(buffer) - 1, 0);
    if (bytes_received == -1) {
        perror("recv");
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    buffer[bytes_received] = '\0';
    printf("Received message: %s\n", buffer);

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

在这个 UDP 示例中，我们创建了一个 UDP 套接字，并使用 `connect()` 函数设置默认的目标地址。然后我们使用 `send()` 和 `recv()` 函数进行数据传输。尽管 UDP 是无连接的，但 `connect()` 提供了一种便捷的方式来指定默认目标地址。



## accept函数



`accept()` 函数用于接受来自客户端的连接请求。它在服务器程序中使用，允许服务器从已经处于监听状态的套接字队列中提取第一个连接请求，并返回一个新的套接字描述符，用于与客户端进行通信。

### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
```

### 参数

- **sockfd**：由 `socket()` 和 `bind()` 函数创建和绑定，并通过 `listen()` 函数设置为监听状态的套接字描述符。
- **addr**：指向一个 `sockaddr` 结构体的指针，用于存储已连接客户端的地址信息。如果不需要客户端的地址信息，可以传递 NULL。
- **addrlen**：指向一个 `socklen_t` 变量的指针，该变量最初应设置为 `addr` 所指向的结构体的大小。函数返回时，这个变量包含了实际存储在 `addr` 结构体中的地址的大小。如果不需要客户端的地址信息，可以传递 NULL。

### 返回值

- 成功时返回一个新的套接字描述符。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 常见错误

- **EBADF**：`sockfd` 不是有效的文件描述符。
- **EINTR**：等待连接请求时被信号中断。
- **EINVAL**：`sockfd` 没有绑定到地址或者没有监听状态。
- **ENOTSOCK**：`sockfd` 不是一个套接字。
- **EOPNOTSUPP**：`sockfd` 不是面向连接的套接字类型。

### 使用示例

以下是一个简单的 TCP 服务器示例，展示如何使用 `accept()` 函数：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sockfd, new_sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len;
    char buffer[1024];
    int backlog = 10;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(12345);      // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(sockfd, backlog) == -1) {
        perror("listen");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port 12345...\n");

    while (1) {
        // 接受客户端连接
        addr_len = sizeof(client_addr);
        new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
        if (new_sockfd == -1) {
            perror("accept");
            continue;
        }

        printf("Accepted connection from %s\n", inet_ntoa(client_addr.sin_addr));

        // 处理客户端连接
        ssize_t bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
        if (bytes_received == -1) {
            perror("recv");
        } else {
            buffer[bytes_received] = '\0';
            printf("Received: %s\n", buffer);
        }

        // 关闭客户端连接
        close(new_sockfd);
    }

    // 关闭服务器套接字
    close(sockfd);

    return 0;
}
```

### 详细说明

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```
   创建一个 IPv4，流式 (TCP) 套接字。如果创建失败，`socket()` 返回 -1，并设置 `errno`。

2. **设置服务器地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
   server_addr.sin_port = htons(12345);      // 绑定到端口 12345
   ```
   设置 `server_addr` 结构体，用于指定绑定的地址和端口。

3. **绑定套接字：**
   ```c
   if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("bind");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `bind()` 函数将套接字与指定的地址和端口绑定。如果绑定失败，`bind()` 返回 -1，并设置 `errno`。

4. **监听连接请求：**
   ```c
   if (listen(sockfd, backlog) == -1) {
       perror("listen");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `listen()` 函数将套接字设置为被动模式，准备接受连接请求。`backlog` 参数指定挂起连接队列的最大长度。

5. **接受客户端连接：**
   ```c
   while (1) {
       addr_len = sizeof(client_addr);
       new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
       if (new_sockfd == -1) {
           perror("accept");
           continue;
       }
       printf("Accepted connection from %s\n", inet_ntoa(client_addr.sin_addr));
       // 处理客户端连接...
       close(new_sockfd);
   }
   ```
   在一个无限循环中，调用 `accept()` 函数接受客户端连接。如果接受成功，`accept()` 返回一个新的套接字描述符，用于与客户端通信。

6. **处理客户端连接：**
   ```c
   ssize_t bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
   if (bytes_received == -1) {
       perror("recv");
   } else {
       buffer[bytes_received] = '\0';
       printf("Received: %s\n", buffer);
   }
   ```
   使用 `recv()` 函数从客户端接收数据，并打印接收到的数据。

7. **关闭套接字：**
   ```c
   close(new_sockfd);
   close(sockfd);
   ```
   当不再需要连接时，调用 `close()` 函数关闭套接字。

通过上述步骤，一个简单的 TCP 服务器可以接受客户端的连接请求，并处理这些请求。

## `send()` and `recv()`



`send()` 和 `recv()` 函数用于在已连接的套接字之间进行数据传输。`send()` 用于发送数据，`recv()` 用于接收数据。这两个函数通常用于基于 TCP 的连接，但也可以用于连接到远程地址的 UDP 套接字。

### `send()` 函数

#### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

ssize_t send(int sockfd, const void *buf, size_t len, int flags);
```

#### 参数

- **sockfd**：套接字描述符，由 `socket()` 或 `accept()` 返回。
- **buf**：指向要发送的数据的缓冲区。
- **len**：要发送的数据长度。
- **flags**：发送标志，通常设置为 0。

#### 返回值

- 成功时返回发送的字节数。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### `recv()` 函数

#### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

ssize_t recv(int sockfd, void *buf, size_t len, int flags);
```

#### 参数

- **sockfd**：套接字描述符，由 `socket()` 或 `accept()` 返回。
- **buf**：指向用于接收数据的缓冲区。
- **len**：缓冲区的长度。
- **flags**：接收标志，通常设置为 0。

#### 返回值

- 成功时返回接收到的字节数。如果连接被关闭，返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 示例

以下是一个简单的 TCP 客户端和服务器示例，演示如何使用 `send()` 和 `recv()` 函数。

#### TCP 服务器

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 12345
#define BACKLOG 10

int main() {
    int sockfd, new_sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len;
    char buffer[1024];
    ssize_t bytes_received;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(PORT);       // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(sockfd, BACKLOG) == -1) {
        perror("listen");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port %d...\n", PORT);

    while (1) {
        // 接受客户端连接
        addr_len = sizeof(client_addr);
        new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
        if (new_sockfd == -1) {
            perror("accept");
            continue;
        }

        printf("Accepted connection from %s\n", inet_ntoa(client_addr.sin_addr));

        // 接收数据
        bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
        if (bytes_received == -1) {
            perror("recv");
            close(new_sockfd);
            continue;
        }
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);

        // 发送响应
        const char *response = "Message received";
        if (send(new_sockfd, response, strlen(response), 0) == -1) {
            perror("send");
        }

        // 关闭客户端连接
        close(new_sockfd);
    }

    // 关闭服务器套接字
    close(sockfd);

    return 0;
}
```

#### TCP 客户端

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 12345
#define SERVER_IP "127.0.0.1"

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[1024];
    ssize_t bytes_sent, bytes_received;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT); // 服务器端口
    if (inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 连接到服务器
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 发送数据
    const char *message = "Hello, Server!";
    bytes_sent = send(sockfd, message, strlen(message), 0);
    if (bytes_sent == -1) {
        perror("send");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 接收响应
    bytes_received = recv(sockfd, buffer, sizeof(buffer) - 1, 0);
    if (bytes_received == -1) {
        perror("recv");
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    buffer[bytes_received] = '\0';
    printf("Received from server: %s\n", buffer);

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

### 详细说明

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```
   这段代码创建一个流式 (TCP) 套接字。如果创建失败，`socket()` 返回 -1，并设置 `errno`。

2. **设置地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址（服务器）
   server_addr.sin_port = htons(PORT);
   ```
   设置 `server_addr` 结构体，用于指定绑定的地址和端口。

3. **绑定和监听（服务器）：**
   ```c
   if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("bind");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   
   if (listen(sockfd, BACKLOG) == -1) {
       perror("listen");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `bind()` 和 `listen()` 函数，将套接字绑定到指定的地址和端口，并使其进入监听状态。

4. **接受连接（服务器）：**
   ```c
   new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
   if (new_sockfd == -1) {
       perror("accept");
       continue;
   }
   ```
   调用 `accept()` 函数接受客户端的连接请求。如果接受成功，`accept()` 返回一个新的套接字描述符，用于与客户端通信。

5. **连接到服务器（客户端）：**
   ```c
   if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("connect");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `connect()` 函数将客户端套接字连接到服务器。

6. **发送数据：**
   ```c
   bytes_sent = send(sockfd, message, strlen(message), 0);
   if (bytes_sent == -1) {
       perror("send");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `send()` 函数发送数据。如果发送失败，`send()` 返回 -1，并设置 `errno`。

7. **接收数据：**
   ```c
   bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
   if (bytes_received == -1) {
       perror("recv");
       close(new_sockfd);
       continue;
   }
   buffer[bytes_received] = '\0';
   printf("Received: %s\n", buffer);
   ```
   调用 `recv()` 函数接收数据。如果接

收失败，`recv()` 返回 -1，并设置 `errno`。

通过这些步骤，TCP 服务器和客户端可以通过 `send()` 和 `recv()` 函数进行数据传输。

`send()` 和 `recv()` 函数中的 `flags` 参数除了可以设置为 0 之外，还可以设置为一些其他的标志，以控制数据传输的行为。以下是一些常见的标志及其说明：

### `send()` 函数中的 `flags`

- **`MSG_DONTROUTE`**：告诉套接字绕过常规路由表查找，直接在本地网络上发送数据。
- **`MSG_DONTWAIT`**：使操作变为非阻塞模式，如果操作不能立即完成，则返回 `EAGAIN` 或 `EWOULDBLOCK` 错误。
- **`MSG_EOR`**：指示数据发送结束，适用于分段发送的数据流。
- **`MSG_NOSIGNAL`**：防止在发送操作失败时发送 `SIGPIPE` 信号。
- **`MSG_OOB`**：发送带外数据（TCP）。

### `recv()` 函数中的 `flags`

- **`MSG_DONTWAIT`**：使操作变为非阻塞模式，如果操作不能立即完成，则返回 `EAGAIN` 或 `EWOULDBLOCK` 错误。
- **`MSG_PEEK`**：从套接字缓冲区中读取数据，但不将其移除，即之后再次调用 `recv()` 时仍能读取到相同的数据。
- **`MSG_WAITALL`**：等待接收到所请求的所有数据后才返回，通常用于确保接收到完整的数据包。
- **`MSG_OOB`**：接收带外数据（TCP）。
- **`MSG_TRUNC`**：如果数据包长度超过缓冲区长度，数据会被截断，但返回的长度是原始数据包的长度。

### 示例

#### 使用 `MSG_DONTWAIT` 标志

以下是一个使用 `MSG_DONTWAIT` 标志的示例，使得 `recv()` 操作变为非阻塞模式：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#define PORT 12345
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    if (inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 连接到服务器
    if (connect(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 接收数据，非阻塞模式
    bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, MSG_DONTWAIT);
    if (bytes_received == -1) {
        if (errno == EAGAIN || errno == EWOULDBLOCK) {
            printf("No data available right now, try again later.\n");
        } else {
            perror("recv");
        }
    } else if (bytes_received == 0) {
        printf("Connection closed by peer.\n");
    } else {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

#### 使用 `MSG_PEEK` 标志

以下是一个使用 `MSG_PEEK` 标志的示例，从套接字缓冲区中读取数据，但不将其移除：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 12345
#define BUFFER_SIZE 1024

int main() {
    int sockfd, new_sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len;
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(PORT);       // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(sockfd, 10) == -1) {
        perror("listen");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port %d...\n", PORT);

    // 接受客户端连接
    addr_len = sizeof(client_addr);
    new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
    if (new_sockfd == -1) {
        perror("accept");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Accepted connection from %s\n", inet_ntoa(client_addr.sin_addr));

    // 使用 MSG_PEEK 读取数据但不移除
    bytes_received = recv(new_sockfd, buffer, BUFFER_SIZE - 1, MSG_PEEK);
    if (bytes_received == -1) {
        perror("recv");
        close(new_sockfd);
        close(sockfd);
        exit(EXIT_FAILURE);
    } else {
        buffer[bytes_received] = '\0';
        printf("Peeked data: %s\n", buffer);
    }

    // 实际读取数据并移除
    bytes_received = recv(new_sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received == -1) {
        perror("recv");
    } else {
        buffer[bytes_received] = '\0';
        printf("Received data: %s\n", buffer);
    }

    // 关闭套接字
    close(new_sockfd);
    close(sockfd);

    return 0;
}
```

通过这些示例，你可以看到 `send()` 和 `recv()` 函数中 `flags` 参数的不同设置如何影响数据传输的行为。根据具体应用的需求，可以选择适当的标志来控制数据传输。

## `sendto()` and `recvfrom()`



`sendto()` 和 `recvfrom()` 函数用于在没有连接的情况下（如 UDP）进行数据传输。这些函数允许指定目标地址和端口，适用于面向数据报的套接字（如 UDP 套接字）。

### `sendto()` 函数

#### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
               const struct sockaddr *dest_addr, socklen_t addrlen);
```

#### 参数

- **sockfd**：套接字描述符，由 `socket()` 返回。
- **buf**：指向要发送的数据的缓冲区。
- **len**：要发送的数据长度。
- **flags**：发送标志，通常设置为 0。
- **dest_addr**：指向 `sockaddr` 结构体的指针，包含目标地址和端口。
- **addrlen**：`dest_addr` 结构体的大小（字节数）。

#### 返回值

- 成功时返回发送的字节数。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### `recvfrom()` 函数

#### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags,
                 struct sockaddr *src_addr, socklen_t *addrlen);
```

#### 参数

- **sockfd**：套接字描述符，由 `socket()` 返回。
- **buf**：指向用于接收数据的缓冲区。
- **len**：缓冲区的长度。
- **flags**：接收标志，通常设置为 0。
- **src_addr**：指向 `sockaddr` 结构体的指针，用于存储发送方的地址和端口。可以设置为 NULL。
- **addrlen**：指向一个 `socklen_t` 变量的指针，最初应设置为 `src_addr` 所指向的结构体的大小。函数返回时，该变量包含实际存储在 `src_addr` 结构体中的地址的大小。可以设置为 NULL。

#### 返回值

- 成功时返回接收到的字节数。如果连接被关闭，返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 示例

以下是一个简单的 UDP 客户端和服务器示例，演示如何使用 `sendto()` 和 `recvfrom()` 函数进行数据传输。

#### UDP 服务器

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 12345
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len;
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received;

    // 创建一个 IPv4, 数据报(UDP)套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(PORT);       // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port %d...\n", PORT);

    while (1) {
        // 接收来自客户端的数据
        addr_len = sizeof(client_addr);
        bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                                  (struct sockaddr *)&client_addr, &addr_len);
        if (bytes_received == -1) {
            perror("recvfrom");
            continue;
        }

        buffer[bytes_received] = '\0';
        printf("Received from %s: %s\n", inet_ntoa(client_addr.sin_addr), buffer);

        // 发送响应到客户端
        const char *response = "Message received";
        if (sendto(sockfd, response, strlen(response), 0,
                   (struct sockaddr *)&client_addr, addr_len) == -1) {
            perror("sendto");
        }
    }

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

#### UDP 客户端

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 12345
#define SERVER_IP "127.0.0.1"
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];
    ssize_t bytes_sent, bytes_received;
    socklen_t addr_len;

    // 创建一个 IPv4, 数据报(UDP)套接字
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT); // 服务器端口
    if (inet_pton(AF_INET, SERVER_IP, &server_addr.sin_addr) <= 0) {
        perror("inet_pton");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 发送数据到服务器
    const char *message = "Hello, Server!";
    bytes_sent = sendto(sockfd, message, strlen(message), 0,
                        (struct sockaddr *)&server_addr, sizeof(server_addr));
    if (bytes_sent == -1) {
        perror("sendto");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 接收来自服务器的响应
    addr_len = sizeof(server_addr);
    bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                              (struct sockaddr *)&server_addr, &addr_len);
    if (bytes_received == -1) {
        perror("recvfrom");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    buffer[bytes_received] = '\0';
    printf("Received from server: %s\n", buffer);

    // 关闭套接字
    close(sockfd);

    return 0;
}
```

### 详细说明

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_DGRAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```
   创建一个数据报(UDP)套接字。如果创建失败，`socket()` 返回 -1，并设置 `errno`。

2. **设置服务器地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址（服务器）
   server_addr.sin_port = htons(PORT);
   ```
   设置 `server_addr` 结构体，用于指定绑定的地址和端口。

3. **绑定套接字（服务器）：**
   ```c
   if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("bind");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `bind()` 函数将套接字与指定的地址和端口绑定。如果绑定失败，`bind()` 返回 -1，并设置 `errno`。

4. **发送数据（客户端）：**
   ```c
   bytes_sent = sendto(sockfd, message, strlen(message), 0,
                       (struct sockaddr *)&server_addr, sizeof(server_addr));
   if (bytes_sent == -1) {
       perror("sendto");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```
   调用 `sendto()` 函数将数据发送到指定的目标地址和端口。如果发送失败，`sendto()` 返回 -1，并设置 `errno`。

5. **接收数据：**
   ```c
   bytes_received = recvfrom(sockfd, buffer, BUFFER_SIZE - 1, 0,
                             (struct sockaddr *)&client_addr, &addr_len);
   if (bytes_received == -1) {
       perror("recvfrom");
       continue;
   }
   buffer[bytes_received] = '\0';
   printf("Received from %s: %s\n", inet_ntoa(client_addr.sin_addr), buffer);
   ```
   调用 `recvfrom()` 函数从指定的源地址和端口接收数据。如果接收失败，`recvfrom()` 返回 -1，并设置 `errno`。

通过这些步骤，UDP 服务器和客户端可以使用 `sendto()` 和 `recvfrom()` 函数进行数据传输。这些函数允许在没有连接的

## close() and shutdown()

`close()` 和 `shutdown()` 函数用于关闭套接字，但它们在行为和使用场景上有所不同。

### `close()` 函数

`close()` 函数用于关闭一个文件描述符（包括套接字）。调用 `close()` 后，文件描述符变为无效，不能再用于读写操作。

#### 函数原型

```c
#include <unistd.h>

int close(int fd);
```

#### 参数

- **fd**：要关闭的文件描述符。

#### 返回值

- 成功时返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 使用示例

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

int main() {
    int sockfd;

    // 创建一个套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 使用套接字进行一些操作...

    // 关闭套接字
    if (close(sockfd) == -1) {
        perror("close");
        exit(EXIT_FAILURE);
    }

    printf("Socket closed successfully\n");
    return 0;
}
```

### `shutdown()` 函数

`shutdown()` 函数用于部分或完全关闭一个套接字的连接。与 `close()` 不同，`shutdown()` 允许只关闭套接字的一部分（如只关闭读或只关闭写）。

#### 函数原型

```c
#include <sys/types.h>
#include <sys/socket.h>

int shutdown(int sockfd, int how);
```

#### 参数

- **sockfd**：要关闭的套接字描述符。
- **how**：指定如何关闭套接字。可以是以下值之一：
  - `SHUT_RD`：关闭读这一半连接。
  - `SHUT_WR`：关闭写这一半连接。
  - `SHUT_RDWR`：同时关闭读和写。

#### 返回值

- 成功时返回 0。
- 失败时返回 -1，并设置 `errno` 来指示错误。

### 使用示例

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

int main() {
    int sockfd;

    // 创建一个套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 使用套接字进行一些操作...

    // 关闭套接字的写端
    if (shutdown(sockfd, SHUT_WR) == -1) {
        perror("shutdown");
        exit(EXIT_FAILURE);
    }

    printf("Socket write shutdown successfully\n");

    // 关闭套接字的读端
    if (shutdown(sockfd, SHUT_RD) == -1) {
        perror("shutdown");
        exit(EXIT_FAILURE);
    }

    printf("Socket read shutdown successfully\n");

    // 完全关闭套接字
    if (close(sockfd) == -1) {
        perror("close");
        exit(EXIT_FAILURE);
    }

    printf("Socket closed successfully\n");
    return 0;
}
```

### 区别和使用场景

- **`close()`**：完全关闭文件描述符，使其不可用。常用于释放资源。
  - 使用场景：在不再需要使用套接字时调用，以释放资源。

- **`shutdown()`**：部分或完全关闭套接字的连接。可以关闭读、写或读写。
  - 使用场景：需要关闭套接字的某一部分连接（如不再需要发送数据但还需要接收数据）时使用。

通过这两个函数，可以灵活地控制套接字的关闭方式，确保资源的正确释放和网络连接的正确管理。

## tcp服务器

server.c

```c
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

#define MYPORT "3490"
#define BACKLOG 10

int main()
{
    struct sockaddr_storage their_addr;
    socklen_t addr_size;

    struct addrinfo hints, *res;
    int sockfd, new_fd;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;

    int status = getaddrinfo(NULL, MYPORT, &hints, &res);
    if (status != 0) {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
        return 1;
    }

    sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sockfd == -1) {
        perror("socket");
        freeaddrinfo(res);
        return 1;
    }

    if (bind(sockfd, res->ai_addr, res->ai_addrlen) == -1) {
        close(sockfd);
        perror("bind");
        freeaddrinfo(res);
        return 1;
    }

    freeaddrinfo(res);

    if (listen(sockfd, BACKLOG) == -1) {
        perror("listen");
        close(sockfd);
        return 1;
    }

    addr_size = sizeof their_addr;
    new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &addr_size);
    if (new_fd == -1) {
        perror("accept");
        close(sockfd);
        return 1;
    } else {
        printf("连接成功\n");
    }

    char *msg = "Hello, Meowrain, this is server";
    int len = strlen(msg);
    int bytes_sent = send(new_fd, msg, len, 0);
    if (bytes_sent == -1) {
        perror("send");
    }

    close(new_fd);
    close(sockfd);

    return 0;
}

```

client.c

```c
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

#define SERVERPORT "3490" // 与server端的端口一致

int main() {
    struct addrinfo hints, *res;
    int sockfd;

    // 设置hints
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    // 获取server地址信息
    int status = getaddrinfo("127.0.0.1", SERVERPORT, &hints, &res); // 假设server在本地运行
    if (status != 0) {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
        return 1;
    }

    // 创建socket
    sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sockfd == -1) {
        perror("socket");
        freeaddrinfo(res);
        return 1;
    }

    // 连接到server
    if (connect(sockfd, res->ai_addr, res->ai_addrlen) == -1) {
        perror("连接失败");
        close(sockfd);
        freeaddrinfo(res);
        return 1;
    }

    printf("连接成功\n");

    // 可以在这里添加进一步的通信代码，比如发送或接收数据
    char buffer[1024];
    int bytes_received = recv(sockfd, buffer, sizeof(buffer) - 1, 0);
    if (bytes_received == -1) {
        perror("recv");
    } else {
        buffer[bytes_received] = '\0'; // 确保字符串终止
        printf("从服务器接收到消息: %s\n", buffer);
    }

    // 关闭socket
    close(sockfd);

    // 释放地址信息
    freeaddrinfo(res);

    return 0;
}

```

## udp服务器

udpserver.c

```c
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>

#define MYPORT "8090"

int main() {
    struct addrinfo hints, *res;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET;         // 使用 IPv4
    hints.ai_socktype = SOCK_DGRAM;    // 使用 UDP
    hints.ai_flags = AI_PASSIVE;       // 使用我的 IP

    int status = getaddrinfo(NULL, MYPORT, &hints, &res);
    if (status != 0) {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
        return 1;
    }

    int sockfd;
    if ((sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol)) == -1) {
        perror("socket");
        freeaddrinfo(res);
        return 1;
    }

    if (bind(sockfd, res->ai_addr, res->ai_addrlen) == -1) {
        perror("bind");
        close(sockfd);
        freeaddrinfo(res);
        return 1;
    }

    struct sockaddr_storage their_addr;
    socklen_t addr_len = sizeof their_addr;
    char buf[100];
    int numbytes = recvfrom(sockfd, buf, sizeof buf, 0, (struct sockaddr *)&their_addr, &addr_len);
    if (numbytes == -1) {
        perror("recvfrom");
        close(sockfd);
        freeaddrinfo(res);
        return 1;
    }

    printf("Received: %s\n", buf);

    char *msg = "UDP server response";
    int bytes_sent = sendto(sockfd, msg, strlen(msg), 0, (struct sockaddr *)&their_addr, addr_len);
    if (bytes_sent == -1) {
        perror("sendto");
        close(sockfd);
        freeaddrinfo(res);
        return 1;
    }

    printf("Message sent: %s\n", msg);

    close(sockfd);
    freeaddrinfo(res);
    return 0;
}

```

udpclient.c

```c
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>

#define SERVERPORT "8090"
#define SERVERADDR "127.0.0.1"

int main() {
    struct addrinfo hints, *res;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET;         // 使用 IPv4
    hints.ai_socktype = SOCK_DGRAM;    // 使用 UDP

    int status = getaddrinfo(SERVERADDR, SERVERPORT, &hints, &res);
    if (status != 0) {
        fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(status));
        return 1;
    }

    int sockfd;
    if ((sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol)) == -1) {
        perror("socket");
        freeaddrinfo(res);
        return 1;
    }

    char *msg = "Hello, UDP server!";
    int bytes_sent = sendto(sockfd, msg, strlen(msg), 0, res->ai_addr, res->ai_addrlen);
    if (bytes_sent == -1) {
        perror("sendto");
        close(sockfd);
        freeaddrinfo(res);
        return 1;
    }

    printf("Message sent: %s\n", msg);

    struct sockaddr_storage their_addr;
    socklen_t addr_len = sizeof their_addr;
    char buf[100];
    int numbytes = recvfrom(sockfd, buf, sizeof buf, 0, (struct sockaddr *)&their_addr, &addr_len);
    if (numbytes == -1) {
        perror("recvfrom");
        close(sockfd);
        freeaddrinfo(res);
        return 1;
    }

    buf[numbytes] = '\0'; // Null-terminate the received data
    printf("Received: %s\n", buf);

    close(sockfd);
    freeaddrinfo(res);
    return 0;
}

```

## getpeername()

是的，在我之前的示例中，使用 `getpeername()` 函数获取的远程地址信息实际上与通过 `accept()` 获取的客户端地址信息是相同的。这是因为 `accept()` 函数已经提供了客户端的地址信息，并存储在 `client_addr` 结构体中。

为了更好地说明 `getpeername()` 的使用场景，我将提供一个更清晰的示例。我们将在接受客户端连接后使用 `getpeername()` 来获取远程客户端的地址信息，以展示如何使用该函数。

### 示例：使用 `getpeername()` 获取客户端地址信息

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 12345
#define BACKLOG 10

int main() {
    int sockfd, new_sockfd;
    struct sockaddr_in server_addr, client_addr;
    struct sockaddr_in peer_addr;
    socklen_t addr_len, peer_addr_len;
    char buffer[1024];
    ssize_t bytes_received;

    // 创建一个 IPv4, 流式(TCP)套接字
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; // 绑定到本地所有地址
    server_addr.sin_port = htons(PORT);       // 绑定到端口 12345

    // 绑定套接字到地址和端口
    if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(sockfd, BACKLOG) == -1) {
        perror("listen");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Listening on port %d...\n", PORT);

    // 接受客户端连接
    addr_len = sizeof(client_addr);
    new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
    if (new_sockfd == -1) {
        perror("accept");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Accepted connection from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

    // 获取远程端地址信息
    peer_addr_len = sizeof(peer_addr);
    if (getpeername(new_sockfd, (struct sockaddr *)&peer_addr, &peer_addr_len) == -1) {
        perror("getpeername");
        close(new_sockfd);
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    printf("Peer address (from getpeername): %s, port: %d\n",
           inet_ntoa(peer_addr.sin_addr), ntohs(peer_addr.sin_port));

    // 接收数据
    bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
    if (bytes_received == -1) {
        perror("recv");
    } else {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }

    // 发送响应
    const char *response = "Message received";
    if (send(new_sockfd, response, strlen(response), 0) == -1) {
        perror("send");
    }

    // 关闭客户端连接
    close(new_sockfd);

    // 关闭服务器套接字
    close(sockfd);

    return 0;
}
```

### 说明

1. **创建套接字：**
   ```c
   sockfd = socket(AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1) {
       perror("socket");
       exit(EXIT_FAILURE);
   }
   ```

2. **设置服务器地址和端口：**
   ```c
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = INADDR_ANY;
   server_addr.sin_port = htons(PORT);
   ```

3. **绑定套接字：**
   ```c
   if (bind(sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
       perror("bind");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```

4. **监听连接请求：**
   ```c
   if (listen(sockfd, BACKLOG) == -1) {
       perror("listen");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```

5. **接受客户端连接：**
   ```c
   addr_len = sizeof(client_addr);
   new_sockfd = accept(sockfd, (struct sockaddr *)&client_addr, &addr_len);
   if (new_sockfd == -1) {
       perror("accept");
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   ```

6. **打印客户端地址信息：**
   ```c
   printf("Accepted connection from %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
   ```

7. **使用 `getpeername()` 获取远程端地址信息：**
   ```c
   peer_addr_len = sizeof(peer_addr);
   if (getpeername(new_sockfd, (struct sockaddr *)&peer_addr, &peer_addr_len) == -1) {
       perror("getpeername");
       close(new_sockfd);
       close(sockfd);
       exit(EXIT_FAILURE);
   }
   
   printf("Peer address (from getpeername): %s, port: %d\n",
          inet_ntoa(peer_addr.sin_addr), ntohs(peer_addr.sin_port));
   ```

8. **接收数据并发送响应：**
   ```c
   bytes_received = recv(new_sockfd, buffer, sizeof(buffer) - 1, 0);
   if (bytes_received == -1) {
       perror("recv");
   } else {
       buffer[bytes_received] = '\0';
       printf("Received: %s\n", buffer);
   }
   
   const char *response = "Message received";
   if (send(new_sockfd, response, strlen(response), 0) == -1) {
       perror("send");
   }
   ```

9. **关闭套接字：**
   ```c
   close(new_sockfd);
   close(sockfd);
   ```

通过这个示例，可以看到 `getpeername()` 函数如何用来获取已连接客户端的地址信息。尽管在大多数情况下，我们可以通过 `accept()` 直接获取客户端地址，但 `getpeername()` 提供了一种额外的方法来获取这个信息。



# 阻塞

## fcntl()

`fcntl()` 是一个用于操作文件描述符的系统调用，常用于设置文件描述符的属性、获取文件状态信息以及执行文件锁定等操作。它在网络编程中也常用于设置套接字的非阻塞模式。

### 函数原型

```c
#include <fcntl.h>

int fcntl(int fd, int cmd, ... /* arg */ );
```

### 参数

- **fd**：要操作的文件描述符。
- **cmd**：要执行的操作命令。
- **arg**：可选参数，根据 `cmd` 的不同，参数的数量和类型也不同。

### 常用命令

1. **F_GETFL**：获取文件描述符状态标志。
2. **F_SETFL**：设置文件描述符状态标志。
3. **F_GETFD**：获取文件描述符标志。
4. **F_SETFD**：设置文件描述符标志。
5. **F_SETLK**：设置文件锁（非阻塞）。
6. **F_SETLKW**：设置文件锁（阻塞）。

### 设置非阻塞模式

在网络编程中，常见的用法是将套接字设置为非阻塞模式。以下是如何使用 `fcntl()` 将套接字设置为非阻塞模式的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <errno.h>

#define PORT 12345
#define BUFFER_SIZE 1024

void set_non_blocking(int socket);

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received;

    // 创建套接字
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // 绑定套接字
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(server_socket, 10) == -1) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server listening on port %d\n", PORT);

    // 设置服务器套接字为非阻塞模式
    set_non_blocking(server_socket);

    while (1) {
        // 接受客户端连接
        client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_addr_len);
        if (client_socket == -1) {
            if (errno == EWOULDBLOCK || errno == EAGAIN) {
                // 没有可接受的连接，继续循环
                usleep(100000); // 睡眠100毫秒
                continue;
            } else {
                perror("accept");
                close(server_socket);
                exit(EXIT_FAILURE);
            }
        }

        printf("New client connected\n");

        // 设置客户端套接字为非阻塞模式
        set_non_blocking(client_socket);

        // 接收数据
        while (1) {
            bytes_received = recv(client_socket, buffer, BUFFER_SIZE - 1, 0);
            if (bytes_received == -1) {
                if (errno == EWOULDBLOCK || errno == EAGAIN) {
                    // 没有更多数据，继续循环
                    perror("info");
                    usleep(100000); // 睡眠100毫秒
                    continue;
                } else {
                    perror("recv");
                    close(client_socket);
                    break;
                }
            } else if (bytes_received == 0) {
                // 客户端关闭连接
                printf("Client disconnected\n");
                close(client_socket);
                break;
            } else {
                buffer[bytes_received] = '\0';
                printf("Received message: %s\n", buffer);
                send(client_socket, buffer, bytes_received, 0);
            }
        }
    }

    close(server_socket);
    return 0;
}

void set_non_blocking(int socket) {
    int flags;

    // 获取文件描述符的标志
    flags = fcntl(socket, F_GETFL, 0);
    if (flags == -1) {
        perror("fcntl(F_GETFL)");
        exit(EXIT_FAILURE);
    }

    // 设置非阻塞标志
    flags |= O_NONBLOCK;
    if (fcntl(socket, F_SETFL, flags) == -1) {
        perror("fcntl(F_SETFL)");
        exit(EXIT_FAILURE);
    }
}

```





## 阻塞模式和非阻塞模式

设置套接字为非阻塞模式后，你可以高效地“轮询”套接字以获取信息。非阻塞模式的一个重要特性是，当你尝试从非阻塞套接字读取数据但没有数据可读时，读取操作不会阻塞进程，而是立即返回 -1，并将 `errno` 设置为 `EAGAIN` 或 `EWOULDBLOCK`。

### 具体解释

1. **阻塞模式下的行为**：
   - 默认情况下，套接字操作（如 `recv()` 或 `send()`）是阻塞的。这意味着，如果你调用 `recv()` 读取数据，而没有数据可供读取，`recv()` 调用会阻塞，直到有数据可读或发生错误。

2. **非阻塞模式下的行为**：
   - 在非阻塞模式下，如果你调用 `recv()` 读取数据，而没有数据可供读取，`recv()` 调用不会阻塞，而是立即返回 -1，并将 `errno` 设置为 `EAGAIN` 或 `EWOULDBLOCK`。
   - 同样地，如果你调用 `send()` 发送数据，但发送缓冲区已满，`send()` 调用不会阻塞，而是立即返回 -1，并将 `errno` 设置为 `EAGAIN` 或 `EWOULDBLOCK`。

### 示例代码

以下是一个设置套接字为非阻塞模式，并处理 `recv()` 返回值的示例：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <errno.h>

#define PORT 12345
#define BUFFER_SIZE 1024

void set_non_blocking(int socket);

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received;

    // 创建套接字
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // 绑定套接字
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(server_socket, 10) == -1) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server listening on port %d\n", PORT);

    // 设置服务器套接字为非阻塞模式
    set_non_blocking(server_socket);

    while (1) {
        // 接受客户端连接
        client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_addr_len);
        if (client_socket == -1) {
            if (errno == EWOULDBLOCK || errno == EAGAIN) {
                // 没有可接受的连接，继续循环
                usleep(100000); // 睡眠100毫秒
                continue;
            } else {
                perror("accept");
                close(server_socket);
                exit(EXIT_FAILURE);
            }
        }

        // 设置客户端套接字为非阻塞模式
        set_non_blocking(client_socket);

        // 接收数据
        while (1) {
            bytes_received = recv(client_socket, buffer, BUFFER_SIZE - 1, 0);
            if (bytes_received > 0) {
                buffer[bytes_received] = '\0';
                printf("Received message: %s\n", buffer);
                send(client_socket, buffer, bytes_received, 0);
            } else if (bytes_received == 0) {
                // 客户端关闭连接
                close(client_socket);
                break;
            } else {
                if (errno == EWOULDBLOCK || errno == EAGAIN) {
                    // 没有更多数据，继续循环
                    usleep(100000); // 睡眠100毫秒
                    continue;
                } else {
                    perror("recv");
                    close(client_socket);
                    break;
                }
            }
        }
    }

    close(server_socket);
    return 0;
}

void set_non_blocking(int socket) {
    int flags;

    // 获取文件描述符的标志
    flags = fcntl(socket, F_GETFL, 0);
    if (flags == -1) {
        perror("fcntl(F_GETFL)");
        exit(EXIT_FAILURE);
    }

    // 设置非阻塞标志
    flags |= O_NONBLOCK;
    if (fcntl(socket, F_SETFL, flags) == -1) {
        perror("fcntl(F_SETFL)");
        exit(EXIT_FAILURE);
    }
}
```

### 代码解释

1. **创建和绑定套接字**：
   - 创建一个 TCP 套接字，绑定到指定端口，并开始监听连接请求。

2. **设置套接字为非阻塞模式**：
   ```c
   void set_non_blocking(int socket) {
       int flags;
       flags = fcntl(socket, F_GETFL, 0);
       if (flags == -1) {
           perror("fcntl(F_GETFL)");
           exit(EXIT_FAILURE);
       }
       flags |= O_NONBLOCK;
       if (fcntl(socket, F_SETFL, flags) == -1) {
           perror("fcntl(F_SETFL)");
           exit(EXIT_FAILURE);
       }
   }
   ```

3. **接受和处理客户端连接**：
   - 使用 `accept()` 接受客户端连接。由于套接字是非阻塞的，如果没有可接受的连接，`accept()` 会立即返回 -1，并将 `errno` 设置为 `EWOULDBLOCK` 或 `EAGAIN`。在这种情况下，程序会继续循环，等待新的连接请求。
   - 接收数据时，如果没有数据可读，`recv()` 会立即返回 -1，并将 `errno` 设置为 `EWOULDBLOCK` 或 `EAGAIN`。程序会继续循环，等待新的数据到达。

通过这种方式，程序可以有效地处理多个客户端连接，而不会因为一个客户端的操作而阻塞整个服务器。

### 非阻塞模式的问题

> 通过非阻塞套接字进行轮询（polling）来检查是否有数据可读可能会导致高 CPU 占用，因为程序可能会在无数据可读的情况下频繁轮询。这种情况下，使用更高效的方法来监控多个文件描述符的状态，例如 `poll()` 或 `select()`，会是更优雅的解决方案



## poll()

`poll()` 是一种用于同步 I/O 多路复用的系统调用，它允许程序在多个文件描述符上等待事件。它是 `select()` 的改进版本，提供了更好的可扩展性和灵活性。`poll()` 常用于网络编程中，特别是当你需要同时处理多个网络连接时。

### `poll()` 函数原型

```c
#include <poll.h>

int poll(struct pollfd *fds, nfds_t nfds, int timeout);
```

### 参数

- **fds**：一个 `pollfd` 结构体数组，描述要监视的文件描述符及其事件。
- **nfds**：要监视的文件描述符数量。
- **timeout**：等待的超时时间（毫秒）。如果为 -1，则无限等待。如果为 0，则立即返回。

### `pollfd` 结构体

```c
struct pollfd {
    int fd;         // the socket descriptor
    short events;   // bitmap of events we're interested in
    short revents;  // when poll() returns, bitmap of events that occurred
};
```

### 常用事件标志

- **POLLIN**：有数据可读。
- **POLLOUT**：可以写数据。
- **POLLERR**：发生错误。
- **POLLHUP**：挂起。

### 使用 `poll()` 的示例

以下是一个使用 `poll()` 的示例，演示如何使用它来处理多个客户端连接。这个示例代码实现了一个简单的回显服务器，能够同时处理多个客户端的连接和数据传输。

#### 服务器代码

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <poll.h>
#include <errno.h>

#define PORT 12345
#define BUFFER_SIZE 1024
#define MAX_CLIENTS 100

int main() {
    int server_socket, client_socket;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received;

    struct pollfd fds[MAX_CLIENTS];
    int nfds = 1; // 初始只有一个服务器套接字

    // 创建套接字
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // 绑定套接字
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(server_socket, 10) == -1) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server listening on port %d\n", PORT);

    // 初始化 pollfd 结构体
    fds[0].fd = server_socket;
    fds[0].events = POLLIN;

    while (1) {
        int poll_count = poll(fds, nfds, -1); // 无限等待
        if (poll_count == -1) {
            perror("poll");
            close(server_socket);
            exit(EXIT_FAILURE);
        }

        for (int i = 0; i < nfds; i++) {
            if (fds[i].revents & POLLIN) {
                if (fds[i].fd == server_socket) {
                    // 接受新连接
                    client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_addr_len);
                    if (client_socket == -1) {
                        perror("accept");
                    } else {
                        printf("New connection accepted\n");
                        fds[nfds].fd = client_socket;
                        fds[nfds].events = POLLIN;
                        nfds++;
                    }
                } else {
                    // 处理现有连接的数据
                    bytes_received = recv(fds[i].fd, buffer, BUFFER_SIZE - 1, 0);
                    if (bytes_received > 0) {
                        buffer[bytes_received] = '\0';
                        printf("Received message: %s\n", buffer);
                        send(fds[i].fd, buffer, bytes_received, 0);
                    } else if (bytes_received == 0) {
                        // 客户端关闭连接
                        printf("Client disconnected\n");
                        close(fds[i].fd);
                        fds[i] = fds[nfds - 1];
                        nfds--;
                    } else {
                        perror("recv");
                        close(fds[i].fd);
                        fds[i] = fds[nfds - 1];
                        nfds--;
                    }
                }
            }
        }
    }

    close(server_socket);
    return 0;
}
```

### 代码说明

1. **初始化服务器套接字**：
   - 创建一个 TCP 套接字，绑定到指定端口，并开始监听连接请求。

2. **初始化 `pollfd` 结构体数组**：
   ```c
   fds[0].fd = server_socket;
   fds[0].events = POLLIN;
   ```

3. **使用 `poll()` 监视文件描述符**：
   
   - 无限等待有事件发生。
   - 检查每个文件描述符的事件。
   
4. **处理新连接和现有连接的数据**：
   - 如果有新的连接请求，接受连接并将新客户端添加到 `pollfd` 数组中。
   - 如果有数据可读，读取数据并回显给客户端。

5. **处理客户端断开**：
   - 如果客户端关闭连接，移除对应的文件描述符。

### 注意事项

- **文件描述符数量**：虽然 `poll()` 没有 `select()` 那样的文件描述符数量限制，但你仍然需要确保 `pollfd` 数组的大小足够大，以容纳你要监视的所有文件描述符。
- **错误处理**：务必处理 `poll()` 调用中的错误情况，如 `poll()` 返回 -1 时的错误处理。
- **性能优化**：对于大量客户端连接的高并发场景，可以考虑使用 `epoll`（在 Linux 上）或其他更高效的 I/O 多路复用机制。

通过使用 `poll()`，你可以更高效地监视和处理多个文件描述符上的 I/O 事件，从而构建更高性能的网络服务器。

 ## 阻塞IO和非阻塞IO下poll的行为状态区别

在使用 `poll()` 的情况下，套接字是否设置为非阻塞模式会影响到 `accept()` 和 `recv()` 等 I/O 操作的行为。以下是阻塞模式和非阻塞模式下使用 `poll()` 的区别和影响：

### 阻塞模式下使用 `poll()`

#### 行为

1. **`poll()`**：
   - `poll()` 会阻塞，直到至少一个文件描述符上有指定的事件发生。

2. **`accept()` 和 `recv()`**：
   - `accept()`：如果没有新的连接请求，会阻塞，直到有新的连接请求到来。
   - `recv()`：如果没有数据可读，会阻塞，直到有数据到来。

#### 优点

- 简单直观：编写阻塞模式代码更简单，不需要处理 `EWOULDBLOCK` 和 `EAGAIN` 等错误。
- 适用于低并发：在低并发情况下，阻塞模式的性能和响应时间可能已经足够。

#### 缺点

- 可能会导致性能瓶颈：在高并发情况下，如果某个 `accept()` 或 `recv()` 调用阻塞，可能会导致整个应用程序的其他部分无法及时响应。
- 整体响应时间可能更长：由于阻塞操作，某些客户端可能会遭遇较长的等待时间。

### 非阻塞模式下使用 `poll()`

#### 行为

1. **`poll()`**：
   - `poll()` 会阻塞，直到至少一个文件描述符上有指定的事件发生。

2. **`accept()` 和 `recv()`**：
   - `accept()`：如果没有新的连接请求，会立即返回 -1，并设置 `errno` 为 `EWOULDBLOCK` 或 `EAGAIN`。
   - `recv()`：如果没有数据可读，会立即返回 -1，并设置 `errno` 为 `EWOULDBLOCK` 或 `EAGAIN`。

#### 优点

- 提高并发处理能力：非阻塞模式下，程序不会因为单个阻塞操作而被挂起，能够更高效地处理大量并发连接。
- 更低的延迟：非阻塞模式下，I/O 操作可以更快地返回，提高了整体响应速度。

#### 缺点

- 编码更复杂：需要处理 `EWOULDBLOCK` 和 `EAGAIN` 错误，并在这些错误发生时采取适当的行动（如继续轮询）。
- 资源管理更复杂：需要注意处理频繁的非阻塞 I/O 操作带来的 CPU 占用。

### 示例对比

#### 阻塞模式示例

```c
while (1) {
    int poll_count = poll(fds, nfds, -1); // 无限等待
    if (poll_count == -1) {
        perror("poll");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < nfds; i++) {
        if (fds[i].revents & POLLIN) {
            if (fds[i].fd == server_socket) {
                // 接受新连接，可能阻塞
                client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_addr_len);
                if (client_socket == -1) {
                    perror("accept");
                } else {
                    fds[nfds].fd = client_socket;
                    fds[nfds].events = POLLIN;
                    nfds++;
                }
            } else {
                // 读取数据，可能阻塞
                bytes_received = recv(fds[i].fd, buffer, BUFFER_SIZE - 1, 0);
                if (bytes_received > 0) {
                    buffer[bytes_received] = '\0';
                    send(fds[i].fd, buffer, bytes_received, 0);
                } else if (bytes_received == 0) {
                    close(fds[i].fd);
                    fds[i] = fds[nfds - 1];
                    nfds--;
                } else {
                    perror("recv");
                    close(fds[i].fd);
                    fds[i] = fds[nfds - 1];
                    nfds--;
                }
            }
        }
    }
}
```

#### 非阻塞模式示例

```c
void set_non_blocking(int socket) {
    int flags = fcntl(socket, F_GETFL, 0);
    if (flags == -1) {
        perror("fcntl(F_GETFL)");
        exit(EXIT_FAILURE);
    }
    if (fcntl(socket, F_SETFL, flags | O_NONBLOCK) == -1) {
        perror("fcntl(F_SETFL)");
        exit(EXIT_FAILURE);
    }
}

while (1) {
    int poll_count = poll(fds, nfds, -1); // 无限等待
    if (poll_count == -1) {
        perror("poll");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < nfds; i++) {
        if (fds[i].revents & POLLIN) {
            if (fds[i].fd == server_socket) {
                // 接受新连接，不会阻塞
                client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &client_addr_len);
                if (client_socket == -1) {
                    if (errno != EWOULDBLOCK && errno != EAGAIN) {
                        perror("accept");
                    }
                } else {
                    set_non_blocking(client_socket); // 设置新连接为非阻塞模式
                    fds[nfds].fd = client_socket;
                    fds[nfds].events = POLLIN;
                    nfds++;
                }
            } else {
                // 读取数据，不会阻塞
                bytes_received = recv(fds[i].fd, buffer, BUFFER_SIZE - 1, 0);
                if (bytes_received > 0) {
                    buffer[bytes_received] = '\0';
                    send(fds[i].fd, buffer, bytes_received, 0);
                } else if (bytes_received == 0) {
                    close(fds[i].fd);
                    fds[i] = fds[nfds - 1];
                    nfds--;
                } else {
                    if (errno != EWOULDBLOCK && errno != EAGAIN) {
                        perror("recv");
                        close(fds[i].fd);
                        fds[i] = fds[nfds - 1];
                        nfds--;
                    }
                }
            }
        }
    }
}
```

### 结论

- **阻塞模式**：代码更简单，适用于低并发或简单应用，但在高并发情况下可能会导致性能瓶颈。
- **非阻塞模式**：更适合高并发应用，能够提高响应速度和并发处理能力，但需要处理更多的错误和边界情况，代码更复杂。

通过根据应用的具体需求选择合适的模式，你可以实现最佳的性能和可扩展性。





## 实践--聊天室
> 使用poll函数实现IO多路复用，实现一个聊天室。

### 目录结构
![](https://static.meowrain.cn/i/2024/06/14/qz5yjs-3.webp)

### 代码实现
> - Makefile
```makefile
CC = gcc

CFLAGS = -Iinclude -Wall -g

SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj

SRCS = $(wildcard $(SRC_DIR)/*.c)

OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

TARGET = chat_server

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $^

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR) chat_server

.PHONY: all clean


```

---

> server.h
```c
#ifndef SERVER_H
#define SERVER_H
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <poll.h>
#include <errno.h>
#include <arpa/inet.h>
#include <string.h>
#define PORT 8099
#define MAXCLIENTS 100
int create_server_socket();
#endif // SERVER_H
```

---

> client_handler.h
```c
#ifndef CLIENT_HANDLER_H
#define CLIENT_HANDLER_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <poll.h>
#include <errno.h>
#define BUFFER_SIZE 1024
void handle_new_connection(int server_socket, struct pollfd *fds, int *nfds);
void handle_client_message(struct pollfd *fds, int *nfds, int i);
void broadcast_message(struct pollfd *fds, int nfds, int sender_fd, const char *message, ssize_t message_len);
#endif

```

---

> server.c

```c
#include "server.h"
#include "client_handler.h"

int create_server_socket()
{
    int server_socket = socket(PF_INET, SOCK_STREAM, 0);
    if (server_socket == -1)
    {
        perror("socket");
        exit(EXIT_FAILURE);
    }
    struct sockaddr_in server_addr;

    server_addr.sin_family = PF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    if(bind(server_socket,(struct sockaddr*)&server_addr,sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }
    
    if(listen(server_socket,10) == -1) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    return server_socket;
}

```

---

> client_handler.c
```c
#include "client_handler.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <errno.h>

void handle_new_connection(int server_socket, struct pollfd *fds, int *nfds)
{
    struct sockaddr_in client_addr;
    socklen_t clientaddr_len = sizeof(client_addr);
    int client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &clientaddr_len);
    if (client_socket == -1)
    {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    else
    {
        char client_ip[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &client_addr.sin_addr, client_ip, sizeof(client_ip));
        printf("New connection accepted from %s:%d\n", client_ip, ntohs(client_addr.sin_port));
        char newbuffer[BUFFER_SIZE];
        sprintf(newbuffer,"Welcome,Friends,You are login in my server now,your ip is:%s\n", client_ip);
        send(client_socket,newbuffer,strlen(newbuffer),0);
        fds[*nfds].fd = client_socket;
        fds[*nfds].events = POLLIN;
        (*nfds)++;
    }
}

void handle_client_message(struct pollfd *fds, int *nfds, int i)
{
    char buffer[BUFFER_SIZE];
    ssize_t bytes_received = recv(fds[i].fd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0)
    {
        buffer[bytes_received] = '\0';
        printf("Received message: %s\n", buffer);

        // 获取发送者的 IP 和端口
        struct sockaddr_in sender_addr;
        socklen_t addr_len = sizeof(sender_addr);
        getpeername(fds[i].fd, (struct sockaddr *)&sender_addr, &addr_len);
        char sender_ip[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &sender_addr.sin_addr, sender_ip, sizeof(sender_ip));
        int sender_port = ntohs(sender_addr.sin_port);

        // 计算前缀长度和剩余空间
        const char *prefix_format = "From %s:%d: ";
        int prefix_len = snprintf(NULL, 0, prefix_format, sender_ip, sender_port);
        int remaining_space = BUFFER_SIZE - prefix_len - 1;

        // 确保 buffer 不会超过 remaining_space
        if (bytes_received > remaining_space)
        {
            bytes_received = remaining_space;
            buffer[bytes_received] = '\0'; // 确保 buffer 以空字符结尾
        }

        // 创建新的消息缓冲区并添加发送者的 IP 和端口信息
        char newbuffer[BUFFER_SIZE];
        snprintf(newbuffer, sizeof(newbuffer), prefix_format, sender_ip, sender_port);
        strncat(newbuffer, buffer, remaining_space);

        broadcast_message(fds, *nfds, fds[i].fd, newbuffer, strlen(newbuffer));
    }
    else if (bytes_received == 0)
    {
        printf("Client disconnected\n");
        close(fds[i].fd);
        fds[i] = fds[*nfds - 1];
        (*nfds)--;
    }
    else
    {
        perror("recv");
        close(fds[i].fd);
        fds[i] = fds[*nfds - 1];
        (*nfds)--;
    }
}

void broadcast_message(struct pollfd *fds, int nfds, int sender_fd, const char *message, ssize_t message_len)
{
    for (int i = 1; i < nfds; i++)
    {
        if (fds[i].fd != sender_fd)
        {
            send(fds[i].fd, message, message_len, 0);
        }
    }
}

```

----

> main.c

```c
#include "server.h"
#include "client_handler.h"

#define MAX_CLIENTS 100

int main() {
    int server_socket = create_server_socket(PORT);
    struct pollfd fds[MAX_CLIENTS];
    int nfds = 1;

    fds[0].fd = server_socket;
    fds[0].events = POLLIN;

    printf("Server listening on port %d\n", PORT);

    while (1) {
        int poll_count = poll(fds, nfds, -1);
        if (poll_count == -1) {
            perror("poll");
            close(server_socket);
            exit(EXIT_FAILURE);
        }

        for (int i = 0; i < nfds; i++) {
            if (fds[i].revents & POLLIN) {
                if (fds[i].fd == server_socket) {
                    handle_new_connection(server_socket, fds, &nfds);
                } else {
                    handle_client_message(fds, &nfds, i);
                }
            }
        }
    }

    close(server_socket);
    return 0;
}

```





### 代码分析

接下来，我们分析一下代码。
首先，我们来看一下 `server.h` 文件。
```c
#ifndef SERVER_H
#define SERVER_H
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <poll.h>
#include <errno.h>
#include <arpa/inet.h>
#include <string.h>
#define PORT 8099
#define MAXCLIENTS 100
int create_server_socket();
#endif // SERVER_H
```
我们在这里定义了服务器的端口号和最大客户端数量。以及一些必要的头文件。还有一个create_server_socket函数,这个函数用来创建服务器的socket。

然后我们看`server.c`文件，看看这个`create_server_socket()`函数怎么实现的

```c
#include "server.h"
#include "client_handler.h"

int create_server_socket()
{
    int server_socket = socket(PF_INET, SOCK_STREAM, 0);
    if (server_socket == -1)
    {
        perror("socket");
        exit(EXIT_FAILURE);
    }
    struct sockaddr_in server_addr;

    server_addr.sin_family = PF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    if(bind(server_socket,(struct sockaddr*)&server_addr,sizeof(server_addr)) == -1) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }
    
    if(listen(server_socket,10) == -1) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    return server_socket;
}

```

在`create_server_socket()` 函数中，我们首先使用socket函数创建了一个socket，使用ipv4协议，使用tcp协议.

接着我们创建了一个sockaddr_in结构体，这个结构体用来保存服务器的地址信息。

**其中sin_addr.s_addr设置为INADDR_ANY，表示服务器可以接受来自任何ip的连接。**

然后使用bind函数将socket绑定到服务器的地址上
最后使用listen函数监听端口。

listen函数的第二个参数 backlog 是用来指定连接队列的最大长度，即服务器可以排队等待处理的未完成连接请求的最大数量。

最后我们把创建的`server_socket`返回。


然后呢，我们来看看最重要的client_handler部分
首先是client_handler.h文件

```c
#ifndef CLIENT_HANDLER_H
#define CLIENT_HANDLER_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <poll.h>
#include <errno.h>
#define BUFFER_SIZE 1024
void handle_new_connection(int server_socket, struct pollfd *fds, int *nfds);
void handle_client_message(struct pollfd *fds, int *nfds, int i);
void broadcast_message(struct pollfd *fds, int nfds, int sender_fd, const char *message, ssize_t message_len);
#endif

```

我们看到，这里定义了缓冲区大小，以及一些必要的头文件。
