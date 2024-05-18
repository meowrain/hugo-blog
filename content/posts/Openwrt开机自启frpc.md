---
title: Openwrt开机自启frpc
subtitle:
date: 2024-05-18T15:25:10+08:00
slug: e31d395
draft: false
description:
keywords:
license: CC
comment: true
weight: 0
tags:
  - 折腾
  - Linux
categories:
  - 折腾
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

> https://openwrt.org/docs/guide-developer/procd-init-script-example

cd /etc/init.d
vim frpc

```
#!/bin/sh /etc/rc.common
START=99
STOP=90
SERVICE=frpc
USE_PROCD=1
PROC="/usr/bin/frpc -c /root/frpc/frpc.toml"
start_service(){
     procd_open_instance
     procd_set_param command $PROC
     procd_set_param respawn
     procd_close_instance
}
service_triggers()
{
        procd_add_reload_trigger "rpcd"
}




```


`/etc/init.d/frp enable && echo on`
