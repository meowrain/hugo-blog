---
title: Docker用代理拉取镜像
subtitle:
date: 2024-05-15T19:12:28+08:00
slug: 7c3ddcd
draft: false
description:
keywords:
license:
comment: true
weight: 0
tags:
  - Docker
categories:
  - Docker
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
summary:
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

# 配置代理

打开`/usr/lib/systemd/system/docker.service`，在[Service]域中添加以下参数：

```
Environment="HTTP_PROXY=http://proxy-addr:port/"   # 代理服务器地址
Environment="HTTPS_PROXY=http://proxy-addr:port/"  # https
Environment="NO_PROXY=localhost,127.0.0.1"         # 哪些地址不需要走代理

```

# 更新配置，启动服务
```
systemctl daemon-reload
systemctl restart docker.service

```


