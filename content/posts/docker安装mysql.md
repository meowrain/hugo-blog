---
title: Docker安装mysql
subtitle:
date: 2024-05-15T19:15:16+08:00
slug: e3c5896
draft: false
description:
keywords:
license:
comment: true
weight: 0
tags:
  - Docker
  - Mysql
categories:
  - Docker
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


# Docker安装mysql

```shell
$ docker pull mysql:latest
$ cd ~
$ mkdir mysql
$ cd mysql
```

```shell
$ docker run -p 3306:3306 --name mysql -v $PWD/conf/my.cnf:/etc/mysql/my.cnf -v $PWD/logs:/logs -v $PWD/data:/mysql_data -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```

# 连接mysql
> https://docs.fedoraproject.org/en-US/quick-docs/installing-mysql-mariadb/
> 可以参考一下官方文档

```shell
$ sudo dnf install community-mysql-server
```

```shell
$ mysql -h 127.0.0.1 -P 3306 -u root -p123456
```