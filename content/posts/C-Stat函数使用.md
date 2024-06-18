---
title: C Stat函数使用
subtitle:
date: 2024-06-17T16:01:47Z
slug: 7484d0b
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - Linux系统编程
  - C语言函数
  - stat函数
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

# C stat函数使用

头文件：`#include<sys/stat.h>  #include<uninstd.h>`

定义函数：`int stat(const char * file_name, struct stat *buf);`

函数说明：`stat()用来将参数file_name 所指的文件状态, 复制到参数buf 所指的结构中。`

struct stat *buf
```c
struct stat {
    dev_t st_dev; //device 文件的设备编号
    ino_t st_ino; //inode 文件的i-node
    mode_t st_mode; //protection 文件的类型和存取的权限
    nlink_t st_nlink; //number of hard links 连到该文件的硬连接数目, 刚建立的文件值为1.
    uid_t st_uid; //user ID of owner 文件所有者的用户识别码
    gid_t st_gid; //group ID of owner 文件所有者的组识别码
    dev_t st_rdev; //device type 若此文件为装置设备文件, 则为其设备编号
    off_t st_size; //total size, in bytes 文件大小, 以字节计算
    unsigned long st_blksize; //blocksize for filesystem I/O 文件系统的I/O 缓冲区大小.
    u nsigned long st_blocks; //number of blocks allocated 占用文件区块的个数, 每一区块大小为512 个字节.
    time_t st_atime; //time of lastaccess 文件最近一次被存取或被执行的时间, 一般只有在用mknod、 utime、read、write 与tructate 时改变.
    time_t st_mtime; //time of last modification 文件最后一次被修改的时间, 一般只有在用mknod、 utime 和write 时才会改变
    time_t st_ctime; //time of last change i-node 最近一次被更改的时间, 此参数会在文件所有者、组、 权限被更改时更新
};
```
st_mode 则定义了下列数种情况：

```
1、S_IFMT 0170000 文件类型的位遮罩
2、S_IFSOCK 0140000 scoket
3、S_IFLNK 0120000 符号连接
4、S_IFREG 0100000 一般文件
5、S_IFBLK 0060000 区块装置
6、S_IFDIR 0040000 目录
7、S_IFCHR 0020000 字符装置
8、S_IFIFO 0010000 先进先出
9、S_ISUID 04000 文件的 (set user-id on execution)位
10、S_ISGID 02000 文件的 (set group-id on execution)位
11、S_ISVTX 01000 文件的sticky 位
12、S_IRUSR (S_IREAD) 00400 文件所有者具可读取权限
13、S_IWUSR (S_IWRITE)00200 文件所有者具可写入权限
14、S_IXUSR (S_IEXEC) 00100 文件所有者具可执行权限
15、S_IRGRP 00040 用户组具可读取权限
16、S_IWGRP 00020 用户组具可写入权限
17、S_IXGRP 00010 用户组具可执行权限
18、S_IROTH 00004 其他用户具可读取权限
19、S_IWOTH 00002 其他用户具可写入权限
20、S_IXOTH 00001 其他用户具可执行权限上述的文件类型在 POSIX 中定义了检查这些类型的宏定义
21、S_ISLNK (st_mode) 判断是否为符号连接
22、S_ISREG (st_mode) 是否为一般文件
23、S_ISDIR (st_mode) 是否为目录
24、S_ISCHR (st_mode) 是否为字符装置文件
25、S_ISBLK (s3e) 是否为先进先出
26、S_ISSOCK (st_mode) 是否为socket 若一目录具有sticky 位 (S_ISVTX), 则表示在此目录下的文件只能 被该文件所有者、此目录所有者或root 来删除或改名.
```

![](https://static.meowrain.cn/i/2024/06/18/1sct5-3.webp)

```c
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
void println(char *text)
{
    printf("%s\n", text);
}
void print_file_type(mode_t mode)
{
    if (S_ISREG(mode))
    {
        printf("文件类型: 普通文件\n");
    }
    else if (S_ISDIR(mode))
    {
        printf("文件类型: 目录\n");
    }
    else if (S_ISCHR(mode))
    {
        printf("文件类型: 字符设备\n");
    }
    else if (S_ISBLK(mode))
    {
        printf("文件类型: 块设备\n");
    }
    else if (S_ISFIFO(mode))
    {
        printf("文件类型: 先进先出（FIFO）\n");
    }
    else if (S_ISLNK(mode))
    {
        printf("文件类型: 符号链接\n");
    }
    else if (S_ISSOCK(mode))
    {
        printf("文件类型: 套接字\n");
    }
    else
    {
        printf("文件类型: 未知\n");
    }
}
void print_file_permissions(mode_t mode)
{
    printf("权限: ");
    printf((mode & S_IRUSR) ? "r" : "-");
    printf((mode & S_IWUSR) ? "w" : "-");
    printf((mode & S_IXUSR) ? "x" : "-");
    printf((mode & S_IRGRP) ? "r" : "-");
    printf((mode & S_IWGRP) ? "w" : "-");
    printf((mode & S_IXGRP) ? "x" : "-");
    printf((mode & S_IROTH) ? "r" : "-");
    printf((mode & S_IWOTH) ? "w" : "-");
    printf((mode & S_IXOTH) ? "x" : "-");
    printf("\n");
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        println("请输入要获取相关信息的文件路径：");
        exit(-1);
    }
    /**
     * int stat(const char *__restrict__ __file, struct stat *__restrict__ __buf)
        Get file attributes for FILE and put them in BUF.
     */
    struct stat info;
    int err = stat(argv[1], &info);
    if (err == -1)
    {
        perror("stat:");
        exit(-1);
    }
    printf("文件的设备编号:%ld\n", info.st_dev);
    printf("文件节点:%ld\n", info.st_ino);
    print_file_type(info.st_mode);
    print_file_permissions(info.st_mode);
    printf("连到该文件的硬连接数目：%ld\n", info.st_nlink);
    printf("用户ID:%d\n", info.st_uid);
    printf("组ID:%d\n", info.st_gid);
    printf("(设备类型)若此文件为设备文件，则为其设备编号:%ld\n", info.st_rdev);
    printf("文件字节数:%ld字节\n", info.st_size);
    printf("块大小:%ld\n", info.st_blksize);
    printf("块数:%ld\n", info.st_blocks);
    char *time_string = ctime(&info.st_atim.tv_sec);
    printf("最后一次访问时间:%s", time_string);
    time_string = ctime(&info.st_mtim.tv_sec);
    printf("最后一次修改时间:%s", time_string);
    time_string = ctime(&info.st_ctime);
    printf("最后一次改变时间(属性改变):%s", time_string);
}
```
