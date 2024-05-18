# Docker用代理拉取镜像


# 配置代理

打开`/usr/lib/systemd/system/docker.service`，在[Service]域中添加以下参数：

```
Environment=&#34;HTTP_PROXY=http://proxy-addr:port/&#34;   # 代理服务器地址
Environment=&#34;HTTPS_PROXY=http://proxy-addr:port/&#34;  # https
Environment=&#34;NO_PROXY=localhost,127.0.0.1&#34;         # 哪些地址不需要走代理

```

# 更新配置，启动服务
```
systemctl daemon-reload
systemctl restart docker.service

```




---

> 作者: meowrain  
> URL: http://localhost:1313/posts/7c3ddcd/  

