---
title: Linux系统编程 标准IO 打开并读写文件
subtitle:
date: 2024-06-19T02:32:12Z
slug: 232b1fc
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Linux系统编程
  - 文件IO
  - 文件读写
categories:
  - Linux系统编程
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

> https://cplusplus.com/reference/cstdio/fopen/
> https://cplusplus.com/reference/cstdio/fgetc/?kw=fgetc
> https://cplusplus.com/reference/cstdio/fputc/?kw=fputc
> https://cplusplus.com/reference/cstdio/fgets/?kw=fgets
> https://cplusplus.com/reference/cstdio/fputs/?kw=fputs
> https://man7.org/linux/man-pages/man3/getline.3.html
> https://cplusplus.com/reference/cstdio/feof/?kw=feof
> https://cplusplus.com/reference/cstdio/fclose/?kw=fclose
> https://cplusplus.com/reference/cstdio/fread/?kw=fread
> https://cplusplus.com/reference/cstdio/fwrite/?kw=fwrite
> https://cplusplus.com/reference/cstdio/fseek/?kw=fseek
> https://cplusplus.com/reference/cstdio/rewind/kw=rewind
> https://cplusplus.com/reference/cstdio/ftell/?kw=ftell
![](https://static.meowrain.cn/i/2024/01/16/t0jeh1-3.webp)


**`fopen`**：
- **函数原型**：`FILE *fopen(const char *filename, const char *mode);`
- **功能**：打开一个文件，并返回一个指向该文件的文件指针（`FILE` 类型）。这个文件指针用于后续的文件读写操作。
- **参数**：
  - `filename`：指向一个以空字符结尾的字符串，该字符串指定要打开的文件名，可以包含路径信息。
  - `mode`：指向一个以空字符结尾的字符串，指定文件的打开模式。常见的模式包括：
    - `"r"`：以只读方式打开文件（文件必须存在）。
    - `"w"`：以写入方式打开文件，如果文件不存在则创建，如果文件已存在则清空文件内容。
    - `"a"`：以追加方式打开文件，如果文件不存在则创建，写入的数据追加到文件末尾。
    - `"r+"`：以读写方式打开文件（文件必须存在）。
    - `"w+"`：以读写方式打开文件，如果文件不存在则创建，如果文件已存在则清空文件内容。
    - `"a+"`：以读取和追加方式打开文件，如果文件不存在则创建，读取从文件开始，写入追加到文件末尾。
    - 还可以在上述模式后添加 `"b"` 来以二进制模式打开文件，例如 `"rb"`、`"wb"` 等。
- **返回值**：成功时返回一个有效的文件指针，如果文件无法打开，则返回 `NULL`。

在使用 `fopen` 打开文件后，通常需要检查返回的文件指针是否为 `NULL` 来确保文件成功打开。文件使用完毕后，应使用 `fclose` 函数关闭文件，释放资源。例如：

```c
FILE *fp;
char *filename = "example.txt";
char *mode = "r";

fp = fopen(filename, mode);
if (fp == NULL) {
    printf("无法打开文件\n");
    return 1;
}

// 文件操作代码...

fclose(fp);
```

这个例子展示了如何使用 `fopen` 打开一个文件，并在操作完成后关闭文件。

在C语言中，`fgetc`, `fputc`, `fgets`, 和 `fputs` 是用于文件操作的标准库函数，它们分别用于从文件中读取字符、向文件写入字符、从文件中读取字符串和向文件写入字符串。下面是这些函数的简要介绍：

1. **`fgetc`**：
   - **函数原型**：`int fgetc(FILE *stream);`
   - **功能**：从指定的文件流（`stream`）中读取一个字符。
   - **返回值**：返回读取的字符，如果到达文件末尾或发生错误，则返回 `EOF`。

2. **`fputc`**：
   - **函数原型**：`int fputc(int character, FILE *stream);`
   - **功能**：将一个字符（`character`）写入到指定的文件流（`stream`）中。
   - **返回值**：成功时返回写入的字符，如果发生错误，则返回 `EOF`。

3. **`fgets`**：
   - **函数原型**：`char *fgets(char *str, int n, FILE *stream);`
   - **功能**：从指定的文件流（`stream`）中读取最多 `n-1` 个字符，并将其存储在字符数组 `str` 中。如果在读取完整行之前已经读取了 `n-1` 个字符，或者遇到换行符或文件结束符，读取操作将停止。
   - **返回值**：成功时返回指向 `str` 的指针，如果到达文件末尾或发生错误，则返回 `NULL`。

4. **`fputs`**：
   - **函数原型**：`int fputs(const char *str, FILE *stream);`
   - **功能**：将字符串 `str` 写入到指定的文件流（`stream`）中。不包括字符串末尾的空字符。
   - **返回值**：成功时返回非负值，如果发生错误，则返回 `EOF`。

这些函数都是标准输入输出库（`stdio.h`）的一部分，用于处理文件和字符数据。在使用这些函数之前，通常需要打开文件并获取相应的文件指针，使用完毕后还需要关闭文件以释放资源。
# 函数使用示例
## 读取
```c
#include <stdio.h>
//成功返回流指针，失败返回空指针

int main(void)
{
        FILE *file;
        char filename[] = "./files/demo.txt";
        char mode[] = "r";
        file = fopen(filename,mode);
        if(file == NULL)
        {
                printf("无法打开文件\n");
                return 1;
        }
        int ch;
        while((ch = fgetc(file)) != EOF){
                printf("%c",ch);
        }
        //执行完毕后关闭流
        fclose(file);

        return 0;
}
```
![](https://static.meowrain.cn/i/2024/01/16/ttixxs-3.webp)

使用 fgets 函数按行读取文件内容：
```c
//成功返回流指针，失败返回空指针

int main(void)
{
        FILE *file;
        char filename[] = "./files/demo.txt";
        char mode[] = "r+";
        file = fopen(filename,mode);
        if(file == NULL)
        {
                printf("无法打开文件\n");
                return 1;
        }
        //int ch;
//      while((ch = fgetc(file)) != EOF){
//              printf("%c",ch);
//      }
        char buffer[1024];
        while(fgets(buffer,sizeof(buffer),file) != NULL)
        {
                printf("%s",buffer);
        }
        //执行完毕后关闭流
        fclose(file);

        return 0;
}
```

## 写入
```c
#include <stdio.h>
int main(int argc,int*argv[])
{
        FILE *file;
        char filename[] = "./files/demo2.txt";
        char mode[] = "w";
        int ch;
        file = fopen(filename,mode);
        if(file == NULL)
        {
                printf("无法打开文件");
                return 1;
        }
        while((ch = getchar()) != EOF)
        {
                fputc(ch,file);
        }
        fclose(file);
        return 0;
}
```

---
```c
#include <stdio.h>

int main(int argc,int* argv[])
{
        FILE* file;
        char filename[] = "./files/exxample.txt";
        char mode[] = "w";
        char str[100];

        file = fopen(filename,mode);
        if(file == NULL)
        {
                printf("无法打开文件.\n");
                return 1;
        }
        printf("请输入要写入的文件的字符串:\n");
        fgets(str,sizeof(str),stdin);
        fputs(str,file);

        fclose(file);
        return 0;
 }
```
## 从文件里面读取一行

```c
#include <stdio.h>
#include <stdlib.h>
int main(){
    FILE* file = fopen("./xxx.txt","r");
    if(file == NULL) {
        perror("fopen:");
        exit(EXIT_FAILURE);
    }
    char *buffer == NULL;
    size_t buffer_size = 0;
    ssize_t read_length = getline(&buffer,&buffer_size,file);
    if(read_length == -1){
        perror("readline():");
        free(buffer);
        fclose(file);
        exit(EXIT_FAILURE);
    }
    printf("%s\n",buffer);
    free(buffer);
    fclose(file);
    return 0;
}
```

一行一行读取所有内容:
```c
#include <stdio.h>
#include <stdlib.h>
int main() {
    FILE* file = fopen("./xxx.txt","r");
    if(file == NULL) {
        perror("fopen:");
        exit(EXIT_FAILURE);
    }
    char* buffer = NULL;
    size_t buffer_size = 0;
    while(getline(&buffer,&buffer_size,file) != -1){
        printf("%s",buffer);
    }

    free(buffer);
    fclose(file);
    return 0;
}
```

## 返回文件头部重新读取
`rewind` 函数用于将文件指针重新定位到文件的开头。以下是一个简单的例子，展示了如何使用 `rewind` 函数：

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE* file = fopen("example.txt", "r");
    if (file == NULL) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    char buffer[100];

    // 读取并打印文件的第一行
    if (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("First line: %s", buffer);
    }

    // 使用 rewind 将文件指针重新定位到文件开头
    rewind(file);

    // 再次读取并打印文件的第一行
    if (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("First line again: %s", buffer);
    }

    fclose(file);
    return 0;
}
```

在这个例子中，我们首先打开一个文件 `example.txt` 并读取并打印其第一行。然后，我们使用 `rewind` 函数将文件指针重新定位到文件的开头，再次读取并打印第一行。

请确保 `example.txt` 文件存在并且包含一些文本，以便程序能够正常运行。


## 读写二进制文件
`fread` 和 `fwrite` 是C语言中用于读写数据的两个重要函数，它们可以用来处理二进制数据或文本数据，通常用于文件操作。下面是这两个函数的详细介绍：

**`fread`**：
- **函数原型**：`size_t fread(void *ptr, size_t size, size_t count, FILE *stream);`
- **功能**：从指定的文件流（`stream`）中读取数据到内存中。
- **参数**：
  - `ptr`：指向一个内存块的指针，用于存储从文件中读取的数据。
  - `size`：指定每个数据项的字节数。
  - `count`：指定要读取的数据项的数量。
  - `stream`：指向要读取的文件的文件指针。
- **返回值**：返回成功读取的数据项的数量。如果返回值小于 `count`，可能是因为到达文件末尾或发生了错误。

**`fwrite`**：
- **函数原型**：`size_t fwrite(const void *ptr, size_t size, size_t count, FILE *stream);`
- **功能**：将内存中的数据写入到指定的文件流（`stream`）中。
- **参数**：
  - `ptr`：指向要写入的数据的内存块的指针。
  - `size`：指定每个数据项的字节数。
  - `count`：指定要写入的数据项的数量。
  - `stream`：指向要写入的文件的文件指针。
- **返回值**：返回成功写入的数据项的数量。如果返回值小于 `count`，可能是因为发生了错误。

写入部分
```c
#include <stdio.h>
#include <stdlib.h>
typedef struct {
    int id;
    char name[20];
}Student;
int main() {
    FILE* fp;
    Student students[] = {{1,"Alice"},{2,"Bob"}};
    int num_students = sizeof(students)/sizeof(Student);

    fp = fopen("students.dat","wb");
    if(fp == NULL) {
        perror("fopen:");
        exit(EXIT_FAILURE);
    }
    fwrite(students,sizeof(Student),sizeof(students)/sizeof(Student),fp);

    fclose(fp);
    
    return 0;
}
```

---

读取部分
```c
#include <stdlib.h>
#include <stdio.h>
typedef struct
{
    int id;
    char name[20];
} Student;
int main()
{
    FILE *fp = fopen("./students.dat", "rb");
    if (fp == NULL)
    {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    fseek(fp, 0, SEEK_END);
    const int num_students = ftell(fp)/sizeof(Student);
    printf("Thre are %d students in students.dat\n",num_students);
    rewind(fp);
    Student students[num_students];
    fread(students, sizeof(Student), num_students, fp);
    for (int i = 0; i < 2; i++)
    {
        printf("Student info:");
        printf("id:%d,name:%s", students[i].id, students[i].name);
        printf("\n");
    }
    fclose(fp);
    return 0;
}
```

# 移动文件指针

`fseek` 是C语言中用于操作文件指针位置的函数，它允许你在文件中移动文件指针到指定的位置，从而可以实现随机访问文件中的数据。下面是 `fseek` 函数的详细介绍：

**`fseek`**：
- **函数原型**：`int fseek(FILE *stream, long offset, int origin);`
- **功能**：设置文件指针（`stream`）的位置。
- **参数**：
  - `stream`：指向要操作的文件的文件指针。
  - `offset`：指定从 `origin` 开始要移动的字节数。如果 `offset` 是正数，则文件指针向文件尾方向移动；如果 `offset` 是负数，则文件指针向文件头方向移动。
  - `origin`：指定起始位置，可以是以下三个宏之一：
    - `SEEK_SET`：文件开始位置。
    - `SEEK_CUR`：文件指针当前位置。
    - `SEEK_END`：文件结束位置。
- **返回值**：成功时返回 `0`，如果发生错误则返回非零值。

使用 `fseek` 可以实现多种文件操作，例如跳过文件的一部分、重置文件指针到文件开始、或者移动到文件的特定位置进行读写操作。例如，要重置文件指针到文件开始，可以使用：

```c
fseek(fp, 0, SEEK_SET);
```

要移动到文件末尾，可以使用：

```c
fseek(fp, 0, SEEK_END);
```

要从当前位置向前移动10个字节，可以使用：

```c
fseek(fp, 10, SEEK_CUR);
```

在使用 `fseek` 后，通常可以使用 `ftell` 函数来获取当前文件指针的位置。例如：

```c
long position = ftell(fp);
```

`fseek` 和 `ftell` 通常用于处理二进制文件，因为它们允许你精确地控制文件指针的位置。对于文本文件，`fseek` 的使用可能会受到限制，因为文本文件可能包含无法直接定位的字符（如换行符在不同系统中的表示不同）。



`ftell` 是C语言中用于获取文件指针当前位置的函数，它返回文件指针相对于文件开始位置的字节偏移量。下面是 `ftell` 函数的详细介绍：

**`ftell`**：
- **函数原型**：`long ftell(FILE *stream);`
- **功能**：获取指定文件流（`stream`）的当前文件指针位置。
- **参数**：
  - `stream`：指向要获取位置信息的文件的文件指针。
- **返回值**：成功时返回文件指针相对于文件开始位置的字节偏移量。如果发生错误，则返回 `-1L`，并设置 `errno` 来指示错误类型。

使用 `ftell` 可以方便地获取文件指针的当前位置，这在需要记录文件读写进度或者在文件中进行随机访问时非常有用。例如，你可以在读取文件之前使用 `ftell` 来获取文件指针的初始位置，然后在读取后再次使用 `ftell` 来确定已经读取了多少字节。

下面是一个简单的例子，展示了如何使用 `ftell` 来获取文件指针的位置：

```c
#include <stdio.h>

int main() {
    FILE *fp = fopen("example.txt", "r");
    if (fp == NULL) {
        perror("无法打开文件");
        return 1;
    }

    // 获取文件指针的初始位置
    long initial_position = ftell(fp);
    printf("文件指针的初始位置: %ld\n", initial_position);

    // 读取一些数据
    char buffer[100];
    fread(buffer, 1, 50, fp);

    // 获取文件指针的新位置
    long new_position = ftell(fp);
    printf("读取50字节后文件指针的位置: %ld\n", new_position);

    // 关闭文件
    fclose(fp);
    return 0;
}
```

在这个例子中，我们首先打开一个文件，然后使用 `ftell` 获取文件指针的初始位置。接着，我们读取50字节的数据，并再次使用 `ftell` 来获取文件指针的新位置。最后，我们关闭文件。

注意，`ftell` 返回的偏移量是相对于文件开始位置的，因此它通常与 `fseek` 一起使用来实现文件的随机访问。


`rewind` 是C语言中用于将文件指针重置到文件开始位置的函数。这个函数非常简单，它不需要任何参数，直接将文件指针移动到文件的开头。下面是 `rewind` 函数的详细介绍：

**`rewind`**：
- **函数原型**：`void rewind(FILE *stream);`
- **功能**：将文件指针（`stream`）重置到文件的开始位置。
- **参数**：
  - `stream`：指向要重置位置的文件的文件指针。
- **返回值**：`rewind` 函数没有返回值。

使用 `rewind` 可以方便地将文件指针移动到文件的开始，这在需要重新读取文件内容或者在文件操作过程中需要回到文件开头时非常有用。例如，如果你已经读取了文件的一部分，但想要重新开始读取，可以使用 `rewind` 来重置文件指针。

下面是一个简单的例子，展示了如何使用 `rewind` 来重置文件指针：

```c
#include <stdio.h>

int main() {
    FILE *fp = fopen("example.txt", "r");
    if (fp == NULL) {
        perror("无法打开文件");
        return 1;
    }

    // 读取一些数据
    char buffer[100];
    fread(buffer, 1, 50, fp);

    // 重置文件指针到文件开始
    rewind(fp);

    // 再次读取数据
    fread(buffer, 1, 50, fp);

    // 关闭文件
    fclose(fp);
    return 0;
}
```

在这个例子中，我们首先打开一个文件，然后读取50字节的数据。接着，我们使用 `rewind` 将文件指针重置到文件开始，并再次读取50字节的数据。最后，我们关闭文件。

`rewind` 函数等效于以下代码：

```c
fseek(fp, 0, SEEK_SET);
```

这两行代码都会将文件指针移动到文件的开始位置。`rewind` 函数通常用于简化代码，使得意图更加清晰。

## 临时文件

`tmpfile()` 是C语言中的一个标准库函数，用于创建一个临时文件，该文件在程序结束时或显式关闭后会自动删除。这个函数通常用于需要临时存储数据，但在程序结束时不需要保留这些数据的场景。下面是 `tmpfile()` 函数的详细介绍：

**`tmpfile()`**：
- **函数原型**：`FILE *tmpfile(void);`
- **功能**：创建一个临时文件，并返回一个指向该文件的文件指针。
- **返回值**：成功时返回一个有效的文件指针，如果创建临时文件失败，则返回 `NULL`。

`tmpfile()` 创建的临时文件是以二进制模式打开的，模式为 `wb+`，这意味着文件既可以读也可以写，并且是以二进制格式打开的。

下面是一个简单的例子，展示了如何使用 `tmpfile()` 来创建和使用一个临时文件：

```c
#include <stdio.h>

int main() {
    FILE *temp_file = tmpfile();
    if (temp_file == NULL) {
        perror("无法创建临时文件");
        return 1;
    }

    // 写入一些数据到临时文件
    const char *data = "这是一些临时数据";
    fwrite(data, sizeof(char), strlen(data), temp_file);

    // 重置文件指针到文件开始
    rewind(temp_file);

    // 从临时文件读取数据
    char buffer[100];
    size_t bytes_read = fread(buffer, sizeof(char), sizeof(buffer), temp_file);
    buffer[bytes_read] = '\0'; // 确保字符串以 null 结尾

    printf("从临时文件读取的数据: %s\n", buffer);

    // 关闭临时文件（文件会在关闭后自动删除）
    fclose(temp_file);

    return 0;
}
```

在这个例子中，我们首先使用 `tmpfile()` 创建一个临时文件，并检查是否成功。然后，我们将一些数据写入临时文件，重置文件指针，并从文件中读取数据。最后，我们关闭临时文件，文件会在关闭后自动删除。

注意，`tmpfile()` 创建的临时文件的路径和名称是由系统自动生成的，因此每次调用 `tmpfile()` 时，通常会创建一个不同的临时文件。这使得 `tmpfile()` 非常适合于需要临时存储数据但不关心文件持久性的场景。